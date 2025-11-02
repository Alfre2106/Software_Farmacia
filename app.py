from flask import Flask, request, jsonify, session, send_from_directory
from flask_cors import CORS
import mysql.connector
from datetime import datetime, timedelta
import hashlib
import os
from functools import wraps

app = Flask(__name__, static_folder='static', static_url_path='')
app.secret_key = 'farmacia_secret_key_2025'
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['SESSION_COOKIE_SECURE'] = False
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=24)

CORS(app, 
     supports_credentials=True, 
     origins=['http://localhost:5000', 'http://127.0.0.1:5000'],
     allow_headers=['Content-Type'],
     methods=['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'])

# Configuración de la Base de Datos
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'farmacia_db'
}

def get_db():
    """Conexión a la base de datos"""
    return mysql.connector.connect(**DB_CONFIG)

def hash_password(password):
    """Hash simple de contraseña"""
    return hashlib.sha256(password.encode()).hexdigest()

def login_required(f):
    """Decorador para rutas que requieren autenticación"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            return jsonify({'error': 'No autorizado'}), 401
        return f(*args, **kwargs)
    return decorated_function

def role_required(roles):
    """Decorador para verificar roles específicos"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'rol' not in session or session['rol'] not in roles:
                return jsonify({'error': 'Permisos insuficientes'}), 403
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# ===== RUTAS DE AUTENTICACIÓN =====

@app.route('/')
def index():
    """Página principal"""
    return send_from_directory('static', 'login.html')

