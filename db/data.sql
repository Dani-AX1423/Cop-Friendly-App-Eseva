-- Insert Users
INSERT INTO users (name, phone, address) VALUES
('Arun Kumar', '9876543210', 'Chennai'),
('Priya Sharma', '9123456780', 'Coimbatore');

-- Insert Police Staff
INSERT INTO police_staff (name, rank, station) VALUES
('Inspector Ravi', 'Inspector', 'T Nagar'),
('Sub Inspector Manoj', 'SI', 'Velachery');

-- Insert Complaints
INSERT INTO complaints (user_id, complaint_type, description, status) VALUES
(1, 'Theft', 'Bike stolen near mall', 'Pending'),
(2, 'Noise', 'Loud noise at night', 'Pending');