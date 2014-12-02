-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-11-2014 a las 16:29:27
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
-- Estructura de tabla para la tabla `controlpcb`
--

DROP TABLE IF EXISTS `controlpcb`;
CREATE TABLE IF NOT EXISTS `controlpcb` (
`Id` int(11) NOT NULL,
  `BPRdate` varchar(15) NOT NULL,
  `BPRhour` varchar(15) NOT NULL,
  `OfSerial` varchar(20) NOT NULL,
  `ModelName` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dftresults`
--

DROP TABLE IF EXISTS `dftresults`;
CREATE TABLE IF NOT EXISTS `dftresults` (
`Id` int(11) NOT NULL,
  `OfSerie` varchar(20) DEFAULT NULL,
  `Result` varchar(2) DEFAULT NULL,
  `TestDate` varchar(15) DEFAULT NULL,
  `TestHour` varchar(15) DEFAULT NULL,
  `NJig` int(11) DEFAULT NULL,
  `Line_id` int(11) DEFAULT NULL,
  `TestTime` double DEFAULT NULL,
  `Chassis` varchar(20) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1528 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pallet`
--

DROP TABLE IF EXISTS `pallet`;
CREATE TABLE IF NOT EXISTS `pallet` (
`PalletID` int(11) NOT NULL,
  `OrdenF` varchar(20) NOT NULL,
  `Qty` int(11) DEFAULT NULL,
  `FullQty` int(11) NOT NULL,
  `Observ` varchar(200) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='Guardado de pallet' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbpr`
--

DROP TABLE IF EXISTS `tbpr`;
CREATE TABLE IF NOT EXISTS `tbpr` (
`Id` int(11) NOT NULL,
  `BPRdate` varchar(15) NOT NULL,
  `BPRhour` varchar(15) NOT NULL,
  `OfSerial` varchar(20) NOT NULL,
  `ModelName` varchar(20) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=35 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tlinkofmod`
--

DROP TABLE IF EXISTS `tlinkofmod`;
CREATE TABLE IF NOT EXISTS `tlinkofmod` (
`Id` int(11) NOT NULL,
  `NBox` int(11) NOT NULL,
  `strOf` varchar(20) NOT NULL,
  `strModel` varchar(20) NOT NULL,
  `Status` int(3) NOT NULL DEFAULT '1'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tmodels`
--

DROP TABLE IF EXISTS `tmodels`;
CREATE TABLE IF NOT EXISTS `tmodels` (
`Id` int(11) NOT NULL,
  `ModelName` varchar(20) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tordenf`
--

DROP TABLE IF EXISTS `tordenf`;
CREATE TABLE IF NOT EXISTS `tordenf` (
`Id` int(11) NOT NULL,
  `OrdenF` varchar(20) DEFAULT NULL,
  `Status` int(3) NOT NULL DEFAULT '1'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wrongpcb`
--

DROP TABLE IF EXISTS `wrongpcb`;
CREATE TABLE IF NOT EXISTS `wrongpcb` (
`Id` int(11) NOT NULL,
  `BPRDate` varchar(15) NOT NULL,
  `BPRHour` varchar(15) NOT NULL,
  `ModelName` varchar(50) NOT NULL,
  `OfSerial` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='test table' AUTO_INCREMENT=1 ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `controlpcb`
--
ALTER TABLE `controlpcb`
 ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `dftresults`
--
ALTER TABLE `dftresults`
 ADD PRIMARY KEY (`Id`), ADD UNIQUE KEY `Id_UNIQUE` (`Id`);

--
-- Indices de la tabla `pallet`
--
ALTER TABLE `pallet`
 ADD PRIMARY KEY (`PalletID`);

--
-- Indices de la tabla `tbpr`
--
ALTER TABLE `tbpr`
 ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `tlinkofmod`
--
ALTER TABLE `tlinkofmod`
 ADD PRIMARY KEY (`Id`), ADD UNIQUE KEY `Id_UNIQUE` (`Id`), ADD UNIQUE KEY `strOf` (`strOf`), ADD UNIQUE KEY `strOf_2` (`strOf`), ADD UNIQUE KEY `NBox` (`NBox`);

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
-- Indices de la tabla `wrongpcb`
--
ALTER TABLE `wrongpcb`
 ADD PRIMARY KEY (`Id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `controlpcb`
--
ALTER TABLE `controlpcb`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `dftresults`
--
ALTER TABLE `dftresults`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1528;
--
-- AUTO_INCREMENT de la tabla `pallet`
--
ALTER TABLE `pallet`
MODIFY `PalletID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `tbpr`
--
ALTER TABLE `tbpr`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT de la tabla `tlinkofmod`
--
ALTER TABLE `tlinkofmod`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `tmodels`
--
ALTER TABLE `tmodels`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `tordenf`
--
ALTER TABLE `tordenf`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `wrongpcb`
--
ALTER TABLE `wrongpcb`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
