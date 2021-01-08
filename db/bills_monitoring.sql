-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 31, 2020 at 08:25 AM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bills_monitoring`
--

-- --------------------------------------------------------

--
-- Table structure for table `attachments`
--

CREATE TABLE `attachments` (
  `ID` int(11) NOT NULL,
  `attachment_id` varchar(20) NOT NULL,
  `billing_id` varchar(20) NOT NULL,
  `attachment` varchar(255) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- Error reading data for table bills_monitoring.attachments: #1064 - You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'FROM `bills_monitoring`.`attachments`' at line 1

-- --------------------------------------------------------

--
-- Table structure for table `billings`
--

CREATE TABLE `billings` (
  `ID` int(11) NOT NULL,
  `billing_id` varchar(20) NOT NULL,
  `bill_id` varchar(20) NOT NULL,
  `soa_number` varchar(20) DEFAULT NULL,
  `month_year` date NOT NULL,
  `bill_received_date` datetime NOT NULL,
  `amount` double NOT NULL,
  `due_date` date NOT NULL,
  `billing_period_start` date NOT NULL,
  `billing_period_end` date NOT NULL,
  `payment_status` int(1) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `remarks` text,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `billings`
--

INSERT INTO `billings` (`ID`, `billing_id`, `bill_id`, `soa_number`, `month_year`, `bill_received_date`, `amount`, `due_date`, `billing_period_start`, `billing_period_end`, `payment_status`, `created_by`, `remarks`, `date_created`, `date_modified`, `status`) VALUES
(20, '2020128-266984', '2020128-244044', '123123', '2020-01-28', '2020-01-15 00:00:00', 1000, '2020-01-31', '2020-01-28', '2020-01-31', 0, 'Jericho Cosico', 'Remarks', '2020-01-28 16:22:48', '2020-01-28 16:22:48', 0),
(21, '2020128-780522', '2020128-857041', '03948756321', '2019-12-16', '2020-01-30 00:00:00', 100.23, '2020-01-29', '2019-12-16', '2020-01-15', 1, 'super admin', '', '2020-01-28 18:14:59', '2020-01-30 15:32:59', 1),
(22, '2020129-436634', '2020129-114134', '9173253', '2019-12-21', '2020-01-29 00:00:00', 1000, '2020-02-03', '2019-12-21', '2020-01-20', 0, 'super admin', '', '2020-01-29 09:37:09', '2020-01-30 15:32:12', 1),
(23, '2020129-621840', '2020129-797591', '0', '2019-12-26', '2020-01-29 00:00:00', 1000.24, '2020-02-08', '2019-12-26', '2020-01-25', 0, 'Charmaine Cruz', '', '2020-01-29 10:06:25', '2020-01-29 11:49:19', 1),
(24, '2020131-603740', '2020128-914212', '9286472', '2019-12-31', '2020-01-31 00:00:00', 985.54, '2020-02-14', '2019-12-31', '2020-01-30', 0, 'super admin', '', '2020-01-31 13:24:29', '2020-01-31 13:24:29', 1);

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `ID` int(11) NOT NULL,
  `bill_id` varchar(20) NOT NULL,
  `bill` text NOT NULL,
  `account_name` varchar(50) NOT NULL,
  `account_number` int(11) NOT NULL,
  `tel_no` bigint(11) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- Error reading data for table bills_monitoring.bills: #1064 - You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'FROM `bills_monitoring`.`bills`' at line 1

-- --------------------------------------------------------

--
-- Table structure for table `bills_payment`
--

CREATE TABLE `bills_payment` (
  `ID` int(11) NOT NULL,
  `bill_payment_id` varchar(20) NOT NULL,
  `billing_id` varchar(20) NOT NULL,
  `accountable_person` varchar(50) NOT NULL,
  `voucher_number` varchar(20) NOT NULL,
  `voucher_date` date NOT NULL,
  `amount` double NOT NULL,
  `cheque_number` varchar(20) DEFAULT NULL,
  `cheque_date` date DEFAULT NULL,
  `bank` varchar(50) DEFAULT NULL,
  `prepared_by` varchar(50) NOT NULL,
  `received_by` varchar(50) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `payment_type` tinyint(1) NOT NULL,
  `status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- Error reading data for table bills_monitoring.bills_payment: #1064 - You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'FROM `bills_monitoring`.`bills_payment`' at line 1

