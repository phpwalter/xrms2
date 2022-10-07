-- -------------------------------------------------------------
-- COMPANY tables

-- Create table `company`
--
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
    `id`               BINARY(16)         DEFAULT (uuid_to_bin(uuid(),1)) NOT NULL PRIMARY KEY   COMMENT 'UUID value for improved security',
    `name`             VARCHAR(64)        NOT NULL,
    `short_name`       VARCHAR(64)        NOT NULL,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

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
