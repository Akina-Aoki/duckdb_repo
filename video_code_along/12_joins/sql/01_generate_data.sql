-- create plants dataset 

CREATE TABLE IF NOT EXISTS main.plants ( -- Define plants table
	plant_id INTEGER PRIMARY KEY, -- constraint: primary key
	plant_name TEXT UNIQUE,
	type TEXT
);

CREATE TABLE IF NOT EXISTS plant_care ( -- Define plant_care table
    id INTEGER PRIMARY KEY, -- constraint: primary key
    plant_id INTEGER,
    water_schedule TEXT,
    sunlight TEXT
);


-- Insert data into plants and plant_care tables, the type columns
INSERT INTO main.plants (plant_id, plant_name, type) 
VALUES
	(1, 'Rose', 'Flower'),
	(2, 'Oak', 'Tree'),
	(3, 'Tulip', 'Flower'),
	(4, 'Cactus', 'Succulent'),
	(5, 'Sunflower', 'Flower');

INSERT INTO main.plant_care (id, plant_id, water_schedule, sunlight) 
VALUES
	(1, 1, 'Daily', 'Full Sun'),
	(2, 3, 'Weekly', 'Partial Sun'),
	(3, 4, 'Biweekly', 'Full Sun'),
	(4, 6, 'Daily', 'Shade');

/* INGESTION 
duckdb plants.duckdb < sql/02_generate_data.sql
duckdb -ui plants.duckdb
*/