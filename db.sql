-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Nov 23, 2020 at 08:44 AM
-- Server version: 5.7.26
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `box_time`
--

-- --------------------------------------------------------

--
-- Table structure for table `drawn_boxes`
--

CREATE TABLE `drawn_boxes` (
  `ID` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `img_path` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `iou` float NOT NULL,
  `height` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `time` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `drawn_points`
--

CREATE TABLE `drawn_points` (
  `ID` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `img_path` varchar(255) NOT NULL,
  `point_1_x` int(11) NOT NULL,
  `point_2_x` int(11) NOT NULL,
  `point_3_x` int(11) NOT NULL,
  `point_4_x` int(11) NOT NULL,
  `point_1_y` int(11) NOT NULL,
  `point_2_y` int(11) NOT NULL,
  `point_3_y` int(11) NOT NULL,
  `point_4_y` int(11) NOT NULL,
  `iou` float NOT NULL,
  `time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `drawn_boxes`
--
ALTER TABLE `drawn_boxes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `drawn_points`
--
ALTER TABLE `drawn_points`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `drawn_boxes`
--
ALTER TABLE `drawn_boxes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drawn_points`
--
ALTER TABLE `drawn_points`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
