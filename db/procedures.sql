USE cop_friendly_app;

DELIMITER //

CREATE PROCEDURE assign_officer(
    IN comp_id INT,
    IN staff INT
)
BEGIN
    INSERT INTO assignments (complaint_id, staff_id)
    VALUES (comp_id, staff);
END;
//

DELIMITER ;