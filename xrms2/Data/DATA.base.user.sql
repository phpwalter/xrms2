SET FOREIGN_KEY_CHECKS=0;

USE `xrms2`;

set @ca_id = NULL;
set @cs_id = NULL;

set @ua_id = NULL;
set @us_id = NULL;

set @cp_id = NULL;
set @dv_id = NULL;

SET @ca_email = 'admin@2.com';
SET @a_fn = 'Admin';
SET @a_ln = 'Admin';

SET @cs_email = 'sa@s.com';


SET @salt = NULL;  -- UUID pulled from USER record
SET @pepper = 'pepper';
SET @ps = 'admin';
SET @pw = NULL;

-- FOR testing, `pepper` is 'peppers'


--
-- -------------------------------------------------------
--

-- `id` is auto generated

TRUNCATE `contact`;
INSERT INTO
    `contact` (`first_name`, `last_name`, `email`, `company_id`, `is_active`)
VALUES
    ('System', 'Admin', @cs_email, 1, 1),
    (@a_fn, @a_ln, @ca_email, 1, 1)
;

-- pull CONTACT ID
SELECT BIN_TO_UUID(`id`,1) INTO @ca_id FROM `contact` WHERE `first_name` = 'Admin';
SELECT BIN_TO_UUID(`id`,1) INTO @cs_id FROM `contact` WHERE `first_name` = 'System';


--
-- -------------------------------------------------------
--

-- `id` is auto generated

-- `password` is just a place holder
TRUNCATE `user`;
INSERT INTO
    `user` (`email`, `password`, `contact_id`, `user_type_id`, `is_admin`, `is_active`)
VALUES
    (@s_email, uuid(), UUID_TO_BIN(@cs_id,1), 1, 1, 1),
    (@c_email, uuid(), UUID_TO_BIN(@ca_id,1), 1, 1, 1)
;

-- pull USER ID
SELECT BIN_TO_UUID(`id`,1) INTO @us_id FROM `user` WHERE `contact_id` = UUID_TO_BIN(@cs_id,1);
SELECT BIN_TO_UUID(`id`,1) INTO @ua_id FROM `user` WHERE `contact_id` = UUID_TO_BIN(@ca_id,1);

SET @pw = FN_hash_password(@ua_id, @ps, @pepper);



--
-- -------------------------------------------------------
--

-- `id` is auto generated

TRUNCATE `company`;
INSERT INTO
    `company` (`name`, `short_name`, `is_active`)
VALUES
    ('Test Systems', 'TS', 1)
;

-- pull COMPANY ID
SELECT BIN_TO_UUID(`id`,1) INTO @cp_id FROM `company`;



--
-- -------------------------------------------------------
--

-- `id` is auto generated

TRUNCATE `division`;
 INSERT INTO
    `division` (`name`, `short_name`, `company_id`, `is_active`)
 VALUES
    ('DevOps', 'DO', UUID_TO_BIN(@cp_id,1), 1)
 ;


SELECT BIN_TO_UUID(`id`,1) INTO @dv_id FROM `division`;



--
-- -------------------------------------------------------
--

-- Final step, update all records with values from various tables

UPDATE `user`  -- SYSTEM account
   SET `last_access_on` = NULL,
       `created_by`= UUID_TO_BIN(@us_id,1),
       `created_on`= NOW(),
       `modified_by`= UUID_TO_BIN(@us_id,1),
       `modified_on`= NOW();


UPDATE `contact` -- SYSTEM account
   SET `company_anniversary`= NOW(),
       `user_id`= UUID_TO_BIN(@us_id,1),
       `company_id`= UUID_TO_BIN(@cp_id,1),
       `division_id`= UUID_TO_BIN(@d_id,1),
       `owned_by`= UUID_TO_BIN(@us_id,1),
       `created_by`= UUID_TO_BIN(@us_id,1),
       `created_on`= NOW(),
       `modified_by`= UUID_TO_BIN(@us_id,1),
       `modified_on`= NOW()
 WHERE BIN_TO_UUID(`id`,1) = @cs_id;

