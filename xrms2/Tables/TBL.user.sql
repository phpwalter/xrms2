-- -------------------------------------------------------------
-- USER tables

-- Create table `user`
--
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id`               BINARY(16)         DEFAULT (uuid_to_bin(uuid(),1)) NOT NULL PRIMARY KEY   COMMENT 'UUID value for improved security',

    `email`            VARCHAR(254)       NOT NULL              COMMENT 'To be used as USER NAME',
    `salt`             VARCHAR(254)       DEFAULT (uuid()) NOT NULL     COMMENT 'add PEPPER in app code',
    `password`         VARCHAR(254)       NOT NULL              COMMENT 'SALT & PEPPER + encoding',

    `contact_id`       BINARY(16)         DEFAULT NULL          COMMENT 'Foreign Key to CONTACT Table',
    `dept_id`          BINARY(16)         DEFAULT NULL          COMMENT 'Foreign Key to DEPARTMENT Table',
    `user_type_id`     INT UNSIGNED       NOT NULL              COMMENT 'Foreign Key to USER_TYPE Table',
    `pass_reset`       ENUM ('1', '0')    NOT NULL DEFAULT '0'  COMMENT 'T|F flag',
    `pass_limit`       TIMESTAMP          DEFAULT NULL          COMMENT 'time in future must request new reset',
    `is_admin`         ENUM ('1', '0')    NOT NULL DEFAULT '0'  COMMENT 'T|F flag',

    `last_access_on`   TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `CN_user_email` UNIQUE (`email`),
    CONSTRAINT `CN_user_salt` UNIQUE (`salt`),
    CONSTRAINT `CN_user_password` UNIQUE (`password`),

    CONSTRAINT `FK_user_contact_id` FOREIGN KEY (`contact_id`)
        REFERENCES `contact` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_user_dept_id` FOREIGN KEY (`dept_id`)
        REFERENCES `department` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT `FK_user_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_user_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    INDEX IDX_user_last_access_on (`last_access_on`),
    INDEX IDX_user_created_on (`created_on`),
    INDEX IDX_user_modified_on (`modified_on`),
    INDEX IDX_user_is_active (`is_active`),
    INDEX IDX_user_is_admin (`is_admin`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


-- FOR testing, `pepper` is 'peppers'
INSERT INTO
    `user` (`id`, `email`, `password`, `contact_id`, `user_type_id`, `is_admin`)
VALUES
    ( uuid_to_bin('11ed4453-884a-9c37-ba04-2cf05dce0be8'),'admin@2.c', '884a9c44-4453-11ed-ba04-2cf05dce0be89ba46f4dff81c22e81f5a1c8315c5b3139c115ce', 1, 1, 1)
;



--
-- Create table `user_type`
--
DROP TABLE IF EXISTS `user_type`;
CREATE TABLE `user_type` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `label`            VARCHAR(64)        NOT NULL,
    `label_plural`     VARCHAR(64)        NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_user_type_created_by` FOREIGN KEY (`created_by`)
      REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_user_type_modified_by` FOREIGN KEY (`modified_by`)
      REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_user_type_label` (`label`),
    UNIQUE INDEX `UNQ_user_type_label_plural` (`label_plural`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;

INSERT INTO
    `user_type` (`label`, `label_plural`, `is_active`)
VALUES
    ( 'owner', 'owners', 1),
    ( 'admin', 'admins', 1),
    ( 'member', 'members', 1),
    ( 'guest', 'guests', 1)
;

--
-- Create table `user_preference_type`
--
DROP TABLE IF EXISTS `user_preference_type`;
CREATE TABLE user_preference_type (
    `id`                    INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `name`                  VARCHAR(64)        NOT NULL,
    `short_name`            VARCHAR(64)        NOT NULL,
    `description`           VARCHAR(128)       NOT NULL,
    `allow_multiple_flag`   ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',
    `allow_user_edit_flag`  ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',
    `form_element_type`     VARCHAR(32)        NOT NULL DEFAULT 'TEXT',
    `skip_system_edit_flag` ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',
    `read_only`             ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'T|F flag',

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_user_preference_type_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_preference_type_user_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_preference_type_name` (`name`),
    UNIQUE INDEX `UNQ_preference_type_short_name` (`short_name`),
    INDEX `IDX_preference_type_is_active` (`is_active`)

)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;


--
-- Create table `user_login`
--
CREATE TABLE IF NOT EXISTS user_login (
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



-- eof
