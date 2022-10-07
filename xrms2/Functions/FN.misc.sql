
--
-- Definition for procedure throw
--
DROP PROCEDURE IF EXISTS `xrms2`.`throw`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
PROCEDURE `xrms2`.`throw`( IN `$_errno` INT UNSIGNED )
  NO SQL
  COMMENT 'Throws a USER defined error'
BEGIN

  -- ------------------------------------------------------------------
  -- * PRCEDURE
  -- *
  -- *  Throws a "user defined" error condition.
  -- *  Retrieves message form ERROR table.
  -- *
  -- *  @author Walter Torres <walter@torres.ws>
  -- *
  -- *  @param `$_errno` INT(8) UNSIGNED  USER defined error code
  --
  -- ------------------------------------------------------------------

  DECLARE `$_msg` VARCHAR(128) DEFAULT NULL;

  IF $_errno IS NOT NULL
    THEN

    SELECT `description`
      INTO $_msg
      FROM `errors`
     WHERE `err_id` = $_errno
     LIMIT 1
      ;

  END IF;

  -- Set a message, just in case
  SET $_msg = IF($_msg IS NULL, "Unknown Error Code", $_msg);

  SIGNAL SQLSTATE
    'ERR0R'

  SET MESSAGE_TEXT = $_msg
    , MYSQL_ERRNO  = $_errno
  ;

END$$
DELIMITER ;


--
-- Definition for function FN_cast_INT
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_cast_INT`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_cast_INT`(`$_parm` VARCHAR(128))
  RETURNS INT
  NO SQL
BEGIN

-- ------------------------------------------------------------------
-- * FUNCTION
-- *
-- *  Cast given STRING as an SIGNED INT. But only if it can.
-- *   - ALPHA, or numbers embedded with ALPHA, are returned as a NULL
-- *   - NULL is returned as a NULL
-- *
-- *  @author Walter Torres <walter@torres.ws>
-- *
-- *  @param `$_parm` VARCHAR(128)
-- *
-- *  @return `$_parm` INT SIGNED  returns NULL if not an INT
--
-- ------------------------------------------------------------------

  -- Error handling
  DECLARE EXIT HANDLER FOR 1292
      RETURN NULL;

  SET $_parm = IF( $_parm = ''
                 , NULL
                 , CAST($_parm AS SIGNED)
                 );

  RETURN $_parm;

END$$
DELIMITER ;

--
-- -----------------------------------------------------------------
--

--
-- Definition for function FN_ckBoolean
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_ckBoolean`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_ckBoolean`( `$_boolValue`    VARCHAR(128)
                               , `$_defaultValue` BOOLEAN
                               )
  RETURNS tinyint
  NO SQL
BEGIN

  -- Just incase DEFAULT is not set
  SET $_defaultValue = IF($_defaultValue IS NULL, 0, $_defaultValue); -- set to FALSE

  IF $_boolValue IS NULL
    OR $_boolValue = ''
    OR $_boolValue > 1
    THEN

    SET $_boolValue = $_defaultValue;

  END IF;

  RETURN $_boolValue;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--

