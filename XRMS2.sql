-- 
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8mb4';
SET  CHARACTER SET 'utf8';

SET FOREIGN_KEY_CHECKS=0;

--
-- Set default database
--
-- DROP DATABASE IF EXISTS `xrms2`;
-- CREATE DATABASE `xrms2`
--     DEFAULT CHARACTER SET UTF8MB4,
--             COLLATE utf8mb4_bin;

USE `xrms2`;

-- -------------------------------------------------------------
-- USER tables

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
    `id`               BINARY(16)         DEFAULT (uuid_to_bin(uuid(),1)) NOT NULL PRIMARY KEY   COMMENT 'UUID value for improved security',

    `email`            VARCHAR(254)       NOT NULL              COMMENT 'To be used as USER NAME',
    `salt`             VARCHAR(254)       DEFAULT (uuid()) NOT NULL     COMMENT 'add PEPPER in app code',
    `password`         VARCHAR(254)       NOT NULL              COMMENT 'SALT & PEPPER + encoding',

    `contact_id`       BINARY(16)         DEFAULT NULL          COMMENT 'Foreign Key to CONTACT Table',
    `user_type_id`     INT UNSIGNED       NOT NULL              COMMENT 'Foreign Key to USER_TYPE Table',
    `pass_reset`       ENUM ('1', '0')    NOT NULL DEFAULT '0'  COMMENT 'T|F flag',
    `pass_limit`       TIMESTAMP          DEFAULT NULL          COMMENT 'time in future must request new reset',
    `is_admin`         ENUM ('1', '0')    NOT NULL DEFAULT '0'  COMMENT 'T|F flag',

    `last_access_on`   timestamp          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `CN_user_email`    UNIQUE (`email`),
    CONSTRAINT `CN_user_salt`     UNIQUE (`salt`),
    CONSTRAINT `CN_user_password` UNIQUE (`password`),

    CONSTRAINT `FK_user_contact_id`
      FOREIGN KEY (`contact_id`)
        REFERENCES `contact` (`id`)
          ON DELETE CASCADE
          ON UPDATE CASCADE,

     CONSTRAINT `FK_user_type_id`
       FOREIGN KEY (`user_type_id`)
       REFERENCES `user_type` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_user_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_user_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    INDEX IDX_user_last_access_on (`last_access_on`),
    INDEX IDX_user_created_on (`created_on`),
    INDEX IDX_user_modified_on (`modified_on`),
    INDEX IDX_user_is_active (`is_active`),
    INDEX IDX_user_is_admin (`is_admin`)
)
    ENGINE = INNODB;


