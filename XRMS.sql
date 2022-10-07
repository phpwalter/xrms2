-- 
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

--
-- Set default database
--
DROP DATABASE IF EXISTS `xrms2`;
CREATE DATABASE `xrms2`;
USE `xrms2`;

--
-- Create table `data_source`
--
CREATE TABLE data_source (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_data_source_label` on table `data_source`
--
ALTER TABLE data_source
ADD UNIQUE INDEX UNQ_data_source_label (label);

--
-- Create index `UNQ_data_source_plural_label` on table `data_source`
--
ALTER TABLE data_source
ADD UNIQUE INDEX UNQ_data_source_plural_label (plural_label);

--
-- Create index `IDX_data_source_sort_order` on table `data_source`
--
ALTER TABLE data_source
ADD INDEX IDX_data_source_sort_order (sort_order);

--
-- Create index `IDX_data_source_is_active` on table `data_source`
--
ALTER TABLE data_source
ADD INDEX IDX_data_source_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE data_source
ADD CONSTRAINT FK_data_source_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE data_source
ADD CONSTRAINT FK_data_source_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `controlled_object`
--
CREATE TABLE controlled_object (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(128) DEFAULT NULL,
    on_what_table varchar(128) DEFAULT NULL,
    on_what_field varchar(128) DEFAULT NULL,
    user_field varchar(32) DEFAULT NULL,
    data_source_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on DATA SOURCE table',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE controlled_object
ADD CONSTRAINT FK_controlled_object_data_source_id FOREIGN KEY (data_source_id)
REFERENCES data_source (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `controlled_object_relationship`
--
CREATE TABLE controlled_object_relationship (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    child_controlled_object_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on CONTROLLED OBJECT table',
    parent_controlled_object_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on CONTROLLED OBJECT table',
    on_what_child_field varchar(128) DEFAULT NULL,
    on_what_parent_field varchar(128) DEFAULT NULL,
    cross_table varchar(128) DEFAULT NULL,
    singular int(10) UNSIGNED DEFAULT NULL,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_controlled_object_relationship` on table `controlled_object_relationship`
--
ALTER TABLE controlled_object_relationship
ADD UNIQUE INDEX UNQ_controlled_object_relationship (parent_controlled_object_id, child_controlled_object_id);

--
-- Create foreign key
--
ALTER TABLE controlled_object_relationship
ADD CONSTRAINT FK_controlled_object_relationship_child_controlled_object_id FOREIGN KEY (child_controlled_object_id)
REFERENCES controlled_object (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE controlled_object_relationship
ADD CONSTRAINT FK_controlled_object_relationship_parent_controlled_object_id FOREIGN KEY (parent_controlled_object_id)
REFERENCES controlled_object (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `rating`
--
CREATE TABLE rating (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_rating_label` on table `rating`
--
ALTER TABLE rating
ADD UNIQUE INDEX UNQ_rating_label (label);

--
-- Create index `UNQ_rating_plural_label` on table `rating`
--
ALTER TABLE rating
ADD UNIQUE INDEX UNQ_rating_plural_label (plural_label);

--
-- Create index `IDX_rating_sort_order` on table `rating`
--
ALTER TABLE rating
ADD INDEX IDX_rating_sort_order (sort_order);

--
-- Create index `IDX_rating_is_active` on table `rating`
--
ALTER TABLE rating
ADD INDEX IDX_rating_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE rating
ADD CONSTRAINT FK_rating_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE rating
ADD CONSTRAINT FK_rating_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `crm_status`
--
CREATE TABLE crm_status (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_crm_status_label` on table `crm_status`
--
ALTER TABLE crm_status
ADD UNIQUE INDEX UNQ_crm_status_label (label);

--
-- Create index `UNQ_crm_status_plural_label` on table `crm_status`
--
ALTER TABLE crm_status
ADD UNIQUE INDEX UNQ_crm_status_plural_label (plural_label);

--
-- Create index `IDX_crm_status_sort_order` on table `crm_status`
--
ALTER TABLE crm_status
ADD INDEX IDX_crm_status_sort_order (sort_order);

--
-- Create index `IDX_crm_status_is_active` on table `crm_status`
--
ALTER TABLE crm_status
ADD INDEX IDX_crm_status_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE crm_status
ADD CONSTRAINT FK_crm_status_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE crm_status
ADD CONSTRAINT FK_crm_status_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `company_type`
--
CREATE TABLE company_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_company_type_label` on table `company_type`
--
ALTER TABLE company_type
ADD UNIQUE INDEX UNQ_company_type_label (label);

--
-- Create index `UNQ_company_type_plural_label` on table `company_type`
--
ALTER TABLE company_type
ADD UNIQUE INDEX UNQ_company_type_plural_label (plural_label);

--
-- Create index `IDX_company_type_sort_order` on table `company_type`
--
ALTER TABLE company_type
ADD INDEX IDX_company_type_sort_order (sort_order);

--
-- Create index `IDX_company_type_is_active` on table `company_type`
--
ALTER TABLE company_type
ADD INDEX IDX_company_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE company_type
ADD CONSTRAINT FK_company_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_type
ADD CONSTRAINT FK_company_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `account_status`
--
CREATE TABLE account_status (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_account_status_label` on table `account_status`
--
ALTER TABLE account_status
ADD UNIQUE INDEX UNQ_account_status_label (label);

--
-- Create index `UNQ_account_status_plural_label` on table `account_status`
--
ALTER TABLE account_status
ADD UNIQUE INDEX UNQ_account_status_plural_label (plural_label);

--
-- Create index `IDX_account_status_sort_order` on table `account_status`
--
ALTER TABLE account_status
ADD INDEX IDX_account_status_sort_order (sort_order);

--
-- Create index `IDX_account_status_is_,active` on table `account_status`
--
ALTER TABLE account_status
ADD INDEX `IDX_account_status_is_,active` (is_active);

--
-- Create foreign key
--
ALTER TABLE account_status
ADD CONSTRAINT FK_account_status_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE account_status
ADD CONSTRAINT FK_account_status_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `time_daylight_savings`
--
CREATE TABLE time_daylight_savings (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    start_position varchar(5) DEFAULT NULL,
    start_day varchar(10) DEFAULT NULL,
    start_month int(10) UNSIGNED DEFAULT NULL,
    end_position varchar(5) DEFAULT NULL,
    end_day varchar(10) DEFAULT NULL,
    end_month int(2) UNSIGNED DEFAULT NULL,
    hour_shift decimal(10, 0) DEFAULT 0,
    current_hour_shift decimal(10, 0) DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE time_daylight_savings
ADD CONSTRAINT FK_time_daylight_savings_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE time_daylight_savings
ADD CONSTRAINT FK_time_daylight_savings_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `social_media_type`
--
CREATE TABLE social_media_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_social_media_type_label` on table `social_media_type`
--
ALTER TABLE social_media_type
ADD UNIQUE INDEX UNQ_social_media_type_label (label);

--
-- Create index `UNQ_social_media_type_plural_label` on table `social_media_type`
--
ALTER TABLE social_media_type
ADD UNIQUE INDEX UNQ_social_media_type_plural_label (plural_label);

--
-- Create index `IDX_social_media_type_sort_order` on table `social_media_type`
--
ALTER TABLE social_media_type
ADD INDEX IDX_social_media_type_sort_order (sort_order);

--
-- Create index `IDX_social_media_type_is_active` on table `social_media_type`
--
ALTER TABLE social_media_type
ADD INDEX IDX_social_media_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE social_media_type
ADD CONSTRAINT FK_social_media_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE social_media_type
ADD CONSTRAINT FK_social_media_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `country`
--
CREATE TABLE country (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    un_code varchar(20) DEFAULT NULL,
    iso_code1 varchar(50) DEFAULT NULL,
    iso_code2 varchar(50) DEFAULT NULL,
    iso_code3 varchar(50) DEFAULT NULL,
    telephone_code varchar(50) DEFAULT NULL,
    address_format_string_id int(10) UNSIGNED NOT NULL DEFAULT 1,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_country_name` on table `country`
--
ALTER TABLE country
ADD UNIQUE INDEX UNQ_country_name (name);

--
-- Create index `UNQ_un_code` on table `country`
--
ALTER TABLE country
ADD UNIQUE INDEX UNQ_un_code (un_code);

--
-- Create index `UNQ_iso_code1` on table `country`
--
ALTER TABLE country
ADD UNIQUE INDEX UNQ_iso_code1 (iso_code1);

--
-- Create index `UNQ_iso_code2` on table `country`
--
ALTER TABLE country
ADD UNIQUE INDEX UNQ_iso_code2 (iso_code2);

--
-- Create index `UNQ_iso_code3` on table `country`
--
ALTER TABLE country
ADD UNIQUE INDEX UNQ_iso_code3 (iso_code3);

--
-- Create table `time_zones`
--
CREATE TABLE time_zones (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    country_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on COUNTRY table',
    province varchar(255) DEFAULT NULL,
    city varchar(255) DEFAULT NULL,
    postal_code varchar(255) DEFAULT NULL,
    daylight_savings_id int(10) UNSIGNED NOT NULL COMMENT 'FK on DAYLIGHT SAVINGS table',
    gmt_offset decimal(10, 0) DEFAULT NULL,
    confirmed enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'T|F flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `province` on table `time_zones`
--
ALTER TABLE time_zones
ADD INDEX province (province);

--
-- Create foreign key
--
ALTER TABLE time_zones
ADD CONSTRAINT FK_time_zones_country_id FOREIGN KEY (country_id)
REFERENCES country (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE time_zones
ADD CONSTRAINT FK_time_zones_daylight_savings_id FOREIGN KEY (daylight_savings_id)
REFERENCES time_daylight_savings (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `address_type`
--
CREATE TABLE address_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_address_type_label` on table `address_type`
--
ALTER TABLE address_type
ADD UNIQUE INDEX UNQ_address_type_label (label);

--
-- Create index `UNQ_address_type_plural_label` on table `address_type`
--
ALTER TABLE address_type
ADD UNIQUE INDEX UNQ_address_type_plural_label (plural_label);

--
-- Create index `IDX_address_type_sort_order` on table `address_type`
--
ALTER TABLE address_type
ADD INDEX IDX_address_type_sort_order (sort_order);

--
-- Create index `IDX_address_type_is_active` on table `address_type`
--
ALTER TABLE address_type
ADD INDEX IDX_address_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE address_type
ADD CONSTRAINT FK_address_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE address_type
ADD CONSTRAINT FK_address_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `address`
--
CREATE TABLE address (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    address_body varchar(255) NOT NULL,
    line1 varchar(255) NOT NULL,
    line2 varchar(255) DEFAULT NULL,
    line3 varchar(255) DEFAULT NULL,
    city varchar(255) NOT NULL,
    province varchar(255) NOT NULL,
    postal_code varchar(255) NOT NULL,
    country_id int(10) UNSIGNED NOT NULL DEFAULT 1,
    address_type_id int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'FK on ADDRESS TYPE table',
    social_media_type_id int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'FK on SOCIAL MEDIA TYPE table',
    gmt_offset decimal(10, 0) DEFAULT NULL,
    daylight_savings_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on DAYLIGHT SAVINGS table',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_address_name` on table `address`
--
ALTER TABLE address
ADD UNIQUE INDEX UNQ_address_name (name);

--
-- Create index `UNQ_address_address_body` on table `address`
--
ALTER TABLE address
ADD UNIQUE INDEX UNQ_address_address_body (address_body);

--
-- Create index `IDX_address_city` on table `address`
--
ALTER TABLE address
ADD INDEX IDX_address_city (city);

--
-- Create index `IDX_address_province` on table `address`
--
ALTER TABLE address
ADD INDEX IDX_address_province (province);

--
-- Create index `IDX_address_is_active` on table `address`
--
ALTER TABLE address
ADD INDEX IDX_address_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE address
ADD CONSTRAINT FK_address_country_id FOREIGN KEY (country_id)
REFERENCES country (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE address
ADD CONSTRAINT FK_address_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE address
ADD CONSTRAINT FK_address_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE address
ADD CONSTRAINT FK_address_social_media_address_type_id FOREIGN KEY (address_type_id)
REFERENCES address_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE address
ADD CONSTRAINT FK_address_social_media_daylight_savings_id FOREIGN KEY (daylight_savings_id)
REFERENCES time_daylight_savings (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE address
ADD CONSTRAINT FK_address_social_media_type_id FOREIGN KEY (social_media_type_id)
REFERENCES social_media_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `role`
--
CREATE TABLE role (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_role_label` on table `role`
--
ALTER TABLE role
ADD UNIQUE INDEX UNQ_role_label (label);

--
-- Create index `UNQ_role_plural_label` on table `role`
--
ALTER TABLE role
ADD UNIQUE INDEX UNQ_role_plural_label (plural_label);

--
-- Create index `IDX_role_sort_order` on table `role`
--
ALTER TABLE role
ADD INDEX IDX_role_sort_order (sort_order);

--
-- Create index `IDX_role_is_active` on table `role`
--
ALTER TABLE role
ADD INDEX IDX_role_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE role
ADD CONSTRAINT FK_role_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE role
ADD CONSTRAINT FK_role_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `activity_type`
--
CREATE TABLE activity_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL COMMENT 'USER that made record',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED DEFAULT NULL COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_activity_type_label` on table `activity_type`
--
ALTER TABLE activity_type
ADD UNIQUE INDEX UNQ_activity_type_label (label);

--
-- Create index `UNQ_activity_type_plural_label` on table `activity_type`
--
ALTER TABLE activity_type
ADD UNIQUE INDEX UNQ_activity_type_plural_label (plural_label);

--
-- Create index `IDX_activity_type_sort_order` on table `activity_type`
--
ALTER TABLE activity_type
ADD INDEX IDX_activity_type_sort_order (sort_order);

--
-- Create index `IDX_activity_type_is_,active` on table `activity_type`
--
ALTER TABLE activity_type
ADD INDEX `IDX_activity_type_is_,active` (is_active);

--
-- Create foreign key
--
ALTER TABLE activity_type
ADD CONSTRAINT FK_activity_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity_type
ADD CONSTRAINT FK_activity_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `campaign_type`
--
CREATE TABLE campaign_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_campaign_type_label` on table `campaign_type`
--
ALTER TABLE campaign_type
ADD UNIQUE INDEX UNQ_campaign_type_label (label);

--
-- Create index `UNQ_campaign_type_plural_label` on table `campaign_type`
--
ALTER TABLE campaign_type
ADD UNIQUE INDEX UNQ_campaign_type_plural_label (plural_label);

--
-- Create index `IDX_campaign_type_sort_order` on table `campaign_type`
--
ALTER TABLE campaign_type
ADD INDEX IDX_campaign_type_sort_order (sort_order);

--
-- Create index `IDX_campaign_type_is_active` on table `campaign_type`
--
ALTER TABLE campaign_type
ADD INDEX IDX_campaign_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE campaign_type
ADD CONSTRAINT FK_campaign_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE campaign_type
ADD CONSTRAINT FK_campaign_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `campaign_status`
--
CREATE TABLE campaign_status (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_campaign_status_label` on table `campaign_status`
--
ALTER TABLE campaign_status
ADD UNIQUE INDEX UNQ_campaign_status_label (label);

--
-- Create index `UNQ_campaign_status_plural_label` on table `campaign_status`
--
ALTER TABLE campaign_status
ADD UNIQUE INDEX UNQ_campaign_status_plural_label (plural_label);

--
-- Create index `IDX_campaign_status_sort_order` on table `campaign_status`
--
ALTER TABLE campaign_status
ADD INDEX IDX_campaign_status_sort_order (sort_order);

--
-- Create index `IDX_campaign_status_is_active` on table `campaign_status`
--
ALTER TABLE campaign_status
ADD INDEX IDX_campaign_status_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE campaign_status
ADD CONSTRAINT FK_campaign_status_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE campaign_status
ADD CONSTRAINT FK_campaign_status_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `campaign`
--
CREATE TABLE campaign (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    title varchar(100) DEFAULT NULL,
    `desc` text DEFAULT NULL,
    campaign_type_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CAMPAIGN TYPE table',
    campaign_status_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CAMPAIGN STATUS table',
    owned_by int(10) UNSIGNED NOT NULL COMMENT 'Who manages this record, defaults to CREATED BY',
    starts_at timestamp NULL DEFAULT NULL,
    ends_at timestamp NULL DEFAULT NULL,
    cost decimal(8, 0) NOT NULL DEFAULT 0,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_campaign_campaign_title` on table `campaign`
--
ALTER TABLE campaign
ADD UNIQUE INDEX UNQ_campaign_campaign_title (title);

--
-- Create index `IDX_campaign_is_active` on table `campaign`
--
ALTER TABLE campaign
ADD INDEX IDX_campaign_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE campaign
ADD CONSTRAINT FK_campaign_campaign_status_id FOREIGN KEY (campaign_status_id)
REFERENCES campaign_status (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE campaign
ADD CONSTRAINT FK_campaign_campaign_type_id FOREIGN KEY (campaign_type_id)
REFERENCES campaign_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE campaign
ADD CONSTRAINT FK_campaign_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE campaign
ADD CONSTRAINT FK_campaign_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE campaign
ADD CONSTRAINT FK_campaign_owner_id FOREIGN KEY (owned_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `industry`
--
CREATE TABLE industry (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_industry_label` on table `industry`
--
ALTER TABLE industry
ADD UNIQUE INDEX UNQ_industry_label (label);

--
-- Create index `UNQ_industry_plural_label` on table `industry`
--
ALTER TABLE industry
ADD UNIQUE INDEX UNQ_industry_plural_label (plural_label);

--
-- Create index `IDX_industry_sort_order` on table `industry`
--
ALTER TABLE industry
ADD INDEX IDX_industry_sort_order (sort_order);

--
-- Create index `IDX_industry_is_active` on table `industry`
--
ALTER TABLE industry
ADD INDEX IDX_industry_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE industry
ADD CONSTRAINT FK_industry_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE industry
ADD CONSTRAINT FK_industry_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `company_source`
--
CREATE TABLE company_source (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_company_source_label` on table `company_source`
--
ALTER TABLE company_source
ADD UNIQUE INDEX UNQ_company_source_label (label);

--
-- Create index `UNQ_company_source_plural_label` on table `company_source`
--
ALTER TABLE company_source
ADD UNIQUE INDEX UNQ_company_source_plural_label (plural_label);

--
-- Create index `IDX_company_source_sort_order` on table `company_source`
--
ALTER TABLE company_source
ADD INDEX IDX_company_source_sort_order (sort_order);

--
-- Create index `IDX_company_source_is_active` on table `company_source`
--
ALTER TABLE company_source
ADD INDEX IDX_company_source_is_active (is_active);

--
-- Create table `company`
--
CREATE TABLE company (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    legal_name varchar(100) DEFAULT NULL,
    tax_id varchar(100) DEFAULT NULL,
    profile text DEFAULT NULL,
    url varchar(50) DEFAULT NULL,
    employees int(10) UNSIGNED NOT NULL DEFAULT 0,
    revenue int(10) NOT NULL DEFAULT 0,
    credit_limit int(10) UNSIGNED NOT NULL DEFAULT 0,
    terms int(10) UNSIGNED NOT NULL DEFAULT 0,
    rating_id int(10) UNSIGNED NOT NULL,
    industry_id int(10) UNSIGNED NOT NULL COMMENT 'FK on INDUSTRY table',
    account_status_id int(10) UNSIGNED NOT NULL COMMENT 'FK on ACCOUNT STATUS table',
    company_type_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY TYPE table',
    crm_status_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CRM STATUS table',
    company_source_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY SOURCE table',
    owner_id int(10) UNSIGNED NOT NULL COMMENT 'USER that ownes this record',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_company_name` on table `company`
--
ALTER TABLE company
ADD INDEX IDX_company_name (name);

--
-- Create index `IDX_company_tax_id` on table `company`
--
ALTER TABLE company
ADD INDEX IDX_company_tax_id (tax_id);

--
-- Create index `IDX_company_is_active` on table `company`
--
ALTER TABLE company
ADD INDEX IDX_company_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_account_status_id FOREIGN KEY (account_status_id)
REFERENCES account_status (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_company_source_id FOREIGN KEY (company_source_id)
REFERENCES company_source (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_company_type_id FOREIGN KEY (company_type_id)
REFERENCES company_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_crm_status_id FOREIGN KEY (crm_status_id)
REFERENCES crm_status (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_industry_id FOREIGN KEY (industry_id)
REFERENCES industry (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_owner_id FOREIGN KEY (owner_id)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company
ADD CONSTRAINT FK_company_rating_id FOREIGN KEY (rating_id)
REFERENCES rating (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `contact_former_company`
--
CREATE TABLE contact_former_company (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    contact_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CONTACT table',
    former_company_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY table',
    company_change_at timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE contact_former_company
ADD CONSTRAINT FK_contact_former_company_company_id FOREIGN KEY (former_company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact_former_company
ADD CONSTRAINT FK_contact_former_company_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact_former_company
ADD CONSTRAINT FK_contact_former_company_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact_former_company
ADD CONSTRAINT FK_contact_former_company_owner_id FOREIGN KEY (contact_id)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `company_relationship`
--
CREATE TABLE company_relationship (
    from_company_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY table',
    relationship_type varchar(100) NOT NULL,
    to_company_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY table',
    established_at timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag'
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_company_relationship` on table `company_relationship`
--
ALTER TABLE company_relationship
ADD INDEX IDX_company_relationship (from_company_id, to_company_id);

--
-- Create index `IDX_company_relationship_is_active` on table `company_relationship`
--
ALTER TABLE company_relationship
ADD INDEX IDX_company_relationship_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE company_relationship
ADD CONSTRAINT FK_company_relationship_company_from_id FOREIGN KEY (from_company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_relationship
ADD CONSTRAINT FK_company_relationship_company_to_id FOREIGN KEY (to_company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_relationship
ADD CONSTRAINT FK_company_relationship_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_relationship
ADD CONSTRAINT FK_company_relationship_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `company_former_name`
--
CREATE TABLE company_former_name (
    company_id int(10) UNSIGNED NOT NULL,
    namechange_at timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    former_name varchar(100) NOT NULL,
    description varchar(100) DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field'
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_company_former_name_company_id` on table `company_former_name`
--
ALTER TABLE company_former_name
ADD INDEX IDX_company_former_name_company_id (company_id);

--
-- Create index `IDX_company_former_name_former_name` on table `company_former_name`
--
ALTER TABLE company_former_name
ADD INDEX IDX_company_former_name_former_name (former_name);

--
-- Create foreign key
--
ALTER TABLE company_former_name
ADD CONSTRAINT FK_company_former_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_former_name
ADD CONSTRAINT FK_company_former_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_former_name
ADD CONSTRAINT FK_company_former_name_company_id FOREIGN KEY (company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `company_division`
--
CREATE TABLE company_division (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    division_name varchar(100) NOT NULL,
    description text DEFAULT NULL,
    company_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY table',
    company_source_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY SOURCE table',
    industry_id int(10) UNSIGNED NOT NULL COMMENT 'FK on INDUSTRY table',
    owned_by int(10) UNSIGNED NOT NULL COMMENT 'Who manages this record, defaults to CREATED BY',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_company_division_division_name` on table `company_division`
--
ALTER TABLE company_division
ADD UNIQUE INDEX UNQ_company_division_division_name (division_name);

--
-- Create foreign key
--
ALTER TABLE company_division
ADD CONSTRAINT FK_company_division_company_id FOREIGN KEY (company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_division
ADD CONSTRAINT FK_company_division_company_source_id FOREIGN KEY (company_source_id)
REFERENCES company_source (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_division
ADD CONSTRAINT FK_company_division_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_division
ADD CONSTRAINT FK_company_division_industry_id FOREIGN KEY (industry_id)
REFERENCES industry (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_division
ADD CONSTRAINT FK_company_division_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_division
ADD CONSTRAINT FK_company_division_owned_by FOREIGN KEY (owned_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `company_campaign_map`
--
CREATE TABLE company_campaign_map (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    company_id int(10) UNSIGNED NOT NULL,
    campaign_id int(10) UNSIGNED NOT NULL,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_company_category_scope_map` on table `company_campaign_map`
--
ALTER TABLE company_campaign_map
ADD UNIQUE INDEX IDX_company_category_scope_map (company_id, campaign_id);

--
-- Create index `IDX_company_category_scope_map_campaign_id` on table `company_campaign_map`
--
ALTER TABLE company_campaign_map
ADD INDEX IDX_company_category_scope_map_campaign_id (campaign_id);

--
-- Create index `IDX_company_category_scope_map_company_id` on table `company_campaign_map`
--
ALTER TABLE company_campaign_map
ADD INDEX IDX_company_category_scope_map_company_id (company_id);

--
-- Create foreign key
--
ALTER TABLE company_campaign_map
ADD CONSTRAINT FK_company_campaign_map_campaign_id FOREIGN KEY (campaign_id)
REFERENCES campaign (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE company_campaign_map
ADD CONSTRAINT FK_company_campaign_map_company_id FOREIGN KEY (company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `salutation`
--
CREATE TABLE salutation (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    salutation varchar(20) NOT NULL,
    salutation_sort_value int(4) DEFAULT 1,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a display flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_salutation` on table `salutation`
--
ALTER TABLE salutation
ADD UNIQUE INDEX UNQ_salutation (salutation);

--
-- Create index `IDX_salutation_is_active` on table `salutation`
--
ALTER TABLE salutation
ADD INDEX IDX_salutation_is_active (is_active);

--
-- Create table `contact_name_suffix`
--
CREATE TABLE contact_name_suffix (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_contact_name_suffix_label` on table `contact_name_suffix`
--
ALTER TABLE contact_name_suffix
ADD UNIQUE INDEX UNQ_contact_name_suffix_label (label);

--
-- Create index `IDX_contact_name_suffix_sort_order` on table `contact_name_suffix`
--
ALTER TABLE contact_name_suffix
ADD INDEX IDX_contact_name_suffix_sort_order (sort_order);

--
-- Create index `IDX_contact_name_suffix_is_active` on table `contact_name_suffix`
--
ALTER TABLE contact_name_suffix
ADD INDEX IDX_contact_name_suffix_is_active (is_active);

--
-- Create table `contact_gender`
--
CREATE TABLE contact_gender (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_contact_gender_label` on table `contact_gender`
--
ALTER TABLE contact_gender
ADD UNIQUE INDEX UNQ_contact_gender_label (label);

--
-- Create index `IDX_contact_gender_order` on table `contact_gender`
--
ALTER TABLE contact_gender
ADD INDEX IDX_contact_gender_order (sort_order);

--
-- Create index `IDX_contact_gender_is_active` on table `contact_gender`
--
ALTER TABLE contact_gender
ADD INDEX IDX_contact_gender_is_active (is_active);

--
-- Create table `contact`
--
CREATE TABLE contact (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    last_name varchar(100) NOT NULL,
    middle_name varchar(100) DEFAULT NULL,
    first_name varchar(100) NOT NULL,
    preferred_name varchar(100) DEFAULT NULL,
    title varchar(100) DEFAULT NULL,
    salutation_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on SALUTATION table',
    contact_name_suffix_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on CONTACT SUFFIX table',
    company_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY table',
    division_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on DIVISION table',
    gender_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on CONTACT GENDER table',
    date_of_birth date DEFAULT NULL,
    anniversary date DEFAULT NULL,
    company_anniversary date DEFAULT NULL,
    summary varchar(100) DEFAULT NULL,
    description varchar(100) DEFAULT NULL,
    interests varchar(50) DEFAULT NULL,
    profile text DEFAULT NULL,
    tax_id varchar(32) DEFAULT NULL,
    owned_by int(10) UNSIGNED NOT NULL COMMENT 'Who manages this record, defaults to CREATED BY',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_contact_is_active` on table `contact`
--
ALTER TABLE contact
ADD INDEX IDX_contact_is_active (is_active);

--
-- Create index `IDX_contact_name` on table `contact`
--
ALTER TABLE contact
ADD INDEX IDX_contact_name (last_name, first_name);

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_company_id FOREIGN KEY (company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_contact_name_suffix_id FOREIGN KEY (contact_name_suffix_id)
REFERENCES contact_name_suffix (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_division_id FOREIGN KEY (division_id)
REFERENCES company_division (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_gender_id FOREIGN KEY (gender_id)
REFERENCES contact_gender (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_owner_id FOREIGN KEY (owned_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact
ADD CONSTRAINT FK_contact_salutation_id FOREIGN KEY (salutation_id)
REFERENCES salutation (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `contact_social_media`
--
CREATE TABLE contact_social_media (
    contact_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CONTACT table',
    social_media_id int(10) UNSIGNED NOT NULL COMMENT 'FK on SOCIAL MEDIA table',
    social_media_name varchar(50) DEFAULT NULL,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag'
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_contact_social_media` on table `contact_social_media`
--
ALTER TABLE contact_social_media
ADD UNIQUE INDEX UNQ_contact_social_media (contact_id, social_media_id);

--
-- Create index `UNQ_contact_social_media_name` on table `contact_social_media`
--
ALTER TABLE contact_social_media
ADD UNIQUE INDEX UNQ_contact_social_media_name (social_media_id, social_media_name);

--
-- Create index `IDX_company_type_is_active` on table `contact_social_media`
--
ALTER TABLE contact_social_media
ADD INDEX IDX_company_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE contact_social_media
ADD CONSTRAINT contact_social_media_contact_id FOREIGN KEY (contact_id)
REFERENCES contact (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE contact_social_media
ADD CONSTRAINT contact_social_media_social_media_id FOREIGN KEY (social_media_id)
REFERENCES social_media_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `workflow_entity_type`
--
CREATE TABLE workflow_entity_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED DEFAULT NULL COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_workflow_entity_type_label` on table `workflow_entity_type`
--
ALTER TABLE workflow_entity_type
ADD UNIQUE INDEX UNQ_workflow_entity_type_label (label);

--
-- Create index `UNQ_workflow_entity_type_plural_label` on table `workflow_entity_type`
--
ALTER TABLE workflow_entity_type
ADD UNIQUE INDEX UNQ_workflow_entity_type_plural_label (plural_label);

--
-- Create index `IDX_workflow_entity_type_sort_order` on table `workflow_entity_type`
--
ALTER TABLE workflow_entity_type
ADD INDEX IDX_workflow_entity_type_sort_order (sort_order);

--
-- Create index `IDX_workflow_entity_type_is_,active` on table `workflow_entity_type`
--
ALTER TABLE workflow_entity_type
ADD INDEX `IDX_workflow_entity_type_is_,active` (is_active);

--
-- Create foreign key
--
ALTER TABLE workflow_entity_type
ADD CONSTRAINT FK_workflow_entity_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE workflow_entity_type
ADD CONSTRAINT FK_workflow_entity_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `activity_template`
--
CREATE TABLE activity_template (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    activity_title varchar(100) DEFAULT NULL,
    activity_description text DEFAULT NULL,
    default_TEXT text DEFAULT NULL,
    activity_type_id int(10) UNSIGNED NOT NULL COMMENT 'FK on ACTIVITY table',
    role_id int(10) UNSIGNED NOT NULL DEFAULT 3 COMMENT 'FK on ROLE table',
    on_what_table varchar(100) DEFAULT NULL,
    on_what_id int(10) UNSIGNED DEFAULT NULL,
    duration varchar(20) NOT NULL DEFAULT '1' COMMENT 'varchar for advanced date functionality',
    workflow_entity_type_id int(10) UNSIGNED DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_activity_template_sort_order` on table `activity_template`
--
ALTER TABLE activity_template
ADD INDEX IDX_activity_template_sort_order (sort_order);

--
-- Create index `FK_activity_template_activity_type_id_idx` on table `activity_template`
--
ALTER TABLE activity_template
ADD INDEX FK_activity_template_activity_type_id_idx (activity_type_id);

--
-- Create index `FK_activity_template_role_id_idx` on table `activity_template`
--
ALTER TABLE activity_template
ADD INDEX FK_activity_template_role_id_idx (role_id);

--
-- Create index `IDX_activity_template_is_active` on table `activity_template`
--
ALTER TABLE activity_template
ADD INDEX IDX_activity_template_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE activity_template
ADD CONSTRAINT FK_activity_template_activity_type_id FOREIGN KEY (activity_type_id)
REFERENCES activity_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity_template
ADD CONSTRAINT FK_activity_template_role_id FOREIGN KEY (role_id)
REFERENCES role (id);

--
-- Create foreign key
--
ALTER TABLE activity_template
ADD CONSTRAINT FK_activity_template_workflow_entity_type_id FOREIGN KEY (workflow_entity_type_id)
REFERENCES workflow_entity_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `activity_participant_position`
--
CREATE TABLE activity_participant_position (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL,
    workflow_entity_type_id int(10) UNSIGNED NOT NULL COMMENT 'FK on ACTIVITY TYPE table',
    global_flag enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'T|F flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `FK_activity_participant_workflow_entity_type_id_idx` on table `activity_participant_position`
--
ALTER TABLE activity_participant_position
ADD INDEX FK_activity_participant_workflow_entity_type_id_idx (workflow_entity_type_id);

--
-- Create foreign key
--
ALTER TABLE activity_participant_position
ADD CONSTRAINT FK_activity_participant_position_workflow_entity_type_id FOREIGN KEY (workflow_entity_type_id)
REFERENCES workflow_entity_type (id);

--
-- Create table `activity_resolution_type`
--
CREATE TABLE activity_resolution_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_activity_resolution_type_label` on table `activity_resolution_type`
--
ALTER TABLE activity_resolution_type
ADD UNIQUE INDEX UNQ_activity_resolution_type_label (label);

--
-- Create index `UNQ_activity_resolution_type_plural_label` on table `activity_resolution_type`
--
ALTER TABLE activity_resolution_type
ADD UNIQUE INDEX UNQ_activity_resolution_type_plural_label (plural_label);

--
-- Create index `IDX_activity_resolution_type_sort_order` on table `activity_resolution_type`
--
ALTER TABLE activity_resolution_type
ADD INDEX IDX_activity_resolution_type_sort_order (sort_order);

--
-- Create index `IDX_activity_resolution_type_is_,active` on table `activity_resolution_type`
--
ALTER TABLE activity_resolution_type
ADD INDEX `IDX_activity_resolution_type_is_,active` (is_active);

--
-- Create foreign key
--
ALTER TABLE activity_resolution_type
ADD CONSTRAINT FK_activity_resolution_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity_resolution_type
ADD CONSTRAINT FK_activity_resolution_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `activity`
--
CREATE TABLE activity (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `desc` text DEFAULT NULL,
    activity_template_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on ACTIVITY TEMPLATE table',
    activity_title varchar(100) DEFAULT NULL,
    activity_type_id int(10) UNSIGNED NOT NULL COMMENT 'FK on ACTIVITY TYPE table',
    company_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY table',
    contact_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CONTACT table',
    address_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on ADDRESS table',
    on_what_table varchar(100) DEFAULT NULL,
    on_what_id int(10) UNSIGNED DEFAULT NULL,
    on_what_status int(10) UNSIGNED DEFAULT NULL,
    thread_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on THREAD table',
    followup_from_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on CONTACT table',
    scheduled_at timestamp NULL DEFAULT NULL,
    owner_id int(10) UNSIGNED NOT NULL COMMENT 'Who manages this record, defaults to CREATED BY',
    ends_at timestamp NULL DEFAULT NULL,
    completed_at timestamp NULL DEFAULT NULL,
    completed_by int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on CONTACT table',
    activity_status_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on ACTIVITY STATUS table',
    activity_recurrence_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on ACTIVITY RECURRENCE table',
    activity_resolution_type_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on ACTIVITY RESOLUTION TYPE table',
    activity_priority_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on ACTIVITY PRIORITY table',
    resolution_description text DEFAULT NULL,
    created_by int(10) NOT NULL DEFAULT 1 COMMENT 'FK on CONTACT table',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'FK on CONTACT table',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_activity` on table `activity`
--
ALTER TABLE activity
ADD INDEX IDX_activity (owner_id, contact_id, company_id);

--
-- Create index `IDX_activity_is_active` on table `activity`
--
ALTER TABLE activity
ADD INDEX IDX_activity_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_activity_activity_resolution_type_id FOREIGN KEY (activity_resolution_type_id)
REFERENCES activity_resolution_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_activity_template_id FOREIGN KEY (activity_template_id)
REFERENCES activity_template (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_address_id FOREIGN KEY (address_id)
REFERENCES address (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_company_id FOREIGN KEY (company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_contact_id FOREIGN KEY (contact_id)
REFERENCES contact (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id);

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_owner_id FOREIGN KEY (owner_id)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `activity_participant`
--
CREATE TABLE activity_participant (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    activity_id int(10) UNSIGNED NOT NULL COMMENT 'FK on ACTIVITY table',
    contact_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CONTACT table',
    activity_participant_position_id int(10) UNSIGNED NOT NULL COMMENT 'FK on ACTIVITY PARTICIPANT POSITION table',
    created_by int(10) NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `FK_activity_participant_activity_id_idx` on table `activity_participant`
--
ALTER TABLE activity_participant
ADD INDEX FK_activity_participant_activity_id_idx (activity_id);

--
-- Create index `FK_activity_participant_contact_id_idx` on table `activity_participant`
--
ALTER TABLE activity_participant
ADD INDEX FK_activity_participant_contact_id_idx (contact_id);

--
-- Create index `FK_activity_participant_activity_participant_position_id_idx` on table `activity_participant`
--
ALTER TABLE activity_participant
ADD INDEX FK_activity_participant_activity_participant_position_id_idx (activity_participant_position_id);

--
-- Create index `IDX_activity_participant_is_active` on table `activity_participant`
--
ALTER TABLE activity_participant
ADD INDEX IDX_activity_participant_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE activity_participant
ADD CONSTRAINT FK_activity_participant_activity_id FOREIGN KEY (activity_id)
REFERENCES activity (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity_participant
ADD CONSTRAINT FK_activity_participant_activity_participant_position_id FOREIGN KEY (activity_participant_position_id)
REFERENCES activity_participant_position (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity_participant
ADD CONSTRAINT FK_activity_participant_contact_id FOREIGN KEY (contact_id)
REFERENCES contact (id);

--
-- Create table `role_permission_scope`
--
CREATE TABLE role_permission_scope (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(128) NOT NULL,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_role_permission_scope_label` on table `role_permission_scope`
--
ALTER TABLE role_permission_scope
ADD UNIQUE INDEX UNQ_role_permission_scope_label (label);

--
-- Create table `permission`
--
CREATE TABLE permission (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    abbr varchar(5) NOT NULL,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_permission_label` on table `permission`
--
ALTER TABLE permission
ADD UNIQUE INDEX UNQ_permission_label (label);

--
-- Create index `UNQ_permission_abbr` on table `permission`
--
ALTER TABLE permission
ADD UNIQUE INDEX UNQ_permission_abbr (abbr);

--
-- Create table `role_permission`
--
CREATE TABLE role_permission (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    role_id int(10) UNSIGNED NOT NULL,
    cor_id int(10) UNSIGNED NOT NULL COMMENT 'FK to controlled_object_relationship',
    scope_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK to role_permission_scope',
    permission_id int(10) UNSIGNED NOT NULL,
    Inheritable_flag enum ('1', '0') NOT NULL DEFAULT '1',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE role_permission
ADD CONSTRAINT FK_role_permission_cor_id FOREIGN KEY (cor_id)
REFERENCES controlled_object_relationship (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE role_permission
ADD CONSTRAINT FK_role_permission_permission_id FOREIGN KEY (permission_id)
REFERENCES permission (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE role_permission
ADD CONSTRAINT FK_role_permission_role_id FOREIGN KEY (role_id)
REFERENCES role (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE role_permission
ADD CONSTRAINT FK_role_permission_scope_id FOREIGN KEY (scope_id)
REFERENCES role_permission_scope (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `relationship_type`
--
CREATE TABLE relationship_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_relationship_type_label` on table `relationship_type`
--
ALTER TABLE relationship_type
ADD UNIQUE INDEX UNQ_relationship_type_label (label);

--
-- Create index `UNQ_relationship_type_plural_label` on table `relationship_type`
--
ALTER TABLE relationship_type
ADD UNIQUE INDEX UNQ_relationship_type_plural_label (plural_label);

--
-- Create index `IDX_relationship_type_sort_order` on table `relationship_type`
--
ALTER TABLE relationship_type
ADD INDEX IDX_relationship_type_sort_order (sort_order);

--
-- Create index `IDX_relationship_type_is_active` on table `relationship_type`
--
ALTER TABLE relationship_type
ADD INDEX IDX_relationship_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE relationship_type
ADD CONSTRAINT FK_relationship_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE relationship_type
ADD CONSTRAINT FK_relationship_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `relationship`
--
CREATE TABLE relationship (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    from_what_id int(10) UNSIGNED NOT NULL,
    to_what_id int(10) UNSIGNED NOT NULL,
    relationship_type_id int(10) UNSIGNED NOT NULL,
    ended_on timestamp NULL DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_relationship_from_what_id` on table `relationship`
--
ALTER TABLE relationship
ADD INDEX IDX_relationship_from_what_id (from_what_id);

--
-- Create index `IDX_relationship_to_what_id` on table `relationship`
--
ALTER TABLE relationship
ADD INDEX IDX_relationship_to_what_id (to_what_id);

--
-- Create index `IDX_relationship_is_active` on table `relationship`
--
ALTER TABLE relationship
ADD INDEX IDX_relationship_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE relationship
ADD CONSTRAINT FK_relationship_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE relationship
ADD CONSTRAINT FK_relationship_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE relationship
ADD CONSTRAINT FK_relationship_relationship_type_id FOREIGN KEY (relationship_type_id)
REFERENCES relationship_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `opportunity_type`
--
CREATE TABLE opportunity_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_opportunity_type_label` on table `opportunity_type`
--
ALTER TABLE opportunity_type
ADD UNIQUE INDEX UNQ_opportunity_type_label (label);

--
-- Create index `UNQ_opportunity_type_plural_label` on table `opportunity_type`
--
ALTER TABLE opportunity_type
ADD UNIQUE INDEX UNQ_opportunity_type_plural_label (plural_label);

--
-- Create index `IDX_opportunity_type_sort_order` on table `opportunity_type`
--
ALTER TABLE opportunity_type
ADD INDEX IDX_opportunity_type_sort_order (sort_order);

--
-- Create index `IDX_opportunity_type_is_active` on table `opportunity_type`
--
ALTER TABLE opportunity_type
ADD INDEX IDX_opportunity_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE opportunity_type
ADD CONSTRAINT FK_opportunity_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity_type
ADD CONSTRAINT FK_opportunity_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `opportunity_status`
--
CREATE TABLE opportunity_status (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_opportunity_status_label` on table `opportunity_status`
--
ALTER TABLE opportunity_status
ADD UNIQUE INDEX UNQ_opportunity_status_label (label);

--
-- Create index `UNQ_opportunity_status_plural_label` on table `opportunity_status`
--
ALTER TABLE opportunity_status
ADD UNIQUE INDEX UNQ_opportunity_status_plural_label (plural_label);

--
-- Create index `IDX_opportunity_status_sort_order` on table `opportunity_status`
--
ALTER TABLE opportunity_status
ADD INDEX IDX_opportunity_status_sort_order (sort_order);

--
-- Create index `IDX_opportunity_status_is_active` on table `opportunity_status`
--
ALTER TABLE opportunity_status
ADD INDEX IDX_opportunity_status_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE opportunity_status
ADD CONSTRAINT FK_opportunity_status_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity_status
ADD CONSTRAINT FK_opportunity_status_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `opportunity`
--
CREATE TABLE opportunity (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    opportunity_type_id int(10) UNSIGNED NOT NULL DEFAULT 1,
    opportunity_status_id int(10) UNSIGNED NOT NULL DEFAULT 1,
    campaign_id int(10) UNSIGNED DEFAULT NULL,
    company_id int(10) UNSIGNED NOT NULL,
    division_id int(10) UNSIGNED DEFAULT NULL,
    contact_id int(10) UNSIGNED NOT NULL,
    opportunity_title varchar(100) NOT NULL,
    opportunity_description text NOT NULL,
    next_step varchar(100) DEFAULT NULL,
    size decimal(10, 0) NOT NULL DEFAULT 0,
    probability int(10) UNSIGNED NOT NULL DEFAULT 0,
    owned_by int(10) UNSIGNED NOT NULL COMMENT 'Who manages this record, defaults to CREATED BY',
    new_owned_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'Needs to change when OWNER is changed',
    closed_by int(10) UNSIGNED DEFAULT NULL,
    closed_on timestamp NULL DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_opportunity_is_active` on table `opportunity`
--
ALTER TABLE opportunity
ADD INDEX IDX_opportunity_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_campaign_id FOREIGN KEY (campaign_id)
REFERENCES campaign (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_closed_by FOREIGN KEY (closed_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_company_id FOREIGN KEY (company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_contact_id FOREIGN KEY (contact_id)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_division_id FOREIGN KEY (division_id)
REFERENCES company_division (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_opportunity_status_id FOREIGN KEY (opportunity_status_id)
REFERENCES opportunity_status (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_opportunity_type_id FOREIGN KEY (opportunity_type_id)
REFERENCES opportunity_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE opportunity
ADD CONSTRAINT FK_opportunity_owner_id FOREIGN KEY (owned_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `group`
--
CREATE TABLE `group` (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(128) NOT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_group_name` on table `group`
--
ALTER TABLE `group`
ADD UNIQUE INDEX UNQ_group_name (name);

--
-- Create index `IDX_group_sort_order` on table `group`
--
ALTER TABLE `group`
ADD INDEX IDX_group_sort_order (sort_order);

--
-- Create index `IDX_group_is_active` on table `group`
--
ALTER TABLE `group`
ADD INDEX IDX_group_is_active (is_active);

--
-- Create table `group_user`
--
CREATE TABLE group_user (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    group_id int(10) UNSIGNED NOT NULL,
    user_id int(10) UNSIGNED NOT NULL,
    role_id int(10) UNSIGNED NOT NULL,
    child_group_id int(10) UNSIGNED DEFAULT NULL,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE group_user
ADD CONSTRAINT FK_group_user_child_group_id FOREIGN KEY (child_group_id)
REFERENCES `group` (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE group_user
ADD CONSTRAINT FK_group_user_group_id FOREIGN KEY (group_id)
REFERENCES `group` (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE group_user
ADD CONSTRAINT FK_group_user_role_id FOREIGN KEY (role_id)
REFERENCES role (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE group_user
ADD CONSTRAINT FK_group_user_user_id FOREIGN KEY (user_id)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `group_member`
--
CREATE TABLE group_member (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    group_id int(10) UNSIGNED NOT NULL,
    controlled_object_id int(10) UNSIGNED NOT NULL,
    on_what_id int(10) UNSIGNED NOT NULL,
    criteria_table varchar(50) NOT NULL,
    criteria_result_field varchar(50) NOT NULL,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `group_member_controlled_object_id` on table `group_member`
--
ALTER TABLE group_member
ADD INDEX group_member_controlled_object_id (controlled_object_id);

--
-- Create foreign key
--
ALTER TABLE group_member
ADD CONSTRAINT FK_group_member_group_id FOREIGN KEY (group_id)
REFERENCES `group` (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `group_member_criteria`
--
CREATE TABLE group_member_criteria (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    group_member_id int(10) UNSIGNED NOT NULL,
    criteria_fieldname varchar(60) NOT NULL,
    criteria_value varchar(50) NOT NULL,
    criteria_operator varchar(8) NOT NULL DEFAULT '=',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE group_member_criteria
ADD CONSTRAINT FK_group_member_group_member_id FOREIGN KEY (group_member_id)
REFERENCES group_member (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `category_scope`
--
CREATE TABLE category_scope (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    on_what_table varchar(100) DEFAULT NULL,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_category_scope_label` on table `category_scope`
--
ALTER TABLE category_scope
ADD UNIQUE INDEX UNQ_category_scope_label (label);

--
-- Create index `UNQ_category_scope_plural_label` on table `category_scope`
--
ALTER TABLE category_scope
ADD UNIQUE INDEX UNQ_category_scope_plural_label (plural_label);

--
-- Create index `IDX_category_scope_is_active` on table `category_scope`
--
ALTER TABLE category_scope
ADD INDEX IDX_category_scope_is_active (is_active);

--
-- Create table `category`
--
CREATE TABLE category (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_category_label` on table `category`
--
ALTER TABLE category
ADD UNIQUE INDEX UNQ_category_label (label);

--
-- Create index `UNQ_category_plural_label` on table `category`
--
ALTER TABLE category
ADD UNIQUE INDEX UNQ_category_plural_label (plural_label);

--
-- Create index `IDX_category_is_active` on table `category`
--
ALTER TABLE category
ADD INDEX IDX_category_is_active (is_active);

--
-- Create table `entity_category_map`
--
CREATE TABLE entity_category_map (
    category_id int(10) UNSIGNED NOT NULL,
    on_what_table varchar(100) NOT NULL,
    on_what_id int(10) UNSIGNED NOT NULL
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_entity_category_map` on table `entity_category_map`
--
ALTER TABLE entity_category_map
ADD UNIQUE INDEX UNQ_entity_category_map (on_what_table, on_what_id);

--
-- Create foreign key
--
ALTER TABLE entity_category_map
ADD CONSTRAINT entity_category_map_category_id FOREIGN KEY (category_id)
REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `category_scope_map`
--
CREATE TABLE category_scope_map (
    category_id int(10) UNSIGNED NOT NULL,
    category_scope_id int(10) UNSIGNED NOT NULL
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_category_scope_map` on table `category_scope_map`
--
ALTER TABLE category_scope_map
ADD UNIQUE INDEX IDX_category_scope_map (category_id, category_scope_id);

--
-- Create index `IDX_category_scope_map_category_id` on table `category_scope_map`
--
ALTER TABLE category_scope_map
ADD INDEX IDX_category_scope_map_category_id (category_id);

--
-- Create index `IDX_category_scope_map_company_id` on table `category_scope_map`
--
ALTER TABLE category_scope_map
ADD INDEX IDX_category_scope_map_company_id (category_scope_id);

--
-- Create foreign key
--
ALTER TABLE category_scope_map
ADD CONSTRAINT FK_category_scope_map_category_id FOREIGN KEY (category_id)
REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE category_scope_map
ADD CONSTRAINT FK_category_scope_map_category_scope_id FOREIGN KEY (category_scope_id)
REFERENCES category_scope (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `priority`
--
CREATE TABLE priority (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    short_name varchar(10) NOT NULL,
    plural_label varchar(100) NOT NULL,
    score_adjustment int(10) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_priority_name` on table `priority`
--
ALTER TABLE priority
ADD UNIQUE INDEX UNQ_priority_name (name);

--
-- Create index `UNQ_priority_short_name` on table `priority`
--
ALTER TABLE priority
ADD UNIQUE INDEX UNQ_priority_short_name (short_name);

--
-- Create index `UNQ_priority_plural_label` on table `priority`
--
ALTER TABLE priority
ADD UNIQUE INDEX UNQ_priority_plural_label (plural_label);

--
-- Create table `case_type`
--
CREATE TABLE case_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_case_type_label` on table `case_type`
--
ALTER TABLE case_type
ADD UNIQUE INDEX UNQ_case_type_label (label);

--
-- Create index `UNQ_case_type_plural_label` on table `case_type`
--
ALTER TABLE case_type
ADD UNIQUE INDEX UNQ_case_type_plural_label (plural_label);

--
-- Create index `IDX_case_type_sort_order` on table `case_type`
--
ALTER TABLE case_type
ADD INDEX IDX_case_type_sort_order (sort_order);

--
-- Create index `IDX_case_type_is_active` on table `case_type`
--
ALTER TABLE case_type
ADD INDEX IDX_case_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE case_type
ADD CONSTRAINT FK_case_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE case_type
ADD CONSTRAINT FK_case_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `case`
--
CREATE TABLE `case` (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    title varchar(100) NOT NULL,
    description text NOT NULL,
    due_on datetime NOT NULL,
    case_type_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CASE TYPE table',
    priority_id int(10) UNSIGNED NOT NULL DEFAULT 3 COMMENT 'Default to MEDIUM [this should be configurable]',
    company_id int(10) UNSIGNED NOT NULL COMMENT 'FK on COMPANY table',
    division_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on DIVISION table',
    contact_id int(10) UNSIGNED NOT NULL COMMENT 'FK on CONTACT table',
    case_status_id int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Default to NEW - FK on CASE STATUS table',
    owned_by int(10) UNSIGNED NOT NULL COMMENT 'Default to USER that OPENed record',
    new_owned_at timestamp NOT NULL DEFAULT current_timestamp COMMENT 'changed when OWNER is changed',
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    closed_by int(10) UNSIGNED DEFAULT NULL COMMENT 'USER that CLOSED record',
    closed_on datetime DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_case_title` on table `case`
--
ALTER TABLE `case`
ADD UNIQUE INDEX UNQ_case_title (title);

--
-- Create index `IDX_case_is_active` on table `case`
--
ALTER TABLE `case`
ADD INDEX IDX_case_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_case_status_id FOREIGN KEY (case_status_id)
REFERENCES case_status (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_case_type_id FOREIGN KEY (case_type_id)
REFERENCES case_type (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_closed_by FOREIGN KEY (closed_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_company_id FOREIGN KEY (company_id)
REFERENCES company (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_contact_id FOREIGN KEY (contact_id)
REFERENCES contact (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_division_id FOREIGN KEY (division_id)
REFERENCES company_division (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_owned_by FOREIGN KEY (owned_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE `case`
ADD CONSTRAINT FK_case_priority_id FOREIGN KEY (priority_id)
REFERENCES priority (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `workflow_history`
--
CREATE TABLE workflow_history (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    on_what_table varchar(32) DEFAULT NULL,
    on_what_id int(10) UNSIGNED DEFAULT NULL,
    old_status int(10) UNSIGNED DEFAULT NULL,
    new_status int(10) UNSIGNED DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_workflow_history_created_on` on table `workflow_history`
--
ALTER TABLE workflow_history
ADD INDEX IDX_workflow_history_created_on (created_on);

--
-- Create foreign key
--
ALTER TABLE workflow_history
ADD CONSTRAINT FK_workflow_history_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `user_preference_type`
--
CREATE TABLE user_preference_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name varchar(128) NOT NULL,
    short_name varchar(64) NOT NULL,
    description varchar(255) NOT NULL,
    allow_multiple_flag enum ('1', '0') NOT NULL DEFAULT '0' COMMENT 'T|F flag',
    allow_user_edit_flag enum ('1', '0') NOT NULL DEFAULT '0' COMMENT 'T|F flag',
    form_element_type varchar(32) NOT NULL DEFAULT 'TEXT',
    read_only enum ('1', '0') NOT NULL DEFAULT '0' COMMENT 'T|F flag',
    skip_system_edit_flag enum ('1', '0') NOT NULL DEFAULT '0' COMMENT 'T|F flag',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_preference_type_name` on table `user_preference_type`
--
ALTER TABLE user_preference_type
ADD UNIQUE INDEX UNQ_preference_type_name (name);

--
-- Create index `UNQ_preference_type_short_name` on table `user_preference_type`
--
ALTER TABLE user_preference_type
ADD UNIQUE INDEX UNQ_preference_type_short_name (short_name);

--
-- Create index `IDX_preference_type_is_active` on table `user_preference_type`
--
ALTER TABLE user_preference_type
ADD INDEX IDX_preference_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE user_preference_type
ADD CONSTRAINT FK_user_preference_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE user_preference_type
ADD CONSTRAINT FK_user_preference_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `status_indicator`
--
CREATE TABLE status_indicator (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_status_indicator_label` on table `status_indicator`
--
ALTER TABLE status_indicator
ADD UNIQUE INDEX UNQ_status_indicator_label (label);

--
-- Create index `UNQ_status_indicator_plural_label` on table `status_indicator`
--
ALTER TABLE status_indicator
ADD UNIQUE INDEX UNQ_status_indicator_plural_label (plural_label);

--
-- Create index `IDX_status_indicator_sort_order` on table `status_indicator`
--
ALTER TABLE status_indicator
ADD INDEX IDX_status_indicator_sort_order (sort_order);

--
-- Create index `IDX_status_indicator_is_active` on table `status_indicator`
--
ALTER TABLE status_indicator
ADD INDEX IDX_status_indicator_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE status_indicator
ADD CONSTRAINT FK_status_indicator_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE status_indicator
ADD CONSTRAINT FK_status_indicator_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `session`
--
CREATE TABLE session (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    data_value text NOT NULL,
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `session_modified_on` on table `session`
--
ALTER TABLE session
ADD INDEX session_modified_on (modified_on);

--
-- Create table `saved_action`
--
CREATE TABLE saved_action (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    on_what_table varchar(100) NOT NULL,
    saved_action varchar(100) NOT NULL,
    group_item int(10) UNSIGNED DEFAULT NULL,
    saved_data text NOT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_saved_action_label` on table `saved_action`
--
ALTER TABLE saved_action
ADD UNIQUE INDEX UNQ_saved_action_label (label, created_by);

--
-- Create index `saved_action_group_item` on table `saved_action`
--
ALTER TABLE saved_action
ADD INDEX saved_action_group_item (group_item);

--
-- Create foreign key
--
ALTER TABLE saved_action
ADD CONSTRAINT FK_saved_action_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE saved_action
ADD CONSTRAINT FK_saved_action_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `recent_item`
--
CREATE TABLE recent_item (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    on_what_table varchar(100) NOT NULL,
    on_what_id int(10) UNSIGNED NOT NULL,
    recent_action varchar(100) NOT NULL,
    created_by int(10) UNSIGNED DEFAULT NULL COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE recent_item
ADD CONSTRAINT FK_recent_item_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `phone_type`
--
CREATE TABLE phone_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_phone_type_label` on table `phone_type`
--
ALTER TABLE phone_type
ADD UNIQUE INDEX UNQ_phone_type_label (label);

--
-- Create index `UNQ_phone_type_plural_label` on table `phone_type`
--
ALTER TABLE phone_type
ADD UNIQUE INDEX UNQ_phone_type_plural_label (plural_label);

--
-- Create index `IDX_phone_type_sort_order` on table `phone_type`
--
ALTER TABLE phone_type
ADD INDEX IDX_phone_type_sort_order (sort_order);

--
-- Create index `IDX_phone_type_is_active` on table `phone_type`
--
ALTER TABLE phone_type
ADD INDEX IDX_phone_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE phone_type
ADD CONSTRAINT FK_phone_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE phone_type
ADD CONSTRAINT FK_phone_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `pager_saved_view`
--
CREATE TABLE pager_saved_view (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    pager_label varchar(255) NOT NULL,
    view_data text NOT NULL,
    owned_by int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Who manages this record, defaults to CREATED BY',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_pager_saved_view_pager_label` on table `pager_saved_view`
--
ALTER TABLE pager_saved_view
ADD UNIQUE INDEX UNQ_pager_saved_view_pager_label (pager_label);

--
-- Create foreign key
--
ALTER TABLE pager_saved_view
ADD CONSTRAINT FK_pager_saved_view_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE pager_saved_view
ADD CONSTRAINT FK_pager_saved_view_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE pager_saved_view
ADD CONSTRAINT FK_pager_saved_view_owned_by FOREIGN KEY (owned_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `notes`
--
CREATE TABLE notes (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    description text NOT NULL,
    on_what_table varchar(100) DEFAULT NULL,
    on_what_id int(10) UNSIGNED DEFAULT NULL,
    entered_at timestamp NULL DEFAULT NULL,
    entered_by int(10) UNSIGNED NOT NULL DEFAULT 0,
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_crm_status_is_active` on table `notes`
--
ALTER TABLE notes
ADD INDEX IDX_crm_status_is_active (is_active);

--
-- Create table `language`
--
CREATE TABLE language (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(32) NOT NULL,
    code varchar(32) NOT NULL,
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `IDX_language_order_label` on table `language`
--
ALTER TABLE language
ADD INDEX IDX_language_order_label (label);

--
-- Create index `IDX_language_order_codel` on table `language`
--
ALTER TABLE language
ADD INDEX IDX_language_order_codel (code);

--
-- Create table `file`
--
CREATE TABLE file (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    file_name varchar(100) DEFAULT NULL,
    pretty_name varchar(100) DEFAULT NULL,
    description text DEFAULT NULL,
    filesystem_name varchar(100) DEFAULT NULL,
    file_size int(10) UNSIGNED NOT NULL DEFAULT 0,
    file_type varchar(10) DEFAULT NULL,
    on_what_table varchar(100) DEFAULT NULL,
    on_what_id int(10) UNSIGNED DEFAULT NULL,
    owner_id int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Who manages this record, defaults to CREATED BY',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_file_name` on table `file`
--
ALTER TABLE file
ADD UNIQUE INDEX UNQ_file_name (file_name);

--
-- Create index `IDX_file_is_active` on table `file`
--
ALTER TABLE file
ADD INDEX IDX_file_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE file
ADD CONSTRAINT FK_file_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE file
ADD CONSTRAINT FK_file_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE file
ADD CONSTRAINT FK_file_owner_id FOREIGN KEY (owner_id)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `email_type`
--
CREATE TABLE email_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_email_type_label` on table `email_type`
--
ALTER TABLE email_type
ADD UNIQUE INDEX UNQ_email_type_label (label);

--
-- Create index `UNQ_email_type_plural_label` on table `email_type`
--
ALTER TABLE email_type
ADD UNIQUE INDEX UNQ_email_type_plural_label (plural_label);

--
-- Create index `IDX_email_type_sort_order` on table `email_type`
--
ALTER TABLE email_type
ADD INDEX IDX_email_type_sort_order (sort_order);

--
-- Create index `IDX_email_type_is_active` on table `email_type`
--
ALTER TABLE email_type
ADD INDEX IDX_email_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE email_type
ADD CONSTRAINT FK_email_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE email_type
ADD CONSTRAINT FK_email_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `email_template_type`
--
CREATE TABLE email_template_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_email_template_type_label` on table `email_template_type`
--
ALTER TABLE email_template_type
ADD UNIQUE INDEX UNQ_email_template_type_label (label);

--
-- Create index `UNQ_email_template_type_plural_label` on table `email_template_type`
--
ALTER TABLE email_template_type
ADD UNIQUE INDEX UNQ_email_template_type_plural_label (plural_label);

--
-- Create index `IDX_email_template_type_sort_order` on table `email_template_type`
--
ALTER TABLE email_template_type
ADD INDEX IDX_email_template_type_sort_order (sort_order);

--
-- Create index `IDX_email_template_type_is_active` on table `email_template_type`
--
ALTER TABLE email_template_type
ADD INDEX IDX_email_template_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE email_template_type
ADD CONSTRAINT FK_email_template_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE email_template_type
ADD CONSTRAINT FK_email_template_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `email_template`
--
CREATE TABLE email_template (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    email_template_title varchar(100) NOT NULL,
    email_template_type_id int(10) UNSIGNED NOT NULL COMMENT 'FK on EMAIL TEMPLATE TYPE table',
    email_template_body text DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_email_template_email_template_title` on table `email_template`
--
ALTER TABLE email_template
ADD UNIQUE INDEX UNQ_email_template_email_template_title (email_template_title);

--
-- Create index `IDX_email_template_is_active` on table `email_template`
--
ALTER TABLE email_template
ADD INDEX IDX_email_template_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE email_template
ADD CONSTRAINT FK_email_template_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE email_template
ADD CONSTRAINT FK_email_template_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `case_priority`
--
CREATE TABLE case_priority (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_case_priority_label` on table `case_priority`
--
ALTER TABLE case_priority
ADD UNIQUE INDEX UNQ_case_priority_label (label);

--
-- Create index `UNQ_case_priority_plural_label` on table `case_priority`
--
ALTER TABLE case_priority
ADD UNIQUE INDEX UNQ_case_priority_plural_label (plural_label);

--
-- Create index `IDX_case_priority_sort_order` on table `case_priority`
--
ALTER TABLE case_priority
ADD INDEX IDX_case_priority_sort_order (sort_order);

--
-- Create index `IDX_case_priority_is_active` on table `case_priority`
--
ALTER TABLE case_priority
ADD INDEX IDX_case_priority_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE case_priority
ADD CONSTRAINT FK_case_priority_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE case_priority
ADD CONSTRAINT FK_case_priority_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `audit_type`
--
CREATE TABLE audit_type (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_audit_type_label` on table `audit_type`
--
ALTER TABLE audit_type
ADD UNIQUE INDEX UNQ_audit_type_label (label);

--
-- Create index `UNQ_audit_type_plural_label` on table `audit_type`
--
ALTER TABLE audit_type
ADD UNIQUE INDEX UNQ_audit_type_plural_label (plural_label);

--
-- Create index `IDX_audit_type_sort_order` on table `audit_type`
--
ALTER TABLE audit_type
ADD INDEX IDX_audit_type_sort_order (sort_order);

--
-- Create index `IDX_audit_type_is_active` on table `audit_type`
--
ALTER TABLE audit_type
ADD INDEX IDX_audit_type_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE audit_type
ADD CONSTRAINT FK_audit_type_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE audit_type
ADD CONSTRAINT FK_audit_type_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `audit_item`
--
CREATE TABLE audit_item (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    audit_type_id int(10) UNSIGNED DEFAULT NULL COMMENT 'FK on AUDIT TYPE table',
    on_what_table varchar(100) DEFAULT NULL,
    on_what_id int(10) UNSIGNED DEFAULT NULL,
    remote_addr varchar(40) NOT NULL,
    remote_port int(10) UNSIGNED NOT NULL,
    session_id varchar(50) DEFAULT NULL COMMENT 'This will be NULL if LOGIN fails',
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'This will be NULL if LOGIN fails',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE audit_item
ADD CONSTRAINT FK_audit_item_audit_type_id FOREIGN KEY (audit_type_id)
REFERENCES audit_item (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE audit_item
ADD CONSTRAINT FK_audit_item_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `address_format`
--
CREATE TABLE address_format (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    format varchar(255) DEFAULT NULL,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_address_format_format` on table `address_format`
--
ALTER TABLE address_format
ADD UNIQUE INDEX UNQ_address_format_format (format);

--
-- Create index `IDX_address_format_is_active` on table `address_format`
--
ALTER TABLE address_format
ADD INDEX IDX_address_format_is_active (is_active);

--
-- Create foreign key
--
ALTER TABLE address_format
ADD CONSTRAINT FK_address_format_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE address_format
ADD CONSTRAINT FK_address_format_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `activity_status`
--
CREATE TABLE activity_status (
    id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    label varchar(100) NOT NULL,
    plural_label varchar(100) NOT NULL,
    `desc` varchar(200) DEFAULT NULL,
    sort_order int(2) UNSIGNED NOT NULL DEFAULT 1,
    created_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that CREATED record, also original OWNER',
    created_on timestamp NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
    modified_by int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'USER that last updated record',
    modified_on timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
    is_active enum ('1', '0') NOT NULL DEFAULT '1' COMMENT 'used as a logical DELETE flag',
    PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `UNQ_activity_status_label` on table `activity_status`
--
ALTER TABLE activity_status
ADD UNIQUE INDEX UNQ_activity_status_label (label);

--
-- Create index `UNQ_activity_status_plural_label` on table `activity_status`
--
ALTER TABLE activity_status
ADD UNIQUE INDEX UNQ_activity_status_plural_label (plural_label);

--
-- Create index `IDX_activity_status_sort_order` on table `activity_status`
--
ALTER TABLE activity_status
ADD INDEX IDX_activity_status_sort_order (sort_order);

--
-- Create index `IDX_activity_status_is_,active` on table `activity_status`
--
ALTER TABLE activity_status
ADD INDEX `IDX_activity_status_is_,active` (is_active);

--
-- Create foreign key
--
ALTER TABLE activity_status
ADD CONSTRAINT FK_activity_status_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity_status
ADD CONSTRAINT FK_activity_status_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create table `activity_recurrence`
--
CREATE TABLE activity_recurrence (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  activity_id INT(10) UNSIGNED NOT NULL COMMENT 'FK on ACTIVITY table',
  start_TIMESTAMP TIMESTAMP NULL DEFAULT NULL,
  end_TIMESTAMP TIMESTAMP NULL DEFAULT NULL,
  end_count INT(10) UNSIGNED DEFAULT 0,
  frequency INT(10) UNSIGNED NOT NULL DEFAULT 0,
  period VARCHAR(100) DEFAULT NULL,
  day_offset INT(10) UNSIGNED DEFAULT 0,
  month_offset INT(10) UNSIGNED DEFAULT 0,
  week_offset INT(10) UNSIGNED DEFAULT 0,
  week_days VARCHAR(100) DEFAULT NULL,
  created_by INT(10) UNSIGNED NOT NULL COMMENT 'USER that CREATED record, also original OWNER',
  created_on TIMESTAMP NOT NULL DEFAULT current_timestamp COMMENT 'DB auto-maintains this field',
  modified_by INT(10) UNSIGNED NOT NULL COMMENT 'USER that last updated record',
  modified_on TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP COMMENT 'DB auto-maintains this field',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create foreign key
--
ALTER TABLE activity_recurrence
ADD CONSTRAINT FK_activity_recurrence_activity_id FOREIGN KEY (activity_id)
REFERENCES activity (id);

--
-- Create foreign key
--
ALTER TABLE activity_recurrence
ADD CONSTRAINT FK_activity_recurrence_created_by FOREIGN KEY (created_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity_recurrence
ADD CONSTRAINT FK_activity_recurrence_modified_by FOREIGN KEY (modified_by)
REFERENCES user (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Create foreign key
--
ALTER TABLE activity
ADD CONSTRAINT FK_activity_activity_recurrence_id FOREIGN KEY (activity_recurrence_id)
REFERENCES activity_recurrence (id) ON DELETE CASCADE ON UPDATE CASCADE;