-- ------------------------------------------------------------------
-- * FUNCTION
-- *
-- *  Returns an input wrapped in "'" if value is non-numeric, original otherwise.
-- *
-- *  @author ymgoldman
--            https://stackoverflow.com/questions/2763722/stored-procedure-to-create-insert-statements-in-mysql
-- *
-- *  @param  `$_value` varchar(128)
-- *
-- *  @return varchar(128)  Wrapped string or numeric value
-- *
-- *  @uses FN_wrapNonNumeric()
-- *
-- *  @example select wrapNonNumeric(now()); => '\'2012-02-16'\'
--             select wrapNonNumeric(NULL); => NULL
--             select wrapNonNumeric(1); => 1
--             select wrapNonNumeric('1d3'); => '\'1d3\''
--
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS `xrms2`.`FN_wrapNonNumeric`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_wrapNonNumeric`( `$_value` varchar(128)  )
  RETURNS varchar(128)
  NO SQL
  DETERMINISTIC
BEGIN

  RETURN IF(FN_cast_INT($_value), $_value, concat("'", $_value, "'"));

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--


--
-- Definition for function FN_ckConsecDays
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_ckConsecDays`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_ckConsecDays`( `$user_id`       INT UNSIGNED
                                  , `$days_to_count` INT UNSIGNED
                                  )
  RETURNS tinyint
  NO SQL
BEGIN

  DECLARE $has_consec TINYINT UNSIGNED;

  SELECT
    IF(COUNT(1) > 0, 1, 0) INTO $has_consec
  FROM (SELECT
      *
    FROM (SELECT
        IF(CAST(`b`.`login_date` AS date) IS NULL, @val := @val + 1, @val) AS `consec_set`
      FROM `user_login_log` `a`
        CROSS JOIN (SELECT
            @val := 0) `var_init`
        LEFT JOIN `user_login_log` `b`
          ON `a`.`user_id` = `b`.`user_id`
          AND CAST(`a`.`login_date` AS date) = CAST(`b`.`login_date` AS date) + INTERVAL 1 DAY
      WHERE `a`.`user_id` = $user_id
	  GROUP BY CAST(`a`.`login_date` AS date)) `a`
    GROUP BY `a`.`consec_set`
    HAVING COUNT(1) >= $days_to_count) `a`;

  RETURN $has_consec;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--

--
-- Definition for function FN_ckDocType
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_ckDocType`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_ckDocType`( `$_docTypeID` INT UNSIGNED )
  RETURNS int UNSIGNED
  READS SQL DATA
  DETERMINISTIC
BEGIN

  -- Default to NULL [no type] if invalid value
  DECLARE `$_properValue` INT(1) UNSIGNED DEFAULT NULL;

  -- Only need to query if we have a value to check
  IF $_docTypeID IS NOT NULL
    AND $_docTypeID > 0
    THEN

      SELECT `doc_type_id` INTO $_properValue
        FROM `doc_type`
       WHERE `doc_type_id` = $_docTypeID;

  END IF;

  -- We have what we need
  RETURN $_properValue;

END
$$

DELIMITER ;


--
-- -----------------------------------------------------------------
--

--
-- Definition for function FN_ckLanguage
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_ckLanguage`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_ckLanguage`( `$_languageID` INT UNSIGNED )
  RETURNS int UNSIGNED
  READS SQL DATA
  DETERMINISTIC
BEGIN

  -- Default to 1 [ENGLISH] if invalid value
  DECLARE `$_properValue` INT UNSIGNED DEFAULT 1;

  -- Only need to query if we have a value to check
  IF ($_languageID IS NOT NULL)
  THEN
    SELECT `language_id` INTO $_properValue
      FROM `language`
     WHERE `language_id` = $_languageID;
  END IF;

  RETURN $_properValue;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--


--
-- Definition for function FN_ckStatus
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_ckStatus`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_ckStatus`( `$_statusID` INT UNSIGNED )
  RETURNS int UNSIGNED
  READS SQL DATA
  DETERMINISTIC
BEGIN

  -- Default to 1 [draft] if invalid value
  DECLARE `$_properValue` INT UNSIGNED DEFAULT 1;

  -- Only need to query if we have a value to check
  IF ($_statusID IS NOT NULL)
  THEN
    SELECT `status_id` INTO $_properValue
      FROM `status`
     WHERE `status_id` = $_statusID;
  END IF;

  RETURN $_properValue;

END
$$

DELIMITER ;


--
-- -----------------------------------------------------------------
--


--
-- Definition for function FN_force_BOD_Date
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_force_BOD_Date`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_force_BOD_Date`( `$_unixStamp` INT UNSIGNED)
  RETURNS INT UNSIGNED
  NO SQL
  DETERMINISTIC
BEGIN

-- ------------------------------------------------------------------
-- * FUNCTION
-- *
-- *  Forces a given UNIX TIMESTAMP to at the Beginnig of Day [BOD] time
-- *  (midnight) while keeping the date.
-- *
-- *  @author Walter Torres <walter@torres.ws>
-- *
-- *  @param  `$_unixStamp` INT(11)
-- *
-- *  @return INT(11) UNSIGNED   redefined UNIX TIMESTAMP
--
-- ------------------------------------------------------------------

  RETURN UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME($_unixStamp),'%Y-%m-%d'),'  00:00:00'));

END
$$

DELIMITER ;

--
-- Definition for function FN_force_EOD_Date
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_force_EOD_Date`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_force_EOD_Date`( `$_unixStamp` int UNSIGNED)
  RETURNS int UNSIGNED
  NO SQL
  DETERMINISTIC
BEGIN

-- ------------------------------------------------------------------
-- * FUNCTION
-- *
-- *  Forces a given UNIX TIMESTAMP to at the End of Day [EOD] time
-- *  (1 second before midnight of next day) while keeping the date.
-- *
-- *  @author Walter Torres <walter@torres.ws>
-- *
-- *  @param  `$_unixStamp` INT UNBSIGNED
-- *
-- *  @return INT UNSIGNED   redefined UNIX TIMESTAMP
--
-- ------------------------------------------------------------------

  RETURN UNIX_TIMESTAMP(CONCAT(DATE_FORMAT(FROM_UNIXTIME($_unixStamp),'%Y-%m-%d'),' 23:59:59'));

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--

--
-- Definition for function FN_makeShortName
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_makeShortName`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_makeShortName`($_name varchar(100))
  RETURNS varchar(20)
  NO SQL
  DETERMINISTIC
BEGIN

  SET $_name = REPLACE($_name, ' ', '_');
  SET $_name = LEFT($_name, 20);

  RETURN $_name;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--


--
-- Definition for function FN_split_nameValuePairs
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_split_nameValuePairs`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_split_nameValuePairs`( $_data        VARCHAR(500)
                                  , $_delimiter_1 VARCHAR(2)
                                  , $_delimiter_2 VARCHAR(2)
                                  )
  RETURNS varchar(250)
  NO SQL
  DETERMINISTIC
BEGIN

  IF $_delimiter_1 IS NULL
    THEN
    SET $_delimiter_1 = ':';
  END IF;

  IF $_delimiter_2 IS NULL
    THEN
    SET $_delimiter_2 = '|';
  END IF;


  IF (POSITION($_delimiter_2 IN $_data) > 0)
    THEN

    SET $_data = `FN_stripSpaceCSL`($_data, $_delimiter_1);

    IF $_data IS NOT NULL
      THEN

    BEGIN

      DECLARE $_currentPair VARCHAR(500) DEFAULT '';
      DECLARE $_fieldName   VARCHAR(100) DEFAULT 0;
      DECLARE $_fieldValue  VARCHAR(500) DEFAULT 0;

      DECLARE $_delimiterLength TINYINT(1) DEFAULT 0;

      SET $_delimiterLength = CHAR_LENGTH($_delimiter_1);

      DROP TEMPORARY TABLE IF EXISTS `tmp_nameValuePairs`;
      CREATE TEMPORARY TABLE IF NOT EXISTS `tmp_nameValuePairs`
          ( `name`  VARCHAR(500) NOT NULL,
            `value` VARCHAR(1000) NOT NULL
          )
      ENGINE = MEMORY DEFAULT CHARSET = utf8;

      WHILE $_data != ''
        DO

        SET $_currentPair = `FN_strip_right`($_data, $_delimiter_1);


        IF NULLIF($_currentPair, '') IS NOT NULL
          THEN

          IF (POSITION($_delimiter_2 IN $_currentPair) > 0)
            THEN
            SET $_fieldName = `FN_strip_right`($_currentPair, $_delimiter_2);
            SET $_fieldValue = `FN_strip_left`($_currentPair, $_delimiter_2);

            INSERT IGNORE INTO `tmp_nameValuePairs` (`name`, `value`)
              VALUES ($_fieldName, $_fieldValue);

          END IF;

        END IF;

        SET $_data = SUBSTRING($_data, CHAR_LENGTH($_currentPair) + $_delimiterLength + 1);

      END WHILE;

    END;

    END IF;
  END IF;

  RETURN 'tmp_nameValuePairs';

END
$$


DELIMITER ;
--
-- -----------------------------------------------------------------
--

--
-- Definition for function FN_split_Values
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_split_Values`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_split_Values`( `$_data`      TEXT
                                 , `$_delimiter` VARCHAR(2)
                                 )
  RETURNS INT UNSIGNED
  NO SQL
  DETERMINISTIC
BEGIN

-- ----------------------------------------------------------
-- * FUNCTION
-- *
-- *  A simple parseing function to retrieve and make data sets
-- *  easier to pass an of array data to mySQL
-- *
-- *  @author Walter Torres <walter@torres.ws>
-- *
-- *  @param `$_data` TEXT                     Delimited Data set to parse
-- *  @param `$_delimiter` VARCHAR(2)          Character (or 3) to parse data set
-- *
-- *  @return `$_foundCount` INT(10) UNSIGNED  How many values where found.
--
-- ----------------------------------------------------------

  -- Return how many pieces of data we found
  DECLARE `$_foundCount` INT UNSIGNED DEFAULT 0;

  -- Define DELIMTER if not given
  SET $_delimiter = IF($_delimiter IS NULL, '|', $_delimiter);

  -- Cleans SPACE from data set
  SET $_data = `FN_stripSpaceCSL`($_data, $_delimiter);

  -- Process if we have anything left
  IF $_data IS NOT NULL
    THEN

    BEGIN

      -- Each piece of data to be culled from data set
      DECLARE `$_currentValue` TEXT DEFAULT '';

      -- Length of DELIMITER is used to cull actual values from data set
      DECLARE `$_delimiterLength` tinyint UNSIGNED DEFAULT 1;
      SET $_delimiterLength = CHAR_LENGTH($_delimiter);

      -- a TEMP TABLE to place values from data set
      DROP TEMPORARY TABLE IF EXISTS `tmp_Values`;
      CREATE TEMPORARY TABLE IF NOT EXISTS `tmp_Values`
        ( `value` VARCHAR(1000) NOT NULL )
      ENGINE = MEMORY
      DEFAULT charset = `utf8`;

      -- Loop until we're done
      WHILE $_data != ''
        DO

        -- Drop everything RIGHT of the DELIMITER
        SET $_currentValue = `FN_strip_right`($_data, $_delimiter);

        -- Skip if we have nothing left to pull
        IF NULLIF($_currentValue, '') IS NOT NULL
          THEN

          -- row won't actually be inserted if it results in a duplicate key
          INSERT IGNORE
            INTO `tmp_Values`
             SET `value` = $_currentValue;

          -- Add to our found count
          set $_foundCount = $_foundCount + 1;

        END IF;

        -- Strip off current value and DELIMITER form data set and loop around
        SET $_data = SUBSTRING($_data, CHAR_LENGTH($_currentValue) + $_delimiterLength + 1);

      END WHILE;

    END;

  END IF;

  -- How many do we have?
  RETURN $_foundCount;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--



--
-- Definition for function FN_stripSpaceCSL (Comma Seperated List)
--

DROP FUNCTION IF EXISTS `xrms2`.`FN_strip_spaceCSL`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_strip_spaceCSL`( `$_text`      TEXT
                           , `$_delimiter` VARCHAR(10)
                           )
  RETURNS TEXT
  NO SQL
  DETERMINISTIC
