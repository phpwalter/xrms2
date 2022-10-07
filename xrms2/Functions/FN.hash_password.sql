-- ------------------------------------------------------------------
-- * FUNCTION
-- *
-- *  create a password HASH
-- *
-- *  @author Walter Torres <walter@torres.ws>
-- *
-- *  @param `uid`      VARCHAR(128)   UUID of user ID
-- *  @param `open_pw`  VARCHAR(128)   string to convert into HASHED password
-- *  @param `pepper`   VARCHAR(128)   string to complexity to HASH
-- *
-- *  @return `new_pw`  VARCHAR(128)   converted HASHED password
--
-- ------------------------------------------------------------------


DROP FUNCTION IF EXISTS `FN_hash_password`;
DELIMITER $$
CREATE DEFINER=`xrms`@`localhost`
       FUNCTION `xrms2`.`FN_hash_password`( `uid`     VARCHAR(128)
                                          , `open_pw` VARCHAR(128)
                                          , `pepper`  VARCHAR(128)
                                          )
RETURNS VARCHAR(128) charset utf8mb4
READS SQL DATA
DETERMINISTIC

BEGIN

  DECLARE `salty`  VARCHAR(128) DEFAULT FALSE;
  DECLARE `new_pw` VARCHAR(128) DEFAULT FALSE;

    -- Do we have a valid UUID?
    IF IS_UUID(uid) IS TRUE THEN
      -- Pull SALT for this user
      SELECT `salt` INTO salty FROM `user` WHERE `id` = UUID_TO_BIN(uid,1);

      -- Do we have a valid UUID?
      IF IS_UUID(salty) IS TRUE THEN
        -- Make HASH from given (clear) password
        SET new_pw = SHA(CONCAT(salty, open_pw, pepper));

      END IF;
    END IF;

    RETURN (new_pw);
END
$$


DELIMITER ;

-- eof
