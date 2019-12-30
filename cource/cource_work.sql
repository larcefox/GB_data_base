/* Курсовая работа. Субботин Андрей.
	Курсовая работа по теме "Учетная система"
	Созданы таблицы:
		1. users - пользователи;
		2. profiles -профили пользователей;
		3. contractor - контрагенты;
		4. organisation - организации;
		5. document_type - типы документов;
		6. user_documents - пользовательские документы;
		7. user_forms - типы визуальных форм документов;
		8. user_form_elements - типы элементов управления;
		9. user_form_elements таюлица сопоставления форм и элементов;
		10.info_registr - регистр данных;
		11.account_registr - регистр накопления;
		12.remains_registr - регистр остатков.
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


DROP TABLE IF EXISTS info_registr;
CREATE TABLE info_registr (
	`id` SERIAL,
	`reg_measure` VARCHAR(255),
	`mesure_price` DECIMAL(15, 2),
	`date_of_create` datetime DEFAULT current_timestamp(),
	INDEX measure_idx(`reg_measure`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS constants_registr;
CREATE TABLE constants_registr (
	`id` SERIAL,
	`const_key` VARCHAR(255),
	`const_value` VARCHAR(255)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `document_type`;
CREATE TABLE `document_type` (
	`id` SERIAL PRIMARY KEY,
    `name` VARCHAR(255),
    `created_at` DATETIME DEFAULT NOW(),
    `moving_type` enum('приход','расход'),
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS user_documents;
CREATE TABLE user_documents (
	`id` SERIAL,
	`doc_type` bigint(20) unsigned NOT NULL,
	`doc_measure` bigint(20) unsigned NOT NULL,
	`doc_sum` DECIMAL(15, 2), 
	`doc_number` VARCHAR(255) NOT NULL DEFAULT 'б/н',
	`doc_date` datetime DEFAULT current_timestamp(),
	`GUID` VARCHAR(40)  NOT NULL UNIQUE,
	`author` bigint(20) unsigned NOT NULL,
	`organisation_id` bigint(20) unsigned NOT NULL,
	`contractor_id` bigint(20) unsigned NOT NULL,
	`caption` VARCHAR(255) DEFAULT NULL,	
	`date_of_create` datetime DEFAULT current_timestamp(),
	`date_of_change` datetime DEFAULT NULL,
	`on_delete` BOOL DEFAULT 0,
	FOREIGN KEY (`doc_type`) REFERENCES document_type(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,
    FOREIGN KEY (`doc_measure`) REFERENCES info_registr(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,
	FOREIGN KEY (`author`) REFERENCES users(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,
    FOREIGN KEY (`organisation_id`) REFERENCES organisation(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,	
    FOREIGN KEY (`contractor_id`) REFERENCES contractor(`id`)
    	ON UPDATE CASCADE
    	ON DELETE RESTRICT,
	INDEX num_date_idx(`doc_number`, `doc_date`),
	INDEX GUID_idx(`GUID`),
	INDEX org_contr_idx(`organisation_id`, `contractor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `account_registr`;
CREATE TABLE `account_registr` (
	`id` SERIAL,
	`moving_type` enum('приход','расход'),
	`reg_measure` VARCHAR(255),
	`reg_summ` DECIMAL(15, 2),
	`doc_id` BIGINT UNSIGNED NOT NULL COMMENT 'Dockument',
	`date_of_create` datetime DEFAULT current_timestamp(),
	FOREIGN KEY (`doc_id`) REFERENCES user_documents(id)
		ON UPDATE CASCADE
    	ON DELETE RESTRICT,
	INDEX measure_idx(`reg_measure`),
	INDEX doc_id_idx(`doc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS remains_registr;
CREATE TABLE remains_registr (
	`measure_id`  BIGINT UNSIGNED NOT NULL,
	`reg_summ` DECIMAL(15, 2),
	`date_of_create` datetime DEFAULT current_timestamp(),
	FOREIGN KEY (`measure_id`) REFERENCES info_registr(id)
		ON UPDATE CASCADE
    	ON DELETE RESTRICT,
	INDEX measure_idx(`measure_id`)
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


-- наполнение данными


INSERT INTO `constants_registr` VALUES ('1','libero','311576034'),
('2','reiciendis','3544337'),
('3','earum','891'),
('4','cumque','30218503'),
('5','odio','10416650'),
('6','ut','5787'),
('7','repudiandae','894742'),
('8','et','632535573'),
('9','sequi','55784'),
('10','cupiditate','16120'); 


INSERT INTO `contractor` VALUES ('7','Koelpin PLC','03751 Christiansen Hollow\nPort Claudborough, DC 42852-3973','1-678-180-63','denesik.reuben@example.org','corporate','4','6335','1982-09-22 18:44:03','0'),
('23','Hagenes LLC','78209 Tod Keys\nNiaville, IN 98192-2909','(193)764-064','udaniel@example.com','person','5','8489','2004-02-08 20:40:26','0'),
('26','Franecki Ltd','405 Kris Branch Suite 640\nWhiteberg, MD 90442','476.799.3717','jfarrell@example.net','corporate','9','5696601','2019-09-10 21:44:43','0'),
('85','Corkery, Corwin and Kozey','52265 Reinger Mountains Suite 850\nToniborough, GA 19621','01819302987','hardy73@example.org','corporate','27','75','1986-12-12 21:14:30','0'),
('35','Rodriguez and Sons','595 Brown Branch\nHellerborough, MO 06501','1-574-737-67','wisozk.gino@example.com','person','41','6190639','2001-05-12 18:52:53','0'),
('82','Harvey, Mann and Hudson','07820 Laila Club\nNew Clint, NV 30380','(988)794-973','wilkinson.skyla@example.org','person','43','4577975','1990-07-25 09:47:07','0'),
('96','Padberg-Leffler','268 Boyle Crossing Apt. 755\nSouth Milfordberg, CO 84697-4723','1-948-690-91','reynolds.loy@example.net','corporate','52','578','1991-06-07 06:03:01','0'),
('5','Hirthe-Ward','035 Hegmann Trail\nLake Lialand, NC 50833-6099','(883)992-580','wcassin@example.net','corporate','54','91','1992-05-24 22:49:31','0'),
('94','Dach-Weimann','528 Koepp Brooks Apt. 472\nDuBuquehaven, PA 85909','(152)914-287','nturcotte@example.com','person','67','92','1994-08-08 03:09:51','0'),
('72','Macejkovic, Schmitt and Bergnaum','2420 Harold Coves Suite 283\nReingerside, VT 35469','1-467-480-52','lucienne.feest@example.org','person','69','96','2015-09-20 04:00:05','0'),
('51','Heaney, Stracke and Jaskolski','8620 Beahan Flat\nRobelmouth, ND 09633','09728037945','tmorar@example.com','corporate','71','837596276','1994-01-19 13:24:14','0'),
('50','Oberbrunner, Gutkowski and Wunsch','782 Emanuel Turnpike\nHellerland, AK 78859-7848','1-102-572-05','richard.bogisich@example.org','corporate','74','38','1985-02-17 21:56:48','0'),
('60','Rutherford-Reichel','999 Kunde Manors Suite 383\nNikolausmouth, TN 28386','(207)576-417','ryann26@example.net','corporate','77','711972','1971-09-07 05:34:49','0'),
('20','Champlin Group','344 Runolfsson Spurs Suite 380\nThielton, VA 23153','807.382.4685','shanny.rau@example.com','person','84','17','2004-10-07 01:56:36','0'),
('47','Ebert PLC','1742 Dennis Radial Suite 401\nWest Elena, ID 95784-5301','638.448.3733','nolan.ida@example.org','person','87','8','1983-12-27 07:30:43','0'),
('92','Simonis, Bins and Murazik','4273 Howell Divide Apt. 696\nMadisenhaven, TN 98298','1-116-391-43','gdonnelly@example.org','person','97','2915011','1992-01-03 14:45:24','0'),
('34','Mueller-Hahn','49392 Friedrich Parkway Apt. 935\nWest Erikaberg, FL 39386','134-167-8808','schowalter.theresia@example.com','corporate','235','439489274','2009-03-07 20:24:26','0'),
('86','Larkin, Senger and Bartell','465 Wunsch Valleys\nWalshview, AK 32465-1183','180.069.4435','bernadette.walsh@example.com','corporate','289','478291','2019-11-10 00:21:50','0'),
('25','Larson, Ortiz and Goldner','5242 Hoeger Lock\nAlainaside, VT 95655','328.429.9819','amaya51@example.org','corporate','300','92504954','1977-01-27 05:45:18','0'),
('79','Deckow Inc','7404 Brekke Mount\nLake Bianka, CO 32607-8993','(394)586-886','bonita20@example.org','person','433','4999','1979-12-22 03:50:31','0'),
('99','Murray, Sipes and Rutherford','846 Steuber Groves Suite 893\nLake Stephenland, MO 03456-0177','(223)969-168','deja89@example.net','corporate','507','85358658','2003-07-23 17:47:09','0'),
('43','Bauch, Grady and Considine','924 Predovic Hollow\nNaomiebury, MN 30473-8281','03307658764','corn@example.org','person','547','5184759','2006-03-17 10:18:47','0'),
('38','Collier and Sons','96251 Harvey Hills Suite 600\nPort Cameron, CO 67834','(359)865-361','nels39@example.com','person','616','92682222','1997-06-17 23:25:44','0'),
('65','Renner, Goyette and O\'Connell','620 Daija Lane\nWest Vena, SC 45856-9432','947.890.5390','jed.connelly@example.com','person','838','87707','2010-01-25 13:33:29','0'),
('58','Dietrich-Pollich','5809 Jennyfer Valley Apt. 882\nNorth Vern, IL 79908','008-408-4058','tferry@example.org','corporate','889','57427163','1998-11-19 15:58:41','0'),
('24','Hauck, Effertz and Nienow','71179 Addie Pike\nLake Trevaburgh, GA 55833-3657','017.212.6926','adeckow@example.net','person','953','483774444','2016-12-21 02:36:52','0'),
('48','Walsh, Abernathy and Reinger','2034 Hermann Terrace\nLueilwitzstad, CA 51867','1-671-800-74','pollich.faustino@example.com','corporate','1095','917768947','2003-12-11 20:43:05','0'),
('15','Orn PLC','7229 Brycen Track Apt. 493\nSouth Retta, SD 86981','789-399-1956','omari.lynch@example.net','person','1212','1200','1991-09-18 04:29:50','0'),
('63','Fisher-Stroman','503 Junior Camp Apt. 550\nWintheiserport, MT 51397-6027','1-003-792-66','hrodriguez@example.org','corporate','2014','81913405','2003-04-15 17:17:17','0'),
('2','Lemke Group','2935 Mraz Spring\nAndersonmouth, NJ 98351-6698','+85(4)681151','austen.kub@example.org','corporate','2804','622707574','2016-02-23 16:58:59','0'),
('73','Hand-Corkery','59114 Jenifer Drives\nManuelafort, NM 40425-4985','265.534.7625','gpfannerstill@example.org','corporate','3003','273','2003-09-17 02:16:45','0'),
('1','McGlynn Inc','8669 Gerhold Manors\nFaychester, PA 56562','1-445-537-02','neha79@example.com','person','3394','21380','2002-04-27 07:38:38','0'),
('8','Corkery Ltd','992 Sylvia Shores\nVelvaport, DE 19307','06154040247','conroy.carlos@example.net','person','5370','467','1988-06-27 13:00:54','0'),
('81','Reilly Ltd','279 Hills Path\nBernhardstad, NE 81773-6981','364-542-5397','jaylen30@example.net','person','6904','20','1998-09-29 00:23:13','0'),
('95','Ritchie-Abshire','271 Price Way Suite 418\nAlbertomouth, NM 47413-0614','423-361-0040','trisha.gottlieb@example.org','corporate','7294','686151','1997-02-25 06:16:18','0'),
('62','Friesen-Macejkovic','4911 Casandra Squares Suite 999\nHansenbury, TX 78157-2115','056-963-1332','qlarkin@example.net','person','8261','53056','1996-04-10 00:15:18','0'),
('19','Marks-Stamm','685 Effertz Rapids\nHailiestad, MS 79265','069.106.3797','legros.osbaldo@example.com','person','8642','3','2019-05-18 18:11:54','0'),
('10','Mraz, Dach and Glover','459 Koelpin Crossroad\nSouth Timmothyborough, NM 86565-5338','799.244.5259','mccullough.arno@example.org','person','8883','92773','2003-10-03 00:17:06','0'),
('53','Keeling and Sons','668 Trevor Green\nEast Christelle, WV 51982-7368','1-275-144-88','arnaldo.morissette@example.com','corporate','9588','6890','1983-03-17 00:35:17','0'),
('93','Batz, Lehner and Bradtke','293 Alessandra Passage Suite 709\nStokeshaven, MD 28457-1369','595-667-3858','dixie.mosciski@example.org','corporate','19214','6823473','1998-09-20 07:57:55','0'),
('87','Yundt Ltd','362 Marta Path\nKreigerbury, HI 58574-3760','+55(1)563204','west.sarai@example.org','corporate','19742','5476','2012-08-26 03:02:36','0'),
('27','Gerlach, Lockman and Kautzer','21830 Littel Groves Apt. 707\nJacksonbury, DC 78569','095.424.2246','shanie.stokes@example.com','person','23830','56','2000-09-30 14:50:17','0'),
('75','Weissnat Ltd','197 Terry Plain\nNorth Shyannburgh, SC 78290-2426','199.029.2887','kkshlerin@example.net','corporate','25745','8939476','1988-04-04 13:12:26','0'),
('9','Hudson and Sons','952 Lucio Ports\nRennerfort, ME 46330','205-201-7395','eldora.dickens@example.org','person','47860','913','2015-06-01 04:10:05','0'),
('56','Torp Ltd','79554 Feil Drive\nJenningsville, NC 95905-3115','1-537-326-45','carrie.gutmann@example.com','corporate','52124','38709','2004-05-26 15:31:37','0'),
('88','Hessel-Lueilwitz','323 Mohammad Pass Apt. 009\nEast Annabellport, IA 09845-5034','(685)967-256','collier.mekhi@example.org','corporate','57631','6','1971-04-14 03:51:30','0'),
('55','Zboncak, Dietrich and Fadel','05600 Horacio Squares\nChamplinbury, TX 58272-6871','160-611-0379','timothy88@example.org','person','65982','89','1970-01-07 12:06:45','0'),
('41','Larson Inc','3722 Mosciski Greens Apt. 499\nSchambergerside, CT 86293-3205','02698733432','sbosco@example.org','person','72996','642','1990-02-12 12:58:15','0'),
('39','Johns LLC','91284 Schmidt Pine\nEmmerichborough, MT 59533','316-284-6610','dpfeffer@example.com','corporate','95983','30323492','2005-01-28 01:27:08','0'),
('4','Will LLC','569 Reyna Green\nWalterhaven, WA 14182','(942)023-965','berenice10@example.net','person','102672','0','1990-01-02 04:01:11','0'),
('69','Spinka, Doyle and Herman','12967 Zelma Shore\nSchmidtmouth, MT 21682','1-881-796-91','jbatz@example.net','corporate','112327','201475','2006-03-29 14:07:47','0'),
('70','Friesen-Krajcik','01446 Noe Place Apt. 638\nErdmanton, OR 45157','(960)268-600','o\'reilly.nathanael@example.org','person','127485','760848083','2008-04-12 15:27:20','0'),
('54','Volkman and Sons','19615 Turcotte Bridge Apt. 720\nLake Christop, OK 15236-4767','1-918-417-00','grady73@example.net','corporate','134709','210813301','1975-11-08 05:59:26','0'),
('3','McGlynn Inc','81688 Feeney Valleys Apt. 961\nRansomfort, PA 58468','04385015785','bergnaum.kennith@example.com','corporate','262750','11','2019-11-07 08:45:17','0'),
('84','Stracke-Eichmann','28205 Stracke Walks Apt. 953\nLake Kolestad, IA 54278-8717','(122)584-667','hunter.weimann@example.org','corporate','309263','58222','2004-07-15 09:23:32','0'),
('90','Bailey, Spencer and Ebert','688 Watsica Ridge Apt. 835\nWest Hilmaland, IA 51222-3939','136-542-1541','thora69@example.com','corporate','313455','33867','2002-03-04 12:59:53','0'),
('36','Lakin, Williamson and Kovacek','97579 Kassulke Bridge\nEast Alva, MO 23558','314-399-2179','nkihn@example.org','corporate','367888','799769','1972-09-02 16:29:31','0'),
('68','Bins and Sons','1188 Luigi Manor\nSanfordtown, PA 08507','1-942-374-39','jaskolski.lilly@example.net','person','392538','169','2009-02-04 11:20:29','0'),
('17','Smitham, Lang and Stark','4578 Toni Squares\nBrantchester, KS 69558','(022)586-850','dicki.vern@example.org','corporate','408073','74680','2017-04-11 19:37:46','0'),
('77','Bechtelar-Keebler','3378 Streich Course Apt. 098\nErdmanside, DE 19699-0068','729.258.0338','kitty47@example.org','person','626823','3711194','1974-12-27 12:38:23','0'),
('49','Schultz and Sons','421 Nolan Villages Suite 049\nNew Ralph, IL 44397','00532048024','lvonrueden@example.org','corporate','741360','42','2012-09-03 09:07:34','0'),
('100','Boehm-Daugherty','7155 Wilkinson Inlet\nMacejkovicchester, WA 85059-6845','856-111-0521','patricia.yundt@example.org','person','864770','9937637','1993-08-26 06:16:12','0'),
('30','Okuneva Inc','582 Walter Vista\nHilpertmouth, AZ 30932-0667','456-491-5304','sasha83@example.org','corporate','914516','60','2004-04-12 21:18:57','0'),
('91','Hansen Ltd','09248 Hoeger Parkways Suite 786\nNorth Rafael, WA 27554-9062','1-742-009-23','bmccullough@example.net','person','921285','98899156','1980-01-11 20:33:14','0'),
('22','Quitzon, Jakubowski and Bode','14290 Walsh Road Suite 924\nLake Lilla, VT 81332-7864','231-229-6385','feeney.brendan@example.org','person','937475','72','1985-08-11 23:52:26','0'),
('12','Mohr-Dicki','97572 Karlee Mills Suite 722\nEast Norris, WI 98079-1123','1-254-381-50','maddison.parisian@example.net','corporate','940854','19698522','2004-05-15 14:07:47','0'),
('45','Spinka, Funk and Wunsch','20512 Daphnee Field\nLake Nicolastad, NV 70561','+31(0)299409','alisha99@example.com','corporate','1564140','90464493','2019-08-06 02:36:57','0'),
('33','Bartoletti-Lueilwitz','868 Harber Port Apt. 249\nWilkinsonbury, AL 27415-8823','1-784-324-25','elena.wolf@example.org','person','1717797','3445089','1993-03-21 04:40:59','0'),
('16','Russel-Moen','5030 Stoltenberg Knolls\nLake Nina, WY 60348','06145441739','leonora28@example.com','person','2090301','894','1988-12-10 18:26:46','0'),
('31','Ruecker LLC','239 Kareem Dale Suite 235\nLake Helene, CO 84085','967-391-6923','heather.labadie@example.com','corporate','2152423','2','1997-12-03 00:49:03','0'),
('11','Larkin, Borer and Smitham','265 Myrtie Throughway Suite 684\nLake Leola, ME 57569','1-116-703-35','ali.boyle@example.net','person','2739546','436451','1992-10-21 23:45:17','0'),
('59','Dooley-Wehner','7064 Izaiah Lane Apt. 281\nPaolohaven, SC 75691','(469)124-470','orville57@example.org','corporate','4165015','248069394','1990-01-16 21:39:23','0'),
('44','Oberbrunner-Swift','924 Miguel Tunnel\nPort Bella, MD 42026','789.377.0331','gutkowski.anabelle@example.org','corporate','4243505','51170','2004-01-17 07:02:41','0'),
('80','Roberts-Connelly','485 Diego Village Apt. 511\nLake Josianeside, MA 22059-6824','148.188.3356','jamarcus16@example.com','corporate','4327254','23089','2000-12-16 11:15:33','0'),
('64','McClure-Padberg','4700 Grayce Extension\nDickenschester, ND 31934','616.585.0345','reyes.bins@example.com','person','4418092','26284','1972-10-25 09:45:10','0'),
('21','Bergstrom, McCullough and Von','14448 Rutherford Underpass\nLangworthbury, DE 55411-3202','(418)164-174','rdaniel@example.com','corporate','5120960','499','1972-11-29 17:06:07','0'),
('98','Zulauf Group','040 Myra Lodge\nLake Isac, GA 21733-2536','1-264-229-59','paucek.mohammed@example.com','corporate','5212416','59745443','1984-04-16 11:56:55','0'),
('18','Willms-Wolff','78529 Kip Points Suite 796\nLake Walkerport, TN 43446','426.032.9417','wyman.rath@example.org','person','5224236','570639240','1977-08-16 15:35:54','0'),
('42','Cummings, Herman and Fisher','991 Concepcion Groves Apt. 655\nWest Torrey, MA 94629-3915','600-033-8380','pherman@example.org','person','5968457','63','2018-06-16 04:36:17','0'),
('67','DuBuque, Schimmel and Anderson','3877 Bayer Plaza\nWest Adrianna, AR 15394-4812','+91(2)539080','janie86@example.com','person','6176226','867306','2002-11-23 12:22:08','0'),
('76','Bernier-Bogan','463 Daisy Branch Apt. 386\nOkeyside, KY 76578','431-889-4017','camden.rodriguez@example.net','corporate','7705237','375559537','1983-05-12 00:07:08','0'),
('83','Herman-Abbott','4464 Cooper Square Apt. 088\nWest Federicoview, CA 29998-5305','074-427-2906','icollins@example.com','person','7714329','3853','1972-09-20 23:45:56','0'),
('6','Grimes, Beer and Runolfsdottir','397 Rebekah Villages\nNew Elwinmouth, DC 68598-9617','09316417930','ayla96@example.net','corporate','13259405','5735301','2010-04-11 20:07:59','0'),
('14','Robel Group','44963 Garry Manor Suite 663\nBeulahshire, NC 74731-4865','+04(6)221457','rosetta55@example.org','person','41805934','7','2002-02-28 10:16:28','0'),
('52','Borer, Lakin and Emmerich','566 Tyrique Mount Suite 387\nNorth Kendra, MA 23142','(677)794-378','tracey.volkman@example.org','person','44373146','3355795','1983-05-21 17:14:16','0'),
('28','Renner LLC','427 Agustin Spur Apt. 189\nLake Sonnyview, OR 23547','960-936-8174','rubye.halvorson@example.net','corporate','46401717','144166232','1990-09-04 09:41:05','0'),
('71','Miller-Pfeffer','45164 Isaias Hill\nSouth Jameytown, CA 86470','(231)556-370','abbey.stiedemann@example.net','person','57723213','553','2014-06-23 14:21:03','0'),
('74','Kris Ltd','509 Marvin Lights Suite 878\nLake Tayachester, PA 20025','07849828287','urau@example.net','corporate','60698169','21237142','1982-05-24 20:36:04','0'),
('61','Ratke, Larkin and Flatley','23449 Hester Mountains Apt. 442\nSouth Gwenland, MS 80745-2903','08503045457','o\'conner.stanley@example.net','person','66008196','696','2011-06-23 01:59:13','0'),
('29','Jaskolski-Cartwright','349 Karina Lakes\nDibbertport, MT 20633','620.322.5572','edicki@example.net','corporate','77593456','221850','1973-04-24 02:05:20','0'),
('32','Zboncak Ltd','8970 Gaylord Gateway Apt. 959\nEast Ofeliaport, VT 06255','1-483-372-08','wilkinson.grace@example.com','corporate','77810364','31','1970-03-07 14:53:10','0'),
('46','Krajcik Ltd','1055 Jeromy Lodge\nEast Nicole, CA 03432','164.224.5095','conroy.derek@example.net','corporate','78691958','1','1971-05-15 16:04:04','0'),
('37','Hayes-Dietrich','68730 Reichert Ridges Apt. 252\nLouveniashire, ID 77550-4620','1-713-168-22','cordia69@example.net','corporate','79682905','42288','1995-07-05 21:00:53','0'),
('89','Toy Inc','47212 Reid Valley Suite 829\nHomenickton, VA 64233-9352','1-293-708-35','zieme.emmie@example.com','corporate','94790017','28655749','1978-07-02 06:51:05','0'),
('40','Kuphal, Gutmann and Jacobs','6206 Kellie Stravenue Apt. 605\nLake Okeystad, WV 61918','1-566-783-00','ernesto.cummerata@example.org','corporate','96196906','16380','1970-12-01 18:36:19','0'),
('66','Corwin LLC','5067 Weber Haven Apt. 429\nJenkinsshire, ND 55102-4321','076.310.5996','ludwig21@example.net','person','98323932','353396','1992-08-26 03:03:05','0'),
('97','Murray-Larkin','382 Bode Springs Suite 517\nPort Zelda, KS 65502-2543','+38(6)430408','tobin.mcglynn@example.org','corporate','410656292','382407232','1993-03-22 01:31:13','0'),
('57','Zboncak, Jerde and Renner','8012 Mayert Branch Apt. 328\nLangchester, MS 39213-5582','+99(0)890224','eusebio15@example.com','corporate','481324321','291432073','1974-04-25 15:02:56','0'),
('78','Weissnat, Ledner and Murphy','727 Williamson Mountain Suite 647\nKarsonbury, SC 85064','(443)120-617','ysmitham@example.org','corporate','626556067','274147303','1991-03-04 04:20:10','0'),
('13','Hilpert-Schmeler','6758 Talon Ports\nNorth Filomena, WI 86194-1774','557.460.2050','armstrong.annamae@example.org','person','728566759','33939','1973-03-27 01:35:15','0'); 


INSERT INTO `document_type` VALUES ('1','ipsa','1978-01-30 04:59:43', 'приход','2006-10-23 13:35:25'),
('2','voluptatum','1978-10-22 11:35:46', 'расход','2008-03-31 16:23:17'),
('3','quis','1999-01-28 22:07:43', 'приход','2010-11-03 00:28:46'),
('4','quae','1982-05-11 05:12:26', 'расход','1977-11-23 07:53:15'),
('5','ducimus','1988-02-25 15:10:22', 'приход','1984-05-21 09:05:33');  


INSERT INTO `info_registr` VALUES ('1','sed','701.00','1993-02-22 17:31:54'),
('2','libero','357748741.00','1977-01-21 09:33:51'),
('3','quia','776.00','2002-10-27 13:15:19'),
('4','temporibus','5.00','1982-03-09 20:18:13'),
('5','velit','55.00','2001-11-16 13:32:23'),
('6','praesentium','51885.00','2011-12-19 01:51:20'),
('7','nisi','833883193.00','1982-09-22 09:21:25'),
('8','laudantium','2544.00','1983-08-02 05:19:14'),
('9','incidunt','95669379.00','1990-03-21 13:38:40'),
('10','voluptates','0.00','2017-05-14 00:38:42'),
('11','neque','7434212.00','1981-02-06 11:23:47'),
('12','eligendi','806446.00','1972-10-19 00:45:32'),
('13','ut','262350126.00','2002-03-07 04:08:20'),
('14','distinctio','77391528.00','1974-10-28 16:58:53'),
('15','praesentium','222215.00','2010-08-25 01:58:22'),
('16','labore','3.00','2012-08-04 02:03:10'),
('17','perspiciatis','9270.00','2004-11-28 00:12:48'),
('18','ad','601.00','1975-03-17 16:10:49'),
('19','quo','174918267.00','2019-06-21 09:21:35'),
('20','nulla','2901704.00','1984-01-31 18:04:19'),
('21','atque','8627.00','1971-03-18 10:34:28'),
('22','pariatur','795.00','2004-09-22 04:28:22'),
('23','voluptatem','31.00','1979-09-26 00:07:26'),
('24','quos','39694.00','1992-03-01 00:42:50'),
('25','eos','8378.00','1981-04-12 06:11:52'),
('26','voluptate','8255.00','2013-08-13 04:39:21'),
('27','qui','45075.00','2005-09-15 14:25:08'),
('28','illum','1895.00','2017-11-17 16:27:13'),
('29','suscipit','89.00','2005-06-11 16:59:17'),
('30','at','0.00','1985-09-19 14:34:22'),
('31','culpa','737.00','2015-11-08 19:44:05'),
('32','quia','7.00','1973-10-29 23:44:00'),
('33','repellendus','58875939.00','2004-08-14 06:15:28'),
('34','ea','49528430.00','2007-11-24 04:25:15'),
('35','quo','3783.00','1998-01-02 14:37:08'),
('36','similique','8484.00','1980-01-23 00:03:58'),
('37','nisi','50153677.00','2016-03-08 07:23:11'),
('38','ut','590612.00','1983-10-11 16:47:35'),
('39','enim','50129730.00','1978-02-20 10:32:30'),
('40','ut','92.00','2010-10-22 01:49:14'),
('41','impedit','980.00','2001-11-14 06:35:08'),
('42','qui','737615.00','2015-04-14 03:10:04'),
('43','voluptates','67684299.00','1984-11-03 16:58:57'),
('44','qui','86.00','1971-10-07 19:08:37'),
('45','nisi','96030.00','2015-12-30 09:49:34'),
('46','dolorem','0.00','1991-09-13 03:38:21'),
('47','minima','63050620.00','2008-01-23 01:53:39'),
('48','incidunt','71876644.00','2017-07-22 01:20:09'),
('49','eos','4.00','2019-08-18 07:27:07'),
('50','veritatis','4474116.00','2019-07-29 05:25:53'),
('51','perferendis','0.00','1983-11-26 05:39:45'),
('52','voluptatibus','45484772.00','2015-01-08 08:41:05'),
('53','eum','17.00','1974-09-12 04:42:25'),
('54','necessitatibus','710893558.00','2001-12-13 18:35:38'),
('55','molestias','521.00','2011-02-19 08:15:03'),
('56','autem','60032133.00','1977-05-28 17:29:43'),
('57','est','76417.00','1984-04-19 07:00:35'),
('58','voluptas','0.00','1987-06-18 06:18:33'),
('59','sint','80544.00','1976-08-08 13:41:02'),
('60','nobis','925630.00','1979-08-07 19:56:42'),
('61','ullam','80.00','2007-08-04 17:33:25'),
('62','voluptate','506.00','2008-05-31 15:26:03'),
('63','reprehenderit','0.00','2006-04-03 19:50:48'),
('64','eum','932686447.00','2010-12-29 08:05:21'),
('65','neque','827.00','1987-06-24 12:14:27'),
('66','aliquid','315986.00','2006-10-07 19:52:19'),
('67','error','10820147.00','2014-11-11 06:14:33'),
('68','alias','676163278.00','2000-09-09 15:59:23'),
('69','qui','9994.00','1983-08-18 15:30:41'),
('70','ullam','14.00','1986-05-30 13:37:06'),
('71','ea','496.00','1971-05-18 20:50:45'),
('72','officia','62275837.00','1996-02-24 12:12:48'),
('73','explicabo','76.00','1978-07-01 02:52:24'),
('74','vel','783.00','2008-10-11 23:49:40'),
('75','inventore','16819022.00','1983-11-17 23:03:40'),
('76','minima','638965.00','2004-08-08 01:53:15'),
('77','nisi','2913087.00','1989-05-16 11:39:08'),
('78','quia','7820497.00','2004-11-25 21:52:11'),
('79','similique','3.00','1970-09-30 21:26:55'),
('80','animi','10.00','2004-08-17 11:35:07'),
('81','quis','91720.00','1971-07-24 04:44:31'),
('82','asperiores','65.00','1994-08-10 19:28:58'),
('83','est','5440356.00','1983-06-25 18:49:38'),
('84','ea','603038898.00','1988-11-18 01:31:10'),
('85','et','567027.00','1986-11-02 13:50:33'),
('86','facilis','0.00','1985-08-14 06:41:45'),
('87','natus','20382.00','1987-10-05 03:04:50'),
('88','debitis','21276768.00','2014-12-05 02:11:02'),
('89','animi','146200.00','2005-06-16 09:22:34'),
('90','quia','3286536.00','1978-05-27 09:50:21'),
('91','consequatur','0.00','1989-12-15 15:30:07'),
('92','ea','2.00','2017-12-18 05:11:57'),
('93','culpa','5196.00','1977-03-30 09:04:18'),
('94','illo','89118.00','2012-08-23 09:00:07'),
('95','et','6.00','1974-05-22 23:53:25'),
('96','placeat','24665963.00','1973-07-13 07:51:22'),
('97','vero','7466203.00','1982-06-30 08:13:44'),
('98','ut','220739006.00','1975-04-30 17:38:50'),
('99','quod','0.00','1983-06-20 06:33:49'),
('100','voluptatum','836610338.00','2008-04-14 20:10:36'); 


INSERT INTO `organisation` VALUES ('3','Lockman and Sons','858 Skye Alley Apt. 806\nJennifertown, CA 06737-4006','(008)930-423','abe66@example.org','person','4','972345938','1985-07-17 01:40:38','0'),
('1','Ondricka-Johns','9512 Satterfield Drives Suite 391\nSchultzberg, ND 78686-1000','864.763.6802','xhaag@example.com','person','502731','0','1986-07-19 18:20:19','0'),
('5','Crona Group','03816 Bernhard Rapids\nKylefurt, AR 18687','632.450.6673','yundt.leone@example.org','person','1977370','487656319','1981-11-09 04:07:25','0'),
('4','Boyle, Okuneva and Hegmann','52458 Orval Point Suite 723\nDarrylview, NC 63909-8902','(408)614-022','zkshlerin@example.org','corporate','7933204','3','1984-03-20 13:47:06','0'),
('2','Fahey-Parker','92271 O\'Connell Highway\nNew Amychester, OK 78809','124.536.5216','augustine.d\'amore@example.com','person','71514530','14218','1994-04-25 22:28:26','0');  


INSERT INTO `user_form_elements` VALUES ('1','voluptas','sum',NULL,NULL,'991','0'),
('2','assumenda','sum',NULL,NULL,'708','0'),
('3','delectus','check',NULL,NULL,'488','0'),
('4','iste','sum',NULL,NULL,'190516881','0'),
('5','consequatur','button',NULL,NULL,'458865','51247'),
('6','sint','group',NULL,NULL,'189273','8413815'),
('7','aut','button',NULL,NULL,'3','751123'),
('8','labore','text',NULL,NULL,'88180572','7771447'),
('9','earum','sum',NULL,NULL,'180558','73154669'),
('10','nobis','group',NULL,NULL,'35498801','6'),
('11','quisquam','sum',NULL,NULL,'49875','1900'),
('12','placeat','button',NULL,NULL,'98031','8308'),
('13','iusto','text',NULL,NULL,'0','236094119'),
('14','omnis','group',NULL,NULL,'420931','68280352'),
('15','qui','sum',NULL,NULL,'0','88856'),
('16','repellat','sum',NULL,NULL,'91302','8030480'),
('17','minus','group',NULL,NULL,'746035','82'),
('18','et','sum',NULL,NULL,'2','195'),
('19','rerum','check',NULL,NULL,'80','42889'),
('20','qui','text',NULL,NULL,'62995','6401'),
('21','quae','text',NULL,NULL,'0','784'),
('22','ab','sum',NULL,NULL,'0','411843635'),
('23','vitae','check',NULL,NULL,'629','39'),
('24','necessitatibus','group',NULL,NULL,'648260','63507720'),
('25','sunt','text',NULL,NULL,'8635614','24566'),
('26','consequatur','check',NULL,NULL,'10317702','9594'),
('27','quia','group',NULL,NULL,'0','7751'),
('28','officia','check',NULL,NULL,'348533966','6'),
('29','sit','button',NULL,NULL,'54631343','798'),
('30','itaque','check',NULL,NULL,'506204','74917'); 


INSERT INTO `users` VALUES ('1','Maurice','Konopelski','elakin@example.org','14828451ff98b010d76a63049914453bbf77cb51','1-193-784-06','0'),
('2','Granville','Kiehn','hlegros@example.net','3f472b077a2e1dfab8d718d7fe2f6c7334b7dd30','04307224827','0'),
('3','Natasha','Abernathy','lkeeling@example.com','621b3cf6bb3863fb67c2591b7ee7f9ae514f06cc','1-560-158-70','0'),
('4','Dudley','Spinka','salvatore.stoltenberg@example.com','f07a2a3d56fb2014d1618edf6b13e872ba4112cd','181.725.9158','0'),
('5','Morgan','Kuhic','zieme.stefan@example.net','dbafdab892a4b3b9e7f67f6ac77d4e32ed08c6e2','(157)159-097','0'),
('6','Furman','Jaskolski','ludwig.considine@example.net','28b0d3eec24fe02e1ae8370a6d67038c73635cd6','202-595-3629','0'),
('7','Weldon','McClure','ekub@example.net','1d8163355cf3cf31f0c7e61dea9fcff65a3440bb','+81(0)269013','0'),
('8','Karolann','Marvin','chalvorson@example.net','506275d0610316c44ad72e1b9aca58be1d15a91a','365-873-0974','0'),
('9','Paige','Schaefer','dickinson.gerda@example.org','d36e5c3a9d33a8ce88ea62d52feea9efba808a0b','803-732-5853','0'),
('10','Freda','Mosciski','eugenia28@example.net','3d3dda93c1970b33130806ead4737dc59c125458','1-648-814-81','0'),
('11','Donato','Kuhlman','douglas.miller@example.net','53d99d311ecdf6dcd5023d2d63f672ab26cad3d2','1-295-182-80','0'),
('12','Kristy','Bode','qo\'conner@example.com','4c13d46a5ecf4ec7366c5a7c3770ed1f966a4f63','218-733-8984','0'),
('13','Tatyana','Morar','ortiz.halle@example.org','57241f1610772aeeac856033c798dc83cfdc919c','094.139.1014','0'),
('14','Freddie','Wintheiser','dominic45@example.net','2f037be379f37d8edcb77d1513beb85ec77cdddf','(890)725-484','0'),
('15','Eleazar','Bashirian','xavier.ruecker@example.net','056209650e7c425932f7e68ff3b64be27e2a0266','1-273-993-66','0'),
('16','Marlin','Satterfield','dianna.johns@example.org','6992b49c6632512b88dee8e9bd35a97b2a48f381','(144)887-553','0'),
('17','Antwan','Kozey','shand@example.net','9bc4121bc1a9801075ba9d4bbfa0824ce78a6a1c','470.101.0353','0'),
('18','Lavina','Mayer','bayer.jasmin@example.net','b9c22f5e57b61ccb90c6c0745d1158062c5c7489','265.117.5550','0'),
('19','Geo','Tremblay','towne.cathryn@example.com','c138aba179c6733f2c79beccc1638697bea6a47b','1-902-117-43','0'),
('20','Eleonore','Watsica','camryn75@example.com','a0e9975b9576848afcf4fe94df7e3036cc0368ae','750-052-7358','0'),
('21','Sally','Jacobi','zachary68@example.com','2fa678f15e83109c03a4e90b68834a6d22018c48','1-527-802-58','0'),
('22','Kaycee','Littel','kara.skiles@example.com','70718a9539286e5964e743a94ad4bfdd41a6920f','230.000.2018','0'),
('23','Conor','Brakus','lempi.collier@example.net','68267016756a160bf82e70d1e6d7051d02a1156c','(637)511-504','0'),
('24','Jerrold','Nolan','kuhic.quinten@example.com','1aa6fc9e836cdf93979efd3c10e7ef342cfcf20b','1-056-746-16','0'),
('25','Victoria','Goyette','sthiel@example.net','8adc5acf613be6980751e257f235ca37632a3da9','094-881-2116','0'),
('26','Camron','Ziemann','lessie49@example.org','f377096da54c6550a89d6cb7f97549099e1fd390','1-816-401-77','0'),
('27','Melissa','Wyman','kulas.esther@example.net','0f7bec27c73114097854abe4864047554048295f','320-676-8253','0'),
('28','Marion','Spencer','jayme03@example.com','770cca6bd83972dcbe8d2dd65ec0a65afae97a3c','(166)930-337','0'),
('29','Tierra','Roberts','orlo26@example.net','5073b2502720d5de2b188f1b9eb5f66aa15cc1cb','292-279-1742','0'),
('30','Alaina','O\'Conner','lharvey@example.org','e257aa17d2ea7da34a7bb01b38326120644936b2','1-229-371-15','0'); 


INSERT INTO `profiles` VALUES ('1','m','1976-10-06',NULL,'Alicefort','1989-12-19 10:44:52'),
('2','m','1986-02-27',NULL,'Nienowmouth','1987-08-21 07:35:04'),
('3','m','1978-04-03',NULL,'Collierview','1987-10-31 03:51:48'),
('4','f','1999-03-06',NULL,'North Elliot','2007-07-30 08:51:15'),
('5','f','1977-09-23',NULL,'Lunamouth','2004-01-09 10:48:23'),
('6','f','1974-03-17',NULL,'New Maxineport','1972-06-05 02:35:11'),
('7','m','1985-07-14',NULL,'Antoniettamouth','1982-03-18 17:40:29'),
('8','m','1975-07-21',NULL,'East Veronica','1985-03-24 08:28:02'),
('9','m','2015-11-11',NULL,'Kertzmannmouth','1998-09-19 01:07:41'),
('10','m','1980-09-26',NULL,'New Olin','1996-04-05 10:47:47'),
('11','f','1986-10-19',NULL,'North Eliseport','2005-11-20 09:25:48'),
('12','f','2015-04-24',NULL,'Olaside','1974-03-19 02:25:41'),
('13','f','1999-08-12',NULL,'Rowetown','2012-12-11 20:09:29'),
('14','m','1987-04-25',NULL,'New Pansychester','2005-08-14 09:53:25'),
('15','f','2007-02-05',NULL,'Valeriemouth','2002-11-05 16:43:59'),
('16','m','1970-09-06',NULL,'East Marcelleside','1988-08-05 22:54:07'),
('17','m','2006-03-02',NULL,'South Cordie','1997-10-28 09:24:07'),
('18','m','1991-02-06',NULL,'North Marshallport','1987-07-15 14:37:18'),
('19','f','1993-09-28',NULL,'Port Bryonfort','1997-04-07 14:55:20'),
('20','f','1974-09-28',NULL,'South Geoffrey','1979-12-11 06:42:33'),
('21','m','1973-10-07',NULL,'Ricechester','2010-11-30 00:51:25'),
('22','f','2016-11-24',NULL,'Port Yasmeenhaven','1973-12-08 09:30:26'),
('23','f','2011-12-02',NULL,'Port Josefaberg','1997-06-25 08:13:23'),
('24','m','1973-05-17',NULL,'Abbyshire','2007-11-12 18:44:05'),
('25','f','1970-08-23',NULL,'West Demetrischester','1975-08-28 10:25:08'),
('26','f','2005-02-01',NULL,'West Royce','1984-11-29 10:34:05'),
('27','f','2006-06-03',NULL,'Lake Rosella','2017-01-27 20:18:54'),
('28','f','2003-10-18',NULL,'Port Devon','1975-09-25 19:17:26'),
('29','m','2015-06-02',NULL,'Dallinchester','2007-02-01 22:22:08'),
('30','f','1984-03-15',NULL,'Neilland','2007-10-07 11:26:29'); 


INSERT INTO `user_documents` VALUES ('1','1','1','1.00','9','1985-05-17 10:46:25','48e22d8b9bdf6b028e2d87e10cbb2be50420baa7','1','1','1',NULL,'1978-01-13 07:00:42','2008-09-22 16:51:02','0'),
('2','2','2','3854661.00','9','2000-09-08 16:14:21','9a4ac435559b517e533765cd4ece1a12083208f5','2','2','2',NULL,'1988-04-15 08:12:00','2017-06-13 14:11:02','0'),
('3','3','3','273827.00','','1995-09-21 18:43:00','43e8e8a60a20996730652c0398b0abe7976a0155','3','3','3',NULL,'1978-12-15 07:45:16','2013-03-28 09:19:46','0'),
('4','4','4','104804.00','1','2007-03-05 12:06:09','cff3678c0848bdfa470c967b03109bf445700257','4','4','4',NULL,'2010-07-30 14:31:48','2011-06-27 22:35:40','0'),
('5','5','5','94.00','1','1975-12-13 00:11:33','826c1b8f04767ba239ca0977809a5d4d6d17bb66','5','5','5',NULL,'1998-08-15 20:58:09','1994-03-16 08:25:05','0'),
('6','1','6','78217.00','7','2011-05-07 04:31:15','d98df57fdf2189ec179625ed3df3983450886951','6','3','6',NULL,'2008-12-29 07:11:15','1982-05-09 15:55:13','0'),
('7','2','7','93.00','4','1976-02-20 09:36:59','72e8a7aed0cde362cbd59f365621f96a47967202','7','5','7',NULL,'2018-01-19 04:53:18','2007-07-17 17:44:58','0'),
('8','3','8','6584596.00','6','2007-02-26 17:11:32','d6f38fa309fc018f4001372fc2cec6bc841d129f','3','3','8',NULL,'2018-05-15 00:33:42','1996-03-18 20:53:14','0'),
('9','4','9','5580.00','4','2012-11-29 04:01:54','2af380d6e6ad971312f4c553ea7dd59443d6a36e','9','4','9',NULL,'2010-09-11 14:58:53','1971-07-03 13:12:54','0'),
('10','5','10','0.00','9','1980-04-17 15:04:29','bac9d867a85bda88f0db7af45809f31d5b3e540f','10','5','10',NULL,'1974-12-23 20:46:21','2012-05-02 02:05:39','0'),
('11','1','11','3661.00','5','1974-08-31 14:54:52','6649ff81723cf27503c258a897d6eca98b8dfda2','11','2','11',NULL,'1972-10-25 18:13:11','2014-02-20 20:33:44','0'),
('12','2','12','26489013.00','8','1982-11-20 11:44:26','dfb7462ddf917b337d227389634659e4e856ec1e','12','3','12',NULL,'2009-09-13 12:16:05','2012-05-23 15:05:23','0'),
('13','3','13','53049220.00','6','1998-03-18 10:46:35','b37171cf9682470642b1e085d5c999c40c6a745c','13','3','13',NULL,'2017-11-09 10:58:15','2009-11-09 06:23:06','0'),
('14','4','14','0.00','8','1981-05-13 20:38:05','cdd585de04e87bf9ce0742d1aab66ad99620394f','14','4','14',NULL,'2004-08-20 19:44:22','1977-09-06 16:13:30','0'),
('15','5','15','930250.00','3','2015-02-09 16:34:47','35fb4bcea85e6dee0e28f9197355f80fac9ffa16','15','5','15',NULL,'2019-01-15 08:34:35','2014-07-07 07:04:35','0'),
('16','1','16','37.00','9','2019-09-07 19:20:46','d4976e703123426889f4fc7a78c4cf0d922be9fe','16','1','16',NULL,'2002-10-19 22:32:50','2007-10-17 22:07:50','0'),
('17','2','17','16048.00','8','2000-11-08 15:33:41','7f15ebfb4c371a260550da480b251e4cba4cfc9b','17','2','17',NULL,'1989-01-13 09:42:40','2017-08-23 04:12:48','0'),
('18','3','18','99321359.00','8','2016-06-16 19:48:44','07268e97aeb44ac8f51afc4297d7f958a5d3bef1','18','4','18',NULL,'2007-03-30 16:35:39','1974-03-04 07:57:14','0'),
('19','4','19','565125631.00','2','1992-01-23 14:01:09','8b3809f32e27692e1d631753c16ff464199f5250','19','4','19',NULL,'2000-08-25 15:49:11','2015-02-24 15:56:58','0'),
('20','5','20','509329.00','8','2018-04-19 14:52:51','50239ec924e4edecfd8ce835cd2fe8ce3f36b40b','20','5','20',NULL,'1990-05-13 09:55:49','2015-01-15 17:31:16','0'),
('21','1','21','0.00','1','2019-03-11 01:49:35','d76dd2f44264eab66eca500a1dcc5dc82bdd85e8','21','1','21',NULL,'1980-06-07 05:46:17','2016-10-06 18:55:13','0'),
('22','2','22','70027.00','3','1980-12-11 14:37:31','7a25acead66b55788319a8d7c1e92916cf1a3a71','22','2','22',NULL,'2012-09-16 10:28:15','1980-08-27 23:55:19','0'),
('23','3','23','71966855.00','6','1997-12-04 10:36:03','150feecbbe602a037243c9f344a4af0e2b5eb33a','23','3','23',NULL,'2018-03-27 01:14:10','2012-04-07 14:51:42','0'),
('24','4','24','595.00','8','1980-04-19 11:19:36','b6758a465364b1086f0915b80650d0f0bf9937c3','24','4','24',NULL,'2010-07-15 06:16:25','1996-08-22 02:32:03','0'),
('25','5','25','2269411.00','9','1971-07-21 11:40:20','b5336d856e52200ad39dfec40c06669f0b94ae76','25','5','25',NULL,'1977-07-12 03:26:22','1997-10-24 11:45:20','0'),
('26','1','26','2502962.00','8','2018-08-09 22:31:54','3cd6235717546a52a82a845446eb8a961abb1d2c','26','4','26',NULL,'1985-03-22 11:46:59','2010-06-06 07:26:47','0'),
('27','2','27','648973.00','1','2008-08-18 11:37:26','3953ceb654101bc449187c3fcb08831806514f2e','27','2','27',NULL,'1998-10-25 03:25:22','2003-04-22 19:52:00','0'),
('28','3','28','38477.00','1','1974-04-23 03:14:40','462face8c8692e5541c310759ec2fd8b092ad0aa','28','5','28',NULL,'2004-12-27 05:57:01','2000-10-19 11:17:19','0'),
('29','4','29','58.00','6','1984-09-22 04:36:26','3ec304289c97bee487f095b84789f59b8d7aa6d3','29','4','29',NULL,'1999-05-31 09:07:59','1997-10-28 03:53:31','0'),
('30','5','30','36248145.00','1','2000-06-02 13:57:51','3caee4415c1c2c9f99bcc752552bdfb2642612fe','30','5','30',NULL,'2015-06-07 10:43:54','1984-07-12 17:54:36','0'),
('31','1','31','1018.00','1','1991-07-15 13:27:49','b87ea0257d569a647815ac787d61b7d38ea2573d','1','1','31',NULL,'1976-09-18 18:28:59','1974-11-29 20:41:54','0'),
('32','2','32','792688453.00','1','2013-09-09 03:16:04','3f8c845d1f12e2f001490bfd448aa88fc0bbc8f2','2','2','32',NULL,'1971-03-30 14:23:30','2011-11-06 04:33:53','0'),
('33','3','33','88961.00','4','1977-07-17 03:07:21','a6353e1a20b2f07f55287bbccbca606f0528083d','3','3','33',NULL,'1991-09-04 20:52:36','1991-07-28 12:28:57','0'),
('34','4','34','2.00','6','2002-10-30 01:56:09','6a3ea674ebb5e14c9aab1f65bd636b4c2a537c33','4','4','34',NULL,'1996-03-10 23:28:13','2019-02-28 14:43:35','0'),
('35','5','35','701172.00','','1971-02-24 13:42:19','9f236a63e3ee6ab966bdda511f4cd437574ffe31','5','5','35',NULL,'1973-01-12 20:57:34','2003-06-08 16:28:31','0'),
('36','1','36','943814.00','6','1998-09-30 11:39:00','e86ba7a1d73786bc8a472ef65968fee18e63da99','6','1','36',NULL,'2017-09-25 03:58:03','1973-11-22 23:35:38','0'),
('37','2','37','252297446.00','8','1978-06-27 18:21:57','5b184425d80cee3c0a3278647386de546b6855e8','7','2','37',NULL,'2008-03-24 18:40:42','2000-02-14 15:34:10','0'),
('38','3','38','0.00','3','2002-08-15 20:51:45','8c59a13e3689c63b29c857aeeb358a4620899d4b','8','3','38',NULL,'1991-08-03 14:37:04','1976-01-26 22:29:59','0'),
('39','4','39','7359.00','9','2008-07-06 16:01:55','428416b988cab775244d20e57a92be1f2959b5f5','9','4','39',NULL,'2010-07-22 15:04:10','1999-08-04 15:30:49','0'),
('40','5','40','29252.00','1','1985-10-02 20:46:50','f708bebf12b5b74f404ec9c00becb534529a2d9b','10','5','40',NULL,'1992-09-22 02:56:42','1979-08-19 06:02:50','0'),
('41','1','41','2086399.00','6','2005-09-25 22:26:37','8699ae8ea057730af4d4c84abd50b19c6cde04ae','11','1','41',NULL,'2004-06-15 11:49:45','1993-08-07 03:08:58','0'),
('42','2','42','1.00','6','2003-07-23 20:04:38','146f4f4716d293053512528a958790857d293a67','12','5','42',NULL,'1995-06-20 22:05:46','2019-12-13 08:27:59','0'),
('43','3','43','508269.00','4','1984-10-23 11:32:46','f3689d041555cddc465fb060d0970802c183a731','13','3','43',NULL,'2019-07-07 08:39:16','1987-10-11 14:59:36','0'),
('44','4','44','38054.00','2','1999-07-03 00:08:47','407bbbc58a5c44f78cf4c1d192d4ef4b5a7b0662','14','4','44',NULL,'1994-02-25 19:13:35','1991-07-15 15:03:01','0'),
('45','5','45','4.00','7','2008-11-13 14:53:26','d79caff8bada4293988ece847c19f5d202512903','15','5','45',NULL,'1984-07-20 10:51:57','1993-01-19 09:41:38','0'),
('46','1','46','3821649.00','9','1997-03-11 06:10:20','96ffed75b29cc9bb34ee731213221709ab0f5bc1','16','1','46',NULL,'1971-11-05 08:47:26','2011-05-14 21:27:53','0'),
('47','2','47','800.00','9','2006-01-24 00:50:33','a3ac44cc4a9d84c6d3b11d79387d47853e3a1796','17','2','47',NULL,'2013-11-19 04:56:58','1991-01-18 20:17:32','0'),
('48','3','48','448398692.00','2','1994-01-24 15:13:10','4d9e0326cbb7c59bf4cd6daaae7c6d706b57e6d7','18','3','48',NULL,'1999-09-09 01:00:20','2016-07-23 22:21:46','0'),
('49','4','49','2344.00','6','1986-05-11 05:31:16','3857a97cdac678b69637244abbc4783bd5c81146','19','4','49',NULL,'2002-06-06 19:11:27','2012-06-18 10:53:49','0'),
('50','5','50','942862.00','9','2004-06-23 21:37:04','e0c536df7de149aa0bcae2cc731d79663338cb65','20','5','50',NULL,'1986-12-08 17:57:24','1982-10-19 08:41:47','0'),
('51','1','51','6624816.00','5','1971-10-29 11:39:50','b271e9df7b77be569565a2f62d6448e414b37d97','21','1','51',NULL,'2017-05-12 10:30:26','1978-11-07 01:53:58','0'),
('52','2','52','6543534.00','1','1974-04-06 02:45:59','5557f24ba22d94fd8f15640a2df64a0a63425c78','22','2','52',NULL,'1989-09-16 05:52:24','2015-11-09 20:12:38','0'),
('53','3','53','662.00','6','2000-12-26 02:47:09','a2542695bbc053470c3cd59b332c018c8a2948f7','23','5','53',NULL,'1972-09-20 01:58:24','1976-10-04 22:57:43','0'),
('54','4','54','93215.00','9','1991-06-22 16:39:30','952058a2bbaed2d317552489aff355686148011c','24','4','54',NULL,'2019-12-12 11:55:08','2016-09-08 15:39:01','0'),
('55','5','55','1430377.00','3','2004-03-28 18:41:58','572771db224e2ae316fc092b70f224b307e9f9a8','25','5','55',NULL,'1983-10-23 20:30:34','1997-11-19 19:08:59','0'),
('56','1','56','0.00','4','1985-02-18 20:06:54','1038c5eaf212d0aac4a28ab000a99fc5bd63e881','26','1','56',NULL,'1972-10-05 09:22:15','1976-01-08 17:11:41','0'),
('57','2','57','71986867.00','1','2005-09-22 05:34:14','de0b76a72ab534891b5e9c85d381223cccb45a54','27','2','57',NULL,'1997-03-04 15:58:00','1999-02-27 05:55:07','0'),
('58','3','58','0.00','6','1976-09-23 17:56:36','161964cbbb54411a87560a9b9c847713e318767c','28','3','58',NULL,'1979-03-31 02:53:24','2004-03-15 02:02:36','0'),
('59','4','59','72246717.00','4','2006-02-06 19:17:13','0eef037a0155104f6d89677260e59a3a4cec749f','29','4','59',NULL,'1975-09-24 10:21:16','2000-03-20 20:08:47','0'),
('60','5','60','156586.00','9','2004-02-04 04:29:14','706c51d5cb531e0889cba3bad623d5225051d6ad','30','5','60',NULL,'2013-09-03 23:47:57','2016-06-10 18:13:03','0'),
('61','1','61','0.00','1','2012-05-14 07:02:53','9c325c2947906d56885fbc86cd9ad4ddda6c2ad2','1','1','61',NULL,'1988-11-18 15:48:43','2005-08-09 23:57:48','0'),
('62','2','62','1717169.00','9','2001-10-02 07:26:01','1798238e8abc290e230a6eb54cf6c5dcac994cf8','2','2','62',NULL,'1989-09-12 10:17:24','2001-10-29 20:14:04','0'),
('63','3','63','12.00','1','1972-09-09 17:34:15','ef7c394c32b844c79e08b7cd6be1f3b8eeedfc12','3','3','63',NULL,'2016-04-21 17:33:51','1972-10-15 16:48:18','0'),
('64','4','64','6224.00','7','2006-07-10 05:58:40','dc1d27c6d45d970993d8f5eb46071b0ab082e2d7','4','5','64',NULL,'2018-03-13 18:04:55','2010-11-10 16:56:44','0'),
('65','5','65','5.00','1','2016-10-05 18:29:12','1441d2f20339e987e3b4226b8eb4a6990fdd414d','5','5','65',NULL,'2004-10-29 19:19:53','1989-07-03 12:55:26','0'),
('66','1','66','18619.00','3','2016-01-21 16:58:53','2e454ba1e91a0ade19e7d160c8139f86400bfc28','6','1','66',NULL,'1991-04-25 02:05:19','1972-01-24 07:45:58','0'),
('67','2','67','27340.00','1','1996-12-26 05:04:14','0e99fe1312b23ba7cbd97b1f70b079f308217a80','7','2','67',NULL,'2008-03-07 03:17:50','1995-10-10 20:46:54','0'),
('68','3','68','982554831.00','','2006-04-01 19:00:24','6c7c6d64b850fb5f7b509aa5c05e322aed52089d','8','3','68',NULL,'1991-11-09 14:46:18','1991-08-05 09:58:46','0'),
('69','4','69','5958173.00','1','2002-02-20 06:16:19','f4e797f756e6f0004f1ee4885bd4a4dad929c51b','9','5','69',NULL,'1973-09-10 04:49:32','1974-03-11 09:18:00','0'),
('70','5','70','56629448.00','1','1996-06-18 18:55:13','f303b26d8971703a7205d79e294039d220a666ed','10','5','70',NULL,'2010-09-13 08:23:35','2002-08-22 21:39:31','0'),
('71','1','71','243482348.00','1','1980-09-02 02:15:50','77f1d15d44ef25bcb8fec637f818b7ff4cf53a7a','11','1','71',NULL,'2002-07-25 03:56:58','1995-03-03 21:00:50','0'),
('72','2','72','279730046.00','1','2004-04-10 02:16:25','bdf9d89fbbfb07d37ade9e52c9588413cbedda24','12','2','72',NULL,'2007-07-09 01:52:49','1976-04-13 08:42:58','0'),
('73','3','73','3.00','4','2003-07-12 02:06:26','b00bdc819a5ed8484c53d23e64490168683f4581','13','3','73',NULL,'1984-07-04 10:39:06','2018-04-10 01:18:19','0'),
('74','4','74','6390748.00','3','2013-06-07 17:06:42','c4494f878e83260d9648a15bf37df5447fddf1cc','14','4','74',NULL,'1994-08-17 16:16:45','2002-07-08 21:19:11','0'),
('75','5','75','88674488.00','1','1982-01-10 23:56:53','f112caf380e0818826dd745b34dfc1d6bbe10a2e','15','5','75',NULL,'2001-07-01 18:38:44','1993-04-09 04:08:19','0'),
('76','1','76','2.00','8','1979-07-26 03:59:53','73317878e77ff593501aa31c4d181a877e45f1ac','16','1','76',NULL,'1990-05-02 06:14:55','1997-03-17 13:19:33','0'),
('77','2','77','839.00','2','1998-03-20 09:49:58','618e808761c9f82e826f180d747923ef1f57f38a','17','2','77',NULL,'1981-11-02 22:37:25','1992-04-03 00:12:40','0'),
('78','3','78','39.00','9','2002-05-11 06:18:26','a34656927bfd21140493bf4f3ba2f3525a62f8d4','18','3','78',NULL,'1997-07-06 12:29:54','2003-11-06 22:06:12','0'),
('79','4','79','0.00','1','1990-01-10 01:06:49','2cb7863281d5f5f8188ad6cdbb6dbf21bb361ba5','19','4','79',NULL,'1997-09-04 09:26:45','2018-12-04 01:12:39','0'),
('80','5','80','272.00','2','2016-07-10 08:09:33','e04eb044c7b68010fec31b3e5a6fe6de19bd13a7','20','5','80',NULL,'2010-10-08 23:37:18','1972-06-09 03:27:14','0'),
('81','1','81','2653.00','4','1991-04-03 13:09:44','7ef12397940dd98899505eb4150320e106b17558','21','1','81',NULL,'2006-10-30 07:59:30','2005-03-16 08:25:12','0'),
('82','2','82','6.00','','1972-12-03 17:51:47','64458058a86eb729c251f794cd353f765f29fca8','22','2','82',NULL,'1997-03-06 20:04:46','1971-12-06 02:12:32','0'),
('83','3','83','3600362.00','6','2007-12-19 02:12:16','78b8e84b14cdcdff2035a7a800906d983cc09801','23','3','83',NULL,'2009-05-19 21:51:03','1982-06-02 16:38:42','0'),
('84','4','84','31520002.00','6','1999-04-22 19:37:05','a2e9b3a02fce9cfc8b99543c1acb2c117aa1a32d','24','4','84',NULL,'2005-06-21 04:38:42','2005-02-04 11:07:19','0'),
('85','5','85','1232.00','','1993-10-01 01:03:07','ddb9197b6de37d3415b31544fe6ccc4bbdbc66fc','25','5','85',NULL,'1995-08-11 03:01:23','2013-07-13 02:41:55','0'),
('86','1','86','629387.00','1','1984-07-24 11:39:59','93e8e249e2b8ef2cb3a70b6e70c5f67a14087644','26','1','86',NULL,'1979-08-07 10:24:50','1977-08-10 01:01:41','0'),
('87','2','87','36922785.00','1','1981-06-13 19:20:08','ebffc9ade7f8230e3b866b2c5e42c25737aa0c21','27','2','87',NULL,'1982-12-10 19:28:47','1991-05-28 03:17:43','0'),
('88','3','88','635.00','3','1992-11-09 14:28:50','e98b06b7e9194b4905d9bb6135dd5c02791dd040','28','3','88',NULL,'1981-02-04 08:22:42','2008-09-21 12:38:01','0'),
('89','4','89','0.00','4','1992-06-13 12:38:17','6f50fae06ec9555be936ae2dee9b167050417d78','29','4','89',NULL,'2000-03-27 04:04:09','1997-01-26 20:04:27','0'),
('90','5','90','17182801.00','','1997-07-01 00:09:35','84634ec639187e4d521a3351b211701dddcf9d11','30','5','90',NULL,'2013-05-26 02:44:24','1995-11-12 19:21:52','0'),
('91','1','91','0.00','7','2006-01-31 04:19:53','5660ecadda10305e90f1337632ec01a374150467','1','1','91',NULL,'1975-03-16 15:02:59','1991-05-26 20:12:35','0'),
('92','2','92','2.00','3','1973-06-27 04:20:09','204a9a74b06a2d902352c26afd1bda3f2e75234c','2','2','92',NULL,'1997-10-12 08:24:07','2014-12-16 01:48:57','0'),
('93','3','93','357310490.00','3','1977-05-27 22:07:23','8eafb8355c56d203dc8147306fc0f8557d59a991','3','3','93',NULL,'1971-11-30 03:18:57','1978-02-03 23:17:21','0'),
('94','4','94','2144622.00','','1996-12-10 12:39:51','231092373849f90137dc5f7440f4581f3b6677ae','4','4','94',NULL,'2003-04-26 12:21:49','2012-07-19 04:40:26','0'),
('95','5','95','1212.00','1','2015-12-26 10:25:24','149430b4cd2995ad483f9f0c042d2f7389a8befb','5','5','95',NULL,'1998-02-05 15:59:13','2017-02-03 16:45:09','0'),
('96','1','96','60446066.00','5','1999-02-17 10:17:52','1bf987346739cc1d2df834ce4c6465779c3e3bd1','6','1','96',NULL,'2006-05-23 01:00:08','1990-01-23 21:24:39','0'),
('97','2','97','8873202.00','9','1972-12-08 12:48:39','67b7ed0a15aeec9cbbd81c6130ba0f3604c8e2ec','7','2','97',NULL,'1973-09-30 08:53:22','2012-01-10 13:25:35','0'),
('98','3','98','83714221.00','8','2016-05-12 22:42:24','7917bcafc28a9f04b6c3bcbe936ddb1648e5a242','8','3','98',NULL,'1997-07-09 01:45:39','2008-08-28 15:34:56','0'),
('99','4','99','69362672.00','','2013-05-16 07:20:35','059b8a8af7918a79692dd17ca7b9e83b3d4379d8','9','4','99',NULL,'2003-11-14 02:03:32','2003-04-04 21:04:42','0'),
('100','5','100','8.00','','2015-03-10 21:08:08','5341c8de3c73885ddc5b7122d7c49e0a8da','10','5','100',NULL,'1998-05-11 07:10:16','1975-01-29 19:35:53','0'),
('101','1','1','1.00','9','1985-05-17 10:46:25','48e221d8b9bdf6b087e10cbb2be50420baa7','1','1','1',NULL,'1978-01-13 07:00:42','2008-09-22 16:51:02','0'),
('102','2','2','3854661.00','9','2000-09-08 16:14:21','91a4b5117e533765cd4ece1a12083208f5','2','2','2',NULL,'1988-04-15 08:12:00','2017-06-13 14:11:02','0'),
('103','3','3','273827.00','','1995-09-21 18:43:00','43e81e8a600652c0398b0abe7976a0155','3','3','3',NULL,'1978-12-15 07:45:16','2013-03-28 09:19:46','0'),
('104','4','4','104804.00','1','2007-03-05 12:06:09','cff31678c0848b0c967b03109bf445700257','4','4','4',NULL,'2010-07-30 14:31:48','2011-06-27 22:35:40','0'),
('105','5','5','94.00','1','1975-12-13 00:11:33','826c1b8f014767ba239c9177809a5d4d6d17bb66','5','5','5',NULL,'1998-08-15 20:58:09','1994-03-16 08:25:05','0'),
('106','1','6','78217.00','7','2011-05-07 04:31:15','d98df571fdf2189d3df3983450886951','6','1','6',NULL,'2008-12-29 07:11:15','1982-05-09 15:55:13','0'),
('107','2','7','93.00','4','1976-02-20 09:36:59','72e8a7aed0c1de362cb15621f96a47967202','7','2','7',NULL,'2018-01-19 04:53:18','2007-07-17 17:44:58','0'),
('108','3','8','6584596.00','6','2007-02-26 17:11:32','d6f38fa1309fc1372fc2cec6bc841d129f','8','3','8',NULL,'2018-05-15 00:33:42','1996-03-18 20:53:14','0'),
('109','4','9','5580.00','4','2012-11-29 04:01:54','2af380d6e6a1d971312ea7dd59443d6a36e','9','4','9',NULL,'2010-09-11 14:58:53','1971-07-03 13:12:54','0'),
('110','5','10','0.00','9','1980-04-17 15:04:29','bac9d867a85bda188f0db7aff31d5b3e540f','10','5','10',NULL,'1974-12-23 20:46:21','2012-05-02 02:05:39','0'),
('111','1','11','3661.00','5','1974-08-31 14:54:52','6649ff81723c1f27503c25a98b8dfda2','11','1','11',NULL,'1972-10-25 18:13:11','2014-02-20 20:33:44','0'),
('112','2','12','26489013.00','8','1982-11-20 11:44:26','dfb7462dd1f917b337d22759e4e856ec1e','12','2','12',NULL,'2009-09-13 12:16:05','2012-05-23 15:05:23','0'),
('113','3','13','53049220.00','6','1998-03-18 10:46:35','b37171cf96182470642b1ec40c6a745c','13','3','13',NULL,'2017-11-09 10:58:15','2009-11-09 06:23:06','0'),
('114','4','14','0.00','8','1981-05-13 20:38:05','cdd585de04e87bf9ce10742d1a199620394f','14','4','14',NULL,'2004-08-20 19:44:22','1977-09-06 16:13:30','0'),
('115','5','15','930250.00','3','2015-02-09 16:34:47','35fb4bcea85e6d1ee0e2815f80fac9ffa16','15','5','15',NULL,'2019-01-15 08:34:35','2014-07-07 07:04:35','0'),
('116','1','16','37.00','9','2019-09-07 19:20:46','d4976e703123426889f14fc7d1922be9fe','16','1','16',NULL,'2002-10-19 22:32:50','2007-10-17 22:07:50','0'),
('117','2','17','16048.00','8','2000-11-08 15:33:41','7f15ebfb4c371a2601550dcba4cfc9b','17','2','17',NULL,'1989-01-13 09:42:40','2017-08-23 04:12:48','0'),
('118','3','18','99321359.00','8','2016-06-16 19:48:44','07268e97aeb44ac4297d71f958a5d3bef1','18','3','18',NULL,'2007-03-30 16:35:39','1974-03-04 07:57:14','0'),
('119','4','19','565125631.00','2','1992-01-23 14:01:09','8b3809f32e2753c16f1f464199f5250','19','4','19',NULL,'2000-08-25 15:49:11','2015-02-24 15:56:58','0'),
('120','5','20','509329.00','8','2018-04-19 14:52:51','50239ec924e4edecd2fe8ce13f36b40b','20','5','20',NULL,'1990-05-13 09:55:49','2015-01-15 17:31:16','0'),
('121','1','21','0.00','1','2019-03-11 01:49:35','d76dd2f44264eab66eca505dc82bdd8511e8','21','1','21',NULL,'1980-06-07 05:46:17','2016-10-06 18:55:13','0'),
('122','2','22','70027.00','3','1980-12-11 14:37:31','7a25a1cead66b557d7c1e92916cf1a3a71','22','2','22',NULL,'2012-09-16 10:28:15','1980-08-27 23:55:19','0'),
('123','3','23','71966855.00','6','1997-12-04 10:36:03','1501feecbbe6c9f344a4af0e2b5eb33a','23','3','23',NULL,'2018-03-27 01:14:10','2012-04-07 14:51:42','0'),
('124','4','24','595.00','8','1980-04-19 11:19:36','b6758a4651364b101650d0f0bf9937c3','24','4','24',NULL,'2010-07-15 06:16:25','1996-08-22 02:32:03','0'),
('125','5','25','2269411.00','9','1971-07-21 11:40:20','b5336d1856e522c06669f0b94ae76','25','5','25',NULL,'1977-07-12 03:26:22','1997-10-24 11:45:20','0'),
('126','1','26','2502962.00','8','2018-08-09 22:31:54','3cd623517175466eb8a961abb1d2c','26','1','26',NULL,'1985-03-22 11:46:59','2010-06-06 07:26:47','0'),
('127','2','27','648973.00','1','2008-08-18 11:37:26','3953ceb6514101b08831806514f2e','27','2','27',NULL,'1998-10-25 03:25:22','2003-04-22 19:52:00','0'),
('128','3','28','38477.00','1','1974-04-23 03:14:40','462face8c86192e12fd8b092ad0aa','28','3','28',NULL,'2004-12-27 05:57:01','2000-10-19 11:17:19','0'),
('129','4','29','58.00','6','1984-09-22 04:36:26','3ec304289c97bee1481b8d7aa6d3','29','4','29',NULL,'1999-05-31 09:07:59','1997-10-28 03:53:31','0'),
('130','5','30','36248145.00','1','2000-06-02 13:57:51','3caee4415c117525512bdfb2642612fe','30','5','30',NULL,'2015-06-07 10:43:54','1984-07-12 17:54:36','0'),
('131','1','31','1018.00','1','1991-07-15 13:27:49','b87ea0257d569a6141b7d138ea2573d','1','1','31',NULL,'1976-09-18 18:28:59','1974-11-29 20:41:54','0'),
('132','2','32','792688453.00','1','2013-09-09 03:16:04','3f8c845d1f112e2ffd4481aa88fc0bbc8f2','2','2','32',NULL,'1971-03-30 14:23:30','2011-11-06 04:33:53','0'),
('133','3','33','88961.00','4','1977-07-17 03:07:21','a6353e1a20b2f07f155ca606f10528083d','3','3','33',NULL,'1991-09-04 20:52:36','1991-07-28 12:28:57','0'),
('134','4','34','2.00','6','2002-10-30 01:56:09','6a3ea674ebb5e14c9b4c2a5371c33','4','4','34',NULL,'1996-03-10 23:28:13','2019-02-28 14:43:35','0'),
('135','5','35','701172.00','','1971-02-24 13:42:19','9f236a63e3ee6a4cd4375714ffe31','5','5','35',NULL,'1973-01-12 20:57:34','2003-06-08 16:28:31','0'),
('136','1','36','943814.00','6','1998-09-30 11:39:00','e86ba7a1d73786fee18e163da99','6','1','36',NULL,'2017-09-25 03:58:03','1973-11-22 23:35:38','0'),
('137','2','37','252297446.00','8','1978-06-27 18:21:57','5b18442578647386de5416b6855e8','7','2','37',NULL,'2008-03-24 18:40:42','2000-02-14 15:34:10','0'),
('138','3','38','0.00','3','2002-08-15 20:51:45','8c59a13e3689c68a4620899d41b','8','3','38',NULL,'1991-08-03 14:37:04','1976-01-26 22:29:59','0'),
('139','4','39','7359.00','9','2008-07-06 16:01:55','4218416b9e157a92be1f2959b5f5','9','4','39',NULL,'2010-07-22 15:04:10','1999-08-04 15:30:49','0'),
('140','5','40','29252.00','1','1985-10-02 20:46:50','f7108be9c100becb534529a2d9b','10','5','40',NULL,'1992-09-22 02:56:42','1979-08-19 06:02:50','0'),
('141','1','41','2086399.00','6','2005-09-25 22:26:37','81699ae8ea050b19c6cde04ae','11','1','41',NULL,'2004-06-15 11:49:45','1993-08-07 03:08:58','0'),
('142','2','42','1.00','6','2003-07-23 20:04:38','146f4f47116d29305351857d293a67','12','2','42',NULL,'1995-06-20 22:05:46','2019-12-13 08:27:59','0'),
('143','3','43','508269.00','4','1984-10-23 11:32:46','f36819d041555cddc970802c183a731','13','3','43',NULL,'2019-07-07 08:39:16','1987-10-11 14:59:36','0'),
('144','4','44','38054.00','2','1999-07-03 00:08:47','407bbb1c58a5c44f78cf4cef4b5a7b0662','14','4','44',NULL,'1994-02-25 19:13:35','1991-07-15 15:03:01','0'),
('145','5','45','4.00','7','2008-11-13 14:53:26','d79caff8bad1a4293988ece8d2012512903','15','5','45',NULL,'1984-07-20 10:51:57','1993-01-19 09:41:38','0'),
('146','1','46','3821649.00','9','1997-03-11 06:10:20','96ffed175b29cc9bb31709ab0f5bc1','16','1','46',NULL,'1971-11-05 08:47:26','2011-05-14 21:27:53','0'),
('147','2','47','800.00','9','2006-01-24 00:50:33','a3ac44cc4a91d84c6d3b478531e3a1796','17','2','47',NULL,'2013-11-19 04:56:58','1991-01-18 20:17:32','0'),
('148','3','48','448398692.00','2','1994-01-24 15:13:10','4d9e031267c16d706b57e6d7','18','3','48',NULL,'1999-09-09 01:00:20','2016-07-23 22:21:46','0'),
('149','4','49','2344.00','6','1986-05-11 05:31:16','3857a97cdac6178bbc4783bd51c81146','19','4','49',NULL,'2002-06-06 19:11:27','2012-06-18 10:53:49','0'),
('150','5','50','942862.00','9','2004-06-23 21:37:04','e0c536df7de1cc731d796631338cb65','20','5','50',NULL,'1986-12-08 17:57:24','1982-10-19 08:41:47','0'),
('151','1','51','6624816.00','5','1971-10-29 11:39:50','b271e9df7b7172d6448e4114b37d97','21','1','51',NULL,'2017-05-12 10:30:26','1978-11-07 01:53:58','0'),
('152','2','52','6543534.00','1','1974-04-06 02:45:59','5557f24ba22ddf64a0a631425c78','22','2','52',NULL,'1989-09-16 05:52:24','2015-11-09 20:12:38','0'),
('153','3','53','662.00','6','2000-12-26 02:47:09','a2542695bbc0534018c8a2948f17','23','3','53',NULL,'1972-09-20 01:58:24','1976-10-04 22:57:43','0'),
('154','4','54','93215.00','9','1991-06-22 16:39:30','952058a2bbaed2daff35568614801111c','24','4','54',NULL,'2019-12-12 11:55:08','2016-09-08 15:39:01','0'),
('155','5','55','1430377.00','3','2004-03-28 18:41:58','5172771db226fc092b70f224b307e9f9a8','25','5','55',NULL,'1983-10-23 20:30:34','1997-11-19 19:08:59','0'),
('156','1','56','0.00','4','1985-02-18 20:06:54','1038c5ea1f212d0ab000a99fc5bd63e881','26','1','56',NULL,'1972-10-05 09:22:15','1976-01-08 17:11:41','0'),
('157','2','57','71986867.00','1','2005-09-22 05:34:14','de10b76a72ab534819123cccb45a54','27','2','57',NULL,'1997-03-04 15:58:00','1999-02-27 05:55:07','0'),
('158','3','58','0.00','6','1976-09-23 17:56:36','161964cbbb154411a87713e318767c','28','3','58',NULL,'1979-03-31 02:53:24','2004-03-15 02:02:36','0'),
('159','4','59','72246717.00','4','2006-02-06 19:17:13','0eef1037a09677260e59a3a4cec749f','29','4','59',NULL,'1975-09-24 10:21:16','2000-03-20 20:08:47','0'),
('160','5','60','156586.00','9','2004-02-04 04:29:14','706c51d15cb59cb1a3bad623d5225051d6ad','30','5','60',NULL,'2013-09-03 23:47:57','2016-06-10 18:13:03','0'),
('161','1','61','0.00','1','2012-05-14 07:02:53','9c325c29479061d568854ddda6c2ad2','1','1','61',NULL,'1988-11-18 15:48:43','2005-08-09 23:57:48','0'),
('162','2','62','1717169.00','9','2001-10-02 07:26:01','1798238e18abc24cf6c5dcac994cf8','2','2','62',NULL,'1989-09-12 10:17:24','2001-10-29 20:14:04','0'),
('163','3','63','12.00','1','1972-09-09 17:34:15','ef7c394c32b8441c79e08b8eeedfc12','3','3','63',NULL,'2016-04-21 17:33:51','1972-10-15 16:48:18','0'),
('164','4','64','6224.00','7','2006-07-10 05:58:40','dc1d27c6d45d91170971b0ab082e2d7','4','4','64',NULL,'2018-03-13 18:04:55','2010-11-10 16:56:44','0'),
('165','5','65','5.00','1','2016-10-05 18:29:12','1441d2f20339e98a61990fdd414d','5','5','65',NULL,'2004-10-29 19:19:53','1989-07-03 12:55:26','0'),
('166','1','66','18619.00','3','2016-01-21 16:58:53','2e454ba1e91a0ad60c81139f86400bfc28','6','1','66',NULL,'1991-04-25 02:05:19','1972-01-24 07:45:58','0'),
('167','2','67','27340.00','1','1996-12-26 05:04:14','0e99fe1312b23ba71c179f308217a80','7','2','67',NULL,'2008-03-07 03:17:50','1995-10-10 20:46:54','0'),
('168','3','68','982554831.00','','2006-04-01 19:00:24','6c7c6d64b85c015e322aed52089d','8','3','68',NULL,'1991-11-09 14:46:18','1991-08-05 09:58:46','0'),
('169','4','69','5958173.00','1','2002-02-20 06:16:19','f4e797f75885bd41a4dad929c51b','9','4','69',NULL,'1973-09-10 04:49:32','1974-03-11 09:18:00','0'),
('170','5','70','56629448.00','1','1996-06-18 18:55:13','f303b26d8972940139d220a666ed','10','5','70',NULL,'2010-09-13 08:23:35','2002-08-22 21:39:31','0'),
('171','1','71','243482348.00','1','1980-09-02 02:15:50','77f1d15fec637f8181b7ff4cf53a7a','11','1','71',NULL,'2002-07-25 03:56:58','1995-03-03 21:00:50','0'),
('172','2','72','279730046.00','1','2004-04-10 02:16:25','bdf9d89fbbfe9e52c95881413cbedda24','12','2','72',NULL,'2007-07-09 01:52:49','1976-04-13 08:42:58','0'),
('173','3','73','3.00','4','2003-07-12 02:06:26','b00bdc819a5ed8484c41490168683f45181','13','3','73',NULL,'1984-07-04 10:39:06','2018-04-10 01:18:19','0'),
('174','4','74','6390748.00','3','2013-06-07 17:06:42','c4494f8715bf37df54471fddf1cc','14','4','74',NULL,'1994-08-17 16:16:45','2002-07-08 21:19:11','0'),
('175','5','75','88674488.00','1','1982-01-10 23:56:53','f112caf380e08145b34dfc1d6b1be10a2e','15','5','75',NULL,'2001-07-01 18:38:44','1993-04-09 04:08:19','0'),
('176','1','76','2.00','8','1979-07-26 03:59:53','73317878e77ff593501aa877e45f1ac1','16','1','76',NULL,'1990-05-02 06:14:55','1997-03-17 13:19:33','0'),
('177','2','77','839.00','2','1998-03-20 09:49:58','618e808761c980d7479123ef1f57f381a','17','2','77',NULL,'1981-11-02 22:37:25','1992-04-03 00:12:40','0'),
('178','3','78','39.00','9','2002-05-11 06:18:26','a34656927bfd2f31525a62f8d41','18','3','78',NULL,'1997-07-06 12:29:54','2003-11-06 22:06:12','0'),
('179','4','79','0.00','1','1990-01-10 01:06:49','2cb7863281d5f5f81f211bb361ba51','19','4','79',NULL,'1997-09-04 09:26:45','2018-12-04 01:12:39','0'),
('180','5','80','272.00','2','2016-07-10 08:09:33','e04eb044c7b6fe6d1e19bd13a17','20','5','80',NULL,'2010-10-08 23:37:18','1972-06-09 03:27:14','0'),
('181','1','81','2653.00','4','1991-04-03 13:09:44','7ef12397940dd980e1106b175518','21','1','81',NULL,'2006-10-30 07:59:30','2005-03-16 08:25:12','0'),
('182','2','82','6.00','','1972-12-03 17:51:47','64458058a86eb729c251ff291fca81','22','2','82',NULL,'1997-03-06 20:04:46','1971-12-06 02:12:32','0'),
('183','3','83','3600362.00','6','2007-12-19 02:12:16','78b8e84b14cdcdff2006d1983c1c09801','23','3','83',NULL,'2009-05-19 21:51:03','1982-06-02 16:38:42','0'),
('184','4','84','31520002.00','6','1999-04-22 19:37:05','a2e9b3a02fce9cf1117a1a1a32d','24','4','84',NULL,'2005-06-21 04:38:42','2005-02-04 11:07:19','0'),
('185','5','85','1232.00','','1993-10-01 01:03:07','ddb9197b6e6ccc4bbdbc166fc1','25','5','85',NULL,'1995-08-11 03:01:23','2013-07-13 02:41:55','0'),
('186','1','86','629387.00','1','1984-07-24 11:39:59','93e8e249e2b8ef2c410876144','26','1','86',NULL,'1979-08-07 10:24:50','1977-08-10 01:01:41','0'),
('187','2','87','36922785.00','1','1981-06-13 19:20:08','ebffc966b2c5e42c257317aa01c21','27','2','87',NULL,'1982-12-10 19:28:47','1991-05-28 03:17:43','0'),
('188','3','88','635.00','3','1992-11-09 14:28:50','e98b06b7e96135dd5c02791dd04101','28','3','88',NULL,'1981-02-04 08:22:42','2008-09-21 12:38:01','0'),
('189','4','89','0.00','4','1992-06-13 12:38:17','6f150fae016ec95ee9b167050417d78','29','4','89',NULL,'2000-03-27 04:04:09','1997-01-26 20:04:27','0'),
('190','5','90','17182801.00','','1997-07-01 00:09:35','1846134ec639181b211701dddcf9d11','30','5','90',NULL,'2013-05-26 02:44:24','1995-11-12 19:21:52','0'),
('191','1','91','0.00','7','2006-01-31 04:19:53','5660eca1dda1103f1337632ec01a374150467','1','1','91',NULL,'1975-03-16 15:02:59','1991-05-26 20:12:35','0'),
('192','2','92','2.00','3','1973-06-27 04:20:09','204a9a741d902352c26afd1bda3f2e75234c','2','2','92',NULL,'1997-10-12 08:24:07','2014-12-16 01:48:57','0'),
('193','3','93','357310490.00','3','1977-05-27 22:07:23','85c56d203dc8147306fc0f8557d59a991','3','3','93',NULL,'1971-11-30 03:18:57','1978-02-03 23:17:21','0'),
('194','4','94','2144622.00','','1996-12-10 12:39:51','2310912371384dc5f7440f4581f3b6677ae','4','4','94',NULL,'2003-04-26 12:21:49','2012-07-19 04:40:26','0'),
('195','5','95','1212.00','1','2015-12-26 10:25:24','149430b45ad483f9f0c042d2f7389a8befb','5','5','95',NULL,'1998-02-05 15:59:13','2017-02-03 16:45:09','0'),
('196','1','96','60446066.00','5','1999-02-17 10:17:52','1bf989cc1d2df834ce4c6465779c3e3bd1','6','1','96',NULL,'2006-05-23 01:00:08','1990-01-23 21:24:39','0'),
('197','2','97','8873202.00','9','1972-12-08 12:48:39','67b7e/cbbd81c6130ba0f3604c8e2ec','7','2','97',NULL,'1973-09-30 08:53:22','2012-01-10 13:25:35','0'),
('198','3','98','83714221.00','8','2016-05-12 22:42:24','7917b8a9f04b6c3bcbe936ddb1648e5a242','8','3','98',NULL,'1997-07-09 01:45:39','2008-08-28 15:34:56','0'),
('199','4','99','69362672.00','','2013-05-16 07:20:35','059b8a692dd17ca7b9e83b3d4379d8','9','4','99',NULL,'2003-11-14 02:03:32','2003-04-04 21:04:42','0'),
('200','5','100','8.00','','2015-03-10 21:08:08','534c8de3c738c5b7122d7c49e0a8da','10','5','100',NULL,'1998-05-11 07:10:16','1975-01-29 19:35:53','0');

INSERT INTO `user_forms` VALUES ('1','neutral'),
('2','neutral'),
('3','darck'),
('4','light'),
('5','darck'),
('6','neutral'),
('7','neutral'),
('8','darck'),
('9','neutral'),
('10','neutral'),
('11','contrast'),
('12','contrast'),
('13','darck'),
('14','light'),
('15','neutral'),
('16','neutral'),
('17','contrast'),
('18','neutral'),
('19','contrast'),
('20','darck'),
('21','light'),
('22','light'),
('23','darck'),
('24','light'),
('25','light'),
('26','contrast'),
('27','neutral'),
('28','darck'),
('29','darck'),
('30','light'),
('1','light'),
('2','light'),
('3','contrast'),
('4','darck'),
('5','contrast'),
('6','neutral'),
('7','light'),
('8','light'),
('9','light'),
('10','contrast'),
('11','neutral'),
('12','contrast'),
('13','darck'),
('14','neutral'),
('15','light'),
('16','neutral'),
('17','neutral'),
('18','darck'),
('19','contrast'),
('20','contrast'),
('21','darck'),
('22','darck'),
('23','darck'),
('24','light'),
('25','light'),
('26','contrast'),
('27','contrast'),
('28','contrast'),
('29','contrast'),
('30','light'),
('1','light'),
('2','light'),
('3','contrast'),
('4','contrast'),
('5','neutral'),
('6','neutral'),
('7','light'),
('8','darck'),
('9','darck'),
('10','darck'),
('11','contrast'),
('12','darck'),
('13','neutral'),
('14','neutral'),
('15','contrast'),
('16','neutral'),
('17','neutral'),
('18','darck'),
('19','contrast'),
('20','contrast'),
('21','darck'),
('22','contrast'),
('23','light'),
('24','contrast'),
('25','darck'),
('26','darck'),
('27','contrast'),
('28','light'),
('29','darck'),
('30','darck'),
('1','darck'),
('2','light'),
('3','contrast'),
('4','light'),
('5','light'),
('6','contrast'),
('7','neutral'),
('8','neutral'),
('9','neutral'),
('10','light');


INSERT INTO `forms_elements` VALUES ('1','1'),
('1','2'),
('1','3'),
('1','4'),
('2','5'),
('2','6'),
('2','7'),
('2','8'),
('3','9'),
('3','10'),
('3','11'),
('3','12'),
('4','13'),
('4','14'),
('4','15'),
('4','16'),
('5','17'),
('5','18'),
('5','19'),
('5','20'),
('6','21'),
('6','22'),
('6','23'),
('6','24'),
('7','25'),
('7','26'),
('7','27'),
('7','28'),
('8','1'),
('8','2'),
('8','29'),
('8','30'),
('9','3'),
('9','4'),
('9','5'),
('9','6'),
('10','7'),
('10','8'),
('10','9'),
('10','10'),
('11','11'),
('11','12'),
('11','13'),
('12','14'),
('12','15'),
('12','16'),
('13','17'),
('13','18'),
('13','19'),
('14','20'),
('14','21'),
('14','22'),
('15','23'),
('15','24'),
('15','25'),
('16','26'),
('16','27'),
('16','28'),
('17','1'),
('17','29'),
('17','30'),
('18','2'),
('18','3'),
('18','4'),
('19','5'),
('19','6'),
('19','7'),
('20','8'),
('20','9'),
('20','10'),
('21','11'),
('21','12'),
('21','13'),
('22','14'),
('22','15'),
('22','16'),
('23','17'),
('23','18'),
('23','19'),
('24','20'),
('24','21'),
('24','22'),
('25','23'),
('25','24'),
('25','25'),
('26','26'),
('26','27'),
('26','28'),
('27','1'),
('27','29'),
('27','30'),
('28','2'),
('28','3'),
('28','4'),
('29','5'),
('29','6'),
('29','7'),
('30','8'),
('30','9'),
('30','10');


-- скрипты выборок
	
	-- Перечень до Товаров и сумм подокументно с указанием типа документа и автора в читабельном виде
SELECT info_registr.reg_measure AS measure_name, account_registr.reg_summ, document_type.name AS dt_name, user_documents.GUID AS dt_GUID, CONCAT(users.firstname, ' ', users.lastname) AS dt_author
	FROM account_registr
		JOIN user_documents ON account_registr.doc_id = user_documents.id
		JOIN document_type ON user_documents.doc_type = document_type.id
		JOIN info_registr ON account_registr.reg_measure = info_registr.id
		JOIN users ON user_documents.author = users.id
	ORDER BY account_registr.reg_measure
	;
  -- Остатки в разрезе номенклатуры
SELECT remains_registr.measure_id, info_registr.reg_measure AS measure_name, info_registr.mesure_price, remains_registr.reg_summ
	FROM remains_registr
	JOIN info_registr ON remains_registr.measure_id = info_registr.id
;

-- представления
  -- перечень пользователей, и организаций, от которых они заводили документы
CREATE OR REPLACE VIEW vview1 AS 
	SELECT DISTINCT 
		CONCAT(users.firstname, ' ', users.lastname) AS user_name,
		profiles.hometown,
		profiles.birthday,
		organisation.name org_name,
		organisation.law_status
		FROM users
		JOIN  profiles ON users.id = profiles.user_id
		JOIN user_documents ON users.id = user_documents.author
		JOIN organisation ON user_documents.organisation_id = organisation.id
	ORDER BY profiles.hometown;
SELECT * FROM vview1;

  -- перечень пользователей, и контрагентов , по которым они заводили документы с суммами с учетом типа движения
CREATE OR REPLACE VIEW vview2 AS 
	SELECT DISTINCT 
		CONCAT(users.firstname, ' ', users.lastname) AS user_name,
		profiles.hometown AS city,
		profiles.birthday AS birth_date,
		contractor.name AS org_name,
		contractor.law_status AS status,
		SUM(CASE WHEN document_type.moving_type = 'расход' THEN user_documents.doc_sum * (-1) ELSE user_documents.doc_sum END) AS summ
		FROM users
		JOIN  profiles ON users.id = profiles.user_id
		JOIN user_documents ON users.id = user_documents.author
		JOIN contractor ON user_documents.organisation_id = contractor.id
		JOIN document_type ON user_documents.doc_type = document_type.id
	GROUP BY user_name, city, birth_date, org_name, status
	ORDER BY city;
SELECT * FROM vview2;

-- хранимые процедуры / тригеры


  -- Процедура первоначального наполнения регистров из документов
DROP PROCEDURE IF EXISTS Intelligent_Finance.sp_reg_first_fill;
DROP PROCEDURE IF EXISTS Intelligent_Finance.sp_rem_reg_first_fill;
DELIMITER //
//
CREATE DEFINER=`root`@`%` PROCEDURE `Intelligent_Finance`.`sp_reg_first_fill`()
BEGIN
	START TRANSACTION;
	
		TRUNCATE TABLE account_registr;
	
		INSERT INTO `account_registr` (`moving_type`, `reg_measure`, `reg_summ`, `doc_id`)
			SELECT `moving_type`, `doc_measure`, `doc_sum`,`user_documents`.`id`
				FROM `user_documents`
				JOIN `document_type` ON `doc_type` = `document_type`.`id`;

	COMMIT;

END
//

CREATE DEFINER=`root`@`%` PROCEDURE `Intelligent_Finance`.`sp_rem_reg_first_fill`()
	BEGIN
	START TRANSACTION;
	TRUNCATE TABLE remains_registr;
		INSERT INTO `remains_registr` (`measure_id`, `reg_summ`)
			SELECT reg_measure,
				SUM(CASE WHEN moving_type = 'расход' THEN reg_summ * (-1) ELSE reg_summ END) AS reg_summ		   
				FROM account_registr
				GROUP BY reg_measure;

	COMMIT;

END
//
DELIMITER ;


CALL Intelligent_Finance.sp_reg_first_fill();
CALL Intelligent_Finance.sp_rem_reg_first_fill();



  -- Триггер для обновления регистра накопления после добавления документов
DROP TRIGGER IF EXISTS Intelligent_Finance.t_update_acc_reg_after_insert;

DELIMITER //
//
CREATE TRIGGER `t_update_acc_reg_after_insert` AFTER INSERT ON Intelligent_Finance.user_documents 
 	FOR EACH ROW 
	BEGIN	
	INSERT INTO `account_registr` (`moving_type`, `reg_measure`, `reg_summ`, `doc_id`) VALUES (
				(SELECT `moving_type` FROM document_type WHERE document_type.id = NEW.doc_type),
				NEW.`doc_measure`,
				NEW.`doc_sum`,
				NEW.`id`)
;

END//

DELIMITER ;


INSERT INTO `user_documents` VALUES 
('226','1','1','1.00','9','1985-05-17 10:46:25','x48e226222227811150420ba7','1','1','1',NULL,'1978-01-13 07:00:42','2008-09-22 16:51:02','0'),
('227','2','2','2.00','9','2000-09-08 16:14:21','x9a42111553337811a12088f5','2','2','2',NULL,'1988-04-15 08:12:00','2017-06-13 14:11:02','0')
;
  -- Не смог создать триггер, приходится целиком перезаписывать регистр
CALL Intelligent_Finance.sp_rem_reg_first_fill();










