-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-12-2014 a las 10:46:48
-- Versión del servidor: 5.5.39
-- Versión de PHP: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `dft`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tdftresults`
--

CREATE TABLE IF NOT EXISTS `tdftresults` (
`Id` int(11) NOT NULL,
  `OfSerie` varchar(20) DEFAULT NULL COMMENT 'OF-Serial de la placa producida',
  `Result` varchar(2) DEFAULT NULL COMMENT 'Resultado test: OK-NG',
  `TestDate` varchar(15) DEFAULT NULL COMMENT 'Fecha del test',
  `TestHour` varchar(15) DEFAULT NULL COMMENT 'Hora del test',
  `NJig` int(11) DEFAULT NULL COMMENT 'En que JIG se realizo',
  `Line_id` int(11) DEFAULT NULL COMMENT 'Numero que identifica la linea',
  `TestTime` double DEFAULT NULL COMMENT 'Duracion test en segundos',
  `Chassis` varchar(20) DEFAULT NULL COMMENT 'Chasis DFT usado'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Tabla que contiene resultados de los testeos' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tdms`
--

CREATE TABLE IF NOT EXISTS `tdms` (
`Id` int(11) NOT NULL,
  `DMSdate` varchar(15) NOT NULL COMMENT 'Fecha en la que se realizo la operacion DMS',
  `DMShour` varchar(15) NOT NULL COMMENT 'Hora en la que se realizo la operacion DMS',
  `OfSerial` varchar(20) NOT NULL COMMENT 'Serial de la placa con DMS',
  `ModelName` varchar(20) NOT NULL COMMENT 'Nombre del modelo'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Tabla que guarda placas registradas DMS' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tlinkofmod`
--

CREATE TABLE IF NOT EXISTS `tlinkofmod` (
`Id` int(11) NOT NULL,
  `strOf` varchar(20) NOT NULL COMMENT 'Orden de fabricacion',
  `strModel` varchar(20) NOT NULL COMMENT 'Modelo a producir',
  `Nbox` int(4) NOT NULL COMMENT 'Cantidad de placas que contiene la caja',
  `ActualMagazzine` int(4) DEFAULT '0' COMMENT 'Guarda que magazzine se esta llenando',
  `ActualCount` int(4) DEFAULT '0' COMMENT 'Indica cuantas placas se ha hecho de la OF',
  `Status` int(3) NOT NULL DEFAULT '1' COMMENT 'Estado: 0-Cerrada,1-abierta',
  `Observ` varchar(150) DEFAULT NULL COMMENT 'Se guardaran observaciones en caso de que sea necesario'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Tabla que guarda vinculos OF-Modelo' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tmagazzines`
--

CREATE TABLE IF NOT EXISTS `tmagazzines` (
`Id` int(11) NOT NULL,
  `NMagazzine` int(4) NOT NULL COMMENT 'Nro de magazzine para dicha OF',
  `OrdenF` varchar(20) NOT NULL COMMENT 'Orde de fabricacion del magazzine',
  `Qty` int(11) DEFAULT NULL COMMENT 'Cantidad de placas que entran',
  `RealQty` int(11) NOT NULL COMMENT 'Cantidad real de placas en el magazzine'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='Registro de los magazzines que se llenaron' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tmodels`
--

CREATE TABLE IF NOT EXISTS `tmodels` (
`Id` int(11) NOT NULL,
  `ModelName` varchar(20) NOT NULL COMMENT 'Nombre del modelo a producir'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Tabla que guarda modelos de TV' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tordenf`
--

CREATE TABLE IF NOT EXISTS `tordenf` (
`Id` int(11) NOT NULL,
  `OrdenF` varchar(20) DEFAULT NULL COMMENT 'Guarda la orden de fabricacion',
  `Qty` int(5) NOT NULL COMMENT 'Cantidad de placas que contiene la orden',
  `Status` int(3) NOT NULL DEFAULT '1' COMMENT 'Estado OF 0-cerrado, 1-abierta'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Tabla que guarda ordenes de fabricacion' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `twrongpcb`
--

CREATE TABLE IF NOT EXISTS `twrongpcb` (
`Id` int(11) NOT NULL,
  `WRDate` varchar(15) NOT NULL COMMENT 'Fecha del escaneo',
  `WRHour` varchar(15) NOT NULL COMMENT 'Hora del escaneo',
  `ModelName` varchar(50) NOT NULL COMMENT 'En caso de que la identifique',
  `OfSerial` varchar(50) NOT NULL COMMENT 'Lo que se registro el escaner'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='Guarda informa sobre placas escaneadas' AUTO_INCREMENT=1 ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tdftresults`
--
ALTER TABLE `tdftresults`
 ADD PRIMARY KEY (`Id`), ADD UNIQUE KEY `Id_UNIQUE` (`Id`);

--
-- Indices de la tabla `tdms`
--
ALTER TABLE `tdms`
 ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `tlinkofmod`
--
ALTER TABLE `tlinkofmod`
 ADD PRIMARY KEY (`Id`), ADD UNIQUE KEY `Id_UNIQUE` (`Id`), ADD UNIQUE KEY `strOf` (`strOf`), ADD UNIQUE KEY `strOf_2` (`strOf`);

--
-- Indices de la tabla `tmagazzines`
--
ALTER TABLE `tmagazzines`
 ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `tmodels`
--
ALTER TABLE `tmodels`
 ADD PRIMARY KEY (`Id`), ADD UNIQUE KEY `Id_UNIQUE` (`Id`);

--
-- Indices de la tabla `tordenf`
--
ALTER TABLE `tordenf`
 ADD PRIMARY KEY (`Id`), ADD UNIQUE KEY `Id_UNIQUE` (`Id`);

--
-- Indices de la tabla `twrongpcb`
--
ALTER TABLE `twrongpcb`
 ADD PRIMARY KEY (`Id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tdftresults`
--
ALTER TABLE `tdftresults`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT de la tabla `tdms`
--
ALTER TABLE `tdms`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT de la tabla `tlinkofmod`
--
ALTER TABLE `tlinkofmod`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT de la tabla `tmagazzines`
--
ALTER TABLE `tmagazzines`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT de la tabla `tmodels`
--
ALTER TABLE `tmodels`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT de la tabla `tordenf`
--
ALTER TABLE `tordenf`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT de la tabla `twrongpcb`
--
ALTER TABLE `twrongpcb`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
