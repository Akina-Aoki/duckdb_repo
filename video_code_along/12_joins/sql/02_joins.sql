SELECT
    *
FROM
    main.plant_care;

SELECT
    *
FROM
    main.plants;

-- LEFT JOIN
SELECT
    p.plant_id,
    p.plant_name,
    p.type,
    pc.water_schedule,
    pc.sunlight
FROM
    main.plants p
    LEFT JOIN main.plant_care pc ON p.plant_id = pc.plant_id;

-- RIGHT JOIN
SELECT
    p.plant_id,
    p.plant_name,
    p.type,
    pc.water_schedule,
    pc.sunlight
FROM
    main.plants p  -- LEFT Table: main.plants (Because it was written first, after FROM).
                    -- RIGHT Table: main.plant_care (Because it was written second, after JOIN).

    RIGHT JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
    -- The ON statement tells SQL: "Glue these two rows together ONLY when the ID number in table p 
    -- is the exact same as the ID number in table pc


-- INNER JOIN 
SELECT
    p.plant_id,
    p.plant_name,
    p.type,
    pc.water_schedule,
    pc.sunlight
FROM
    main.plants p
    INNER JOIN main.plant_care pc ON p.plant_id = pc.plant_id;

-- FULL JOIN
SELECT
    p.plant_id,
    p.plant_name,
    p.type,
    pc.water_schedule,
    pc.sunlight
FROM
    main.plants p
    FULL JOIN main.plant_care pc ON p.plant_id = pc.plant_id;

SELECT
    *
FROM
    main.plants p;


-- cross join, joins everything row in plants with every row in plant_care
SELECT
    p.plant_id,
    p.plant_name,
    pc.water_schedule,
    pc.sunlight
FROM
    plants p
    CROSS JOIN plant_care pc;