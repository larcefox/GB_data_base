/* Задача 7

1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
2. Выведите список товаров products и разделов catalogs, который соответствует товару.
3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
    Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.


*/



-- создание таблиц
USE shop;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'английское название городов',
  `to` VARCHAR(255) COMMENT 'английское название городов',
  flight_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  `name` VARCHAR(255) COMMENT 'русское название городов',
  `label` VARCHAR(255) UNIQUE COMMENT 'английское название городов'
);

-- наполнение нужными данными
INSERT INTO flights
  (id, `from`, `to`, flight_date)
VALUES
	(1,	'Moscow',	'Tatuine',	'2017-01-27 09:25:01'),
	(2,	'Moscow',	'Nabu',	'2018-01-27 09:25:01'),
	(3,	'Moscow',	'Corusant',	'2019-01-27 09:25:01'),
	(4,	'Moscow',	'Khot',	'2020-01-27 09:25:01');

INSERT INTO cities
  (id, name, label)
VALUES
	(1,	'Москва',	'Moscow'),
	(2,	'Татуин',	'Tatuine'),
	(3,	'Набу',	'Nabu'),
	(4,	'Корусант',	'Corusant'),
	(5,	'Хот',	'Khot');

-- скрипт самого задания
	-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT users.id, name, birthday_at
	FROM users
	JOIN orders on users.id = orders.user_id
	GROUP BY users.id, name, birthday_at
	ORDER BY name
;

	-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT products.id, products.name, catalogs.name
	FROM products
	JOIN catalogs on products.catalog_id = catalogs.id
	GROUP BY products.id, products.name, catalogs.name
	ORDER BY products.id
;

	-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
	--    Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
SELECT flights.id, c_from.name, c_to.name, flights.flight_date
	FROM flights
	JOIN cities AS c_from ON flights.`from` = c_from.label
	JOIN cities AS c_to ON flights.`to` = c_to.label
;



