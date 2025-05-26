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



