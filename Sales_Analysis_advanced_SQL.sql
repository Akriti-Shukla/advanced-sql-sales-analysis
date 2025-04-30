-- Create 2 tables and demo 12 advanced SQL concepts

-- create a new database

CREATE DATABASE SalesAnalysis;

-- create a sales table
CREATE TABLE sales (
    dt DATE,
    num_sales INT
);

-- insert sales data into the table
INSERT INTO sales (dt, num_sales)
VALUES
    ('2025-01-01', 61),
    ('2025-01-02', 72),
    ('2025-01-04', 84),
    ('2025-01-05', 95),
    ('2025-01-07', 77);
    
-- create a final sales table
CREATE TABLE final_sales (
    dt DATE,
    num_sales INT
);

-- insert final sales data into the table
INSERT INTO final_sales (dt, num_sales)
VALUES
    ('2025-01-01', 61),
    ('2025-01-02', 72),
    ('2025-01-03', 78),
    ('2025-01-04', 84),
    ('2025-01-05', 95),
    ('2025-01-06', 86),
    ('2025-01-07', 77);
    
    
SELECT *
FROM sales;

SELECT *
FROM final_sales;

-- GENERATE A SERIES OF DATES (UNION, UNION ALL)

SELECT '2025-01-01' AS dt
UNION
SELECT '2025-01-02'
UNION
SELECT '2025-01-03'
;

-- UNION - REMOVES THE DUPLICATES
SELECT '2025-01-01' AS dt
UNION
SELECT '2025-01-02'
UNION
SELECT '2025-01-02'
;

-- UNION ALL - KEEPS THE DUPLICATES
SELECT '2025-01-01' AS dt
UNION
SELECT '2025-01-02'
UNION ALL
SELECT '2025-01-02'
;

-- JOIN WITH OUR ORIGINAL TABLE (Subquery, Left Join, Inner Join)

SELECT sq.dt, sales.num_sales FROM

(SELECT '2025-01-01' AS dt
UNION ALL
SELECT '2025-01-02'
UNION ALL
SELECT '2025-01-03'
UNION ALL
SELECT '2025-01-04'
UNION ALL
SELECT '2025-01-05'
UNION ALL
SELECT '2025-01-06'
UNION ALL
SELECT '2025-01-07') AS sq

LEFT JOIN sales ON
sq.dt = sales.dt;

-- inner join

SELECT sq.dt, sales.num_sales FROM

(SELECT '2025-01-01' AS dt
UNION ALL
SELECT '2025-01-02'
UNION ALL
SELECT '2025-01-03'
UNION ALL
SELECT '2025-01-04'
UNION ALL
SELECT '2025-01-05'
UNION ALL
SELECT '2025-01-06'
UNION ALL
SELECT '2025-01-07') AS sq

INNER JOIN sales ON
sq.dt = sales.dt;


-- rewrite subquery as a CTE

WITH CTE AS (SELECT '2025-01-01' AS dt
			UNION ALL
			SELECT '2025-01-02'
			UNION ALL
			SELECT '2025-01-03'
			UNION ALL
			SELECT '2025-01-04'
			UNION ALL
			SELECT '2025-01-05'
			UNION ALL
			SELECT '2025-01-06'
			UNION ALL
			SELECT '2025-01-07')
SELECT cte.dt, sales.num_sales
FROM cte LEFT JOIN sales ON cte.dt=sales.dt;


-- REWRITE CTE AS A RECURSIVE CTE (RECURSIVE CTE, DATE EXPRESSION, DATE FUNCTION)

WITH RECURSIVE CTE AS (SELECT CAST('2025-01-01' AS DATE) AS dt
						UNION ALL
						SELECT dt + INTERVAL 1 DAY
                        FROM cte
                        WHERE dt < CAST('2025-01-07' AS DATE)
)
SELECT * FROM cte;


WITH RECURSIVE CTE AS (SELECT CAST('2025-01-01' AS DATE) AS dt
						UNION ALL
						SELECT dt + INTERVAL 1 DAY
                        FROM cte
                        WHERE dt < CAST('2025-01-07' AS DATE)
)
SELECT cte.dt, sales.num_sales
FROM cte LEFT JOIN sales ON cte.dt=sales.dt;

-- FILL IN THE NULL VALUES (NULL FUNCTION, NUMERIC FUNCTION)

WITH RECURSIVE CTE AS (SELECT CAST('2025-01-01' AS DATE) AS dt
						UNION ALL
						SELECT dt + INTERVAL 1 DAY
                        FROM cte
                        WHERE dt < CAST('2025-01-07' AS DATE)
)
SELECT cte.dt, sales.num_sales,
		coalesce(sales.num_sales, 0) AS sales_estimate,
        coalesce(sales.num_sales, ROUND((SELECT AVG(sales.num_sales) FROM sales),1)) AS sales_estimate2
FROM cte LEFT JOIN sales ON cte.dt=sales.dt;

-- INTRODUCE WINDOW FUNCTIONS

SELECT dt, num_sales,
		ROW_NUMBER() OVER() AS row_num
FROM sales;

SELECT dt, num_sales,
		ROW_NUMBER() OVER() AS row_num,
        LAG(num_sales) OVER() AS prior_sales,
        LEAD(num_sales) OVER() AS next_sales
FROM sales;

-- updating sales values using window functions

WITH RECURSIVE CTE AS (SELECT CAST('2025-01-01' AS DATE) AS dt
						UNION ALL
						SELECT dt + INTERVAL 1 DAY
                        FROM cte
                        WHERE dt < CAST('2025-01-07' AS DATE)
)
SELECT cte.dt, sales.num_sales,
		coalesce(sales.num_sales, 0) AS sales_estimate,
        coalesce(sales.num_sales, ROUND((SELECT AVG(sales.num_sales) FROM sales),1)) AS sales_estimate2,
        coalesce(sales.num_sales, ROUND((LAG(num_sales) OVER()+LEAD(num_sales) OVER())/2,1)) AS sales_estimate3
FROM cte LEFT JOIN sales ON cte.dt=sales.dt;









