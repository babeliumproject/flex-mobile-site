-- NOTE: to use EVENT statements you need MySQL v5.1.6+

-- By default the feature is disabled. You must activate it doing the following
-- on the mysql command line:
-- mysql> SET GLOBAL event_scheduler = ON;

-- To view info about your event do the following query on mysql command line:
-- mysql> SELECT * FROM INFORMATION_SCHEMA.EVENTS WHERE EVENT_NAME='event_name' \G

-- To disable the scheduled event: ALTER EVENT keep_alive_monitor DISABLE
-- To enable the scheduled event: ALTER EVENT keep_alive_monitor ENABLE

-- For more information check out the application's readme.odt


GRANT EVENT ON babeliumproject.* TO babelia@localhost;

delimiter |

CREATE DEFINER = babelia@localhost EVENT IF NOT EXISTS babeliumproject.keep_alive_monitor
    ON SCHEDULE
	EVERY 5 MINUTE
    COMMENT 'This event monitors the users sessions and closes them when needed.'
    DO 
	BEGIN
		UPDATE user_session SET duration = TIMESTAMPDIFF(SECOND,session_date,CURRENT_TIMESTAMP), closed=1 
		WHERE (keep_alive = 0 AND closed=0 AND duration=0);

		UPDATE user_session SET keep_alive = 0 
		WHERE (keep_alive = 1 AND closed = 0);
	END |

delimiter ;
