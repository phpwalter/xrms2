
--
-- FUNC to INSERT create a password HASH
--
DROP FUNCTION IF EXISTS `FN_match_password`;
DELIMITER $$
CREATE DEFINER = `xrms`@`localhost`
       FUNCTION `xrms2`.`FN_match_password`( `uid`     VARCHAR(128)
                                           , `open_pw` VARCHAR(128)
                                           , `pepper`  VARCHAR(128)
                                           )
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
  BEGIN
    DECLARE `salty`    VARCHAR(128) DEFAULT FALSE;
    DECLARE `cur_pw`   VARCHAR(128) DEFAULT FALSE;
    DECLARE `new_pw`   VARCHAR(128) DEFAULT FALSE;
    DECLARE `pw_match` BOOLEAN DEFAULT FALSE;

    -- Do we have a valid UUID?
    IF IS_UUID(uid) IS TRUE THEN
      -- Pull SALT & current PASSWORD for this user
      SELECT `salt`, `password`
        INTO salty, cur_pw
        FROM `user`
       WHERE `id` = UUID_TO_BIN(uid,1);

      -- Do we have a valid UUID?
      IF IS_UUID(uid) IS TRUE THEN
        -- Make HASH from given (clear) password
        SET new_pw = SHA(CONCAT(salty, open_pw, pepper));

        -- compare old to newly hashed password
        SELECT
          CASE
            WHEN cur_pw = new_pw
              THEN TRUE
            END
        INTO pw_match
        ;

      END IF;
    END IF;

    RETURN (pw_match);
END
$$

DELIMITER ;

-- eof
