CREATE DATABASE IF NOT EXISTS `civil`;


CREATE TABLE IF NOT EXISTS `user`(
   `uid` INT UNSIGNED AUTO_INCREMENT,
   `usr_name` VARCHAR(32) NOT NULL ,
	`passwd` VARCHAR(32) NOT NULL,
   `submission_date` DATE,
   PRIMARY KEY ( `uid` ),
   UNIQUE (`usr_name`)
);