CREATE TABLE `sm_dates` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL DEFAULT '0000-00-00',
  `time` TIME NOT NULL,
  `last_send` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  `exclude_weekday` BIT(7) NOT NULL DEFAULT b'0',
  `message` VARCHAR(70) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_date` (`date`,`time`,`exclude_weekday`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


DROP VIEW IF EXISTS `sm_schedule`;
CREATE VIEW `sm_schedule` AS 
SELECT
  `sm_dates`.`id`              AS `id`,
  `sm_dates`.`date`            AS `date`,
  `sm_dates`.`time`            AS `time`,
  `sm_dates`.`last_send`       AS `last_send`,
  `sm_dates`.`exclude_weekday` AS `exclude_weekday`,
  `sm_dates`.`message`         AS `message`,
  MAKE_SET(~(`sm_dates`.`exclude_weekday`),'Вс','Пн','Вт','Ср','Чт','Пт','Сб') AS `weekdays`,
  IF((`sm_dates`.`date` = '0000-00-00'),(7 - BIT_COUNT(`sm_dates`.`exclude_weekday`)),'-') AS `per_week`
FROM `sm_dates`;


