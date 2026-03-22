USE cop_friendly_app;

DELIMITER //

CREATE TRIGGER before_insert_complaint
BEFORE INSERT ON complaints
FOR EACH ROW
BEGIN
    IF NEW.status IS NULL OR NEW.status = '' THEN
        SET NEW.status = 'Pending';
    END IF;
END;
//

DELIMITER ;