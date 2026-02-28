# 💊 Sistema de Gestión de Farmacia

Sistema web para la administración de farmacias desarrollado con **Flask (Python)**, **MySQL** y **HTML/CSS/JavaScript**.  
Permite gestionar usuarios, productos, clientes y ventas de forma segura y organizada.

Este proyecto forma parte de mi portafolio como desarrollador de software.

---

# 🎥 Demo del sistema

Video demostración del funcionamiento del sistema:

https://youtu.be/PuNo6lrDEGo?si=40xaPI8rNyOrfVfh

Plataforma: 0

En el video se muestra:
- Inicio de sesión
- Gestión de productos
- Registro de clientes
- Generación de facturas
- Funcionamiento general del sistema

---

# 🚀 Características principales

- 🔐 Autenticación de usuarios
- 👥 Gestión de roles (Administrador, Vendedor, Gerente)
- 📦 Control de inventario de productos
- 👤 Gestión de clientes
- 🧾 Sistema de facturación
- 📊 Reportes de ventas
- 🌐 API REST para integración con frontend
- 🧩 Arquitectura modular del backend

---

# 🛠 Tecnologías utilizadas

## Backend
- Python
- Flask
- API REST
- Autenticación con sesiones

## Frontend
- HTML5
- CSS3
- JavaScript

## Base de datos
- MySQL

## Herramientas
- Git
- GitHub
- Postman
- Entorno virtual (venv)

---

# 📸 Capturas del sistema

*(Recomendado agregar imágenes del sistema para mostrar la interfaz)*

Ejemplo:

```
/screenshots/login.png
/screenshots/dashboard.png
/screenshots/productos.png
/screenshots/facturacion.png
```

Luego puedes mostrarlas así en el README:

```markdown
## Login
![Login](screenshots/login.png)

## Gestión de productos
![Productos](screenshots/productos.png)

## Facturación
![Facturación](screenshots/facturacion.png)
```

---

# 📋 Requisitos previos

Antes de ejecutar el proyecto debes tener instalado:

- Python 3.10 o superior
- MySQL 8.0+
- Git

---

# ⚙️ Instalación del proyecto

## 1. Clonar repositorio

```bash
git clone https://github.com/tuusuario/FARMACIA_SISTEMA.git
cd FARMACIA_SISTEMA
```

## 2. Crear entorno virtual

```bash
python -m venv venv
```

## 3. Activar entorno virtual

Windows:
```bash
venv\Scripts\activate
```

Linux / macOS:
```bash
source venv/bin/activate
```

## 4. Instalar dependencias

```bash
pip install -r requirements.txt
```

---

# 🗄 Configuración de la base de datos

Crear base de datos en MySQL:

```sql
CREATE DATABASE farmacia_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Crear archivo `.env` en la raíz del proyecto:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=tu_contraseña
DB_NAME=farmacia_db
SECRET_KEY=clave_secreta_segura
```

---

# 🚀 Ejecutar la aplicación

```bash
python app.py
```

Abrir en el navegador:

```
http://localhost:5000
```

---

# 📚 Endpoints principales de la API

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | /api/register | Registrar usuario |
| POST | /api/login | Iniciar sesión |
| POST | /api/logout | Cerrar sesión |
| GET | /api/productos | Listar productos |
| POST | /api/productos | Crear producto |
| PUT | /api/productos/<id> | Actualizar producto |
| DELETE | /api/productos/<id> | Eliminar producto |
| GET | /api/clientes | Listar clientes |
| POST | /api/clientes | Crear cliente |
| POST | /api/facturas | Crear factura |
| GET | /api/facturas | Listar facturas |
| GET | /api/dashboard | Datos del dashboard |
| GET | /api/reportes/* | Reportes del sistema |

---

# 🧰 Estructura del proyecto

```
FARMACIA_SISTEMA/
│
├── static/              
│   └── login.html       
│
├── app.py               
├── requirements.txt     
├── .env                 
├── README.md            
└── venv/                
```

---

# 👨‍💻 Autor

**Alfredo Mercado**  
Estudiante de Ingeniería en Sistemas  
Desarrollador de Software (Backend / Full Stack)

GitHub:  
https://github.com/Alfre2106

---

# 📌 Sobre este proyecto

Este sistema fue desarrollado para fortalecer habilidades en:

- Desarrollo backend con Flask
- Diseño de APIs REST
- Integración con bases de datos MySQL
- Desarrollo web full stack
- Arquitectura básica de sistemas
- Gestión de usuarios y autenticación
