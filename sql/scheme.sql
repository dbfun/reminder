-- Расписание
DROP TABLE IF EXISTS `dates`;
CREATE TABLE `dates` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL DEFAULT '0000-00-00',
  `time` TIME NOT NULL,
  `last_send` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  `exclude_weekday` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `message` VARCHAR(70) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_date` (`date`,`time`,`exclude_weekday`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- Представление расписания
DROP VIEW IF EXISTS `schedule`;
CREATE VIEW `schedule` AS
SELECT
  dates.*,
  MAKE_SET(`exclude_weekday`,'Вс','Пн','Вт','Ср','Чт','Пт','Сб') AS `exclude_weekdays`,
  IF((`date` = '0000-00-00'),(7 - BIT_COUNT(`exclude_weekday`)),'-') AS `per_week`
FROM `dates`;

-- Процедуры добавления в расписание
DROP PROCEDURE IF EXISTS `SCHEDULE_REGULAR`;
DROP PROCEDURE IF EXISTS `SCHEDULE_ONCE`;
DELIMITER $$

CREATE PROCEDURE `SCHEDULE_REGULAR` (IN in_time TIME, IN in_message VARCHAR(70) charset utf8)
BEGIN
  INSERT INTO `dates` (`time`, `message`) VALUES (in_time, in_message);
END$$

CREATE PROCEDURE `SCHEDULE_ONCE` (IN in_date_time DATETIME, IN in_message VARCHAR(70) charset utf8)
BEGIN
  INSERT INTO `dates` (`date`, `time`, `message`) VALUES (CAST(in_date_time AS DATE), CAST(in_date_time AS TIME), in_message);
END$$

DELIMITER ;