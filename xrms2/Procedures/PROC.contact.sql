/*
{
  "email": "walter@ts.com",
  "password": "walter",
  "contact_id": "1ea3701e-45b8-11ed-ba04-2cf05dce0be8",
  "user_type_id": "3",  // member
  "is_admin": "false",
  "created_by": "5f1cece9-45bd-11ed-ba04-2cf05dce0be8"
}

*/




DELIMITER $$
--
-- PROCEDURE to create a new CONTACT record
--
DROP procedure IF EXISTS `PROC_contact`$$


CREATE DEFINER=`xrms`@`localhost`
   procedure `PROC_contact`( IN DATA    JSON
                           , IN userID  int UNSIGNED
                           )
  DETERMINISTIC
  MODIFIES SQL DATA

  BEGIN

    -- This is an UPDATE if defined
    DECLARE `contact_id`             VARCHAR(255)   DEFAULT NULL;

    DECLARE `first_name`             VARCHAR(64)    DEFAULT NULL;
    DECLARE `middle_name`            VARCHAR(64)    DEFAULT NULL;
    DECLARE `last_name`              VARCHAR(64)    DEFAULT NULL;
    DECLARE `preferred_name`         VARCHAR(64)    DEFAULT NULL;
    DECLARE `email`                  VARCHAR(254)   DEFAULT NULL;
    DECLARE `honorific_id`           INT UNSIGNED   DEFAULT NULL;
    DECLARE `name_suffix_id`         INT UNSIGNED   DEFAULT NULL;
    DECLARE `gender_id`              INT UNSIGNED   DEFAULT NULL;
    DECLARE `birthday`               TIMESTAMP      DEFAULT NULL;
    DECLARE `anniversary`            TIMESTAMP      DEFAULT NULL;
    DECLARE `primary_language_id`    INT UNSIGNED   DEFAULT NULL;
    DECLARE `secondary_language_id`  INT UNSIGNED   DEFAULT NULL;

    DECLARE `user_id`                BINARY(16)     DEFAULT NULL;
    DECLARE `company_id`             BINARY(16)     DEFAULT NULL;
    DECLARE `division_id`            BINARY(16)     DEFAULT NULL;
    DECLARE `company_anniversary`    timestamp      DEFAULT NULL;
    DECLARE `manager_id`             BINARY(16)     DEFAULT NULL;

    DECLARE `summary`                VARCHAR(254)   DEFAULT NULL;
    DECLARE `description`            VARCHAR(254)   DEFAULT NULL;
    DECLARE `interests`              VARCHAR(254)   DEFAULT NULL;
    DECLARE `profile`                TEXT           DEFAULT NULL;

    DECLARE `owned_by`               BINARY(16)     DEFAULT 1;
    DECLARE `created_by`             BINARY(16)     DEFAULT 1;
    DECLARE `created_on`             timestamp      DEFAULT NULL;
    DECLARE `modified_by`            BINARY(16)     DEFAULT NULL;
    DECLARE `modified_on`            TIMESTAMP      DEFAULT NULL;
    DECLARE `is_active`              INT UNSIGNED   DEFAULT '0';

    set `id`                     = JSON_UNQUOTE(JSON_EXTRACT(query,'$.id'));
    set `first_name`             = JSON_EXTRACT(query,'$.first_name');
    set `middle_name`            = JSON_EXTRACT(query,'$.middle_name');
    set `last_name`              = JSON_UNQUOTE(JSON_EXTRACT(query,'$.last_name'));
    set `preferred_name`         = JSON_EXTRACT(query,'$.preferred_name');
    set `email`                  = JSON_EXTRACT(query,'$.email');
    set `honorific_id`           = JSON_EXTRACT(query,'$.honorific_id');
    set `name_suffix_id`         = JSON_EXTRACT(query,'$.name_suffix_id');
    set `gender_id`              = JSON_EXTRACT(query,'$.gender_id');
    set `birthday`               = JSON_EXTRACT(query,'$.birthday');
    set `anniversary`            = JSON_EXTRACT(query,'$.anniversary');
    set `primary_language_id`    = JSON_EXTRACT(query,'$.primary_language_id');
    set `secondary_language_id`  = JSON_EXTRACT(query,'$.secondary_language_id');
    set `user_id`                = JSON_EXTRACT(query,'$.user_id');
    set `company_id`             = JSON_EXTRACT(query,'$.company_id');
    set `division_id`            = JSON_EXTRACT(query,'$.division_id');
    set `company_anniversary`    = JSON_EXTRACT(query,'$.company_anniversary');
    set `manager_id`             = JSON_EXTRACT(query,'$.manager_id');
    set `summary`                = JSON_UNQUOTE(JSON_EXTRACT(query,'$.summary'));
    set `description`            = JSON_UNQUOTE(JSON_EXTRACT(query,'$.description'));
    set `interests`              = JSON_UNQUOTE(JSON_EXTRACT(query,'$.interests'));
    set `profile`                = JSON_UNQUOTE(JSON_EXTRACT(query,'$.profile'));
    set `owned_by`               = JSON_EXTRACT(query,'$.owned_by');
    set `created_by`             = JSON_EXTRACT(query,'$.created_by');
    set `created_on`             = JSON_EXTRACT(query,'$.created_on');
    set `modified_by`            = JSON_EXTRACT(query,'$.modified_by');
    set `modified_on`            = JSON_EXTRACT(query,'$.modified_on');
    set `is_active`              = JSON_EXTRACT(query,'$.is_active');
    
    -- NON UUID is illegal
    SET `id` = IF (IS_UUID(`id`) IS TRUE, `id`, NULL);

    IF `id` IS NOT NULL

    THEN

     -- NON UUID is illegal
     SET `honorific_id`  = IF (IS_UUID(`honorific_id`) IS TRUE, UUID_TO_BIN(`honorific_id`,1), NULL);
     SET `company_id`    = IF (IS_UUID(`company_id`)   IS TRUE, UUID_TO_BIN(`company_id`,1),   NULL);
     SET `division_id`   = IF (IS_UUID(`division_id`)  IS TRUE, UUID_TO_BIN(`division_id`,1),  NULL);
     SET `user_id`       = IF (IS_UUID(`user_id`)      IS TRUE, UUID_TO_BIN(`user_id`,1),      NULL);

     SET `manager_id`    = IF (IS_UUID(`manager_id`)   IS TRUE, UUID_TO_BIN(`manager_id`,1),   NULL);
     SET `owned_by`      = IF (IS_UUID(`owned_by`)     IS TRUE, UUID_TO_BIN(`owned_by`,1),     NULL);
     SET `created_by`    = IF (IS_UUID(`created_by`)   IS TRUE, UUID_TO_BIN(`created_by`,1),   NULL);
     SET `modified_by`   = IF (IS_UUID(`modified_by`)  IS TRUE, UUID_TO_BIN(`modified_by`,1),  NULL);
     

     -- A ZERO value is illegal
     SET `name_suffix_id`        = IF(`name_suffix_id`        = 0, NULL, `name_suffix_id`);
     SET `gender_id`             = IF(`gender_id`             = 0, NULL, `gender_id`);
     SET `primary_language_id`   = IF(`primary_language_id`   = 0, NULL, `primary_language_id`);
     SET `secondary_language_id` = IF(`secondary_language_id` = 0, NULL, `secondary_language_id`);

  
     INSERT INTO `contact`
             SET `id`                     = contact_id
               , `first_name`             = first_name
               , `middle_name`            = middle_name
               , `last_name`              = last_name
               , `preferred_name`         = preferred_name
               , `email`                  = email
               , `honorific_id`           = honorific_id
               , `name_suffix_id`         = name_suffix_id
               , `gender_id`              = gender_id
               , `birthday`               = birthday
               , `anniversary`            = anniversary
               , `primary_language_id`    = primary_language_id
               , `secondary_language_id`  = secondary_language_id
               , `user_id`                = user_id
               , `company_id`             = company_id
               , `division_id`            = division_id
               , `company_anniversary`    = company_anniversary
               , `manager_id`             = manager_id
               , `summary`                = summary
               , `description`            = description
               , `interests`              = interests
               , `profile`                = profile
               , `owned_by`               = userID

               , `created_by`             = userID
           --  , `created_date`           -- auto set by DB
           --  , `modified_by`            -- not defined at INSERT
           --  , `modified_date`          -- not defined at INSERT
            -- , `is_active`              -- all new records are deactived by default

     -- UPDATE an existing record
     ON DUPLICATE KEY UPDATE
                 `modified_by`   = userID
           --  , `modified_date` -- auto set by DB
     ;
  

    -- Missing things, so throw an error
    ELSE
      CALL `throw`(1101);
  
    END IF;

  END$$


DELIMITER ;

-- eof
