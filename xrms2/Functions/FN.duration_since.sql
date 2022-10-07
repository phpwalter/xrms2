DELIMITER $$

DROP FUNCTION IF EXISTS `FN_no_of_days`;
CREATE FUNCTION `FN_no_of_days`( `days_from` DATE )
    RETURNS INT
    DETERMINISTIC
    BEGIN

        RETURN TIMESTAMPDIFF(DAY, @days_from, current_date());
    END$$


DROP FUNCTION IF EXISTS `FN_no_of_months`;
CREATE FUNCTION `FN_no_of_months`( `mths_from` DATE )
    RETURNS INT
    DETERMINISTIC
    BEGIN

      RETURN TIMESTAMPDIFF(MONTH, @mths_from, current_date());

    END$$


DROP FUNCTION IF EXISTS `FN_no_of_years`;
CREATE FUNCTION `FN_no_of_years`( `yrs_from` DATE )
    RETURNS INT
    DETERMINISTIC
    BEGIN

        RETURN TIMESTAMPDIFF(YEAR, @yrs_from, current_date());
    END$$


DELIMITER ;

-- eof
