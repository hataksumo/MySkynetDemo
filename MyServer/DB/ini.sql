CREATE DATABASE IF NOT EXISTS `civil`;


CREATE TABLE IF NOT EXISTS `user`(
   `uid` INT UNSIGNED AUTO_INCREMENT,
   `usr_name` VARCHAR(32) NOT NULL ,
	`passwd` VARCHAR(32) NOT NULL,
   `submission_date` timestamp,
   PRIMARY KEY ( `uid` ),
   UNIQUE (`usr_name`)
);

CREATE TABLE IF NOT EXISTS `player_city`(
   `uid` INT UNSIGNED AUTO_INCREMENT,
   `usr_name` VARCHAR(32),
   `resbag_info` TEXT,
   `population` TEXT,
   `building` TEXT,
   PRIMARY KEY ( `uid` ),
   UNIQUE (`usr_name`)
);