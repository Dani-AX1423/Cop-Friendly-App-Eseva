-- Create Database
CREATE DATABASE cop_friendly_app;
USE cop_friendly_app;

-- USERS TABLE
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT NOT NULL
);

-- POLICE STAFF TABLE
CREATE TABLE police_staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    rank VARCHAR(50) NOT NULL,
    station VARCHAR(100)
);

-- COMPLAINTS TABLE
CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    complaint_type VARCHAR(100),
    description TEXT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- ASSIGNMENTS TABLE
CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT,
    staff_id INT,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id)
        ON DELETE CASCADE,

    FOREIGN KEY (staff_id) REFERENCES police_staff(staff_id)
        ON DELETE SET NULL
);