BEGIN

  IF $_text IS NOT NULL
    THEN

    BEGIN
      DECLARE $_delimiterLength tinyint UNSIGNED DEFAULT 0;
      DECLARE $_currentField    varchar(128) DEFAULT '';
      DECLARE $_newText         TEXT DEFAULT '';

      IF $_delimiter IS NULL
        THEN
        SET $_delimiter = ',';
      END IF;

      SET $_delimiterLength = CHAR_LENGTH($_delimiter);

      WHILE ($_text != '')
        DO

        SET $_currentField = `FN_strip_right`($_text, $_delimiter);

        IF NULLIF($_currentField, '') IS NOT NULL
          THEN
          SET $_newText = CONCAT($_newText, $_delimiter, $_currentField);
        END IF;

        SET $_text = SUBSTRING($_text, CHAR_LENGTH($_currentField) + $_delimiterLength + 1);
      END WHILE;

      SET $_text = TRIM(BOTH $_delimiter FROM $_newText);

    END;

  END IF;

  RETURN $_text;

END
$$

DELIMITER ;

--
-- Definition for function FN_strip_left
--
DROP FUNCTION IF EXISTS `xrms2`.`FN_strip_left`;
DELIMITER $$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION `xrms2`.`FN_strip_left`( `$_text`      TEXT
                        , `$_delimiter` VARCHAR(10)
                        )
  RETURNS text CHARSET utf8
  NO SQL
