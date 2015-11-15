-- Добавление в расписание
-- TODO: исключение дня
SET NAMES utf8;
CALL SCHEDULE_REGULAR('09:00:00', 'Добавлено хранимой процедурой SCHEDULE_REGULAR');
CALL SCHEDULE_ONCE('2014-08-16 08:00:00', 'Добавлено хранимой процедурой SCHEDULE_ONCE');
SELECT * FROM `schedule`;

-- Регулярная отправка
-- должна запускаться с периодичностью, которая влияет на точность
-- TODO: доработать пограничное время, в частности интервал в несколько минут-полчаса до полуночи

SELECT * FROM dates
  WHERE 
    `date` = '0000-00-00' AND -- только регулярные
    `last_send` <= ADDDATE(NOW(), INTERVAL -1 DAY) AND -- которые не отправлялись в течение 1 дня
    `exclude_weekday` & POW(2, DAYOFWEEK(NOW())-1) = 0 AND -- пропускаем дни недели
    `time` BETWEEN ADDTIME(CURTIME(), '-00:10:00') AND CURTIME(); -- за последние 10 минут

-- Одноразовая отправка

SELECT * FROM dates
  WHERE 
    TIMESTAMP(CAST(`date` AS DATETIME), `time`) BETWEEN ADDDATE(NOW(), INTERVAL -10 MINUTE) AND NOW() AND -- только регулярные
    `last_send` <= ADDDATE(NOW(), INTERVAL -1 DAY); -- которые не отправлялись в течение 1 дня
    

-- Проба пера
-- SELECT DAYOFWEEK(TIMESTAMP(CAST(CURDATE() AS DATETIME), `time`))-1) 