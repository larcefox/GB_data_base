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
	`on_delete` BOOL DEFAULT 0,
  PRIMARY KEY (`INN`,`KPP`),
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
	`on_delete` BOOL DEFAULT 0,
  PRIMARY KEY (`INN`,`KPP`),
  UNIQUE KEY `INN_2` (`INN`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`),
  KEY `name` (`name`),
  KEY `INN` (`INN`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` SERIAL,
	`firstname` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`lastname` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`pass_hash` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`phone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
	`on_delete` BOOL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `users_phone_idx` (`phone`),
  KEY `firstname` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	`user_id` BIGINT UNSIGNED NOT NULL,
	`gender` enum('m','f'),
	`birthday` date DEFAULT NULL,
	`photo_id` bigint(20) unsigned DEFAULT NULL,
	`hometown` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
	`created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `user_id_2` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES users(`id`) 
  	ON UPDATE CASCADE
  	ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `document_type`;
CREATE TABLE `document_type` (
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS user_documents;
CREATE TABLE user_documents (
	`id` SERIAL,
	`dock_sum` DECIMAL(15, 2), 
	`dock_number` VARCHAR(255) NOT NULL DEFAULT 'б/н',
	`dock_date` datetime DEFAULT current_timestamp(),
	`GUID` VARCHAR(40)  NOT NULL UNIQUE,
	`author` bigint(20) unsigned NOT NULL,
	`organisation_id` bigint(20) unsigned NOT NULL,
	`contractor_id` bigint(20) unsigned NOT NULL,
	`caption` VARCHAR(255) DEFAULT NULL,	
	`date_of_create` datetime DEFAULT current_timestamp(),
	`date_of_change` datetime DEFAULT NULL,
	`on_delete` BOOL DEFAULT 0,
	FOREIGN KEY (`author`) REFERENCES users(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,
    FOREIGN KEY (`organisation_id`) REFERENCES organisation(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,	
    FOREIGN KEY (`contractor_id`) REFERENCES contractor(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,
	INDEX num_date_idx(`dock_number`, `dock_date`),
	INDEX GUID_idx(`GUID`),
	INDEX org_contr_idx(`organisation_id`, `contractor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS user_forms;
CREATE TABLE user_forms (
	`doc_id` BIGINT UNSIGNED NOT NULL,
	`themes` ENUM('light', 'darck', 'neutral', 'contrast'),
	FOREIGN KEY (`doc_id`) REFERENCES user_documents(id)
		ON UPDATE CASCADE
    	ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS user_form_elements_type;
CREATE TABLE user_form_elements (
	`id` SERIAL,
	`name` VARCHAR(255),
	`type` ENUM('text', 'check', 'sum', 'group', 'button'),
	`axis_x` INT(4),
	`axis_y` INT(4),
	`size_x` INT(4),
	`size_y` INT(4)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS forms_elements;
CREATE TABLE forms_elements(
	`form_id` BIGINT UNSIGNED NOT NULL,
	`element_id` BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (`form_id`, `element_id`),
    FOREIGN KEY (`form_id`) REFERENCES user_forms(`doc_id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,
    FOREIGN KEY (`element_id`) REFERENCES user_form_elements(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS info_registr;
CREATE TABLE info_registr (
	`id` SERIAL,
	`reg_measure` VARCHAR(255),
	`reg_summ` DECIMAL(15, 2),
--	`doc_id` BIGINT UNSIGNED NOT NULL COMMENT 'Dockument',
	`date_of_create` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS account_registr;
CREATE TABLE account_registr (
	`id` SERIAL,
	`moving_type` enum('приход','расход'),
	`reg_source` VARCHAR(255),
	`reg_measure` VARCHAR(255),
	`reg_quantity` INT,
	`reg_summ` DECIMAL(15, 2),
	`doc_id` BIGINT UNSIGNED NOT NULL COMMENT 'Dockument',
	`date_of_create` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS remains_registr;
CREATE TABLE remains_registr (
	`id` SERIAL,
	`moving_type` enum('приход','расход'),
	`reg_source` VARCHAR(255),
	`reg_measure` VARCHAR(255),
	`reg_quantity` INT,
	`reg_summ` DECIMAL(15, 2),
	`doc_id` BIGINT UNSIGNED NOT NULL COMMENT 'Dockument',
	`date_of_create` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS constants_registr;
CREATE TABLE constants_registr (
	`id` SERIAL,
	`const_key` VARCHAR(255),
	`const_value` VARCHAR(255)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- наполнение данными
SELECT SHA(NOW());


-- скрипты выборок



-- представления



-- хранимые процедуры / тригеры


-- TODO Замкнуть measure на docks, 
--               константы на docs, 
--               остатки на аккаунтс, 
--               межур на аккаунтс,
--               в остатках сформировать межур,
--               докс на док тайп (табл. соответствия)
--               info_reg to orgs
--               user forms to dock types