BEGIN

  SET $_text = TRIM(SUBSTRING_INDEX($_text, $_delimiter, -1));

  RETURN $_text;

END
$$

--
-- Definition for function FN_strip_right
--
DROP FUNCTION IF EXISTS FN_strip_right$$
CREATE DEFINER = 'xrms'@'localhost'
FUNCTION FN_strip_right( `$_text`      TEXT
                         , `$_delimiter` VARCHAR(10)
                         )
  RETURNS text CHARSET utf8
  NO SQL
BEGIN

  SET $_text = TRIM(SUBSTRING_INDEX($_text, $_delimiter, 1));

  RETURN $_text;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--



--
-- Definition for trigger TR_alertType_ADD
--
DROP TRIGGER IF EXISTS `xrms2`.`TR_alertType_ADD`;
DELIMITER $$
CREATE 
	DEFINER = 'xrms'@'localhost'
TRIGGER `xrms2`.`TR_alertType_ADD`
	AFTER INSERT
	ON alert_type
	FOR EACH ROW
BEGIN

    INSERT INTO `alert_type_edit_log`
            SET `alert_type_id`  = NEW.`alert_type_id`
              , `action`         = 'add'
              , `edit_comments`  = 'Auto Insert'

              , `created_by`     = NEW.`created_by`
          --  , `created_date`   -- this field is updated via INSERT BEFORE trigger
              , `modified_by`    = NEW.`created_by`
          --  , `modified_date`  -- this is a DB auto updated field
    ;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--



