-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-11-2016 a las 15:07:13
-- Versión del servidor: 10.1.10-MariaDB
-- Versión de PHP: 5.6.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `almacen`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `NombreAlmacen` varchar(30) NOT NULL,
  `Ubicacion` varchar(40) NOT NULL,
  `Telefono` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `CodEmpleado` int(10) UNSIGNED NOT NULL,
  `Cedula` varchar(10) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  `Apellido` varchar(30) NOT NULL,
  `Telefono` varchar(12) NOT NULL,
  `Cargo` varchar(15) NOT NULL,
  `EsActivo` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimiento`
--

CREATE TABLE `movimiento` (
  `CodDespacho` int(10) UNSIGNED NOT NULL,
  `CodProducto` int(10) UNSIGNED NOT NULL,
  `CodEmpleado` int(10) UNSIGNED NOT NULL,
  `Solicitante` varchar(30) NOT NULL,
  `Cantidad` int(10) UNSIGNED NOT NULL,
  `Fecha` date NOT NULL,
  `Hora` time NOT NULL,
  `EsValido` tinyint(1) NOT NULL DEFAULT '1',
  `CodUsuario` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `CodProducto` int(10) UNSIGNED NOT NULL,
  `Descripcion` varchar(100) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `UnidadMedida` varchar(15) NOT NULL,
  `Cantidad` int(10) UNSIGNED NOT NULL,
  `Precio` int(10) UNSIGNED NOT NULL,
  `EsValido` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`CodProducto`, `Descripcion`, `UnidadMedida`, `Cantidad`, `Precio`, `EsValido`) VALUES
(1, 'PENICILINA', '50 MG', 80, 700, 1),
(2, 'INYECTADORA', '10 CC', 150, 120, 1),
(3, 'ALCOHOL ISOPROPILICO', '1000 ML', 185, 280, 1),
(4, 'ALCOHOL ISOPROPILICO', '500 ML', 30, 140, 1),
(5, 'AGUA OXIGENADA', '500 ML', 105, 160, 1),
(6, 'AGUA OXIGENADA', '100 ML', 120, 40, 1),
(7, 'ACETAMINOFEN', '50 ML', 65, 380, 1),
(8, 'ASPIRINA', '10 MG', 300, 50, 1),
(9, 'ALGODON', '100 GR', 85, 300, 1),
(10, 'MORFINA', '10 ML', 20, 5000, 1),
(11, 'MERTHIOLATE', '100 ML', 55, 400, 1),
(12, 'ALCOHOL ISOPROPILICO', '250 ML', 65, 70, 1),
(13, 'AGUA DESTILADA', '1000 ML', 45, 500, 1),
(14, 'DAMENAL GOTAS', '10 ML', 30, 450, 1),
(15, 'SUERO', '1000 ML', 125, 320, 1),
(16, 'VIAGRA', '100 MG', 20, 2800, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `CodUsuario` int(10) UNSIGNED NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Clave` varchar(10) NOT NULL,
  `Nivel` varchar(10) NOT NULL,
  `EsActivo` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`CodEmpleado`);

--
-- Indices de la tabla `movimiento`
--
ALTER TABLE `movimiento`
  ADD PRIMARY KEY (`CodDespacho`),
  ADD KEY `codproducto` (`CodProducto`),
  ADD KEY `codempleado` (`CodEmpleado`),
  ADD KEY `CodUsuario` (`CodUsuario`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`CodProducto`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`CodUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `CodEmpleado` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `movimiento`
--
ALTER TABLE `movimiento`
  MODIFY `CodDespacho` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `CodProducto` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `CodUsuario` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `movimiento`
--
ALTER TABLE `movimiento`
  ADD CONSTRAINT `movimiento_ibfk_1` FOREIGN KEY (`codproducto`) REFERENCES `productos` (`codproducto`),
  ADD CONSTRAINT `movimiento_ibfk_2` FOREIGN KEY (`codempleado`) REFERENCES `empleados` (`codempleado`),
  ADD CONSTRAINT `movimiento_ibfk_3` FOREIGN KEY (`CodUsuario`) REFERENCES `usuarios` (`codusuario`),
  ADD CONSTRAINT `movimiento_ibfk_4` FOREIGN KEY (`CodProducto`) REFERENCES `productos` (`codproducto`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
