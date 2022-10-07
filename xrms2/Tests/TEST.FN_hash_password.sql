USE `xrms2`;


-- pull USER ID
SELECT BIN_TO_UUID(`id`,1) INTO @us_id FROM `user` WHERE `contact_id` = UUID_TO_BIN(@cs_id,1);
SELECT BIN_TO_UUID(`id`,1) INTO @ua_id FROM `user` WHERE `contact_id` = UUID_TO_BIN(@ca_id,1);

SET @pw = FN_hash_password(@ua_id, @ps, @pepper);

SELECT @us_id, @ua_id;

set @new_pw = NULL;
set @cur_pw = NULL;
set @hash_pw = NULL;
set @pw_match = NULL;
set @pepper = NULL;
set @uid = NULL;

set @new_pw = 'admin';
set @pepper = 'peppers';

SELECT @uid,  @cur_pw, @new_pw, @pepper, @hash_pw, @pw_match;

-- validate PWD
-- get USER UUID
SELECT * FROM `user` LIMIT 1;
SELECT BIN_TO_UUID(`id`, 1)  FROM `user` INTO @uid;

    SELECT `salt`, `password`
      INTO @salt, @cur_paw
      FROM `user`
     WHERE `id` = UUID_TO_BIN(@uid,1);

SELECT @salt,  @cur_pw;

-- pull existing PW from record
    SELECT `password`
      FROM `user`
     WHERE `id` = UUID_TO_BIN(@uid,1)
      INTO @cur_pw;

SELECT @uid,  @cur_pw;

-- make new password for given user
SELECT FN_hash_password( @uid, @new_pw, @pepper) INTO @hash_pw;

SELECT @uid, @new_pw, @pepper, @hash_pw;

-- compare old to newly hashed password
SELECT FN_match_password( @uid, @new_pw, @pepper) INTO @pw_match;

SELECT @new_pw;
SELECT @hash_pw;
SELECT @pw_match;
