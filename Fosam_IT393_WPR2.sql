-- IT393 AY21-1 WPR2 V1
-- NAME: Bonvie Fosam

-- DO NOT CHANGE THESE LINES!
-- The WPR begins on line 10
DROP DATABASE IF EXISTS wpr2;
CREATE DATABASE wpr2;
USE wpr2;

-- YOUR CODE GOES HERE.

-- Create the tables:
CREATE TABLE Attendee (
  emailAddress VARCHAR(255) NOT NULL,
  lastName VARCHAR(35),
  firstName VARCHAR(35),
  creditCard CHAR(16),
  PRIMARY KEY (emailAddress)
);

CREATE TABLE Conference (
  conferenceID INT,
  name VARCHAR(70) NOT NULL,
  registrationPrice DECIMAL(6,2) NOT NULL,
  registrationEndDate DATE NOT NULL,
  website VARCHAR(255),
  description TEXT,
  PRIMARY KEY (conferenceID)
);

CREATE TABLE Registration (
  emailAddress VARCHAR(255) NOT NULL,
  conferenceID INT,
  registrationDate DATETIME NOT NULL,
  PRIMARY KEY (emailAddress, conferenceID),
  FOREIGN KEY (emailAddress) REFERENCES Attendee(emailAddress),
  FOREIGN KEY (conferenceID) REFERENCES Conference(conferenceID)
);

-- Create stored procedures for each use case:

-- Use Case 1: EnterNewConference
DELIMITER //
CREATE PROCEDURE EnterNewConference (
  new_conferenceID INT,
  new_name VARCHAR(70),
  new_registrationPrice DECIMAL(6,2),
  new_registrationEndDate DATE,
  new_website VARCHAR(255),
  new_description TEXT
)
BEGIN
  INSERT INTO Conference(conferenceID, name, registrationPrice, registrationEndDate, website, description)
  VALUES (
    conferenceID = new_conferenceID,
    name = new_name,
    registrationPrice = new_registrationPrice,
	registrationEndDate = new_registrationEndDate,
    website = new_website,
	description = new_description
  );
END //

-- Use Case 2: ViewConferenceRegistrations
DELIMITER //
CREATE PROCEDURE ViewConferenceRegistrations()
BEGIN
  SELECT
    *
  FROM Registration
  ORDER BY emailAddress;
END//

-- Use Case 3: ViewAvailableConferences
DELIMITER //
CREATE PROCEDURE ViewAvailableConferences()
BEGIN
  SELECT
    name, registrationPrice, website, description
  FROM Conference
  WHERE registrationEndDate - CURRENT_DATE() > 0
  ORDER BY name;
END//
-- Use Case 4: Register
DELIMITER //
CREATE PROCEDURE Register(
	new_emailAddress VARCHAR(255),
    new_conferenceID INT
)
BEGIN
  INSERT INTO Registration (emailAddress, conferenceID, registrationDate)
  VALUES (
    emailAddress = new_emailAddress,
    conferenceID = new_conferenceID,
    registrationDate = NOW()
    );
END//

-- Create the users:
DROP USER IF EXISTS 'Attendee';
DROP USER IF EXISTS 'Admin';
CREATE USER 'Admin';
CREATE USER 'Attendee';

-- Give the users permission to execute their use cases:
GRANT EXECUTE ON PROCEDURE EnterNewConference TO 'Admin';
GRANT EXECUTE ON PROCEDURE ViewConferenceRegistrations TO 'Admin';
GRANT EXECUTE ON PROCEDURE ViewAvailableConferences TO 'Attendee';
GRANT EXECUTE ON PROCEDURE Register TO 'Attendee';

-- Uncomment the test data to check your answers.
-- DO NOT CHANGE ANY LINES BELOW!



INSERT INTO attendee (emailAddress, lastName, firstName, creditCard) VALUES
('data1@test.data', 'Data 1', 'Test', '000-NOT-REAL-000'),
('data2@test.data', 'Data 2', 'Test', '111-NOT-REAL-111'),
('data3@test.data', 'Data 3', 'Test', '222-NOT-REAL-222');

INSERT INTO conference (
	name,
	registrationPrice,
	registrationEndDate,
	website,
	description)
VALUES
	("EnergyCon", 599.99, '2020-12-03', NULL, "All things energy!"),
	("DrinksCon", 600, '2020-12-31', "https://drinks.con", NULL);

CALL Register ('data1@test.data', (SELECT conferenceID FROM conference WHERE name = "EnergyCon"));
CALL Register ('data2@test.data', (SELECT conferenceID FROM conference WHERE name = "DrinksCon"));

SELECT 'Should be "1"' AS `PASS`, (
	SELECT conferenceID FROM conference WHERE registrationPrice = 600
) = (
	SELECT COUNT(*) FROM registration
) AS `CHECK`;