-- -----------------------------------------------------
-- Table `user_to_segment_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_log`  (
    `user_to_segment_log_id`      INT UNSIGNED  NOT NULL AUTO_INCREMENT    PRIMARY KEY,
	  `user_id`                     binary(16)    NOT NULL,
  	`action`                      varchar(6)    NOT NULL, 
  	`created_on`                  timestamp     NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  	`created_by`                  binary(16)    NOT NULL,
  	`edit_comments`               VARCHAR(128)      NULL        DEFAULT NULL          COMMENT 'currently comments are not required',

     CONSTRAINT `FK_user_log_contact_id`
       FOREIGN KEY (`user_id`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_user_log_created_by`
       FOREIGN KEY (`created_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;

--
-- Create table `user_type`
--
DROP TABLE IF EXISTS `user_type`;
CREATE TABLE `user_type` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`             VARCHAR(64)        NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_user_type_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_user_type_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_user_type_label` (`label`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


--
-- Create table `user_preference_type`
--
DROP TABLE IF EXISTS `user_preference_type`;
CREATE TABLE `user_preference_type` (
    `id`                    INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`                 VARCHAR(64)        NOT NULL,
    `description`           VARCHAR(128)       NOT NULL,
    `allow_multiple_flag`   ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',
    `allow_user_edit_flag`  ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',
    `form_element_type`     VARCHAR(32)        NOT NULL DEFAULT 'TEXT',
    `skip_system_edit_flag` ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',
    `read_only`             ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_user_preference_type_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_user_preference_type_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_preference_type_name` (`label`),
    INDEX `IDX_preference_type_is_active` (`is_active`)

)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


--
-- Create table `user_login`
--
CREATE TABLE IF NOT EXISTS `user_login` (
    `user_id`          BINARY(16)         NOT NULL                             COMMENT 'Foreign Key to USER Table',
    `session`          VARCHAR(128)       NOT NULL,
    `ip`               VARCHAR(128)       NOT NULL,
    `nTime`            TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `success`          ENUM ('1', '0')    NOT NULL                             COMMENT 'T|F flag',

    INDEX `user_login_user_id` (`user_id`),
    INDEX `user_login_user_success` (`user_id`, `success`),
    INDEX `user_login_nTime` (`nTime`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;



-- -------------------------------------------------------------
-- CONTACT tables

--
-- Create table `contact`
--
DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
     `id`                     BINARY(16)         DEFAULT (uuid_to_bin(uuid(),1)) NOT NULL PRIMARY KEY   COMMENT 'UUID value for improved security',

     `first_name`             VARCHAR(64)        NOT NULL,
     `middle_name`            VARCHAR(64)        DEFAULT NULL,
     `last_name`              VARCHAR(64)        NOT NULL,
     `preferred_name`         VARCHAR(64)        DEFAULT NULL,
     `email`                  VARCHAR(254)       NOT NULL,
     `honorific_id`           INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on HONORIFIC table',
     `name_suffix_id`         INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on CONTACT SUFFIX table',
     `gender_id`              INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on CONTACT GENDER table',
     `birthday`               TIMESTAMP          DEFAULT NULL,
     `anniversary`            TIMESTAMP          DEFAULT NULL,
     `primary_language_id`    INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on LANGUAGE table',
     `secondary_language_id`  INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on LANGUAGE table',

     `user_id`                BINARY(16)         DEFAULT NULL     COMMENT 'Foreign Key to USER Table, if a user',
     `company_id`             BINARY(16)         NOT NULL         COMMENT 'FK on COMPANY table',
     `division_id`            BINARY(16)         DEFAULT NULL     COMMENT 'FK on DIVISION table',
     `company_anniversary`    TIMESTAMP          DEFAULT NULL     COMMENT 'When CONTACT started at company',
     `manager_id`             BINARY(16)         DEFAULT NULL     COMMENT 'Foreign Key to CONTACT Table',

     `summary`                VARCHAR(254)       DEFAULT NULL,
     `description`            VARCHAR(254)       DEFAULT NULL,
     `interests`              VARCHAR(254)       DEFAULT NULL,
     `profile`                TEXT               DEFAULT NULL,

     `owned_by`               BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'Who manages this record, defaults to CREATED BY via TRIGGER',
     `created_by`             BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
     `created_on`             TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
     `modified_by`            BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
     `modified_on`            TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
     `is_active`              ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_contact_company`
       FOREIGN KEY (`company_id`)
         REFERENCES `company` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

     CONSTRAINT `FK_primary_language_id`
       FOREIGN KEY (`primary_language_id`)
       REFERENCES `language` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_secondary_language_id`
       FOREIGN KEY (`secondary_language_id`)
       REFERENCES `language` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_contact_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_contact_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

     INDEX `IDX_contact_name` (`first_name`, `last_name`),
     INDEX `IDX_contact_email` (`email`),
     INDEX `IDX_contact_company_id` (`company_id`),
     INDEX `IDX_contact_division_id` (`division_id`),
     INDEX `IDX_contact_owned_by` (`owned_by`),
     INDEX `IDX_contact_is_active` (`is_active`)

)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;



--
-- Create table `honorific`
--
DROP TABLE IF EXISTS `honorific`;
CREATE TABLE `honorific` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_honorific_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_honorific_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_honorific_label` (`label`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;

INSERT INTO
    `honorific` (`label`, `is_active`)
VALUES
    ( 'Mr', 1),
    ( 'Mrs', 1),
    ( 'Ms', 1),
    ( 'Mx', 1),
    ( 'Dr', 1),
    ( 'Professor', 1),
    ( 'Sir', 1),
    ( 'Dame', 1),
    ( 'The Honourable', 1)
;


--
-- Create table `suffix`
--
DROP TABLE IF EXISTS `suffix`;
CREATE TABLE `suffix` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `name`             VARCHAR(64)        NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_suffix_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_suffix_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_suffix_name` (`name`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


--
-- Create table `gender`
--
DROP TABLE IF EXISTS `gender`;
CREATE TABLE `gender` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `name`             VARCHAR(64)        NOT NULL,
    `pronoun`          VARCHAR(128)       NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_gender_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_gender_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_gender_name` (`name`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;

INSERT INTO
    `gender` (`name`, `pronoun`, `is_active`)
VALUES
    ( 'Female', 'She/Her/Hers/Herself', 1),
    ( 'Male', 'He/His/His/Himself', 1),
    ( 'Non-Binary', 'Them/They/Theirs/themself', 1)
;


--
-- Create table `contact_social_media`
--
DROP TABLE IF EXISTS `contact_social_media`;
CREATE TABLE `contact_social_media` (
    `contact_id`           INT UNSIGNED       NOT NULL      COMMENT 'FK on CONTACT table',
    `social_media_id`      INT UNSIGNED       NOT NULL      COMMENT 'FK on SOCIAL MEDIA table',
    `social_media_handle`  VARCHAR(64)        NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_contact_social_media_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_contact_social_media_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_contact_social_media_contact` (`contact_id`, `social_media_id`),
    UNIQUE INDEX `UNQ_contact_social_media_handle` (`social_media_id`, `social_media_handle`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


--
-- Create table `contact_phone`
--
DROP TABLE IF EXISTS `contact_phone`;
CREATE TABLE `contact_phone` (
    `contact_id`    BINARY(16)         NOT NULL      COMMENT 'FK on CONTACT table',
    `phone_type`    INT UNSIGNED       NOT NULL      COMMENT 'FK on PHONE TYPE table',
    `number`        INT                NOT NULL      COMMENT 'Number Format via app',

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_contact_phone_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_contact_phone_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    INDEX `UNQ_contact_phone` (`contact_id`, `phone_type`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


-- -------------------------------------------------------------
-- SOCIAL MEDIA tables

-- Create table `social_media`
--
DROP TABLE IF EXISTS `social_media`;
CREATE TABLE `social_media` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `url_prefix`       VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_social_media_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_social_media_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_social_media_label` (`label`),
    INDEX IDX_social_media_type_sort_order (`sort_order`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


-- -------------------------------------------------------------
-- PHONE tables

-- Create table `phone_type`
--
DROP TABLE IF EXISTS `phone_type`;
CREATE TABLE `phone_type` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `label_plural`     VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_phone_type_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_phone_type_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_phone_type_label` (`label`),
    UNIQUE INDEX `UNQ_phone_type_label_plural` (`label_plural`),
    INDEX IDX_phone_type_type_sort_order (`sort_order`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


INSERT INTO
    `phone_type` (`label`, `label_plural`, `is_active`)
VALUES
    ( 'Home', 'Home', 1),
    ( 'Office', 'Office', 1),
    ( 'FAX', 'FAXes', 1),
    ( 'Cell', 'Cell', 1)
;


-- -------------------------------------------------------------
-- COMPANY tables

-- Create table `company`
--
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
    `id`               BINARY(16)         DEFAULT (uuid_to_bin(uuid(),1)) NOT NULL PRIMARY KEY   COMMENT 'UUID value for improved security',
    `name`             VARCHAR(64)        NOT NULL,
    `short_name`       VARCHAR(64)        NOT NULL,

    `owned_by`         BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'Who manages this record, defaults to CREATED BY via TRIGGER',
    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_company_owned_by` FOREIGN KEY (`owned_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_company_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_company_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_company_name` (`name`),
    UNIQUE INDEX `UNQ_company_short_name` (`short_name`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


-- -------------------------------------------------------------
-- DEPARTMENT tables

-- Create table `division`
--
DROP TABLE IF EXISTS `division`;
CREATE TABLE `division` (
    `id`               BINARY(16)         DEFAULT (uuid_to_bin(uuid(),1)) NOT NULL PRIMARY KEY   COMMENT 'UUID value for improved security',
    `name`             VARCHAR(64)        NOT NULL,
    `short_name`       VARCHAR(64)        NOT NULL,
    `company_id`       BINARY(16)         NOT NULL         COMMENT 'FK on COMPANY table',

    `owned_by`         BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'Who manages this record, defaults to CREATED BY via TRIGGER',
    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_department_company` FOREIGN KEY (`company_id`)
        REFERENCES `company` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT `FK_division_owned_by` FOREIGN KEY (`owned_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_division_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_division_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_division_name` (`name`),
    UNIQUE INDEX `UNQ_division_short_name` (`short_name`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;



-- -------------------------------------------------------------
-- MISC tables

-- -----------------------------------------------------
-- Table `language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `language`;
CREATE TABLE `language` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_language_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_languages_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_languagen_label` (`label`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;



-- -----------------------------------------------------
-- Table `content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `content`;
CREATE TABLE `content` (
    `id`                    INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`                 VARCHAR(64)        NOT NULL,
    `content_type_id`       INT UNSIGNED       NOT NULL,
    `language_id`           INT UNSIGNED       NOT NULL,
    `difficulty_level_id`   INT UNSIGNED       NOT NULL,
    `description`           VARCHAR(128)           DEFAULT NULL,
    `path`                  VARCHAR(128)       NOT NULL,
    `comments`              VARCHAR(128)           DEFAULT NULL,
    `expiration_date`       TIMESTAMP          NOT NULL,


    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',


     CONSTRAINT `FK_content_content_type_id`
       FOREIGN KEY (`content_type_id`)
       REFERENCES `content_type` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,
         
     CONSTRAINT `FK_content_difficulty_level_id`
       FOREIGN KEY (`difficulty_level_id`)
       REFERENCES `difficulty_level` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,
         
     CONSTRAINT `FK_content_language_id`
       FOREIGN KEY (`language_id`)
       REFERENCES `language` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_content_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_content_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_content_label` (`label`)
)
    ENGINE = INNODB;


-- -----------------------------------------------------
-- Table `doc_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `doc_type`;
CREATE TABLE `doc_type` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_doc_type_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_doc_type_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_doc_type_label` (`label`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


-- -----------------------------------------------------
-- Table `publish_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `publish_status`;
CREATE TABLE `publish_status` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_publish_status_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_publish_status_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_publish_status_label` (`label`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


--
-- Table structure for table `difficulty_level`
--
DROP TABLE IF EXISTS `difficulty_level`;
CREATE TABLE `difficulty_level` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_difficulty_level_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_difficulty_level_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_difficulty_level_label` (`label`)
)
    ENGINE = INNODB;



--
-- Table structure for table `alert`
--
DROP TABLE IF EXISTS `alert`;
CREATE TABLE `alert` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `alert_type_id`    INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on ALERT TYPE table',
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_alert_created_by`
       FOREIGN KEY (`alert_type`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_alert_created_by`
       FOREIGN KEY (`alert_type_id`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_alert_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_alert_label` (`label`)
)
    ENGINE = INNODB;


--
-- Table structure for table `alert_type`
--
DROP TABLE IF EXISTS `alert_type`;
CREATE TABLE `alert_type` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_alert_type_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_alert_type_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_alert_type_label` (`label`)
)
    ENGINE = INNODB;


--
-- Definition for table `errors`
--
DROP TABLE IF EXISTS `errors`;
CREATE TABLE `errors` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `description`      VARCHAR(128),

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         DEFAULT NULL                         COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          DEFAULT NULL    ON UPDATE CURRENT_TIMESTAMP   COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_errors_created_by`
       FOREIGN KEY (`created_by`)
       REFERENCES `user` (`id`)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

     CONSTRAINT `FK_errors_modified_by`
       FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`)
           ON DELETE CASCADE
           ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_errors_description` (`description`)
)
    ENGINE = INNODB;



-- -------------------------------------------------------------
-- -------------------------------------------------------------
SET FOREIGN_KEY_CHECKS=1;

-- eof
