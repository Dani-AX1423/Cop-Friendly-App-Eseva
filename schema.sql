-- =============================================
-- ESEVA - COP FRIENDLY APP | schema.sql
-- Run: sudo mariadb < schema.sql
-- =============================================

CREATE DATABASE IF NOT EXISTS eseva_db;
USE eseva_db;

-- ---- TABLES (3NF Normalized) ----

CREATE TABLE IF NOT EXISTS users (
  user_id    INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  phone      VARCHAR(15)  NOT NULL UNIQUE,
  email      VARCHAR(100) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS officers (
  officer_id   INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  badge_number VARCHAR(20)  NOT NULL UNIQUE,
  station      VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS complaints (
  complaint_id   INT AUTO_INCREMENT PRIMARY KEY,
  user_id        INT NOT NULL,
  officer_id     INT DEFAULT NULL,
  complaint_type VARCHAR(100) NOT NULL,
  description    TEXT NOT NULL,
  status         ENUM('Pending','In Progress','Resolved') DEFAULT 'Pending',
  created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)    REFERENCES users(user_id)       ON DELETE CASCADE,
  FOREIGN KEY (officer_id) REFERENCES officers(officer_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS audit_log (
  log_id       INT AUTO_INCREMENT PRIMARY KEY,
  complaint_id INT,
  old_status   VARCHAR(50),
  new_status   VARCHAR(50),
  changed_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ---- SEED DATA ----

INSERT IGNORE INTO users (name, phone, email) VALUES
  ('Arjun Kumar',  '9876543210', 'arjun@mail.com'),
  ('Priya Sharma', '9123456780', 'priya@mail.com');

INSERT IGNORE INTO officers (name, badge_number, station) VALUES
  ('Insp. Rajan', 'TN001', 'Anna Nagar PS'),
  ('SI Meena',    'TN002', 'T Nagar PS');

INSERT IGNORE INTO complaints (user_id, complaint_type, description, status) VALUES
  (1, 'Theft',    'Mobile snatched near bus stop', 'Pending'),
  (1, 'Noise',    'Loud music after midnight',     'Resolved'),
  (2, 'Accident', 'Hit and run on OMR road',       'In Progress');

-- ---- VIEWS ----

CREATE OR REPLACE VIEW pending_complaints AS
SELECT c.complaint_id, u.name AS citizen, c.complaint_type, c.status, c.created_at
FROM complaints c JOIN users u ON c.user_id = u.user_id
WHERE c.status = 'Pending';

CREATE OR REPLACE VIEW resolved_complaints AS
SELECT c.complaint_id, u.name AS citizen, c.complaint_type, c.updated_at AS resolved_at
FROM complaints c JOIN users u ON c.user_id = u.user_id
WHERE c.status = 'Resolved';

-- ---- TRIGGER: Audit log on status change ----

DROP TRIGGER IF EXISTS trg_audit_status;
DELIMITER $$
CREATE TRIGGER trg_audit_status
AFTER UPDATE ON complaints
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO audit_log (complaint_id, old_status, new_status)
    VALUES (OLD.complaint_id, OLD.status, NEW.status);
  END IF;
END$$
DELIMITER ;

-- ---- FUNCTION: Count complaints by user ----

DROP FUNCTION IF EXISTS count_user_complaints;
DELIMITER $$
CREATE FUNCTION count_user_complaints(uid INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM complaints WHERE user_id = uid;
  RETURN total;
END$$
DELIMITER ;

-- ---- STORED PROCEDURE: EOD Batch — auto-resolve stale complaints ----

DROP PROCEDURE IF EXISTS eod_auto_resolve;
DELIMITER $$
CREATE PROCEDURE eod_auto_resolve()
BEGIN
  UPDATE complaints
  SET status = 'Resolved'
  WHERE status = 'Pending' AND created_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
  SELECT ROW_COUNT() AS auto_resolved_count;
END$$
DELIMITER ;

-- ---- ACID DEMO (run manually in mariadb shell) ----
-- Atomicity   : START TRANSACTION; INSERT ...; UPDATE ...; ROLLBACK;
-- Consistency : INSERT complaint with user_id=999 → FK error, DB unchanged
-- Isolation   : SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; START TRANSACTION; SELECT ...;
-- Durability  : After COMMIT, restart server → data still present
