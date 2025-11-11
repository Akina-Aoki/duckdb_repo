/*
Change EN to "Entry Level", MI to "Mid Level", SE to "Senior Level", EX to "Executive Level"
-- use CASE WHEN for conditional logic in SQL
THIS IS WITHOUT AN "END AS" ALIAS

*/
SELECT
    CASE
        WHEN experience_level = 'SE' THEN 'Senior level'
        WHEN experience_level = 'MI' THEN 'Mid level'
        WHEN experience_level = 'EN' THEN 'Entry level'
        WHEN experience_level = 'EX' THEN 'Expert level'    
    END AS experience_level
    * EXCLUDE (experience_level), * EXCLUDE (experience_level)
FROM data_jobs;

-- UPDATE AND CHANGE THE DATA BASE:
-- persist the changes
UPDATE data_jobs SET experience_level =     
    CASE    
        WHEN experience_level = 'SE' THEN 'Senior level'
        WHEN experience_level = 'MI' THEN 'Mid level'
        WHEN experience_level = 'EN' THEN 'Entry level'
        WHEN experience_level = 'EX' THEN 'Expert level'    
    END;

-- chech if persisted and correctly formatted
FROM data_jobs;

-- show distinct experience levels

SELECT DISTINCT
    experience_level
FROM
    data_jobs; 