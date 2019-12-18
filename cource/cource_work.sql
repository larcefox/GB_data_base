
/* Курсовая работа. Субботин Андрей.

	Описание

*/

-- скрипты создания структуры БД

DROP DATABASE IF EXISTS Intelligent_Finance;
CREATE DATABASE Intelligent_Finance;
USE Intelligent_Finance;

DROP TABLE IF EXISTS `contractor`;
CREATE TABLE `contractor` (
	`id` SERIAL,
	`name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`adress` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
	`phone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
	`email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`law_status` enum('person','corporate') COLLATE utf8_unicode_ci DEFAULT NULL,
	`INN` int(10) unsigned NOT NULL,
	`KPP` int(10) unsigned NOT NULL,
	`date_of_create` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`INN`,`KPP`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `INN_2` (`INN`),
  UNIQUE KEY `INN_3` (`INN`),
  UNIQUE KEY `KPP` (`KPP`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`),
  KEY `name` (`name`),
  KEY `INN` (`INN`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `organisation`;
CREATE TABLE `organisation` (
	`id` SERIAL,
	`name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`adress` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
	`phone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
	`email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`law_status` enum('person','corporate') COLLATE utf8_unicode_ci DEFAULT NULL,
	`INN` int(10) NOT NULL DEFAULT 0,
	`KPP` int(10) NOT NULL,
	`date_of_create` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`INN`,`KPP`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `INN_2` (`INN`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`),
  KEY `name` (`name`),
  KEY `INN` (`INN`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	`user_id` SERIAL,
	`gender` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
	`birthday` date DEFAULT NULL,
	`photo_id` bigint(20) unsigned DEFAULT NULL,
	`hometown` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `user_id_2` (`user_id`),
  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` SERIAL,
	`firstname` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`lastname` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`pass_hash` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`phone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `users_phone_idx` (`phone`),
  KEY `firstname` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS user_documents;
CREATE TABLE user_documents (
	`id` SERIAL,
	`dock_number` VARCHAR(255) NOT NULL DEFAULT 'б/н',
	`dock_date` datetime DEFAULT current_timestamp(),
	`GUID` VARCHAR(40)  NOT NULL UNIQUE,
	`author` bigint(20) unsigned NOT NULL,
	`organisation_id` bigint(20) unsigned NOT NULL,
	`contractor_id` bigint(20) unsigned NOT NULL,
	`caption` VARCHAR(255) DEFAULT NULL,	
	`date_of_create` datetime DEFAULT current_timestamp(),
	`date_of_change` datetime DEFAULT NULL,
	INDEX num_date_idx(`dock_number`, `dock_date`),
	INDEX GUID_idx(`GUID`),
	INDEX org_contr_idx(`organisation_id`, `contractor_id`),
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `document_type`;
CREATE TABLE `standart_document` (
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS user_forms;
CREATE TABLE user_form (
	`id` SERIAL,
	themth ENUM('light', 'darck', 'neutral', 'contrast'),
	
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS user_form_elements;
CREATE TABLE user_form_elements (
	`id` SERIAL
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS data_registr;
CREATE TABLE data_registr (
	`id` SERIAL
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS account_registr;
CREATE TABLE account_registr (
	`id` SERIAL
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS constants_registr;
CREATE TABLE constants_registr (
	`id` SERIAL
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- наполнение данными
SELECT SHA(NOW());


-- скрипты выборок



-- представления



-- хранимые процедуры / тригеры




































