CREATE DATABASE IF NOT EXISTS spaceapp;

USE spaceapp;

CREATE TABLE User (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(256) NOT NULL,
	name VARCHAR(256) NOT NULL,
	password VARCHAR(256) NOT NULL,
	email VARCHAR(256) NOT NULL
);

CREATE TABLE launch_vehicle (
	launch_vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
	launch_vehicle_name VARCHAR(255),
	model VARCHAR(100),
	status VARCHAR(50),
	launch_site VARCHAR(100)
);

CREATE TABLE Spaceship (
	spaceship_id INT AUTO_INCREMENT PRIMARY KEY,
	spaceship_name VARCHAR(256) NOT NULL,
	type VARCHAR(50) NOT NULL,
	status VARCHAR(50) NOT NULL,
	capacity INT NOT NULL,
	owner_comp_id INT NOT NULL,
	launch_vehicle_id INT,
	FOREIGN KEY (owner_comp_id) REFERENCES User(user_id),
	FOREIGN KEY (launch_vehicle_id) REFERENCES launch_vehicle(launch_vehicle_id)
);

CREATE TABLE space_mission (
	mission_id INT AUTO_INCREMENT PRIMARY KEY,
	mission_name VARCHAR(255),
	description VARCHAR(4096),
	status VARCHAR(50),
	launch_date DATE,
	destination VARCHAR(100),
	cost FLOAT(15, 2),
	duration INT,
	crew_size INT,
	required_roles VARCHAR(255),
	bid_deadline DATE,
	creator_comp_id INT,
	manager_comp_id INT,
	spaceship_id INT,
	FOREIGN KEY (creator_comp_id) REFERENCES User(user_id),
	FOREIGN KEY (manager_comp_id) REFERENCES User(user_id),
	FOREIGN KEY (spaceship_id) REFERENCES Spaceship(spaceship_id)
);

CREATE TABLE bid (
	bid_id INT AUTO_INCREMENT PRIMARY KEY,
	bid_amount FLOAT(15, 2),
	bid_date DATE,
	status VARCHAR(50),
	company_id INT,
	mission_id INT,
	FOREIGN KEY (company_id) REFERENCES User(user_id),
	FOREIGN KEY (mission_id) REFERENCES space_mission(mission_id)
);

CREATE TABLE financial_transaction (
	transaction_id INT AUTO_INCREMENT PRIMARY KEY,
	date DATE,
	type VARCHAR(50),
	amount FLOAT(15, 2),
	status VARCHAR(50),
	description VARCHAR(4096),
	payer_comp INT,
	payee_comp INT,
	mission_id INT,
	FOREIGN KEY (payer_comp) REFERENCES User(user_id),
	FOREIGN KEY (payee_comp) REFERENCES User(user_id),
	FOREIGN KEY (mission_id) REFERENCES space_mission(mission_id)
);

CREATE TABLE communication_log (
	log_id INT PRIMARY KEY AUTO_INCREMENT,
	date_time DATETIME,
	sender_id INT,
	receiver_id INT,
	message VARCHAR(4096),
	type VARCHAR(50),
	mission_id INT,
	FOREIGN KEY (sender_id) REFERENCES User(user_id),
	FOREIGN KEY (receiver_id) REFERENCES User(user_id),
	FOREIGN KEY (mission_id) REFERENCES space_mission(mission_id)
);

