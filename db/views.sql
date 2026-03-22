USE cop_friendly_app;

CREATE VIEW pending_complaints AS
SELECT 
    c.complaint_id,
    u.name AS user_name,
    c.complaint_type,
    c.description,
    c.status,
    c.created_at
FROM complaints c
JOIN users u ON c.user_id = u.user_id
WHERE c.status = 'Pending';