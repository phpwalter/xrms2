-- -------------------------------------------------------------
-- SOCIAL MEDIA tables

-- Create table `social_media`
--
DROP TABLE IF EXISTS `social_media`;
CREATE TABLE `social_media` (
    `id`               INT UNSIGNED       NOT NULL AUTO_INCREMENT    PRIMARY KEY,
    `name`             VARCHAR(64)        NOT NULL,
    `url_prefix`       VARCHAR(64)        NOT NULL,
    `sort_order`       INT UNSIGNED       DEFAULT 1,

    `created_by`       BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that CREATED record, also original OWNER',
    `created_on`       TIMESTAMP          NOT NULL DEFAULT current_timestamp   COMMENT 'DB auto-maintains this field',
    `modified_by`      BINARY(16)         NOT NULL DEFAULT 1                   COMMENT 'USER that last updated record',
    `modified_on`      TIMESTAMP          NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    `is_active`        ENUM ('1', '0')    NOT NULL DEFAULT '0'                 COMMENT 'used as a logical DELETE flag',

    CONSTRAINT `FK_social_media_created_by` FOREIGN KEY (`created_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_social_media_modified_by` FOREIGN KEY (`modified_by`)
        REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE INDEX `UNQ_social_media_label` (`name`),
    INDEX IDX_social_media_type_sort_order (`sort_order`)
)
    ENGINE = INNODB,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_bin;

-- eof
