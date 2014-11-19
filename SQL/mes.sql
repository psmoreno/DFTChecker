-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-11-2014 a las 20:54:00
-- Versión del servidor: 5.5.39
-- Versión de PHP: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `mes`
--
CREATE DATABASE IF NOT EXISTS `mes` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `mes`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_wp_dft_detail`
--

CREATE TABLE IF NOT EXISTS `tb_wp_dft_detail` (
  `seq` int(11) NOT NULL,
  `lotid` varchar(20) NOT NULL,
  `run` int(11) NOT NULL,
  `step_no` int(11) NOT NULL,
  `step_name` varchar(20) NOT NULL,
  `result` varchar(3) NOT NULL,
  `time` float NOT NULL,
  `message` varchar(20) NOT NULL,
  `machine_no` int(11) NOT NULL,
  `line_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_wp_dft_master`
--

CREATE TABLE IF NOT EXISTS `tb_wp_dft_master` (
  `seq` int(11) NOT NULL,
  `lotid` varchar(20) NOT NULL,
  `result` varchar(3) NOT NULL,
  `machine_no` int(11) NOT NULL,
  `line_id` int(11) NOT NULL,
  `time` float NOT NULL,
  `chassis` varchar(10) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `model` varchar(20) NOT NULL,
  `suffix` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla principal de datos de los DFT';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
