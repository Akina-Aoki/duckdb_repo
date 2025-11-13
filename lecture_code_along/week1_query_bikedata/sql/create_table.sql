CREATE TABLE
    IF NOT EXISTS bike_data AS (
        SELECT
            *
        FROM
            read_csv_auto ('../data')
    );
    
