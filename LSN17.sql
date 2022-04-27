/* Quiz at the bottom*/
DROP DATABASE IF EXISTS wpmb;
CREATE DATABASE wpmb;
USE wpmb;

CREATE TABLE person (
	email_addr VARCHAR(255) NOT NULL,
    last_name VARCHAR(35) NOT NULL,
    first_name VARCHAR(35) NOT NULL,
    is_admin BIT NOT NULL,
    PRIMARY KEY (email_addr)
);

CREATE TABLE location (
	location_name VARCHAR(70) NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    street_addr VARCHAR(50),
    city VARCHAR(20),
    state VARCHAR(20),
    country_code CHAR(2),
    postal VARCHAR(20),
    PRIMARY KEY (location_name)
);

CREATE TABLE bird_species (
	species_id int AUTO_INCREMENT NOT NULL,
    genus VARCHAR(35),
    species VARCHAR(35),
    description TEXT,
    PRIMARY KEY (species_id)
);


CREATE TABLE bird_common_name (
	species_id int NOT NULL,
    common_name VARCHAR(70) NOT NULL,
    PRIMARY KEY (species_id),
    FOREIGN KEY (species_id) REFERENCES bird_species(species_id)
);

CREATE TABLE observation (
	observation_id int AUTO_INCREMENT NOT NULL,
    datetime DATETIME NOT NULL,
    location_name VARCHAR(70) NOT NULL,
    PRIMARY KEY (observation_id),
    FOREIGN KEY (location_name) REFERENCES location(location_name)
);

CREATE TABLE personal_observation (
	observation_id int NOT NULL,
    email_addr VARCHAR(255) NOT NULL,
    notes TEXT,
    PRIMARY KEY (observation_id),
    FOREIGN KEY (observation_id) REFERENCES observation(observation_id),
    FOREIGN KEY (email_addr) REFERENCES person(email_addr)
);

CREATE TABLE bird_observed (
	observation_id INT,
	species_id int,
    count INT,
    PRIMARY KEY (observation_id, species_id),
    FOREIGN KEY (observation_id) REFERENCES observation(observation_id),
    FOREIGN KEY (species_id) REFERENCES bird_species(species_id)
);


CREATE USER wpmb_admin;
CREATE USER wpmb_non_administrator;

DELIMITER //

CREATE PROCEDURE EditPerson(
	curr_email_addr VARCHAR(255),
	new_email_addr VARCHAR(255),
    new_last_name VARCHAR(35),
    new_first_name VARCHAR(35)
) 
BEGIN
	UPDATE person 
    SET 
		email_addr = new_email_addr,
		last_name = new_last_name,
		first_name = new_first_name
    WHERE email_addr = curr_email_addr;
END // 

DELIMITER ;


GRANT EXECUTE ON PROCEDURE EditPerson TO wpmb_admin;

INSERT INTO person (email_addr, last_name, first_name, is_admin) VALUES ("admin@admin.a", "Admin", "Alicia",0);
SELECT * FROM person;

/*Lesson Quiz*/

DELIMITER //

CREATE PROCEDURE ViewBirdSpecies_Location(

) 
BEGIN
	SELECT observation.location_name, genus, species, bird_common_name.common_name FROM bird_species
    JOIN bird_observed USING (species_id)
    JOIN observation USING (observation_id)
    JOIN location USING(location.id)
    WHERE location_name = location;
END // 

DELIMITER ;



DELIMITER //

CREATE PROCEDURE ViewLocations_BirdSpecies(

) 
BEGIN
	SELECT observation.location_name, genus, species, bird_common_name.common_name FROM bird_species
		JOIN bird_observed USING (species_id)
		JOIN observation USING (observation_id)
		JOIN location USING(location.id)
    WHERE species_id = species;
END // 

DELIMITER ;


DELIMITER //

CREATE PROCEDURE ViewLocation_BirdCount(

) 
BEGIN
	SELECT observation.location_name, COUNT(species_id) FROM bird_species
	JOIN bird_observed USING (species_id)
    JOIN observation USING (observation_id)
    JOIN location USING (location.id)
    GROUP BY location_name
    ORDER BY (COUNT(species_id));
END // 

DELIMITER ;





