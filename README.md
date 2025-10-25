# 💊 FARMACIA_SISTEMA

Sistema de gestión de farmacia desarrollado con **Flask (Python)**, **MySQL** y **HTML/CSS/JavaScript**.  
Permite manejar usuarios, productos, clientes y facturación de forma segura y sencilla.

---

## 🚀 Características principales

- ✅ Gestión de usuarios con roles (administrador, vendedor, gerente)
- 📦 Registro y control de inventario de productos
- 👥 Módulo de gestión de clientes
- 🧾 Generación de facturas y control de ventas
- 📊 Reportes detallados de ventas por horario y productos más vendidos
- 🔐 Autenticación segura con sesiones
- 🌐 API REST para integración con frontend

---

## 📋 Requisitos previos

Antes de comenzar, asegúrate de tener instalado:

- **Python 3.10+** → [Descargar aquí](https://www.python.org/downloads/)
- **MySQL 8.0+** → [Descargar aquí](https://dev.mysql.com/downloads/)
- **Git** → [Descargar aquí](https://git-scm.com/)

---

## ⚙️ Instalación y configuración

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/tuusuario/FARMACIA_SISTEMA.git
cd FARMACIA_SISTEMA
```

### 2️⃣ Crear y activar entorno virtual

**Crear entorno:**
```bash
python -m venv venv
```

**Activar entorno:**
- **Windows (CMD/PowerShell):**
  ```bash
  venv\Scripts\activate
  ```
- **Linux / macOS:**
  ```bash
  source venv/bin/activate
  ```

> 💡 **Nota:** Verás `(venv)` al inicio de tu terminal cuando esté activado.

### 3️⃣ Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4️⃣ Configurar la base de datos

#### a) Crear la base de datos en MySQL

Abre MySQL y ejecuta:

```sql
CREATE DATABASE farmacia_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### b) Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=tu_contraseña_mysql
DB_NAME=farmacia_db
SECRET_KEY=clave_secreta_muy_segura_12345
```

> ⚠️ **Importante:** Reemplaza `tu_contraseña_mysql` con tu contraseña real de MySQL.

#### c) Crear las tablas

Las tablas se crean automáticamente al ejecutar la aplicación por primera vez. El sistema incluye:
- Tabla de usuarios
- Tabla de productos
- Tabla de clientes
- Tabla de facturas y detalles de factura

---

## 🚀 Ejecutar la aplicación

### Iniciar el servidor

```bash
python app.py
```

Si todo está correcto, verás un mensaje como:

```
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.1.X:5000
```

### Acceder al sistema

Abre tu navegador en:

👉 **http://localhost:5000**

### Credenciales por defecto

Si es la primera vez, registra un usuario con rol **administrador** desde la interfaz de registro.

---

## 🧰 Estructura del proyecto

```
FARMACIA_SISTEMA/
│
├── static/              # Archivos estáticos (HTML, CSS, JS)
│   └── login.html       # Interfaz de usuario
│
├── app.py               # Aplicación principal Flask
├── requirements.txt     # Dependencias del proyecto
├── .env                 # Variables de entorno (NO subir a Git)
├── .gitignore          # Archivos ignorados por Git
├── README.md           # Este archivo
│
└── venv/               # Entorno virtual (NO subir a Git)
```

---

## 📚 Endpoints principales de la API

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/register` | Registrar nuevo usuario |
| POST | `/api/login` | Iniciar sesión |
| POST | `/api/logout` | Cerrar sesión |
| GET | `/api/productos` | Listar productos |
| POST | `/api/productos` | Crear producto |
| PUT | `/api/productos/<id>` | Actualizar producto |
| DELETE | `/api/productos/<id>` | Eliminar producto |
| GET | `/api/clientes` | Listar clientes |
| POST | `/api/clientes` | Crear cliente |
| POST | `/api/facturas` | Crear factura |
| GET | `/api/facturas` | Listar facturas |
| GET | `/api/dashboard` | Datos del dashboard |
| GET | `/api/reportes/*` | Reportes y estadísticas |

---

## 🛠️ Tecnologías utilizadas

- **Backend:** Flask 3.0+
- **Base de datos:** MySQL 8.0+
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Autenticación:** Flask Sessions
- **ORM:** PyMySQL

---

## 🐛 Solución de problemas comunes

### ❌ Error de conexión a MySQL

```
Error: Access denied for user 'root'@'localhost'
```

**Solución:** Verifica tu contraseña en el archivo `.env`

### ❌ Puerto 5000 ocupado

**Solución:** Cambia el puerto en `app.py`:
```python
app.run(debug=True, port=5001)
```

### ❌ Módulos no encontrados

**Solución:** Reinstala las dependencias:
```bash
pip install --force-reinstall -r requirements.txt
```

---

## 👨‍💻 Equipo de desarrollo

**Desarrollado por SOFTSCAPE:**
- Alfredo Mercado
- Edgar Rodelo
- Jesús Cera
- Fabián Polo
- Miguelangel De La Hoz

---

## 📄 Licencia

Este proyecto es de uso educativo.

---


