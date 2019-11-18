/*
 * 
 * Курсовая работа
 * Субботин Андрей aka LarceFox
 * 
 */



DROP database IF EXISTS accoun_system;
CREATE DATABASE accoun_system;
use accoun_system;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id serial PRIMARY KEY, 
	firstname VARCHAR(100),
	lastname VARCHAR(100),
	email VARCHAR(100) UNIQUE,
	pass_hash VARCHAR(100),
	phone VARCHAR(12),
	
	INDEX users_phone_idx(phone),
	INDEX (firstname, lastname)
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
	user_id serial PRIMARY KEY,
	gender CHAR(1),
	birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
	hometown VARCHAR(100),
	created_at DATETIME default now()
);

ALTER TABLE profiles
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;