-- --------------------------------------------------------

--
-- Table structure for table `colors`
--

CREATE TABLE `colors` (
  `id` int(11) NOT NULL,
  `color_id` varchar(20) NOT NULL,
  `color` varchar(255) NOT NULL,
  `color_status` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `colors`
--

INSERT INTO `colors` (`id`, `color_id`, `color`, `color_status`, `status`) VALUES
(1, '2020128-12345', 'red darken-4', 1, 1),
(2, '2020127-67890', 'pink lighten-2', 0, 1),
(3, '2020126-13524', 'purple accent-4', 0, 1),
(4, '2020125-68097', 'deep-purple darken-1', 0, 1),
(5, '20200130-1A237', 'indigo darken-4', 0, 1),
(6, '20200130-0D47A', 'blue darken-2', 0, 1),
(9, '20200130-039BE5', 'light-blue darken-1', 0, 1),
(10, '20200130-26C6DA', 'cyan accent-4', 0, 1),
(13, '20200130-00695C', 'teal darken-1', 0, 1),
(14, '20200130-2E7D32', 'green darken-2', 0, 1),
(17, '20200130-7CB342', 'light-green darken-1', 0, 1),
(18, '20200130-9E9D24', 'lime darken-3', 0, 1),
(20, '20200130-FFD60', 'yellow accent-4', 0, 1),
(22, '20200130-FFCA28', 'amber lighten-1', 0, 1),
(24, '20200130-E65100', 'orange darken-4', 0, 1),
(26, '20200130-FF7043', 'deep-orange lighten-1', 0, 0),
(28, '20200130-3E2723', 'brown accent-4', 0, 1),
(30, '20200130-546E7A', 'blue-grey darken-1', 0, 1),
(32, '20200130-212121', 'grey darken-4', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `dark_mode`
--

CREATE TABLE `dark_mode` (
  `id` int(11) NOT NULL,
  `dark_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dark_mode`
--

INSERT INTO `dark_mode` (`id`, `dark_id`, `user_id`, `status`) VALUES
(1, '2020128-76543', 'su2020130-752767', 1);

-- --------------------------------------------------------

--
-- Table structure for table `email`
--

CREATE TABLE `email` (
  `id` int(11) NOT NULL,
  `email_id` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `status` int(1) NOT NULL,
  `sender_password` varchar(255) NOT NULL,
  `email_time_hour` int(2) NOT NULL,
  `email_time_minute` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `email`
--

INSERT INTO `email` (`id`, `email_id`, `email`, `created_date`, `modified_date`, `status`, `sender_password`, `email_time_hour`, `email_time_minute`) VALUES
(2, 'e20201-203380', 'kathbalbas@gmail.com', '2020-01-24 11:53:14', '2020-01-31 13:15:51', 1, '', 0, 0),
(4, 'e2020127-343240', 'kbalbas@cahera.com', '2020-01-28 00:00:00', '2020-01-31 11:07:11', 2, '$Cahera0370', 10, 0);

-- --------------------------------------------------------

--
-- Table structure for table `service_provider`
--

CREATE TABLE `service_provider` (
  `id` int(11) NOT NULL,
  `service_id` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `status` tinyint(1) NOT NULL,
  `created_by` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `service_provider`
--

INSERT INTO `service_provider` (`id`, `service_id`, `name`, `date_created`, `date_modified`, `status`, `created_by`) VALUES
(5, 'sp2020128-347271', 'Sun', '2020-01-28 10:22:05', '2020-01-30 17:11:15', 1, 'super admin'),
(6, 'sp2020128-329855', 'Globe', '2020-01-28 18:11:22', '2020-01-30 15:32:23', 1, 'super admin'),
(7, 'sp2020128-492326', 'Meralco', '2020-01-28 18:11:31', '2020-01-30 15:32:28', 1, 'super admin'),
(8, 'sp2020128-142807', 'PLDT', '2020-01-28 18:11:40', '2020-01-30 15:32:34', 1, 'super admin'),
(9, 'sp2020129-977734', 'Bloomingdale Water', '2020-01-29 09:41:14', '2020-01-29 11:43:16', 1, 'Charmaine Cruz');

-- --------------------------------------------------------

--
-- Table structure for table `settings_color`
--

CREATE TABLE `settings_color` (
  `id` int(11) NOT NULL,
  `settings_color_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `color_id` varchar(20) NOT NULL,
  `date_modified` datetime NOT NULL,
  `status` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `settings_color`
--

INSERT INTO `settings_color` (`id`, `settings_color_id`, `user_id`, `color_id`, `date_modified`, `status`) VALUES
(1, 'sc-2020130-1000', 'u2020129-70093', '2020128-12345', '2020-01-30 00:00:00', 1),
(3, 'sc-2020130-1001', 'u2020128-109980', '2020127-67890', '2020-01-30 00:00:00', 1),
(4, 'sc2020130-786459', 'su2020130-752767', '2020126-13524', '2020-01-30 15:26:39', 1),
(5, 'sc2020131-984288', 'u2020131-154878', '2020125-68097', '2020-01-31 09:41:59', 1),
(6, 'sc2020131-545337', 'u2020131-74758', '2020125-68097', '2020-01-31 15:14:06', 1),
(7, 'sc2020131-182235', 'u2020131-439197', '2020125-68097', '2020-01-31 15:23:29', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_id`, `fname`, `lname`, `username`, `password`, `date_created`, `date_modified`, `status`) VALUES
(3, 'u2020128-109980', 'Kathleen', 'Balbas', 'kath', 'sha1$16ca478e$1$49f0097f3456207db46c7e0582de409d4750030d', '2020-01-28 15:51:37', '2020-01-31 14:42:01', 1),
(4, 'u2020129-70093', 'Charmaine', 'Cruz', 'maine', 'sha1$90a9533c$1$267f2ef57895486952abdd6501409a696649507e', '2020-01-29 10:22:00', '2020-01-31 15:13:41', 1),
(5, 'su2020130-752767', 'super', 'admin', 'admin', 'sha1$618e6e0a$1$bec8f8d4fa07b616fc19947aa23ee2e3876fe49a', '2020-01-30 15:26:39', '2020-01-31 09:40:02', 9),
(8, 'u2020131-439197', 'Majory', 'De Guzman', 'majo', 'sha1$8441b418$1$d3ed227dc683a2bd6898d939c0b85100ffeeed89', '2020-01-31 15:23:29', '2020-01-31 15:23:29', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `billings`
--
ALTER TABLE `billings`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `bills_payment`
--
ALTER TABLE `bills_payment`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `colors`
--
ALTER TABLE `colors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dark_mode`
--
ALTER TABLE `dark_mode`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `email`
--
ALTER TABLE `email`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `service_provider`
--
ALTER TABLE `service_provider`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings_color`
--
ALTER TABLE `settings_color`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attachments`
--
ALTER TABLE `attachments`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `billings`
--
ALTER TABLE `billings`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `bills_payment`
--
ALTER TABLE `bills_payment`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `colors`
--
ALTER TABLE `colors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `dark_mode`
--
ALTER TABLE `dark_mode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `email`
--
ALTER TABLE `email`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `service_provider`
--
ALTER TABLE `service_provider`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `settings_color`
--
ALTER TABLE `settings_color`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
