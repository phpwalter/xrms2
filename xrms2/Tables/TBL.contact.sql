-- -------------------------------------------------------------
-- CONTACT tables

--
-- Create table `contact`
--
DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
     `id`               BINARY(16)         PRIMARY KEY           COMMENT 'UUID value for improved security',

     `first_name`       VARCHAR(64)        NOT NULL,
     `middle_name`      VARCHAR(64)        NOT NULL,
     `last_name`        VARCHAR(64)        NOT NULL,
     `preferred_name`   VARCHAR(64)        NOT NULL,
     `email`            VARCHAR(254)       NOT NULL,
     `honorific_id`     INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on HONORIFIC table',
     `name_suffix_id`   INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on CONTACT SUFFIX table',
     `gender_id`        INT UNSIGNED       DEFAULT NULL     COMMENT 'FK on CONTACT GENDER table',
     `birthday`         DATE               DEFAULT NULL,
     `anniversary`      DATE               DEFAULT NULL,

     `user_id`          BINARY(16)         NOT NULL         COMMENT 'Foreign Key to USER Table',
     `company_id`       BINARY(16)         NOT NULL         COMMENT 'FK on COMPANY table',
     `division_id`      BINARY(16)         NOT NULL         COMMENT 'FK on DIVISION table',
     `company_anniversary` DATE            DEFAULT NULL     COMMENT 'When CONTACT started at company',

     `summary`          VARCHAR(254)       DEFAULT NULL,
     `description`      VARCHAR(254)       DEFAULT NULL,
     `interests`        VARCHAR(254)       DEFAULT NULL,
     `profile`          TEXT               DEFAULT NULL,

     `owned_by`         BINARY(16)         NOT NULL                             COMMENT 'Who manages this record, defaults to CREATED BY via TRIGGER',
     `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
     `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
     `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
     `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
     `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

     CONSTRAINT `FK_contact_company` FOREIGN KEY (`company_id`)
         REFERENCES `company` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

     CONSTRAINT `FK_contact_created_by` FOREIGN KEY (`created_by`)
         REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
     CONSTRAINT `FK_contact_modified_by` FOREIGN KEY (`modified_by`)
         REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

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
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
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
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
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
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
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
CREATE TABLE contact_social_media (
    `contact_id`           INT UNSIGNED       NOT NULL      COMMENT 'FK on CONTACT table',
    `social_media_id`      INT UNSIGNED       NOT NULL      COMMENT 'FK on SOCIAL MEDIA table',
    `social_media_handle`  VARCHAR(64)        NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
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
CREATE TABLE contact_phone (
    `contact_id`    BINARY(16)         NOT NULL      COMMENT 'FK on CONTACT table',
    `phone_type`    INT UNSIGNED       NOT NULL      COMMENT 'FK on PHONE TYPE table',
    `number`        INT SIGNED         NOT NULL      COMMENT 'Number Format via app',

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
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


-- eof
