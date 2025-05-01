# 🧠 Advanced SQL Project – Sales Analysis & Data Insights

This project demonstrates the application of **advanced SQL techniques** to perform in-depth sales analysis and uncover business insights. The analysis includes handling `NULL` values, generating date series, and combining multiple tables to deliver accurate, actionable results.

## 🔧 What’s Covered:
- ✅ Sales data exploration and cleaning
- ✅ Merging and transforming tables for comprehensive analysis
- ✅ Generating dynamic date series for time-based metrics
- ✅ Tackling incomplete data with smart handling of `NULL` values

## 🧠 Advanced SQL Concepts Applied:
✔ `UNION` / `UNION ALL`  
✔ Subqueries  
✔ `LEFT JOIN` / `INNER JOIN`  
✔ CTEs & Recursive CTEs  
✔ Date Expressions  
✔ `CAST`, `COALESCE`, `ROUND`  
✔ Window Functions

## Includes some advanced SQL queries like

# FILL IN THE NULL VALUES (NULL FUNCTION, NUMERIC FUNCTION)

```sql

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

```

# updating sales values using window functions

```sql

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

```
# Results & Findings

Data Gap Handling:
During our advanced SQL data analysis, we identified missing data for certain dates. 
To address this, we imputed the gaps by calculating the average sales value using the preceding and following day's data, 
ensuring continuity and accuracy in our analysis.

All SQL work files are uploaded for reference and learning.  
This project showcases real-world problem-solving using SQL 
and reflects a deep understanding of database querying for data-driven decision-making.