CREATE TABLE Admin (
	user_id INT PRIMARY KEY,
	permission_level VARCHAR(256) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Company (
	user_id INT PRIMARY KEY,
	address VARCHAR(256) NOT NULL,
	industry_sector VARCHAR(50) NOT NULL,
	website VARCHAR(256),
	FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

CREATE TABLE Astronaut (
    user_id INT PRIMARY KEY,
    company_id INT,
    date_of_birth DATE,
    nationality VARCHAR(40) NOT NULL,
    experience_level VARCHAR(40),
    role_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (company_id) REFERENCES Company(user_id),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

INSERT INTO Role (role_name) VALUES
('Not Assigned'),
('Commander'),
('Pilot'),
('Mission Specialist'),
('Flight Engineer'),
('Medical Doctor');

CREATE TABLE participates (
	astronaut_id INT,
	mission_id INT,
	FOREIGN KEY (astronaut_id) REFERENCES User(user_id),
	FOREIGN KEY (mission_id) REFERENCES space_mission(mission_id) ,
	PRIMARY KEY (astronaut_id, mission_id)
);

CREATE TABLE mission_resource (
	mission_id INT,
	resource_id INT,
	budget FLOAT(15, 2),
	resource_type VARCHAR(50),
	FOREIGN KEY (mission_id) REFERENCES space_mission(mission_id),
	PRIMARY KEY (mission_id, resource_id)
);

CREATE TABLE Training_program (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(256),
    description VARCHAR(4096),
    required_for INT,
    difficulty ENUM('Essential', 'Intermediate', 'Advanced'),
    FOREIGN KEY (required_for) REFERENCES Role(role_id)
);

INSERT INTO Training_program (name, description, required_for, difficulty) VALUES 
('Commander Essential Training', 'This is the essential training program for the commander role.', (SELECT role_id FROM Role WHERE role_name = 'Commander'), 'Essential'),
('Commander Intermediate Training', 'This is the intermediate training program for the commander role.', (SELECT role_id FROM Role WHERE role_name = 'Commander'), 'Intermediate'),
('Commander Advanced Training', 'This is the advanced training program for the commander role.', (SELECT role_id FROM Role WHERE role_name = 'Commander'), 'Advanced'),
('Pilot Essential Training', 'This is the essential training program for the pilot role.', (SELECT role_id FROM Role WHERE role_name = 'Pilot'), 'Essential'),
('Pilot Intermediate Training', 'This is the intermediate training program for the pilot role.', (SELECT role_id FROM Role WHERE role_name = 'Pilot'), 'Intermediate'),
('Pilot Advanced Training', 'This is the advanced training program for the pilot role.', (SELECT role_id FROM Role WHERE role_name = 'Pilot'), 'Advanced'),
('Mission Specialist Essential Training', 'This is the essential training program for the mission specialist role.', (SELECT role_id FROM Role WHERE role_name = 'Mission Specialist'), 'Essential'),
('Mission Specialist Intermediate Training', 'This is the intermediate training program for the mission specialist role.', (SELECT role_id FROM Role WHERE role_name = 'Mission Specialist'), 'Intermediate'),
('Mission Specialist Advanced Training', 'This is the advanced training program for the mission specialist role.', (SELECT role_id FROM Role WHERE role_name = 'Mission Specialist'), 'Advanced'),
('Flight Engineer Essential Training', 'This is the essential training program for the flight engineer role.', (SELECT role_id FROM Role WHERE role_name = 'Flight Engineer'), 'Essential'),
('Flight Engineer Intermediate Training', 'This is the intermediate training program for the flight engineer role.', (SELECT role_id FROM Role WHERE role_name = 'Flight Engineer'), 'Intermediate'),
('Flight Engineer Advanced Training', 'This is the advanced training program for the flight engineer role.', (SELECT role_id FROM Role WHERE role_name = 'Flight Engineer'), 'Advanced'),
('Medical Doctor Essential Training', 'This is the essential training program for the medical doctor role.', (SELECT role_id FROM Role WHERE role_name = 'Medical Doctor'), 'Essential'),
('Medical Doctor Intermediate Training', 'This is the intermediate training program for the medical doctor role.', (SELECT role_id FROM Role WHERE role_name = 'Medical Doctor'), 'Intermediate'),
('Medical Doctor Advanced Training', 'This is the advanced training program for the medical doctor role.', (SELECT role_id FROM Role WHERE role_name = 'Medical Doctor'), 'Advanced'),
('Space Agriculture Training', 'This advanced training program covers the techniques for growing food in space environments.', (SELECT role_id FROM Role WHERE role_name = 'Not assigned'), 'Advanced'),
('Spacecraft Maintenance Training', 'This advanced training program covers the maintenance procedures and troubleshooting of spacecraft systems.', (SELECT role_id FROM Role WHERE role_name = 'Not assigned'), 'Advanced'),
('Robotics Training', 'This advanced training program focuses on the operation and maintenance of robotic systems used in space missions.', (SELECT role_id FROM Role WHERE role_name = 'Not assigned'), 'Advanced'),
('Space Research Training', 'This advanced training program covers the methodologies and practices for conducting research in space.', (SELECT role_id FROM Role WHERE role_name = 'Not assigned'), 'Advanced'),
('Space Engineering Training', 'This advanced training program covers the engineering principles and technologies used in space missions.', (SELECT role_id FROM Role WHERE role_name = 'Not assigned'), 'Advanced');

CREATE TABLE astronaut_training (
    astronaut_id INT,
    program_id INT,
    completion_date DATE,
    FOREIGN KEY (astronaut_id) REFERENCES User(user_id),
    FOREIGN KEY (program_id) REFERENCES Training_program(program_id),
    PRIMARY KEY (astronaut_id, program_id)
);

CREATE TABLE Health_record (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    checkup_date DATE NOT NULL,
    health_status VARCHAR(256),
    fitness_level ENUM('Optimal', 'Above Average', 'Average', 'Below Average', 'Injured') NOT NULL,
    expected_ready_time DATETIME,
    astronaut_id INT,
    FOREIGN KEY (astronaut_id) REFERENCES User(user_id)
);


CREATE TABLE mission_feedback (
	feedback_id INT AUTO_INCREMENT PRIMARY KEY,
	date_submitted DATE NOT NULL,
	content VARCHAR(4096),
	mission_id INT,
	feedback_giver INT,
	FOREIGN KEY (mission_id) REFERENCES space_mission(mission_id),
	FOREIGN KEY (feedback_giver) REFERENCES User(user_id)
);
ALTER TABLE Spaceship CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE owns (
    company_id INT,
    spaceship_id INT,
    PRIMARY KEY (company_id, spaceship_id),
    FOREIGN KEY (company_id) REFERENCES Company(user_id),
    FOREIGN KEY (spaceship_id) REFERENCES Spaceship(spaceship_id)
);

CREATE TABLE uses (
    spaceship_id INT,
    space_mission_id INT,
    PRIMARY KEY (spaceship_id, space_mission_id),
    FOREIGN KEY (spaceship_id) REFERENCES Spaceship(spaceship_id),
    FOREIGN KEY (space_mission_id) REFERENCES space_mission(mission_id)
);

INSERT INTO User (user_id, username, name, password, email) VALUES 
(1, 'companyA', 'Company A', 'pass1', 'companya@example.com'), 
(2, 'companyB', 'Company B', 'pass2', 'companyb@example.com'), 
(3, 'companyC', 'Company C', 'pass3', 'companyc@example.com');

-- Insert corresponding entries into the Company table
INSERT INTO Company (user_id, address, industry_sector, website) VALUES 
(1, '123 Space Way', 'Aerospace', 'https://companyA.com'), 
(2, '456 Galaxy Road', 'Aerospace', 'https://companyB.com'), 
(3, '789 Star Blvd', 'Aerospace', 'https://companyC.com');

-- Inserting sample data into launch_vehicle table 
INSERT INTO launch_vehicle (launch_vehicle_name, model, status, launch_site) 
VALUES 
('Falcon 9', 'Block 5', 'Operational', 'Cape Canaveral'), 
('Delta IV Heavy', 'Heavy', 'Operational', 'Vandenberg'), 
('Atlas V', '401', 'Operational', 'Cape Canaveral'), 
('Starship', 'Mk1', 'Testing', 'Boca Chica'), 
('New Glenn', 'Rocket', 'In Development', 'Cape Canaveral'); 
 
-- Inserting sample data into Spaceship table 
INSERT INTO Spaceship (spaceship_name, type, status, capacity, owner_comp_id, launch_vehicle_id) 
VALUES 
('Spaceship Alpha', 'Exploration', 'Active', 10, 1, 1), 
('Spaceship Beta', 'Mining', 'Active', 15, 2, 2), 
('Spaceship Gamma', 'Research', 'Active', 20, 3, 3), 
('Spaceship Delta', 'Mapping', 'Active', 8, 1, 4), 
('Spaceship Epsilon', 'Tourism', 'Active', 5, 2, 5); 

INSERT INTO owns (company_id, spaceship_id) VALUES 
(1, 1),  -- Company A owns Spaceship Alpha
(2, 2),  -- Company B owns Spaceship Beta
(3, 3),  -- Company C owns Spaceship Gamma
(1, 4),  -- Company A owns Spaceship Delta
(2, 5);  -- Company B owns Spaceship Epsilon