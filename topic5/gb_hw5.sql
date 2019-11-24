/* Задача 5
	Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое
 время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар
 закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились
  в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде 
списка английских названий ('may', 'august')

5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
Отсортируйте записи в порядке, заданном в списке IN.

	Практическое задание теме “Агрегация данных”
6. Подсчитайте средний возраст пользователей в таблице users
7. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели 
текущего года, а не года рождения.
8. (по желанию) Подсчитайте произведение чисел в столбце таблицы


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
  `created_at` VARCHAR(100) DEFAULT NULL,
  `updated_at` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `users_phone_idx` (`phone`),
  KEY `users_firstname_lastname_idx` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Для задания 2
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль',
    email VARCHAR(120) UNIQUE,
    phone BIGINT, 
    INDEX users_phone_idx(phone),
    INDEX users_firstname_lastname_idx(firstname, lastname)
);


DROP TABLE IF EXISTS `storehouses_products`;
CREATE TABLE `storehouses_products` (
  `id` SERIAL PRIMARY KEY,
  `product_name` varchar(50) DEFAULT NULL COMMENT 'Название',
  `product_serial` bigint(20) unsigned,
  `vendor`  varchar(50) DEFAULT NULL COMMENT 'Производитель',
  `value` INT unsigned DEFAULT 0,
  `storehouses` VARCHAR(100) DEFAULT NULL,
  UNIQUE KEY `product_serial` (`product_serial`),
  KEY `product_serial_idx` (`product_serial`),
  KEY `name_vendor_idx` (`product_name`,`vendor`)
);

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
) AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- наполнение нужными данными

INSERT INTO `users` VALUES 
('1','Jada','Bosco','kaley.ortiz@example.org','33',"20.10.2017 8:10","20.10.2017 8:10"),
('2','Nathanial','Kuphal','ferry.millie@example.org','805',"20.10.2017 8:10","20.10.2017 8:10"),
('3','Bud','Schmeler','yschmeler@example.com','966',"20.10.2017 8:10","20.10.2017 8:10"),
('4','Gilberto','Nienow','stella.schimmel@example.org','76',"20.10.2017 8:10","20.10.2017 8:10"),
('5','Creola','Konopelski','lhackett@example.net','0',"20.10.2017 8:10","20.10.2017 8:10"),
('6','Maribel','Heidenreich','ujones@example.org','0',"20.10.2017 8:10","20.10.2017 8:10"),
('7','Emilio','Kub','gudrun16@example.org','0',"20.10.2017 8:10","20.10.2017 8:10"),
('8','Margie','Hodkiewicz','schowalter.elliott@example.net','1',"20.10.2017 8:10","20.10.2017 8:10"),
('9','Leda','Carroll','blick.dominic@example.net','683912',"20.10.2017 8:10","20.10.2017 8:10"),
('10','Malvina','Dickens','khauck@example.net','649',"20.10.2017 8:10","20.10.2017 8:10")
;
INSERT INTO `storehouses_products` (product_name, product_serial, vendor, value, storehouses) VALUES 
('Gear1','111222333','Samsung','33','Moscow'),
('Gear2','111222444','Samsung','50','Moscow'),
('Gear3','155222444','Samsung','60','Moscow'),
('Gear4','111262444','Samsung','40','Ramenskoe'),
('Gear5','111227444','Samsung','0','Klin')
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

-- скрипт самого задания

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

UPDATE users  SET created_at = NOW(), updated_at = NOW();

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое
--    время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

UPDATE users 
SET created_at = CONCAT(SUBSTRING(created_at,7,4), '-', SUBSTRING(created_at,4,2), '-', SUBSTRING(created_at,1,2), ' 0', SUBSTRING(created_at,12,1), ':', SUBSTRING(created_at,14,2), ':00'),
	updated_at = CONCAT(SUBSTRING(updated_at,7,4), '-', SUBSTRING(updated_at,4,2), '-', SUBSTRING(updated_at,1,2), ' 0', SUBSTRING(updated_at,12,1), ':', SUBSTRING(updated_at,14,2), ':00')
;
ALTER TABLE users 
CHANGE 
created_at created_at DATETIME NOT NULL,
CHANGE
updated_at updated_at DATETIME NOT NULL;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар
--    закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились
--    в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

(SELECT id, product_name, vendor, value AS sort_value
	FROM storehouses_products
	WHERE value > 0
	ORDER BY sort_value ASC)
UNION
(SELECT id, product_name, vendor, value
	FROM storehouses_products
	WHERE value = 0)
;

-- 6. Подсчитайте средний возраст пользователей в таблице users

SELECT 
	COUNT(*) AS count_of_users,
	(SELECT AVG(TIMESTAMPDIFF(YEAR, birthday, NOW())) FROM profiles) AS user_average_age
FROM users
;

-- 7. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели 
--    текущего года, а не года рождения.

SELECT 
	COUNT(*) AS count_of_users,
	DAYNAME(DATE_ADD("2019-01-01", INTERVAL (DAYOFYEAR(birthday) - 1) DAY)) AS birthday_day_name
FROM profiles
GROUP BY birthday_day_name
ORDER BY count_of_users DESC
;