-- Definition for trigger TR_plan_EDIT
--
DROP TRIGGER IF EXISTS `xrms2`.`TR_plan_EDIT`;
DELIMITER $$
CREATE 
	DEFINER = 'xrms'@'localhost'
TRIGGER `xrms2`.`TR_plan_EDIT`
	AFTER UPDATE
	ON plan
	FOR EACH ROW
BEGIN

  -- See if the LEVEL changed
  IF (OLD.`status_id` != NEW.`status_id`)
    THEN

    -- Define values
    SET @plan_id   = NEW.`plan_id`;

    -- DRAFT Mode
    IF (NEW.`status_id` = 1)
      THEN

      -- Define values
      SET @action    = 'draft';
      SET @comments  = 'Content has been placed in DRAFT mode';

    -- ACTIVE Mode
    ELSEIF (NEW.`status_id` = 2)
      THEN

      -- Define values
      SET @action    = 'publish';
      SET @comments  = 'Content has been published';

    -- ARCHIVE Mode
    ELSEIF (NEW.`status_id` = 3)
      THEN

      -- Define values
      SET @plan_id   = OLD.`plan_id`;
      SET @action    = 'archive';
      SET @comments  = 'Content has been archived';

    END IF;

    -- the EDIT is handled in the UPDATE script

    -- Update the EDIT log
    INSERT INTO `plan_edit_log`
      SET `plan_id`       = @plan_id
        , `action`        = @action
        , `edit_comments` = @comments
        , `created_by`    = NEW.`modified_by`
    --  , `created_date`  -- this is a DB auto updated field
    ;

  END IF;

END
$$

DELIMITER ;

--
-- -----------------------------------------------------------------
--




--
-- -----------------------------------------------------------------
--




--
-- -----------------------------------------------------------------
--




--
-- -----------------------------------------------------------------
--




--
-- -----------------------------------------------------------------
--






DELIMITER ;

-- eof