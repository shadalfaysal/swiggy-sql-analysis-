-- =====================================================
-- 05. KPIs and deep-dive analysis
-- =====================================================

-- ---------- BASIC KPIs ----------
-- Total Orders
SELECT COUNT(*) AS Total_Orders
FROM fact_swiggy_orders;

-- Total Revenue (INR Million)
SELECT FORMAT(SUM(CONVERT(FLOAT, Price_INR)) / 1000000, 'N2') + ' INR Million' AS Total_Revenue
FROM fact_swiggy_orders;

-- Average Dish Price (INR)
SELECT FORMAT(AVG(CONVERT(FLOAT, Price_INR)), 'N2') + ' INR' AS Average_Dish_Price
FROM fact_swiggy_orders;

-- Average Rating
SELECT FORMAT(AVG(CONVERT(FLOAT, Rating)), 'N2') AS Avg_Rating
FROM fact_swiggy_orders;

-- ---------- DATE-BASED ANALYSIS ----------
-- Monthly orders trend (chronological)
SELECT d.Year, d.Month, d.Month_Name, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year, d.Month, d.Month_Name
ORDER BY d.Year, d.Month;

-- Monthly revenue trend
SELECT d.Year, d.Month, d.Month_Name, SUM(f.Price_INR) AS Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year, d.Month, d.Month_Name
ORDER BY d.Year, d.Month;

-- Quarterly orders trend
SELECT d.Year, d.Quarter, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year, d.Quarter
ORDER BY d.Year, d.Quarter;

-- Year-wise orders (data covers Jan-Aug 2025 only)
SELECT d.Year, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year
ORDER BY d.Year;

-- Day-of-week pattern
SELECT DATENAME(WEEKDAY, d.Full_Date) AS Day_of_Week, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY DATENAME(WEEKDAY, d.Full_Date)
ORDER BY COUNT(*) DESC;

-- ---------- LOCATION-BASED ANALYSIS ----------
-- Top 10 cities by order volume
SELECT TOP 10 l.City, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.City
ORDER BY COUNT(*) DESC;

-- Revenue contribution by state
SELECT
    l.State,
    SUM(f.Price_INR) AS Total_Revenue,
    CAST(100.0 * SUM(f.Price_INR) / SUM(SUM(f.Price_INR)) OVER () AS DECIMAL(5,2)) AS Revenue_Pct
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.State
ORDER BY SUM(f.Price_INR) DESC;

-- ---------- FOOD PERFORMANCE ----------
-- Top 10 restaurants by orders
SELECT TOP 10 r.restaurant_name, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY COUNT(*) DESC;

-- Top categories by orders
SELECT c.category, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY COUNT(*) DESC;

-- Most ordered dishes
SELECT TOP 10 d.dish_name, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.dish_name
ORDER BY COUNT(*) DESC;

-- Cuisine performance (orders + average rating)
SELECT TOP 20
    c.category,
    COUNT(*) AS Total_Orders,
    AVG(CONVERT(FLOAT, f.Rating)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY COUNT(*) DESC;

-- ---------- CUSTOMER SPENDING INSIGHTS ----------
-- Orders by price range (buckets follow the business requirements)
SELECT
    CASE
        WHEN Price_INR < 100  THEN 'Under 100'
        WHEN Price_INR < 200  THEN '100-199'
        WHEN Price_INR < 300  THEN '200-299'
        WHEN Price_INR < 500  THEN '300-499'
        ELSE '500+'
    END AS Price_Range,
    COUNT(*) AS Total_Orders
FROM fact_swiggy_orders
GROUP BY
    CASE
        WHEN Price_INR < 100  THEN 'Under 100'
        WHEN Price_INR < 200  THEN '100-199'
        WHEN Price_INR < 300  THEN '200-299'
        WHEN Price_INR < 500  THEN '300-499'
        ELSE '500+'
    END
ORDER BY MIN(Price_INR);

-- ---------- RATINGS ANALYSIS ----------
-- Rating distribution (rounded to whole stars, 1-5)
SELECT ROUND(Rating, 0) AS Rating_Star, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders
GROUP BY ROUND(Rating, 0)
ORDER BY Rating_Star;
