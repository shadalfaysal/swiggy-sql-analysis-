-- =====================================================
-- 00. Raw table + load CSV (SQL Server)
-- Source file: data/Swiggy_Data.csv  (197,430 rows)
-- Note: Order Date in the CSV is dd-mm-yyyy
-- =====================================================
CREATE TABLE swiggy_data (
    State           VARCHAR(100),
    City            VARCHAR(100),
    Order_Date      DATE,
    Restaurant_Name VARCHAR(300),
    Location        VARCHAR(300),
    Category        VARCHAR(300),
    Dish_Name       VARCHAR(500),
    Price_INR       DECIMAL(10,2),
    Rating          DECIMAL(4,2),
    Rating_Count    INT
);

-- Option A: BULK INSERT (SQL Server 2017+). Change the path first.
SET DATEFORMAT dmy;
BULK INSERT swiggy_data
FROM 'C:\path\to\Swiggy_Data.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDQUOTE = '"', CODEPAGE = '65001');

-- Option B: SSMS -> Tasks -> Import Flat File, then rename columns as above.

-- Sanity check: expect 197,430 rows
SELECT COUNT(*) AS raw_rows FROM swiggy_data;
