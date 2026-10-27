-- =====================================================
-- 04. Load dimensions (distinct values) and fact table
-- =====================================================

-- dim_date
INSERT INTO dim_date (Full_Date, Year, Month, Month_Name, Quarter, Day, Week)
SELECT DISTINCT
    Order_Date,
    YEAR(Order_Date),
    MONTH(Order_Date),
    DATENAME(MONTH, Order_Date),
    DATEPART(QUARTER, Order_Date),
    DAY(Order_Date),
    DATEPART(WEEK, Order_Date)
FROM swiggy_data
WHERE Order_Date IS NOT NULL;

-- dim_location
INSERT INTO dim_location (State, City, Location)
SELECT DISTINCT State, City, Location
FROM swiggy_data;

-- dim_restaurant
INSERT INTO dim_restaurant (restaurant_name)
SELECT DISTINCT Restaurant_Name
FROM swiggy_data;

-- dim_category
INSERT INTO dim_category (category)
SELECT DISTINCT Category
FROM swiggy_data;

-- dim_dish
INSERT INTO dim_dish (dish_name)
SELECT DISTINCT Dish_Name
FROM swiggy_data;

-- fact_swiggy_orders (resolve all dimension keys)
INSERT INTO fact_swiggy_orders (
    date_id, Price_INR, Rating, Rating_Count,
    location_id, restaurant_id, category_id, dish_id
)
SELECT
    dd.date_id,
    s.Price_INR,
    s.Rating,
    s.Rating_Count,
    dl.location_id,
    dr.restaurant_id,
    dc.category_id,
    dsh.dish_id
FROM swiggy_data s
JOIN dim_date       dd  ON s.Order_Date      = dd.Full_Date
JOIN dim_location   dl  ON s.State = dl.State AND s.City = dl.City AND s.Location = dl.Location
JOIN dim_restaurant dr  ON s.Restaurant_Name = dr.restaurant_name
JOIN dim_category   dc  ON s.Category        = dc.category
JOIN dim_dish       dsh ON s.Dish_Name       = dsh.dish_name;

-- Check: fact rows must equal cleaned source rows (197,403)
SELECT
    (SELECT COUNT(*) FROM swiggy_data)        AS source_rows,
    (SELECT COUNT(*) FROM fact_swiggy_orders) AS fact_rows;

-- Full joined view of the model
SELECT *
FROM fact_swiggy_orders f
JOIN dim_date       d  ON f.date_id       = d.date_id
JOIN dim_location   l  ON f.location_id   = l.location_id
JOIN dim_restaurant r  ON f.restaurant_id = r.restaurant_id
JOIN dim_category   c  ON f.category_id   = c.category_id
JOIN dim_dish       di ON f.dish_id       = di.dish_id;