UPDATE `contact` -- ADMIN account
   SET `company_anniversary`= NOW(),
       `user_id`= UUID_TO_BIN(@ua_id,1),
       `company_id`= UUID_TO_BIN(@cp_id,1),
       `division_id`= UUID_TO_BIN(@dv_id,1),
       `owned_by`= UUID_TO_BIN(@ua_id,1),
       `created_by`= UUID_TO_BIN(@us_id,1),
       `created_on`= NOW(),
       `modified_by`= UUID_TO_BIN(@us_id,1),
       `modified_on`= NOW()
 WHERE BIN_TO_UUID(`id`,1) = @ca_id;


UPDATE `company`
   SET `owned_by`= UUID_TO_BIN(@us_id,1),
       `created_by`= UUID_TO_BIN(@us_id,1),
       `created_on`= NOW(),
       `modified_by`= UUID_TO_BIN(@us_id,1),
       `modified_on`= NOW();


UPDATE `division`
   SET `owned_by`= UUID_TO_BIN(@us_id,1),
       `created_by`= UUID_TO_BIN(@us_id,1),
       `created_on`= NOW(),
       `modified_by`= UUID_TO_BIN(@us_id,1),
       `modified_on`= NOW();


SELECT * FROM `user` ;
SELECT * FROM `contact` ;

SELECT * FROM `company` ;
SELECT * FROM `division`;

SELECT @ca_id, @ua_id, @us_id;



--
-- -------------------------------------------------------
--

-- Other tables base data

--
-- `user_type`
--
TRUNCATE `user_type`;
INSERT INTO
    `user_type` (`label`, `created_by`, `is_active`)
VALUES
    ( 'owner',  UUID_TO_BIN(@us_id,1), 1),
    ( 'admin',  UUID_TO_BIN(@us_id,1), 1),
    ( 'member', UUID_TO_BIN(@us_id,1), 1),
    ( 'guest',  UUID_TO_BIN(@us_id,1), 1)
;



--
-- `publish_status`
--
TRUNCATE `publish_status`;
INSERT INTO
    `publish_status` (`id`, `label`, `created_by`, `is_active`)
VALUES
    ( 1, 'Draft',   UUID_TO_BIN(@us_id,1), 1),
    ( 2, 'Publich', UUID_TO_BIN(@us_id,1), 1),
    ( 3, 'Revised', UUID_TO_BIN(@us_id,1), 1),
    ( 4, 'Removed', UUID_TO_BIN(@us_id,1), 1)
    ;

--
-- `difficulty_level`
--
TRUNCATE `difficulty_level`;
INSERT INTO
    `difficulty_level` (`id`, `label`, `created_by`, `is_active`)
VALUES
    ( 1, 'Beginner',     UUID_TO_BIN(@us_id,1), 1),
    ( 2, 'Intermediate', UUID_TO_BIN(@us_id,1), 1),
    ( 3, 'Advanced',     UUID_TO_BIN(@us_id,1), 1)
    ;

--
-- `doc_type`
--
TRUNCATE `doc_type`;
INSERT INTO
    `doc_type` (`id`, `label`, `created_by`, `is_active`)
VALUES
    ( 1, 'Video',   UUID_TO_BIN(@us_id,1), 1),
    ( 2, 'PDF',     UUID_TO_BIN(@us_id,1), 1),
    ( 3, 'MS Word', UUID_TO_BIN(@us_id,1), 1),
    ( 4, 'MS Excel', UUID_TO_BIN(@us_id,1), 1)
    ;


--
-- `language`
--
TRUNCATE `language`;
INSERT INTO
   `language` (`id`, `label`, `created_by`, `is_active`)
VALUES
  (1, 'English', UUID_TO_BIN(@us_id,1), 1),
  (2, 'Spanish', UUID_TO_BIN(@us_id,1), 1)
  ;

--
-- -------------------------------------------------------
--

SET FOREIGN_KEY_CHECKS=1;