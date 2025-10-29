-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-10-2025 a las 22:53:25
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `farmacia_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas_stock`
--

CREATE TABLE `alertas_stock` (
  `id` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `leido` tinyint(1) DEFAULT 0,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `alertas_stock`
--

INSERT INTO `alertas_stock` (`id`, `id_producto`, `mensaje`, `leido`, `fecha_creacion`) VALUES
(1, 2, 'Stock bajo: Ibuprofeno 400mg (4 unidades)', 0, '2025-10-22 16:26:28'),
(2, 6, 'Stock bajo: Diclofenaco (3 unidades)', 0, '2025-10-28 17:15:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `tipo_documento` enum('CC','NIT','CE','Pasaporte') NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `tipo_documento`, `numero_documento`, `nombre`, `telefono`, `email`, `direccion`, `fecha_creacion`) VALUES
(1, 'CC', '00000000', 'Cliente General', NULL, NULL, NULL, '2025-10-22 00:35:55'),
(2, 'CC', '1052958018', 'Alfredo Mercado', '3054473701', '', '', '2025-10-22 01:27:06'),
(3, 'CC', '12345678', 'Juan Pérez', '3001234567', 'juan@email.com', NULL, '2025-10-22 02:34:39'),
(4, 'CC', '87654321', 'María García', '3109876543', 'maria@email.com', NULL, '2025-10-22 02:34:39'),
(5, 'NIT', '900123456', 'Empresa XYZ', '6012345678', 'ventas@xyz.com', NULL, '2025-10-22 02:34:39'),
(6, 'CC', '33353324', 'Yeimis Guerra', '30068430082', 'yeimis83@email.com', '', '2025-10-22 16:20:19'),
(7, 'CC', '9196779', 'Alberto Medel', '3227262638', 'alberto@gmail.com', '', '2025-10-22 16:25:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_facturas`
--

CREATE TABLE `detalle_facturas` (
  `id` int(11) NOT NULL,
  `id_factura` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_facturas`
--

INSERT INTO `detalle_facturas` (`id`, `id_factura`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1, 1, 1, 10, 1200.00, 12000.00),
(2, 2, 2, 5, 1800.00, 9000.00),
(5, 3, 1, 10, 1200.00, 12000.00),
(6, 3, 2, 2, 1500.00, 3000.00),
(7, 4, 3, 5, 3500.00, 17500.00),
(8, 4, 4, 4, 2500.00, 10000.00),
(9, 5, 5, 6, 2000.00, 12000.00),
(10, 6, 1, 15, 1200.00, 18000.00),
(11, 6, 2, 8, 1500.00, 12000.00),
(12, 6, 5, 6, 2000.00, 12000.00),
(13, 7, 3, 3, 3500.00, 10500.00),
(14, 7, 4, 3, 2500.00, 7500.00),
(15, 8, 1, 10, 1200.00, 12000.00),
(16, 8, 2, 5, 1500.00, 7500.00),
(17, 8, 5, 3, 2000.00, 6000.00),
(18, 9, 3, 6, 3500.00, 21000.00),
(19, 9, 5, 6, 2000.00, 12000.00),
(20, 10, 1, 20, 1200.00, 24000.00),
(21, 10, 2, 12, 1500.00, 18000.00),
(22, 10, 4, 6, 2500.00, 15000.00),
(23, 11, 5, 7, 2000.00, 14000.00),
(24, 12, 3, 8, 3500.00, 28000.00),
(25, 12, 4, 4, 2500.00, 10000.00),
(26, 13, 1, 12, 1200.00, 14400.00),
(27, 13, 2, 4, 1500.00, 6000.00),
(28, 14, 3, 10, 3500.00, 35000.00),
(29, 14, 5, 6, 2000.00, 12000.00),
(30, 15, 1, 15, 1200.00, 18000.00),
(31, 15, 4, 4, 2500.00, 10000.00),
(32, 16, 3, 12, 3500.00, 42000.00),
(33, 16, 2, 10, 1500.00, 15000.00),
(34, 16, 5, 3, 2000.00, 6000.00),
(35, 17, 1, 8, 1200.00, 9600.00),
(36, 17, 4, 3, 2500.00, 7500.00),
(37, 18, 3, 10, 3500.00, 35000.00),
(38, 18, 5, 8, 2000.00, 16000.00),
(39, 19, 1, 18, 1200.00, 21600.00),
(40, 19, 2, 6, 1500.00, 9000.00),
(41, 19, 4, 2, 2500.00, 5000.00),
(42, 20, 5, 9, 2000.00, 18000.00),
(43, 21, 1, 12, 1200.00, 14400.00),
(44, 21, 3, 3, 3500.00, 10500.00),
(45, 22, 2, 15, 1500.00, 22500.00),
(46, 22, 4, 9, 2500.00, 22500.00),
(47, 23, 3, 4, 3500.00, 14000.00),
(48, 23, 5, 4, 2000.00, 8000.00),
(49, 24, 1, 20, 1200.00, 24000.00),
(50, 24, 2, 8, 1500.00, 12000.00),
(51, 25, 3, 6, 3500.00, 21000.00),
(52, 25, 4, 3, 2500.00, 7500.00),
(53, 26, 3, 20, 3500.00, 70000.00),
(54, 27, 2, 10, 1800.00, 18000.00),
(55, 28, 1, 10, 1200.00, 12000.00),
(56, 28, 3, 15, 3500.00, 52500.00),
(57, 29, 6, 20, 1100.00, 22000.00),
(58, 29, 2, 12, 1800.00, 21600.00),
(59, 30, 6, 7, 1100.00, 7700.00),
(60, 30, 2, 10, 1800.00, 18000.00),
(61, 31, 1, 10, 1200.00, 12000.00),
(62, 31, 2, 7, 1800.00, 12600.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int(11) NOT NULL,
  `numero_factura` varchar(20) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `horario` enum('mañana','tarde','noche') NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `impuesto` decimal(10,2) DEFAULT 0.00,
  `descuento` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `metodo_pago` enum('efectivo','tarjeta','transferencia') NOT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`id`, `numero_factura`, `fecha`, `horario`, `id_cliente`, `id_usuario`, `subtotal`, `impuesto`, `descuento`, `total`, `metodo_pago`, `observaciones`) VALUES
(1, 'FAC000001', '2025-10-22 01:27:20', 'noche', 2, 1, 12000.00, 0.00, 0.00, 12000.00, 'efectivo', ''),
(2, 'FAC000002', '2025-10-22 01:30:35', 'noche', 2, 1, 9000.00, 0.00, 0.00, 9000.00, 'transferencia', ''),
(3, 'FAC000003', '2025-10-15 11:34:40', 'mañana', 3, 1, 15000.00, 0.00, 0.00, 15000.00, 'efectivo', NULL),
(4, 'FAC000004', '2025-10-15 16:34:40', 'tarde', 4, 1, 28000.00, 0.00, 0.00, 28000.00, 'tarjeta', NULL),
(5, 'FAC000005', '2025-10-15 22:34:40', 'noche', 2, 1, 12000.00, 0.00, 0.00, 12000.00, 'efectivo', NULL),
(6, 'FAC000006', '2025-10-16 12:34:40', 'mañana', 5, 2, 42000.00, 0.00, 0.00, 42000.00, 'transferencia', NULL),
(7, 'FAC000007', '2025-10-16 17:34:40', 'tarde', 3, 2, 18000.00, 0.00, 0.00, 18000.00, 'efectivo', NULL),
(8, 'FAC000008', '2025-10-16 23:34:40', 'noche', 4, 2, 25000.00, 0.00, 0.00, 25000.00, 'tarjeta', NULL),
(9, 'FAC000009', '2025-10-17 10:34:40', 'mañana', 2, 1, 33000.00, 0.00, 0.00, 33000.00, 'efectivo', NULL),
(10, 'FAC000010', '2025-10-17 18:34:40', 'tarde', 5, 1, 56000.00, 0.00, 0.00, 56000.00, 'transferencia', NULL),
(11, 'FAC000011', '2025-10-18 00:34:40', 'noche', 3, 1, 14000.00, 0.00, 0.00, 14000.00, 'efectivo', NULL),
(12, 'FAC000012', '2025-10-18 11:34:40', 'mañana', 4, 2, 38000.00, 0.00, 0.00, 38000.00, 'tarjeta', NULL),
(13, 'FAC000013', '2025-10-18 15:34:40', 'tarde', 2, 2, 21000.00, 0.00, 0.00, 21000.00, 'efectivo', NULL),
(14, 'FAC000014', '2025-10-18 21:34:40', 'noche', 5, 2, 47000.00, 0.00, 0.00, 47000.00, 'transferencia', NULL),
(15, 'FAC000015', '2025-10-19 12:34:40', 'mañana', 3, 1, 29000.00, 0.00, 0.00, 29000.00, 'efectivo', NULL),
(16, 'FAC000016', '2025-10-19 19:34:40', 'tarde', 4, 1, 63000.00, 0.00, 0.00, 63000.00, 'tarjeta', NULL),
(17, 'FAC000017', '2025-10-20 01:34:40', 'noche', 2, 1, 16000.00, 0.00, 0.00, 16000.00, 'efectivo', NULL),
(18, 'FAC000018', '2025-10-20 13:34:40', 'mañana', 5, 2, 51000.00, 0.00, 0.00, 51000.00, 'transferencia', NULL),
(19, 'FAC000019', '2025-10-20 16:34:40', 'tarde', 3, 2, 34000.00, 0.00, 0.00, 34000.00, 'tarjeta', NULL),
(20, 'FAC000020', '2025-10-20 22:34:40', 'noche', 4, 2, 19000.00, 0.00, 0.00, 19000.00, 'efectivo', NULL),
(21, 'FAC000021', '2025-10-21 11:34:40', 'mañana', 2, 1, 24000.00, 0.00, 0.00, 24000.00, 'efectivo', NULL),
(22, 'FAC000022', '2025-10-21 17:34:40', 'tarde', 5, 1, 45000.00, 0.00, 0.00, 45000.00, 'transferencia', NULL),
(23, 'FAC000023', '2025-10-21 23:34:40', 'noche', 3, 1, 22000.00, 0.00, 0.00, 22000.00, 'tarjeta', NULL),
(24, 'FAC000024', '2025-10-21 23:34:40', 'mañana', 4, 2, 36000.00, 0.00, 0.00, 36000.00, 'efectivo', NULL),
(25, 'FAC000025', '2025-10-22 01:34:40', 'tarde', 2, 2, 28000.00, 0.00, 0.00, 28000.00, 'tarjeta', NULL),
(26, 'FAC000026', '2025-10-22 16:21:24', 'mañana', 6, 1, 70000.00, 0.00, 0.00, 70000.00, 'tarjeta', ''),
(27, 'FAC000027', '2025-10-22 16:26:28', 'mañana', 7, 1, 18000.00, 0.00, 0.00, 18000.00, 'efectivo', ''),
(28, 'FAC000028', '2025-10-24 16:18:25', 'mañana', 5, 1, 64500.00, 0.00, 0.00, 64500.00, 'tarjeta', ''),
(29, 'FAC000029', '2025-10-24 17:04:29', 'tarde', 7, 2, 43600.00, 0.00, 0.00, 43600.00, 'efectivo', ''),
(30, 'FAC000030', '2025-10-28 17:15:51', 'tarde', 4, 1, 25700.00, 0.00, 0.00, 25700.00, 'efectivo', ''),
(31, 'FAC000031', '2025-10-29 20:48:39', 'tarde', 3, 1, 24600.00, 0.00, 0.00, 24600.00, 'efectivo', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_inventario`
--

CREATE TABLE `movimientos_inventario` (
  `id` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `tipo_movimiento` enum('entrada','salida','ajuste') NOT NULL,
  `cantidad` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `motivo` varchar(100) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimientos_inventario`
--

INSERT INTO `movimientos_inventario` (`id`, `id_producto`, `tipo_movimiento`, `cantidad`, `id_usuario`, `id_factura`, `motivo`, `fecha`) VALUES
(1, 1, 'salida', 10, 1, 1, 'Venta', '2025-10-22 01:27:20'),
(2, 2, 'salida', 5, 1, 2, 'Venta', '2025-10-22 01:30:35'),
(3, 3, 'salida', 20, 1, 26, 'Venta', '2025-10-22 16:21:24'),
(4, 2, 'salida', 10, 1, 27, 'Venta', '2025-10-22 16:26:28'),
(5, 1, 'salida', 10, 1, 28, 'Venta', '2025-10-24 16:18:25'),
(6, 3, 'salida', 15, 1, 28, 'Venta', '2025-10-24 16:18:25'),
(7, 6, 'salida', 20, 2, 29, 'Venta', '2025-10-24 17:04:29'),
(8, 2, 'salida', 12, 2, 29, 'Venta', '2025-10-24 17:04:29'),
(9, 6, 'salida', 7, 1, 30, 'Venta', '2025-10-28 17:15:51'),
(10, 2, 'salida', 10, 1, 30, 'Venta', '2025-10-28 17:15:51'),
(11, 1, 'salida', 10, 1, 31, 'Venta', '2025-10-29 20:48:39'),
(12, 2, 'salida', 7, 1, 31, 'Venta', '2025-10-29 20:48:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock_actual` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) NOT NULL DEFAULT 10,
  `categoria` varchar(50) DEFAULT NULL,
  `laboratorio` varchar(100) DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `codigo`, `nombre`, `descripcion`, `precio_compra`, `precio_venta`, `stock_actual`, `stock_minimo`, `categoria`, `laboratorio`, `fecha_vencimiento`, `activo`, `fecha_creacion`, `fecha_modificacion`) VALUES
(1, 'MED001', 'Acetaminofén 500mg', 'Analgésico y antipirético', 500.00, 1200.00, 180, 20, 'Analgésicos', 'Laboratorio ABC', '2030-10-25', 1, '2025-10-22 00:35:55', '2025-10-29 20:48:39'),
(2, 'MED002', 'Ibuprofeno 400mg', 'Antiinflamatorio no esteroideo', 800.00, 1800.00, 106, 15, 'Antiinflamatorios', 'Laboratorio XYZ', '2028-09-28', 1, '2025-10-22 00:35:55', '2025-10-29 20:48:39'),
(3, 'MED003', 'Amoxicilina 500mg', 'Antibiótico', 1500.00, 3500.00, 10, 20, 'Antibióticos', 'Lab MNO', NULL, 1, '2025-10-22 02:34:39', '2025-10-29 20:48:02'),
(4, 'MED004', 'Losartán 50mg', 'Antihipertensivo', 1000.00, 2500.00, 100, 15, 'Cardiovascular', 'Lab ABC', NULL, 1, '2025-10-22 02:34:39', '2025-10-22 02:34:39'),
(5, 'MED005', 'Omeprazol 20mg', 'Antiulceroso', 800.00, 2000.00, 120, 20, 'Gastro', 'Lab XYZ', NULL, 1, '2025-10-22 02:34:39', '2025-10-22 02:34:39'),
(6, 'MED006', 'Diclofenaco', '', 1000.00, 1100.00, 200, 15, 'Antiinflamatorios', '', '2028-12-01', 1, '2025-10-24 17:01:59', '2025-10-28 17:18:26'),
(8, 'MED007', 'Metronidazol 500mg', '', 1300.00, 1350.00, 300, 20, 'Antibióticos', 'Lab MNO', '2027-11-29', 1, '2025-10-29 20:50:45', '2025-10-29 20:50:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL,
  `rol` enum('administrador','vendedor','gerente') NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultimo_acceso` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `username`, `password`, `nombre_completo`, `rol`, `activo`, `fecha_creacion`, `ultimo_acceso`) VALUES
(1, 'admin', 'admin123', 'Alfredo Mercado', 'administrador', 1, '2025-10-22 00:35:54', '2025-10-29 21:25:54'),
(2, 'vendedor1', 'vendedor123', 'Juan Pérez', 'vendedor', 1, '2025-10-22 01:01:24', '2025-10-28 17:36:57'),
(3, 'gerente1', 'gerente123', 'Edgar Rodelo', 'gerente', 1, '2025-10-22 21:37:23', '2025-10-29 21:26:33'),
(4, 'vendedor2', 'vendedor321', 'Jesus Cera', 'vendedor', 1, '2025-10-29 21:03:22', '2025-10-29 21:03:36');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas_stock`
--
ALTER TABLE `alertas_stock`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_documento` (`numero_documento`);

--
-- Indices de la tabla `detalle_facturas`
--
ALTER TABLE `detalle_facturas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_factura` (`id_factura`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_factura` (`numero_factura`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `idx_facturas_fecha` (`fecha`),
  ADD KEY `idx_facturas_horario` (`horario`);

--
-- Indices de la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_factura` (`id_factura`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idx_productos_codigo` (`codigo`),
  ADD KEY `idx_productos_nombre` (`nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_usuarios_username` (`username`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alertas_stock`
--
ALTER TABLE `alertas_stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `detalle_facturas`
--
ALTER TABLE `detalle_facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas_stock`
--
ALTER TABLE `alertas_stock`
  ADD CONSTRAINT `alertas_stock_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id`);

--
-- Filtros para la tabla `detalle_facturas`
--
ALTER TABLE `detalle_facturas`
  ADD CONSTRAINT `detalle_facturas_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_facturas_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  ADD CONSTRAINT `movimientos_inventario_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `movimientos_inventario_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `movimientos_inventario_ibfk_3` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
