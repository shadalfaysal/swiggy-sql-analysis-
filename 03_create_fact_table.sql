-- =====================================================
-- 03. Star schema: fact table
-- =====================================================
CREATE TABLE fact_swiggy_orders (
    order_id      INT IDENTITY(1,1) PRIMARY KEY,
    date_id       INT,
    Price_INR     DECIMAL(10,2),
    Rating        DECIMAL(4,2),
    Rating_Count  INT,
    location_id   INT,
    restaurant_id INT,
    category_id   INT,
    dish_id       INT,
    FOREIGN KEY (date_id)       REFERENCES dim_date(date_id),
    FOREIGN KEY (location_id)   REFERENCES dim_location(location_id),
    FOREIGN KEY (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
    FOREIGN KEY (category_id)   REFERENCES dim_category(category_id),
    FOREIGN KEY (dish_id)       REFERENCES dim_dish(dish_id)
);
