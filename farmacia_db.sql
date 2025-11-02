-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-11-2025 a las 20:56:46
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
(2, 6, 'Stock bajo: Diclofenaco (3 unidades)', 0, '2025-10-28 17:15:51'),
(3, 1, 'Stock bajo: Acetaminofén 500mg (1 unidades)', 0, '2025-10-30 00:25:33'),
(4, 2, 'Stock bajo: Ibuprofeno 600mg (7 unidades)', 0, '2025-11-01 00:36:17'),
(5, 3, 'Stock bajo: Amoxicilina 500mg (0 unidades)', 0, '2025-11-02 18:37:27');

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
(7, 'CC', '9196779', 'Alberto Medel', '3227262638', 'alberto@gmail.com', '', '2025-10-22 16:25:35'),
(8, 'CC', '10254147', 'Yesica Guerra', '3005523250', '', '', '2025-10-31 21:59:37');

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
(62, 31, 2, 7, 1800.00, 12600.00),
(63, 32, 1, 9, 1200.00, 10800.00),
(64, 33, 1, 12, 1200.00, 14400.00),
(65, 33, 8, 10, 1350.00, 13500.00),
(66, 33, 2, 20, 1800.00, 36000.00),
(67, 34, 1, 2, 18900.00, 37800.00),
(68, 34, 2, 3, 23800.00, 71400.00),
(69, 35, 1, 100, 18900.00, 1890000.00),
(70, 35, 2, 100, 23800.00, 2380000.00),
(71, 35, 3, 10, 29120.00, 291200.00),
(72, 36, 1, 10, 18900.00, 189000.00),
(73, 36, 3, 15, 29120.00, 436800.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_recepciones`
--

CREATE TABLE `detalle_recepciones` (
  `id` int(11) NOT NULL,
  `id_recepcion` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_recepciones`
--

INSERT INTO `detalle_recepciones` (`id`, `id_recepcion`, `id_producto`, `cantidad`, `precio_compra`, `subtotal`) VALUES
(1, 1, 1, 100, 15900.00, 1590000.00),
(2, 1, 2, 50, 20800.00, 1040000.00),
(3, 1, 8, 20, 11000.00, 220000.00),
(4, 2, 3, 30, 27000.00, 810000.00),
(5, 2, 6, 40, 27000.00, 1080000.00),
(6, 3, 1, 80, 15900.00, 1272000.00),
(7, 3, 2, 60, 20800.00, 1248000.00),
(8, 3, 4, 30, 30000.00, 900000.00),
(9, 4, 5, 50, 18000.00, 900000.00),
(10, 4, 8, 40, 11000.00, 440000.00),
(11, 4, 6, 10, 22000.00, 220000.00),
(12, 5, 1, 120, 15900.00, 1908000.00),
(13, 5, 2, 40, 20800.00, 832000.00),
(14, 5, 3, 20, 10000.00, 200000.00),
(15, 6, 1, 200, 15900.00, 3180000.00),
(16, 6, 6, 100, 3100.00, 310000.00),
(17, 7, 2, 100, 20000.00, 2000000.00),
(18, 8, 1, 100, 15900.00, 1590000.00);

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
(31, 'FAC000031', '2025-10-29 20:48:39', 'tarde', 3, 1, 24600.00, 0.00, 0.00, 24600.00, 'efectivo', ''),
(32, 'FAC000032', '2025-10-30 00:25:33', 'noche', 2, 1, 10800.00, 0.00, 0.00, 10800.00, 'tarjeta', ''),
(33, 'FAC000033', '2025-10-31 22:11:33', 'tarde', 8, 1, 63900.00, 0.00, 0.00, 63900.00, 'tarjeta', ''),
(34, 'FAC000034', '2025-11-01 00:36:17', 'noche', 4, 1, 109200.00, 0.00, 0.00, 109200.00, 'tarjeta', ''),
(35, 'FAC000035', '2025-11-02 18:37:27', 'tarde', 5, 5, 4561200.00, 0.00, 0.00, 4561200.00, 'tarjeta', ''),
(36, 'FAC000036', '2025-11-02 19:21:48', 'tarde', 7, 1, 625800.00, 0.00, 0.00, 625800.00, 'efectivo', '');

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
  `referencia` varchar(50) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimientos_inventario`
--

INSERT INTO `movimientos_inventario` (`id`, `id_producto`, `tipo_movimiento`, `cantidad`, `id_usuario`, `id_factura`, `motivo`, `referencia`, `fecha`) VALUES
(1, 1, 'salida', 10, 1, 1, 'Venta', NULL, '2025-10-22 01:27:20'),
(2, 2, 'salida', 5, 1, 2, 'Venta', NULL, '2025-10-22 01:30:35'),
(3, 3, 'salida', 20, 1, 26, 'Venta', NULL, '2025-10-22 16:21:24'),
(4, 2, 'salida', 10, 1, 27, 'Venta', NULL, '2025-10-22 16:26:28'),
(5, 1, 'salida', 10, 1, 28, 'Venta', NULL, '2025-10-24 16:18:25'),
(6, 3, 'salida', 15, 1, 28, 'Venta', NULL, '2025-10-24 16:18:25'),
(7, 6, 'salida', 20, 2, 29, 'Venta', NULL, '2025-10-24 17:04:29'),
(8, 2, 'salida', 12, 2, 29, 'Venta', NULL, '2025-10-24 17:04:29'),
(9, 6, 'salida', 7, 1, 30, 'Venta', NULL, '2025-10-28 17:15:51'),
(10, 2, 'salida', 10, 1, 30, 'Venta', NULL, '2025-10-28 17:15:51'),
(11, 1, 'salida', 10, 1, 31, 'Venta', NULL, '2025-10-29 20:48:39'),
(12, 2, 'salida', 7, 1, 31, 'Venta', NULL, '2025-10-29 20:48:39'),
(13, 1, 'salida', 9, 1, 32, 'Venta', NULL, '2025-10-30 00:25:33'),
(14, 1, 'salida', 12, 1, 33, 'Venta', NULL, '2025-10-31 22:11:33'),
(15, 8, 'salida', 10, 1, 33, 'Venta', NULL, '2025-10-31 22:11:33'),
(16, 2, 'salida', 20, 1, 33, 'Venta', NULL, '2025-10-31 22:11:33'),
(17, 1, 'salida', 2, 1, 34, 'Venta', NULL, '2025-11-01 00:36:17'),
(18, 2, 'salida', 3, 1, 34, 'Venta', NULL, '2025-11-01 00:36:17'),
(19, 1, 'entrada', 100, 1, NULL, 'Recepción de inventario', 'REC000001', '2025-10-05 14:30:00'),
(20, 2, 'entrada', 50, 1, NULL, 'Recepción de inventario', 'REC000001', '2025-10-05 14:30:00'),
(21, 8, 'entrada', 20, 1, NULL, 'Recepción de inventario', 'REC000001', '2025-10-05 14:30:00'),
(22, 3, 'entrada', 30, 1, NULL, 'Recepción de inventario', 'REC000002', '2025-10-10 19:15:00'),
(23, 6, 'entrada', 40, 1, NULL, 'Recepción de inventario', 'REC000002', '2025-10-10 19:15:00'),
(24, 1, 'entrada', 80, 1, NULL, 'Recepción de inventario', 'REC000003', '2025-10-18 15:45:00'),
(25, 2, 'entrada', 60, 1, NULL, 'Recepción de inventario', 'REC000003', '2025-10-18 15:45:00'),
(26, 4, 'entrada', 30, 1, NULL, 'Recepción de inventario', 'REC000003', '2025-10-18 15:45:00'),
(27, 5, 'entrada', 50, 1, NULL, 'Recepción de inventario', 'REC000004', '2025-10-25 21:20:00'),
(28, 8, 'entrada', 40, 1, NULL, 'Recepción de inventario', 'REC000004', '2025-10-25 21:20:00'),
(29, 6, 'entrada', 10, 1, NULL, 'Recepción de inventario', 'REC000004', '2025-10-25 21:20:00'),
(30, 1, 'entrada', 120, 1, NULL, 'Recepción de inventario', 'REC000005', '2025-11-01 16:00:00'),
(31, 2, 'entrada', 40, 1, NULL, 'Recepción de inventario', 'REC000005', '2025-11-01 16:00:00'),
(32, 3, 'entrada', 20, 1, NULL, 'Recepción de inventario', 'REC000005', '2025-11-01 16:00:00'),
(33, 1, 'entrada', 200, 1, NULL, 'Recepción de inventario', 'REC000006', '2025-11-02 17:57:45'),
(34, 6, 'entrada', 100, 1, NULL, 'Recepción de inventario', 'REC000006', '2025-11-02 17:57:45'),
(35, 1, 'salida', 100, 5, 35, 'Venta', NULL, '2025-11-02 18:37:27'),
(36, 2, 'salida', 100, 5, 35, 'Venta', NULL, '2025-11-02 18:37:27'),
(37, 3, 'salida', 10, 5, 35, 'Venta', NULL, '2025-11-02 18:37:27'),
(38, 2, 'entrada', 100, 1, NULL, 'Recepción de inventario', 'REC000007', '2025-11-02 19:09:10'),
(39, 1, 'entrada', 100, 1, NULL, 'Recepción de inventario', 'REC000008', '2025-11-02 19:10:16'),
(40, 1, 'salida', 10, 1, 36, 'Venta', NULL, '2025-11-02 19:21:48'),
(41, 3, 'salida', 15, 1, 36, 'Venta', NULL, '2025-11-02 19:21:48');

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
(1, 'MED001', 'Acetaminofén 500mg', 'Analgésico y antipirético', 15900.00, 18900.00, 338, 15, 'Analgésicos', 'Laboratorio ABC', '2030-10-25', 1, '2025-10-22 00:35:55', '2025-11-02 19:21:48'),
(2, 'MED002', 'Ibuprofeno 600mg', 'Antiinflamatorio no esteroideo', 20000.00, 23800.00, 600, 15, 'Antiinflamatorios', 'Laboratorio XYZ', '2028-09-28', 1, '2025-10-22 00:35:55', '2025-11-02 19:09:09'),
(3, 'MED003', 'Amoxicilina 500mg', 'Antibiótico', 27.12, 29120.00, 485, 20, 'Antibióticos', 'Lab MNO', NULL, 1, '2025-10-22 02:34:39', '2025-11-02 19:21:48'),
(4, 'MED004', 'Losartán 50mg', 'Antihipertensivo', 20000.00, 22000.00, 300, 15, 'Cardiovascular', 'Lab ABC', '2028-09-29', 1, '2025-10-22 02:34:39', '2025-11-02 18:40:13'),
(5, 'MED005', 'Omeprazol 20mg', 'Antiulceroso', 8500.00, 10500.00, 120, 20, 'Gastro', 'Lab XYZ', '2029-01-01', 1, '2025-10-22 02:34:39', '2025-11-02 18:42:34'),
(6, 'MED006', 'Diclofenaco 50mg', '', 3100.00, 5100.00, 300, 15, 'Antiinflamatorios', '', '2028-12-01', 1, '2025-10-24 17:01:59', '2025-11-02 17:57:45'),
(8, 'MED007', 'Metronidazol 500mg', '', 10000.00, 15000.00, 290, 20, 'Antibióticos', 'Lab MNO', '2027-11-29', 1, '2025-10-29 20:50:45', '2025-11-02 18:41:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepciones`
--

CREATE TABLE `recepciones` (
  `id` int(11) NOT NULL,
  `numero_recepcion` varchar(20) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `proveedor` varchar(200) NOT NULL,
  `numero_documento` varchar(50) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `observaciones` text DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recepciones`
--

INSERT INTO `recepciones` (`id`, `numero_recepcion`, `fecha`, `proveedor`, `numero_documento`, `total`, `id_usuario`, `observaciones`, `fecha_creacion`) VALUES
(1, 'REC000001', '2025-10-05 09:30:00', 'Distribuidora Medifarm S.A.S', 'FC-2025-1001', 2850000.00, 1, 'Recepción mensual de analgésicos', '2025-10-05 14:30:00'),
(2, 'REC000002', '2025-10-10 14:15:00', 'Laboratorios La Santé', 'FAC-8745', 1890000.00, 1, 'Antibióticos y antiinflamatorios', '2025-10-10 19:15:00'),
(3, 'REC000003', '2025-10-18 10:45:00', 'Droguerías Unidos', 'FC-5521', 3420000.00, 1, 'Compra trimestral', '2025-10-18 15:45:00'),
(4, 'REC000004', '2025-10-25 16:20:00', 'Pharma Express Ltda', 'REM-7789', 1560000.00, 1, 'Reposición stock bajo', '2025-10-25 21:20:00'),
(5, 'REC000005', '2025-11-01 11:00:00', 'Distribuidora Medifarm S.A.S', 'FC-2025-1125', 2940000.00, 1, 'Recepción mensual noviembre', '2025-11-01 16:00:00'),
(6, 'REC000006', '2025-11-02 12:57:45', 'Laboratorio S.A.S', '', 3490000.00, 1, '', '2025-11-02 17:57:45'),
(7, 'REC000007', '2025-11-02 14:09:09', 'Medifarm', '', 2000000.00, 1, '', '2025-11-02 19:09:09'),
(8, 'REC000008', '2025-11-02 14:10:16', 'Laboratorio S.A.S', '', 1590000.00, 1, '', '2025-11-02 19:10:16');

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
(1, 'admin', 'admin123', 'Alfredo Mercado', 'administrador', 1, '2025-10-22 00:35:54', '2025-11-02 19:51:31'),
(2, 'vendedor1', 'vendedor123', 'Juan Pérez', 'vendedor', 1, '2025-10-22 01:01:24', '2025-11-02 17:35:19'),
(3, 'gerente1', 'gerente123', 'Edgar Rodelo', 'gerente', 1, '2025-10-22 21:37:23', '2025-11-02 19:46:12'),
(4, 'vendedor2', 'vendedor321', 'Jesus Cera', 'vendedor', 1, '2025-10-29 21:03:22', '2025-10-29 23:02:26'),
(5, 'admin2', 'admin2106', 'Jaider Gonzalez', 'administrador', 1, '2025-11-02 18:29:54', '2025-11-02 18:30:04'),
(6, 'gerente2', 'gerente321', 'Miguelangel Almarales', 'gerente', 1, '2025-11-02 19:52:14', '2025-11-02 19:52:22');

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
-- Indices de la tabla `detalle_recepciones`
--
ALTER TABLE `detalle_recepciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_detalle_recepciones_recepcion` (`id_recepcion`),
  ADD KEY `idx_detalle_recepciones_producto` (`id_producto`);

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
-- Indices de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_recepcion` (`numero_recepcion`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `idx_recepciones_fecha` (`fecha`),
  ADD KEY `idx_recepciones_proveedor` (`proveedor`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `detalle_facturas`
--
ALTER TABLE `detalle_facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT de la tabla `detalle_recepciones`
--
ALTER TABLE `detalle_recepciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
-- Filtros para la tabla `detalle_recepciones`
--
ALTER TABLE `detalle_recepciones`
  ADD CONSTRAINT `detalle_recepciones_ibfk_1` FOREIGN KEY (`id_recepcion`) REFERENCES `recepciones` (`id`),
  ADD CONSTRAINT `detalle_recepciones_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id`);

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

--
-- Filtros para la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD CONSTRAINT `recepciones_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
