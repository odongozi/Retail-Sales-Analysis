
CREATE TABLE retail_sales (
    "Order Number" VARCHAR(50),
    "Sales Date" DATE,
    "Sales Channel" VARCHAR(100),
    "Currency" VARCHAR(10),
    Salesteamindex INTEGER,
    Storeindex INTEGER,
    Productindex INTEGER,
    "Order qty" INTEGER,
    "unit price" NUMERIC(12,2),
    "unit cost" NUMERIC(12,2),
    "Sales Team" VARCHAR(100),
    Region VARCHAR(100),
    "Product Name" VARCHAR(150),
    "Product Category" VARCHAR(100),
    name VARCHAR(150),
    county VARCHAR(100),
    state_code VARCHAR(20),
    state VARCHAR(100),
    type VARCHAR(100),
    latitude NUMERIC(10,6),
    longitude NUMERIC(10,6),
    area_code INTEGER,
    population BIGINT,
    households BIGINT,
    median_income NUMERIC(14,2),
    land_area NUMERIC(14,2),
    water_area NUMERIC(14,2),
    time_zone VARCHAR(100),
    revenue NUMERIC(14,2),
    profit NUMERIC(14,2)
 );

SELECT * FROM retail_sales

/*DATA CLEANING
CHECKING FOR NULL VALUES  no null values found*/


SELECT
    column_name,
    (
        xpath(
            '/row/count/text()',
            query_to_xml(
                format(
                    'SELECT COUNT(*) AS count FROM %I WHERE %I IS NULL',
                    'retail_sales',
                    column_name
                ),
                false,
                true,
                ''
            )
        )
    )[1]::text::int AS null_count
FROM information_schema.columns
WHERE table_name = 'retail_sales';

--   checking for duplicate--(no duplicate found)
SELECT "Order Number", COUNT(*)
FROM retail_sales
GROUP BY "Order Number"
HAVING COUNT(*) > 1;


-- BUISNESS ANALYSIS--
--(revenue by sales channels)
SELECT "Sales Channel", sum(revenue) AS total_revenue
FROM retail_sales
GROUP BY "Sales Channel"
ORDER BY total_revenue DESC


--PROFIT MARGIN BY SALES TEAM
SELECT
    "Sales Team",
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(revenue), 0)) * 100,
        2
    ) AS profit_margin_percentage
FROM retail_sales
GROUP BY "Sales Team"
ORDER BY profit_margin_percentage DESC

--ORDERS BY REGION
SELECT
     Region,
    COUNT(DISTINCT "Order Number") AS total_orders
FROM retail_sales
GROUP BY Region
ORDER BY total_orders DESC


--TOP 5 PROFIT MARGIN BY PRODUCT
SELECT
    "Product Name",
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(revenue), 0)) * 100,
        2
    ) AS profit_margin_percentage
FROM retail_sales
GROUP BY "Product Name"
ORDER BY profit_margin_percentage DESC
LIMIT 5


--PRODUCT CATEGORY WITH THE HIGHESTAVERAGE SELLING PRICE
SELECT
    "Product Category",
    ROUND(AVG("unit price"), 2) AS average_selling_price
FROM retail_sales
GROUP BY "Product Category"
ORDER BY average_selling_price DESC
LIMIT 1;
