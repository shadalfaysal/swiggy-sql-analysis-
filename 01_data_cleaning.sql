-- =====================================================
-- 01. Data validation and cleaning
-- =====================================================

-- 1) NULL checks
SELECT
    SUM(CASE WHEN State           IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN City            IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN Order_Date      IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END) AS null_restaurant,
    SUM(CASE WHEN Location        IS NULL THEN 1 ELSE 0 END) AS null_location,
    SUM(CASE WHEN Category        IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN Dish_Name       IS NULL THEN 1 ELSE 0 END) AS null_dish,
    SUM(CASE WHEN Price_INR       IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN Rating          IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN Rating_Count    IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM swiggy_data;

-- 2) Blank / empty string checks (text columns only;
--    numeric/date columns are covered by the NULL check above)
SELECT *
FROM swiggy_data
WHERE LTRIM(RTRIM(State))           = ''
   OR LTRIM(RTRIM(City))            = ''
   OR LTRIM(RTRIM(Restaurant_Name)) = ''
   OR LTRIM(RTRIM(Location))        = ''
   OR LTRIM(RTRIM(Category))        = ''
   OR LTRIM(RTRIM(Dish_Name))       = '';

-- 3) Duplicate detection
SELECT
    State, City, Order_Date, Restaurant_Name, Location, Category,
    Dish_Name, Price_INR, Rating, Rating_Count,
    COUNT(*) AS duplicate_count
FROM swiggy_data
GROUP BY State, City, Order_Date, Restaurant_Name, Location, Category,
         Dish_Name, Price_INR, Rating, Rating_Count
HAVING COUNT(*) > 1;

-- 4) Delete duplicates (keep one copy of each)
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY State, City, Order_Date, Restaurant_Name, Location,
                            Category, Dish_Name, Price_INR, Rating, Rating_Count
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM swiggy_data
)
DELETE FROM CTE WHERE rn > 1;

-- Check: expect 197,403 rows after removing 27 duplicates
SELECT COUNT(*) AS clean_rows FROM swiggy_data;
