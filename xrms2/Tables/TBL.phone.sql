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
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
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