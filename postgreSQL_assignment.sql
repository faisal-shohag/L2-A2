CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    region VARCHAR(50) NOT NULL
)

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
)

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL,
    species_id INT NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT,
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id),
    FOREIGN KEY (species_id) REFERENCES species(species_id)
)


INSERT INTO rangers (name, region) 
VALUES 
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range'),
('Charlie Red', 'Eastern Forest'),
('Diana Yellow', 'Western Plains'),
('Eve Purple', 'Central Valley');





INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered'),
('Bald Eagle', 'Haliaeetus leucocephalus', '1960-01-01', 'Vulnerable'),
('Black Bear', 'Ursus americanus', '1970-01-01', 'Endangered'),
('Coyote', 'Coyote', '1800-01-01', 'Vulnerable'),
('Grizzly Bear', 'Ursus arctos', '1900-01-01', 'Endangered'),
('Moose', 'Alces alces', '1900-01-01', 'Vulnerable'),
('Red Fox', 'Vulpes vulpes', '1900-01-01', 'Endangered');
               |


INSERT INTO sightings (ranger_id, species_id, sighting_time, location, notes)
VALUES
(1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
(2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
(3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
(2, 1, '2024-05-18 18:30:00', 'Snowfall Pass', NULL);



-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name, region)
VALUES 
('Darek Fox', 'Coastal Plains');


-- 2️⃣ Count unique species ever sighted.
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings


-- 3️⃣ Find all sightings where the location includes "Pass".
SELECT * FROM sightings 
WHERE location LIKE '%Pass%';


-- 4️⃣ List each ranger's name and their total number of sightings.
SELECT name, COUNT(*) AS total_sightings FROM rangers
JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY name;


-- 5️⃣ List species that have never been sighted.
SELECT common_name FROM species
WHERE species_id NOT IN (SELECT DISTINCT species_id FROM sightings);

-- 6️⃣ Show the most recent 2 sightings.
SELECT species.common_name, sighting_time, rangers.name
FROM sightings
JOIN species ON species.species_id = sightings.species_id
JOIN rangers ON rangers.ranger_id = sightings.ranger_id
ORDER BY sighting_time DESC
LIMIT 2;

-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';
-- WHERE EXTRACT YEAR FROM discovery_date < 1800;


-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT sighting_id,
CASE
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 and 17 THEN 'Afternoon'
    ELSE 'Evening'
END
as time_of_day
from sightings;


-- 9️⃣ Delete rangers who have never sighted any species
DELETE FROM rangers
where ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);



