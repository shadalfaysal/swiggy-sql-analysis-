-- =====================================================
-- 02. Star schema: dimension tables
-- =====================================================
CREATE TABLE dim_date (
    date_id    INT IDENTITY(1,1) PRIMARY KEY,
    Full_Date  DATE,
    Year       INT,
    Month      INT,
    Month_Name VARCHAR(20),
    Quarter    INT,
    Day        INT,
    Week       INT
);

CREATE TABLE dim_location (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    State       VARCHAR(100),
    City        VARCHAR(100),
    Location    VARCHAR(300)
);

CREATE TABLE dim_restaurant (
    restaurant_id   INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_name VARCHAR(300)
);

CREATE TABLE dim_category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category    VARCHAR(300)
);

CREATE TABLE dim_dish (
    dish_id   INT IDENTITY(1,1) PRIMARY KEY,
    dish_name VARCHAR(500)
);
