DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `usr_name` varchar(32) NOT NULL,
  `passwd` varchar(32) NOT NULL,
  `nick_name` varchar(32) NOT NULL,
  `submission_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `usr_name` (`usr_name`),
  UNIQUE KEY `nick_name` (`nick_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `player_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player_city` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `account_id` int(11) DEFAULT NULL,
  `nick_name` varchar(32) DEFAULT NULL,
  `city_info` blob,
  `resbag_info` blob,
  `population` blob,
  `building` blob,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `usr_name` (`nick_name`),
  KEY `index_name` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;