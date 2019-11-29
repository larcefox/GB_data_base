/* Задача 6

Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”. Работаем с БД vk и данными, которые вы сгенерировали ранее:
- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
- Определить кто больше поставил лайков (всего) - мужчины или женщины?

*/



-- создание таблиц

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Фамиль',
  `email` varchar(120) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `users_phone_idx` (`phone`),
  KEY `users_firstname_lastname_idx` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `communities`;
CREATE TABLE `communities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `communities_name_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `friend_requests`;
CREATE TABLE `friend_requests` (
  `initiator_user_id` bigint(20) unsigned NOT NULL,
  `target_user_id` bigint(20) unsigned NOT NULL,
  `status` enum('requested','approved','unfriended','declined') COLLATE utf8_unicode_ci DEFAULT NULL,
  `requested_at` datetime DEFAULT current_timestamp(),
  `confirmed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`initiator_user_id`,`target_user_id`),
  KEY `initiator_user_id` (`initiator_user_id`),
  KEY `target_user_id` (`target_user_id`),
  CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`initiator_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `to_user_id` bigint(20) unsigned NOT NULL,
  `from_user_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `media_types`;
CREATE TABLE `media_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `body` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `media_type_id` (`media_type_id`),
  CONSTRAINT `media_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `media_ibfk_2` FOREIGN KEY (`media_type_id`) REFERENCES `media_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint(20) unsigned NOT NULL,
  `to_user_id` bigint(20) unsigned NOT NULL,
  `body` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `messages_from_user_id` (`from_user_id`),
  KEY `messages_to_user_id` (`to_user_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `photo_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned NOT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `photos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `photo_albums` (`id`),
  CONSTRAINT `photos_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
  `user_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `gender` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `photo_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `hometown` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `users_communities`;
CREATE TABLE `users_communities` (
  `user_id` bigint(20) unsigned NOT NULL,
  `community_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`community_id`),
  KEY `community_id` (`community_id`),
  CONSTRAINT `users_communities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_communities_ibfk_2` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- наполнение нужными данными

INSERT INTO `users` VALUES 
('1','Jada','Bosco','kaley.ortiz@example.org','33'),
('2','Nathanial','Kuphal','ferry.millie@example.org','805'),
('3','Bud','Schmeler','yschmeler@example.com','966'),
('4','Gilberto','Nienow','stella.schimmel@example.org','76'),
('5','Creola','Konopelski','lhackett@example.net','0'),
('6','Maribel','Heidenreich','ujones@example.org','0'),
('7','Emilio','Kub','gudrun16@example.org','0'),
('8','Margie','Hodkiewicz','schowalter.elliott@example.net','1'),
('9','Leda','Carroll','blick.dominic@example.net','683912'),
('10','Malvina','Dickens','khauck@example.net','649')
;

INSERT INTO `communities` VALUES ('10','ad'),
('80','aliquid'),
('91','aliquid'),
('1','animi'),
('89','animi'),
('3','aperiam'),
('90','at'),
('14','aut'),
('69','autem'),
('23','beatae'),
('100','blanditiis'),
('6','commodi'),
('36','consequuntur'),
('72','corrupti'),
('86','cumque'),
('48','delectus'),
('62','delectus'),
('71','delectus'),
('21','dolor'),
('26','dolor'),
('38','dolor'),
('92','dolor'),
('94','dolore'),
('43','dolorem')
;

INSERT INTO `profiles` VALUES 
('1','w','1996-02-06','1','2010-07-11 13:41:59','Aronchester'),
('2','m','2011-03-09','2','2003-05-23 04:11:31','Wolffton'),
('3','w','1989-02-01','3','2010-11-23 10:43:55','Wilburnborough'),
('4','w','2013-01-23','4','1985-08-03 20:31:32','Joanastad'),
('5','m','1988-04-03','5','1985-10-02 14:42:43','Roxanetown'),
('6','w','1973-03-31','6','2010-06-17 09:08:22','Bergeland'),
('7','w','1990-08-13','7','1992-01-16 06:55:07','North Derick'),
('8','w','1979-12-23','8','1989-06-20 01:40:47','Bernhardville'),
('9','m','1985-02-26','9','2006-02-19 20:16:42','Edythemouth'),
('10','m','1981-07-20','10','2000-02-17 23:00:41','Lake Loy')
;

INSERT INTO `friend_requests` VALUES ('1','1','approved','1999-12-07 07:57:28','2015-07-11 15:43:11'),
('2','2','unfriended','1979-08-19 03:51:07','2007-08-23 11:54:57'),
('3','3','requested','1970-04-08 04:58:48','1978-05-18 19:13:35'),
('4','4','declined','2010-11-06 03:36:29','2019-02-04 00:08:03'),
('5','5','unfriended','2018-03-03 18:44:33','2001-11-12 22:51:54'),
('6','6','approved','2007-10-22 07:09:35','1986-09-24 18:53:30'),
('7','7','requested','2010-06-05 21:08:26','1988-10-29 23:07:09'),
('8','8','requested','1983-09-13 17:19:33','1975-08-08 18:41:14'),
('9','9','unfriended','1991-03-23 01:53:10','1999-12-23 18:41:16'),
('10','10','approved','2012-05-15 17:33:22','1983-02-24 15:25:10')
;

INSERT INTO `likes` VALUES 
('1','1','1','2016-07-13 12:36:45'),
('2','2','2','1992-08-23 22:10:58'),
('3','3','3','1986-07-28 04:07:55'),
('4','4','4','1998-06-04 01:48:06'),
('5','5','5','1976-08-08 08:15:44'),
('6','6','6','1986-05-14 03:06:19'),
('7','7','7','1998-12-15 23:46:27'),
('8','8','8','1983-07-29 15:47:41'),
('9','9','9','1979-07-23 10:39:36'),
('10','10','10','1987-11-21 02:44:37')
;

INSERT INTO `media_types` VALUES 
('1','excepturi','1994-05-17 09:19:58','2010-11-10 22:49:49'),
('2','dignissimos','1995-07-09 04:34:16','1977-08-05 07:20:24'),
('3','velit','1995-07-22 10:59:14','2002-06-19 19:29:08'),
('4','occaecati','1978-01-27 15:09:48','1980-07-29 23:06:02'),
('5','magnam','1993-09-01 21:30:23','1972-05-08 02:38:52'),
('6','alias','1986-06-29 03:55:43','1998-02-19 18:28:30'),
('7','excepturi','2017-03-12 15:54:55','1997-02-28 19:26:47'),
('8','cumque','2015-09-11 13:50:34','1978-02-27 16:25:10'),
('9','omnis','2005-03-08 01:37:43','1982-10-08 06:47:12'),
('10','harum','1977-05-20 14:08:24','2019-01-18 14:25:15'); 

INSERT INTO `media` VALUES ('1','1','1','Voluptatem temporibus tenetur omnis facere labore. Ipsa recusandae et consectetur aut autem beatae voluptate. Ab est in est earum voluptas quo esse. Pariatur necessitatibus illum eos ullam aliquam. Qui suscipit ut laborum quam est in beatae.','quidem','579930663',NULL,'2014-05-17 07:20:28','2007-10-11 08:18:45'),
('2','1','2','Eaque corrupti et et doloremque exercitationem sed molestiae. Omnis ratione rerum temporibus magnam. Saepe veritatis omnis quo voluptatem dicta tempora sit.','quidem','29',NULL,'2001-07-05 03:54:05','2009-07-05 08:26:45'),
('3','3','3','Hic cumque reprehenderit dolore voluptas excepturi. Deserunt illum repellendus et voluptatem aliquam tempora.','atque','943423834',NULL,'1987-07-25 19:56:02','1999-06-02 19:52:21'),
('4','4','4','Mollitia delectus sit in quae et labore ea accusantium. Molestiae cumque vitae nobis minus. Molestias libero perferendis at consequatur quia eos.','accusamus','0',NULL,'1997-02-13 05:21:25','1979-04-30 03:38:16'),
('5','5','5','Sed voluptates adipisci quaerat non molestiae sit architecto. Ut impedit sunt dolore animi dolor sed. Sit veritatis iure quia non sed cum. Rerum dolor distinctio enim vel nulla eaque.','necessitatibus','946259',NULL,'1988-10-04 03:39:24','1971-04-24 13:53:14'),
('6','6','6','Soluta saepe accusantium tempora occaecati. Sit enim labore voluptatem vero. Sunt voluptas sunt quia magnam at fuga.','nulla','742986',NULL,'1988-06-14 22:45:02','2011-03-01 19:20:04'),
('7','7','7','Odio sit dignissimos necessitatibus autem voluptates distinctio. Consequuntur rerum iusto reiciendis. Quo omnis autem cum dolorem repellendus reiciendis non. Et veritatis et molestiae iste distinctio sit.','autem','6894370',NULL,'2017-05-21 10:07:53','1975-06-11 13:41:34'),
('8','8','8','Sint quia quod voluptatum pariatur consequatur repellat. Explicabo odit molestiae perferendis molestiae dolorem.','consequatur','2849',NULL,'2013-04-21 04:11:37','2007-09-20 00:10:46'),
('9','9','9','Mollitia laborum repellendus qui laudantium cumque dolores quia. Quis velit et laborum molestiae dolorum. Vel eveniet perferendis minus rerum iste. Qui sint quis dolorem nemo nulla aspernatur et molestias.','omnis','0',NULL,'1996-12-10 05:24:58','2014-02-26 05:20:37'),
('10','10','10','In cumque atque architecto eveniet nostrum odit consequatur. Voluptatibus voluptas at et et optio.','maiores','735',NULL,'1992-09-29 02:10:04','2002-10-03 13:49:26')
;

INSERT INTO `messages` VALUES 
('1','2','1','Consequuntur ab nemo necessitatibus labore. Qui sunt velit sit dignissimos. Corporis porro iusto non qui fugiat.','2004-11-18 19:50:31'),
('2','2','1','Placeat recusandae ducimus magni et dolorum consequatur consequatur. Minus voluptatem libero rem ducimus et id saepe minus. Nam sunt modi tenetur. Aut perferendis et temporibus et molestiae.','2000-12-31 06:44:41'),
('3','2','1','Earum voluptatem quis provident. Reiciendis omnis doloribus aut voluptas. Esse magnam quidem modi quis voluptas.','2009-03-01 18:12:18'),
('4','4','4','Quae nihil aut quasi saepe. Expedita ratione qui eaque culpa aperiam rem. Aut accusantium consequatur quidem perferendis et aut asperiores. Reprehenderit repudiandae beatae repellat quo quos.','1980-05-10 22:50:33'),
('5','5','1','Dignissimos pariatur in natus earum consequatur. Labore quis praesentium expedita voluptates fuga voluptas hic. Laudantium ipsa repudiandae doloremque neque enim aperiam. Corporis unde sed necessitatibus tenetur quo.','1995-02-23 16:19:49'),
('6','6','6','Voluptatum tempora accusamus saepe dignissimos. Voluptas dolorem eos quis ipsum quas. Provident alias rem pariatur dicta et illo.','1983-01-22 17:31:42'),
('7','7','1','Molestiae qui sunt consequatur dignissimos non veniam cumque. Quis ipsam accusantium architecto odit occaecati nesciunt. Et inventore dolorem eligendi iste sint aut. Veniam harum incidunt inventore pariatur.','1990-07-21 20:36:16'),
('8','8','1','Ut cupiditate recusandae dicta optio animi deserunt dolores. Est laudantium totam qui corrupti sapiente iure. A occaecati ducimus et non itaque omnis recusandae. Officiis illum ullam dicta consectetur. Vero sed et velit ea reiciendis alias doloribus placeat.','2012-07-13 14:17:07'),
('9','9','9','Laboriosam fugiat vitae impedit ut. Voluptate perspiciatis est consequatur qui sit quo qui. Quaerat voluptas odio ipsa ipsa. Laboriosam eligendi distinctio repellat accusamus.','2016-06-25 22:38:00'),
('10','9','1','Provident sunt officiis non voluptas et. Laboriosam assumenda voluptatem labore quibusdam eum odit. Rem error excepturi omnis eligendi culpa. Deleniti et eum amet architecto quis.','1993-03-09 15:33:34')
;

INSERT INTO `photo_albums` VALUES 
('1','ut','1'),
('2','et','2'),
('3','aut','3'),
('4','est','4'),
('5','officiis','5'),
('6','quaerat','6'),
('7','inventore','7'),
('8','perspiciatis','8'),
('9','voluptate','9'),
('10','suscipit','10')
;

INSERT INTO `photos` VALUES ('1','1','1'),
('2','2','2'),
('3','3','3'),
('4','4','4'),
('5','5','5'),
('6','6','6'),
('7','7','7'),
('8','8','8'),
('9','9','9'),
('10','10','10')
;

INSERT INTO `users_communities` VALUES 
('1','1'),
('2','80'),
('3','91'),
('4','89'),
('5','3'),
('6','90'),
('7','14'),
('8','69'),
('9','92'),
('10','38')
;
-- скрипт самого задания

-- 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
	-- a. Счиатю колличество сообщений по отправителю
SELECT COUNT(to_user_id) as count_of_mess, from_user_id
			FROM messages
			WHERE to_user_id = 1
			GROUP BY from_user_id;
	-- b. Счиатю максимальное число сообщений
SELECT MAX(count_of_mess)
	FROM (SELECT COUNT(to_user_id) as count_of_mess
			FROM messages
			WHERE to_user_id = 1
			GROUP BY from_user_id) as ms
;
	-- c. Беру из первой таблицы строку, где максимальное колличество сообщений
SELECT count_of_mess, from_user_id
	FROM (SELECT COUNT(to_user_id) as count_of_mess, from_user_id
			FROM messages
			WHERE to_user_id = 1
			GROUP BY from_user_id) as m
	where count_of_mess = 
						(SELECT MAX(count_of_mess)
							FROM (SELECT COUNT(to_user_id) as count_of_mess
							FROM messages
							WHERE to_user_id = 1
							GROUP BY from_user_id) as ms)
	GROUP BY from_user_id
;

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..

 -- Получаю пользователей младше 10 лет
SELECT user_id
	FROM profiles as p
	WHERE (SELECT DATEDIFF(NOW(), birthday)/365.25) < 10
;

 -- Считаю сколько лайков у пользователей младше 10 лет
SELECT to_user_id, COUNT(*)
	FROM likes
	WHERE to_user_id IN (SELECT user_id
							FROM profiles as p
							WHERE (SELECT DATEDIFF(NOW(), birthday)/365.25) < 10)
	GROUP BY to_user_id
;