@app.route('/api/login', methods=['POST'])
def login():
    """Autenticación de usuarios"""
    data = request.json
    username = data.get('username')
    password = data.get('password')
    
    if not username or not password:
        return jsonify({'error': 'Usuario y contraseña requeridos'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute(
            "SELECT * FROM usuarios WHERE username = %s AND password = %s AND activo = TRUE",
            (username, password)
        )
        user = cursor.fetchone()
        
        if user:
            cursor.execute(
                "UPDATE usuarios SET ultimo_acceso = NOW() WHERE id = %s",
                (user['id'],)
            )
            db.commit()
            
            session.clear()
            session['user_id'] = user['id']
            session['username'] = user['username']
            session['nombre'] = user['nombre_completo']
            session['rol'] = user['rol']
            session.permanent = True
            
            return jsonify({
                'success': True,
                'user': {
                    'id': user['id'],
                    'username': user['username'],
                    'nombre': user['nombre_completo'],
                    'rol': user['rol']
                }
            })
        else:
            return jsonify({'error': 'Credenciales inválidas'}), 401
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/logout', methods=['POST'])
def logout():
    """Cerrar sesión"""
    session.clear()
    return jsonify({'success': True})

@app.route('/api/session', methods=['GET'])
def check_session():
    """Verificar sesión activa"""
    if 'user_id' in session:
        return jsonify({
            'authenticated': True,
            'user': {
                'id': session['user_id'],
                'username': session['username'],
                'nombre': session['nombre'],
                'rol': session['rol']
            }
        })
    return jsonify({'authenticated': False}), 401

@app.route('/api/register', methods=['POST'])
def register():
    """Registro de nuevos usuarios"""
    data = request.json
    
    required = ['username', 'password', 'nombre_completo', 'rol']
    if not all(field in data for field in required):
        return jsonify({'error': 'Campos requeridos faltantes'}), 400
    
    # Validar rol
    if data['rol'] not in ['administrador', 'vendedor', 'gerente']:
        return jsonify({'error': 'Rol inválido'}), 400
    
    # Validar longitud de contraseña
    if len(data['password']) < 6:
        return jsonify({'error': 'La contraseña debe tener al menos 6 caracteres'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Verificar si el usuario ya existe
        cursor.execute("SELECT id FROM usuarios WHERE username = %s", (data['username'],))
        if cursor.fetchone():
            return jsonify({'error': 'El nombre de usuario ya existe'}), 400
        
        # ✅ CORRECCIÓN: Insertar SIN la columna email
        cursor.execute("""
            INSERT INTO usuarios (username, password, nombre_completo, rol, activo)
            VALUES (%s, %s, %s, %s, TRUE)
        """, (
            data['username'],
            data['password'],
            data['nombre_completo'],
            data['rol']
        ))
        
        db.commit()
        user_id = cursor.lastrowid
        
        return jsonify({
            'success': True,
            'message': 'Usuario registrado exitosamente',
            'user_id': user_id
        }), 201
        
    except mysql.connector.IntegrityError as e:
        return jsonify({'error': 'Error de integridad en la base de datos'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

# ===== RUTAS DE PRODUCTOS =====

@app.route('/api/productos', methods=['GET'])
@login_required
def get_productos():
    """Consultar productos"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        search = request.args.get('search', '')
        if search:
            cursor.execute(
                "SELECT * FROM productos WHERE (nombre LIKE %s OR codigo LIKE %s) AND activo = TRUE ORDER BY nombre",
                (f'%{search}%', f'%{search}%')
            )
        else:
            cursor.execute("SELECT * FROM productos WHERE activo = TRUE ORDER BY nombre")
        
        productos = cursor.fetchall()
        
        for p in productos:
            if p['fecha_vencimiento']:
                p['fecha_vencimiento'] = p['fecha_vencimiento'].isoformat()
            p['fecha_creacion'] = p['fecha_creacion'].isoformat()
            p['fecha_modificacion'] = p['fecha_modificacion'].isoformat()
        
        return jsonify(productos)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/productos/<int:id>', methods=['GET'])
@login_required
def get_producto(id):
    """Consultar producto por ID"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM productos WHERE id = %s", (id,))
        producto = cursor.fetchone()
        
        if producto:
            if producto['fecha_vencimiento']:
                producto['fecha_vencimiento'] = producto['fecha_vencimiento'].isoformat()
            producto['fecha_creacion'] = producto['fecha_creacion'].isoformat()
            producto['fecha_modificacion'] = producto['fecha_modificacion'].isoformat()
            return jsonify(producto)
        return jsonify({'error': 'Producto no encontrado'}), 404
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/productos', methods=['POST'])
@login_required
@role_required(['administrador'])
def crear_producto():
    """Registrar nuevo producto"""
    data = request.json
    
    required = ['codigo', 'nombre', 'precio_compra', 'precio_venta', 'stock_actual', 'stock_minimo']
    if not all(field in data for field in required):
        return jsonify({'error': 'Campos requeridos faltantes'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        cursor.execute("""
            INSERT INTO productos (codigo, nombre, descripcion, precio_compra, precio_venta, 
                                 stock_actual, stock_minimo, categoria, laboratorio, fecha_vencimiento)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            data['codigo'], data['nombre'], data.get('descripcion'),
            data['precio_compra'], data['precio_venta'], data['stock_actual'],
            data['stock_minimo'], data.get('categoria'), data.get('laboratorio'),
            data.get('fecha_vencimiento')
        ))
        
        db.commit()
        producto_id = cursor.lastrowid
        
        if data['stock_actual'] <= data['stock_minimo']:
            cursor.execute("""
                INSERT INTO alertas_stock (id_producto, mensaje)
                VALUES (%s, %s)
            """, (producto_id, f'Stock bajo: {data["nombre"]} ({data["stock_actual"]} unidades)'))
            db.commit()
        
        return jsonify({'success': True, 'id': producto_id}), 201
        
    except mysql.connector.IntegrityError:
        return jsonify({'error': 'El código ya existe'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/productos/<int:id>', methods=['PUT'])
@login_required
@role_required(['administrador'])
def actualizar_producto(id):
    """Editar producto"""
    data = request.json
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        cursor.execute("""
            UPDATE productos SET 
                nombre = %s, descripcion = %s, precio_compra = %s, precio_venta = %s,
                stock_actual = %s, stock_minimo = %s, categoria = %s, 
                laboratorio = %s, fecha_vencimiento = %s
            WHERE id = %s
        """, (
            data['nombre'], data.get('descripcion'), data['precio_compra'],
            data['precio_venta'], data['stock_actual'], data['stock_minimo'],
            data.get('categoria'), data.get('laboratorio'), 
            data.get('fecha_vencimiento'), id
        ))
        
        db.commit()
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Producto no encontrado'}), 404
        
        return jsonify({'success': True})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/productos/<int:id>', methods=['DELETE'])
@login_required
@role_required(['administrador'])
def eliminar_producto(id):
    """Eliminar producto (desactivar)"""
    try:
        db = get_db()
        cursor = db.cursor()
        cursor.execute("UPDATE productos SET activo = FALSE WHERE id = %s", (id,))
        db.commit()
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Producto no encontrado'}), 404
        
        return jsonify({'success': True})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

# ===== RUTAS DE ALERTAS =====

@app.route('/api/alertas', methods=['GET'])
@login_required
def get_alertas():
    """Consultar alertas de stock bajo"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("""
            SELECT a.*, p.nombre, p.stock_actual, p.stock_minimo
            FROM alertas_stock a
            JOIN productos p ON a.id_producto = p.id
            WHERE a.leido = FALSE
            ORDER BY a.fecha_creacion DESC
        """)
        alertas = cursor.fetchall()
        
        for a in alertas:
            a['fecha_creacion'] = a['fecha_creacion'].isoformat()
        
        return jsonify(alertas)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

# ===== RUTAS DE DASHBOARD =====

@app.route('/api/dashboard', methods=['GET'])
@login_required
def get_dashboard():
    """Datos para el dashboard principal"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("SELECT COUNT(*) as total FROM productos WHERE activo = TRUE")
        total_productos = cursor.fetchone()['total']
        
        cursor.execute("""
            SELECT COUNT(*) as total FROM productos 
            WHERE activo = TRUE AND stock_actual <= stock_minimo
        """)
        productos_bajo_stock = cursor.fetchone()['total']
        
        cursor.execute("""
            SELECT COUNT(*) as total, COALESCE(SUM(total), 0) as monto
            FROM facturas WHERE DATE(fecha) = CURDATE()
        """)
        ventas_hoy = cursor.fetchone()
        
        return jsonify({
            'total_productos': total_productos,
            'productos_bajo_stock': productos_bajo_stock,
            'ventas_hoy': ventas_hoy['total'],
            'monto_ventas_hoy': float(ventas_hoy['monto'])
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

# ===== RUTAS DE CLIENTES =====

@app.route('/api/clientes', methods=['GET'])
@login_required
def get_clientes():
    """Obtener lista de clientes"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        search = request.args.get('search', '')
        if search:
            cursor.execute("""
                SELECT * FROM clientes 
                WHERE nombre LIKE %s OR numero_documento LIKE %s
                ORDER BY nombre
            """, (f'%{search}%', f'%{search}%'))
        else:
            cursor.execute("SELECT * FROM clientes ORDER BY nombre LIMIT 100")
        
        clientes = cursor.fetchall()
        
        for c in clientes:
            c['fecha_creacion'] = c['fecha_creacion'].isoformat()
        
        return jsonify(clientes)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/clientes', methods=['POST'])
@login_required
def crear_cliente():
    """Crear nuevo cliente"""
    data = request.json
    
    required = ['tipo_documento', 'numero_documento', 'nombre']
    if not all(field in data for field in required):
        return jsonify({'error': 'Campos requeridos faltantes'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        cursor.execute("""
            INSERT INTO clientes (tipo_documento, numero_documento, nombre, telefono, email, direccion)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            data['tipo_documento'], data['numero_documento'], data['nombre'],
            data.get('telefono'), data.get('email'), data.get('direccion')
        ))
        
        db.commit()
        cliente_id = cursor.lastrowid
        
        return jsonify({'success': True, 'id': cliente_id}), 201
        
    except mysql.connector.IntegrityError:
        return jsonify({'error': 'El número de documento ya existe'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

# ===== RUTAS DE FACTURACIÓN =====

@app.route('/api/facturas', methods=['GET'])
@login_required
def get_facturas():
    """Obtener lista de facturas"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        fecha_inicio = request.args.get('fecha_inicio')
        fecha_fin = request.args.get('fecha_fin')
        
        query = """
            SELECT f.*, c.nombre as nombre_cliente, u.nombre_completo as nombre_usuario
            FROM facturas f
            LEFT JOIN clientes c ON f.id_cliente = c.id
            JOIN usuarios u ON f.id_usuario = u.id
            WHERE 1=1
        """
        params = []
        
        if fecha_inicio:
            query += " AND DATE(f.fecha) >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            query += " AND DATE(f.fecha) <= %s"
            params.append(fecha_fin)
        
        query += " ORDER BY f.fecha DESC LIMIT 100"
        
        cursor.execute(query, params)
        facturas = cursor.fetchall()
        
        for f in facturas:
            f['fecha'] = f['fecha'].isoformat()
        
        return jsonify(facturas)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/facturas/<int:id>', methods=['GET'])
@login_required
def get_factura(id):
    """Obtener detalle de una factura"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT f.*, c.nombre as nombre_cliente, c.numero_documento, c.telefono,
                   u.nombre_completo as nombre_usuario
            FROM facturas f
            LEFT JOIN clientes c ON f.id_cliente = c.id
            JOIN usuarios u ON f.id_usuario = u.id
            WHERE f.id = %s
        """, (id,))
        factura = cursor.fetchone()
        
        if not factura:
            return jsonify({'error': 'Factura no encontrada'}), 404
        
        cursor.execute("""
            SELECT df.*, p.nombre as nombre_producto, p.codigo
            FROM detalle_facturas df
            JOIN productos p ON df.id_producto = p.id
            WHERE df.id_factura = %s
        """, (id,))
        detalle = cursor.fetchall()
        
        factura['fecha'] = factura['fecha'].isoformat()
        factura['detalle'] = detalle
        
        return jsonify(factura)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

def determinar_horario():
    """Determina el horario según la hora actual"""
    hora = datetime.now().hour
    if 6 <= hora < 12:
        return 'mañana'
    elif 12 <= hora < 18:
        return 'tarde'
    else:
        return 'noche'

@app.route('/api/facturas', methods=['POST'])
@login_required
@role_required(['administrador', 'vendedor'])
def crear_factura():
    """Crear nueva factura"""
    data = request.json
    
    required = ['productos', 'metodo_pago']
    if not all(field in data for field in required):
        return jsonify({'error': 'Datos incompletos'}), 400
    
    if not data['productos'] or len(data['productos']) == 0:
        return jsonify({'error': 'Debe agregar al menos un producto'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        for item in data['productos']:
            cursor.execute(
                "SELECT stock_actual FROM productos WHERE id = %s",
                (item['id_producto'],)
            )
            result = cursor.fetchone()
            if not result or result[0] < item['cantidad']:
                return jsonify({'error': f'Stock insuficiente para el producto ID {item["id_producto"]}'}), 400
        
        cursor.execute("SELECT MAX(CAST(SUBSTRING(numero_factura, 4) AS UNSIGNED)) as max FROM facturas")
        max_num = cursor.fetchone()[0] or 0
        numero_factura = f"FAC{str(max_num + 1).zfill(6)}"
        
        subtotal = sum(item['precio_unitario'] * item['cantidad'] for item in data['productos'])
        impuesto = data.get('impuesto', 0)
        descuento = data.get('descuento', 0)
        total = subtotal + impuesto - descuento
        
        horario = determinar_horario()
        
        cursor.execute("""
            INSERT INTO facturas (numero_factura, fecha, horario, id_cliente, id_usuario,
                                subtotal, impuesto, descuento, total, metodo_pago, observaciones)
            VALUES (%s, NOW(), %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            numero_factura, horario, data.get('id_cliente'), session['user_id'],
            subtotal, impuesto, descuento, total, data['metodo_pago'],
            data.get('observaciones')
        ))
        
        factura_id = cursor.lastrowid
        
        for item in data['productos']:
            cursor.execute("""
                INSERT INTO detalle_facturas (id_factura, id_producto, cantidad, precio_unitario, subtotal)
                VALUES (%s, %s, %s, %s, %s)
            """, (
                factura_id, item['id_producto'], item['cantidad'],
                item['precio_unitario'], item['precio_unitario'] * item['cantidad']
            ))
            
            cursor.execute("""
                UPDATE productos SET stock_actual = stock_actual - %s
                WHERE id = %s
            """, (item['cantidad'], item['id_producto']))
            
            cursor.execute("""
                INSERT INTO movimientos_inventario (id_producto, tipo_movimiento, cantidad, id_usuario, id_factura, motivo)
                VALUES (%s, 'salida', %s, %s, %s, 'Venta')
            """, (item['id_producto'], item['cantidad'], session['user_id'], factura_id))
            
            cursor.execute("""
                SELECT stock_actual, stock_minimo, nombre FROM productos WHERE id = %s
            """, (item['id_producto'],))
            producto = cursor.fetchone()
            
            if producto[0] <= producto[1]:
                cursor.execute("""
                    INSERT INTO alertas_stock (id_producto, mensaje)
                    VALUES (%s, %s)
                """, (item['id_producto'], f'Stock bajo: {producto[2]} ({producto[0]} unidades)'))
        
        db.commit()
        
        return jsonify({
            'success': True,
            'id': factura_id,
            'numero_factura': numero_factura,
            'total': total
        }), 201
        
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

# ===== RUTAS DE REPORTES =====

@app.route('/api/reportes/ventas-horario', methods=['GET'])
@login_required
def reporte_ventas_horario():
    """RF4 - Reporte de ventas por horario"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        fecha_inicio = request.args.get('fecha_inicio')
        fecha_fin = request.args.get('fecha_fin')
        
        query = """
            SELECT 
                horario,
                COUNT(*) as cantidad_ventas,
                SUM(total) as monto_total,
                AVG(total) as promedio_venta,
                MIN(total) as venta_minima,
                MAX(total) as venta_maxima
            FROM facturas
            WHERE 1=1
        """
        params = []
        
        if fecha_inicio:
            query += " AND DATE(fecha) >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            query += " AND DATE(fecha) <= %s"
            params.append(fecha_fin)
        
        query += " GROUP BY horario ORDER BY FIELD(horario, 'mañana', 'tarde', 'noche')"
        
        cursor.execute(query, params)
        resultados = cursor.fetchall()
        
        for r in resultados:
            r['monto_total'] = float(r['monto_total'])
            r['promedio_venta'] = float(r['promedio_venta'])
            r['venta_minima'] = float(r['venta_minima'])
            r['venta_maxima'] = float(r['venta_maxima'])
        
        return jsonify(resultados)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/reportes/productos-vendidos', methods=['GET'])
@login_required
def reporte_productos_vendidos():
    """Productos más vendidos"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        fecha_inicio = request.args.get('fecha_inicio')
        fecha_fin = request.args.get('fecha_fin')
        horario = request.args.get('horario')
        
        query = """
            SELECT 
                p.id, p.codigo, p.nombre, p.categoria,
                SUM(df.cantidad) as cantidad_vendida,
                SUM(df.subtotal) as total_vendido,
                COUNT(DISTINCT f.id) as numero_facturas
            FROM detalle_facturas df
            JOIN productos p ON df.id_producto = p.id
            JOIN facturas f ON df.id_factura = f.id
            WHERE 1=1
        """
        params = []
        
        if fecha_inicio:
            query += " AND DATE(f.fecha) >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            query += " AND DATE(f.fecha) <= %s"
            params.append(fecha_fin)
        
        if horario:
            query += " AND f.horario = %s"
            params.append(horario)
        
        query += " GROUP BY p.id ORDER BY cantidad_vendida DESC LIMIT 20"
        
        cursor.execute(query, params)
        resultados = cursor.fetchall()
        
        for r in resultados:
            r['total_vendido'] = float(r['total_vendido'])
        
        return jsonify(resultados)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/reportes/ventas-diarias', methods=['GET'])
@login_required
def reporte_ventas_diarias():
    """Evolución de ventas por día"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        fecha_inicio = request.args.get('fecha_inicio')
        fecha_fin = request.args.get('fecha_fin')
        
        query = """
            SELECT 
                DATE(fecha) as fecha,
                COUNT(*) as cantidad_ventas,
                SUM(total) as monto_total
            FROM facturas
            WHERE 1=1
        """
        params = []
        
        if fecha_inicio:
            query += " AND DATE(fecha) >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            query += " AND DATE(fecha) <= %s"
            params.append(fecha_fin)
        else:
            query += " AND DATE(fecha) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)"
        
        query += " GROUP BY DATE(fecha) ORDER BY fecha ASC"
        
        cursor.execute(query, params)
        resultados = cursor.fetchall()
        
        for r in resultados:
            r['fecha'] = r['fecha'].isoformat()
            r['monto_total'] = float(r['monto_total'])
        
        return jsonify(resultados)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/reportes/resumen-general', methods=['GET'])
@login_required
def reporte_resumen_general():
    """Resumen general del período"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        fecha_inicio = request.args.get('fecha_inicio')
        fecha_fin = request.args.get('fecha_fin')
        
        query = """
            SELECT 
                COUNT(*) as total_facturas,
                SUM(total) as monto_total,
                AVG(total) as promedio_factura,
                MIN(total) as factura_minima,
                MAX(total) as factura_maxima,
                SUM(CASE WHEN metodo_pago = 'efectivo' THEN total ELSE 0 END) as efectivo,
                SUM(CASE WHEN metodo_pago = 'tarjeta' THEN total ELSE 0 END) as tarjeta,
                SUM(CASE WHEN metodo_pago = 'transferencia' THEN total ELSE 0 END) as transferencia
            FROM facturas
            WHERE 1=1
        """
        params = []
        
        if fecha_inicio:
            query += " AND DATE(fecha) >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            query += " AND DATE(fecha) <= %s"
            params.append(fecha_fin)
        
        cursor.execute(query, params)
        resultado = cursor.fetchone()
        
        if resultado['total_facturas'] > 0:
            resultado['monto_total'] = float(resultado['monto_total'])
            resultado['promedio_factura'] = float(resultado['promedio_factura'])
            resultado['factura_minima'] = float(resultado['factura_minima'])
            resultado['factura_maxima'] = float(resultado['factura_maxima'])
            resultado['efectivo'] = float(resultado['efectivo'])
            resultado['tarjeta'] = float(resultado['tarjeta'])
            resultado['transferencia'] = float(resultado['transferencia'])
        
        return jsonify(resultado)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

# ===== RUTAS DE GESTIÓN DE USUARIOS =====

@app.route('/api/usuarios', methods=['GET'])
@login_required
@role_required(['administrador'])
def get_usuarios():
    """Listar todos los usuarios (solo administradores)"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT id, username, nombre_completo, rol, activo, fecha_creacion, ultimo_acceso
            FROM usuarios 
            ORDER BY fecha_creacion DESC
        """)
        usuarios = cursor.fetchall()
        
        for u in usuarios:
            u['fecha_creacion'] = u['fecha_creacion'].isoformat()
            if u['ultimo_acceso']:
                u['ultimo_acceso'] = u['ultimo_acceso'].isoformat()
        
        return jsonify(usuarios)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/usuarios', methods=['POST'])
@login_required
@role_required(['administrador'])
def crear_usuario():
    """Crear nuevo usuario (solo administradores)"""
    data = request.json
    
    required = ['username', 'password', 'nombre_completo', 'rol']
    if not all(field in data for field in required):
        return jsonify({'error': 'Campos requeridos faltantes'}), 400
    
    # Validar rol
    if data['rol'] not in ['administrador', 'vendedor', 'gerente']:
        return jsonify({'error': 'Rol inválido'}), 400
    
    # Validar longitud de contraseña
    if len(data['password']) < 6:
        return jsonify({'error': 'La contraseña debe tener al menos 6 caracteres'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Verificar si el usuario ya existe
        cursor.execute("SELECT id FROM usuarios WHERE username = %s", (data['username'],))
        if cursor.fetchone():
            return jsonify({'error': 'El nombre de usuario ya existe'}), 400
        
        # Insertar nuevo usuario
        cursor.execute("""
            INSERT INTO usuarios (username, password, nombre_completo, rol, activo)
            VALUES (%s, %s, %s, %s, TRUE)
        """, (
            data['username'],
            data['password'],
            data['nombre_completo'],
            data['rol']
        ))
        
        db.commit()
        user_id = cursor.lastrowid
        
        return jsonify({
            'success': True,
            'message': 'Usuario creado exitosamente',
            'id': user_id
        }), 201
        
    except mysql.connector.IntegrityError:
        return jsonify({'error': 'El nombre de usuario ya existe'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/usuarios/<int:id>', methods=['PUT'])
@login_required
@role_required(['administrador'])
def actualizar_usuario(id):
    """Actualizar usuario (solo administradores)"""
    data = request.json
    
    required = ['nombre_completo', 'rol']
    if not all(field in data for field in required):
        return jsonify({'error': 'Nombre completo y rol son requeridos'}), 400
    
    # Validar rol
    if data['rol'] not in ['administrador', 'vendedor', 'gerente']:
        return jsonify({'error': 'Rol inválido'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Verificar que el usuario existe
        cursor.execute("SELECT id FROM usuarios WHERE id = %s", (id,))
        if not cursor.fetchone():
            return jsonify({'error': 'Usuario no encontrado'}), 404
        
        # Si se proporciona nueva contraseña
        if 'password' in data and data['password']:
            if len(data['password']) < 6:
                return jsonify({'error': 'La contraseña debe tener al menos 6 caracteres'}), 400
            
            cursor.execute("""
                UPDATE usuarios 
                SET nombre_completo = %s, rol = %s, password = %s 
                WHERE id = %s
            """, (data['nombre_completo'], data['rol'], data['password'], id))
        else:
            # Sin cambiar contraseña
            cursor.execute("""
                UPDATE usuarios 
                SET nombre_completo = %s, rol = %s 
                WHERE id = %s
            """, (data['nombre_completo'], data['rol'], id))
        
        db.commit()
        
        return jsonify({
            'success': True,
            'message': 'Usuario actualizado exitosamente'
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/usuarios/<int:id>/toggle', methods=['PATCH'])
@login_required
@role_required(['administrador'])
def toggle_usuario(id):
    """Activar/Desactivar usuario (solo administradores)"""
    
    # No permitir desactivarse a sí mismo
    if session['user_id'] == id:
        return jsonify({'error': 'No puedes desactivar tu propia cuenta'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        # Obtener estado actual
        cursor.execute("SELECT activo FROM usuarios WHERE id = %s", (id,))
        usuario = cursor.fetchone()
        
        if not usuario:
            return jsonify({'error': 'Usuario no encontrado'}), 404
        
        # Cambiar estado
        nuevo_estado = not usuario['activo']
        cursor.execute("UPDATE usuarios SET activo = %s WHERE id = %s", (nuevo_estado, id))
        db.commit()
        
        return jsonify({
            'success': True,
            'message': f'Usuario {"activado" if nuevo_estado else "desactivado"} exitosamente',
            'activo': nuevo_estado
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()
        
        # ===== RUTAS DE RECEPCIONES =====

@app.route('/api/recepciones', methods=['GET'])
@login_required
@role_required(['administrador'])
def get_recepciones():
    """Obtener lista de recepciones"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        fecha_inicio = request.args.get('fecha_inicio')
        fecha_fin = request.args.get('fecha_fin')
        
        query = """
            SELECT r.*, u.nombre_completo as nombre_usuario,
                   COUNT(dr.id) as total_productos
            FROM recepciones r
            JOIN usuarios u ON r.id_usuario = u.id
            LEFT JOIN detalle_recepciones dr ON r.id = dr.id_recepcion
            WHERE 1=1
        """
        params = []
        
        if fecha_inicio:
            query += " AND DATE(r.fecha) >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            query += " AND DATE(r.fecha) <= %s"
            params.append(fecha_fin)
        
        query += " GROUP BY r.id ORDER BY r.fecha DESC LIMIT 100"
        
        cursor.execute(query, params)
        recepciones = cursor.fetchall()
        
        for r in recepciones:
            r['fecha'] = r['fecha'].isoformat()
            r['total'] = float(r['total'])
        
        return jsonify(recepciones)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/recepciones/<int:id>', methods=['GET'])
@login_required
@role_required(['administrador'])
def get_recepcion(id):
    """Obtener detalle de una recepción"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT r.*, u.nombre_completo as nombre_usuario
            FROM recepciones r
            JOIN usuarios u ON r.id_usuario = u.id
            WHERE r.id = %s
        """, (id,))
        recepcion = cursor.fetchone()
        
        if not recepcion:
            return jsonify({'error': 'Recepción no encontrada'}), 404
        
        cursor.execute("""
            SELECT dr.*, p.nombre as nombre_producto, p.codigo
            FROM detalle_recepciones dr
            JOIN productos p ON dr.id_producto = p.id
            WHERE dr.id_recepcion = %s
        """, (id,))
        detalle = cursor.fetchall()
        
        recepcion['fecha'] = recepcion['fecha'].isoformat()
        recepcion['total'] = float(recepcion['total'])
        recepcion['detalle'] = detalle
        
        for d in detalle:
            d['precio_compra'] = float(d['precio_compra'])
            d['subtotal'] = float(d['subtotal'])
        
        return jsonify(recepcion)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()

@app.route('/api/recepciones', methods=['POST'])
@login_required
@role_required(['administrador'])
def crear_recepcion():
    """Crear nueva recepción de inventario"""
    data = request.json
    
    required = ['proveedor', 'productos']
    if not all(field in data for field in required):
        return jsonify({'error': 'Datos incompletos'}), 400
    
    if not data['productos'] or len(data['productos']) == 0:
        return jsonify({'error': 'Debe agregar al menos un producto'}), 400
    
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Generar número de recepción
        cursor.execute("SELECT MAX(CAST(SUBSTRING(numero_recepcion, 4) AS UNSIGNED)) as max FROM recepciones")
        max_num = cursor.fetchone()[0] or 0
        numero_recepcion = f"REC{str(max_num + 1).zfill(6)}"
        
        # Calcular total
        total = sum(item['precio_compra'] * item['cantidad'] for item in data['productos'])
        
        # Insertar recepción
        cursor.execute("""
            INSERT INTO recepciones (numero_recepcion, fecha, proveedor, numero_documento, 
                                    total, id_usuario, observaciones)
            VALUES (%s, NOW(), %s, %s, %s, %s, %s)
        """, (
            numero_recepcion,
            data['proveedor'],
            data.get('numero_documento'),
            total,
            session['user_id'],
            data.get('observaciones')
        ))
        
        recepcion_id = cursor.lastrowid
        
        # Insertar detalle y actualizar inventario
        for item in data['productos']:
            # Insertar detalle
            subtotal = item['precio_compra'] * item['cantidad']
            cursor.execute("""
                INSERT INTO detalle_recepciones (id_recepcion, id_producto, cantidad, precio_compra, subtotal)
                VALUES (%s, %s, %s, %s, %s)
            """, (
                recepcion_id,
                item['id_producto'],
                item['cantidad'],
                item['precio_compra'],
                subtotal
            ))
            
            # Actualizar stock del producto
            cursor.execute("""
                UPDATE productos 
                SET stock_actual = stock_actual + %s,
                    precio_compra = %s
                WHERE id = %s
            """, (item['cantidad'], item['precio_compra'], item['id_producto']))
            
            # Registrar movimiento de inventario
            cursor.execute("""
                INSERT INTO movimientos_inventario (id_producto, tipo_movimiento, cantidad, 
                                                    id_usuario, motivo, referencia)
                VALUES (%s, 'entrada', %s, %s, 'Recepción de inventario', %s)
            """, (item['id_producto'], item['cantidad'], session['user_id'], numero_recepcion))
        
        db.commit()
        
        return jsonify({
            'success': True,
            'id': recepcion_id,
            'numero_recepcion': numero_recepcion,
            'total': total
        }), 201
        
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()
        
        # ===== RUTAS DE MOVIMIENTOS DE INVENTARIO =====

@app.route('/api/movimientos', methods=['GET'])
@login_required
def get_movimientos():
    """Obtener historial de movimientos de inventario"""
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        tipo = request.args.get('tipo')
        producto = request.args.get('producto')
        fecha_inicio = request.args.get('fecha_inicio')
        fecha_fin = request.args.get('fecha_fin')
        
        query = """
            SELECT m.*, p.nombre as nombre_producto, p.codigo,
                   u.nombre_completo as nombre_usuario
            FROM movimientos_inventario m
            JOIN productos p ON m.id_producto = p.id
            JOIN usuarios u ON m.id_usuario = u.id
            WHERE 1=1
        """
        params = []
        
        if tipo:
            query += " AND m.tipo_movimiento = %s"
            params.append(tipo)
        
        if producto:
            query += " AND (p.nombre LIKE %s OR p.codigo LIKE %s)"
            params.extend([f'%{producto}%', f'%{producto}%'])
        
        if fecha_inicio:
            query += " AND DATE(m.fecha) >= %s"
            params.append(fecha_inicio)
        
        if fecha_fin:
            query += " AND DATE(m.fecha) <= %s"
            params.append(fecha_fin)
        
        query += " ORDER BY m.fecha DESC LIMIT 500"
        
        cursor.execute(query, params)
        movimientos = cursor.fetchall()
        
        for m in movimientos:
            m['fecha'] = m['fecha'].isoformat()
        
        return jsonify(movimientos)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()
# ===== INICIAR SERVIDOR =====

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
