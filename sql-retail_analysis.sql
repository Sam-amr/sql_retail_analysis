DROP TABLE IF EXISTS retail_sales;

-- CREATE TABLE --
CREATE TABLE retail_sales 
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- View all rows
SELECT * FROM retail_sales;

-- Check NULLs column by column
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE sale_time IS NULL;
SELECT * FROM retail_sales WHERE customer_id IS NULL;
SELECT * FROM retail_sales WHERE gender IS NULL;
SELECT * FROM retail_sales WHERE age IS NULL;
SELECT * FROM retail_sales WHERE category IS NULL;
SELECT * FROM retail_sales WHERE quantity IS NULL;
SELECT * FROM retail_sales WHERE price_per_unit IS NULL;
SELECT * FROM retail_sales WHERE cogs IS NULL;
SELECT * FROM retail_sales WHERE total_sale IS NULL;
---
-- DELETE rows with NULL values in any column
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

 ---DATA EXPLORATION---
 --how many sales do we have 
 SELECT COUNT(*) as total_sale FROM retail_sales
 --
 --how many customers do we have 
 SELECT COUNT(DISTINCT customer_id)as total_sale FROM retail_sales
 --

 --how many categories and category names
 SELECT COUNT(DISTINCT category)as total_sale FROM retail_sales
 SELECT DISTINCT category FROM retail_sales
 ---

----DATA ANALYSIS---

--Q1. Write a SQL Querry to retrieve all columns for sales made on 2022-11-05--
SELECT*
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2. Write a SQL Querry to retrieve all transactions where the category is clothing, quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 3

--Q3. Write a SQL Querry to calculate total sales for each category--
SELECT
      category,
	  SUM(total_sale) as net_sale,
	  COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--Q4. Write a SQL Query to find average age of customers who bought items from beauty category---
SELECT 
   ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category='Beauty'

--Q5. Write a SQL Query to find all transactions where total_sale is greater than 1000---
SELECT * FROM retail_sales
WHERE total_sale > 1000

--Q6. Write a SQL Query to find the total number of transactions made by each gender in each category
SELECT
      category,
      gender,
COUNT(*) AS total_trans
FROM retail_sales
GROUP 
   BY
    category,
    gender
ORDER BY 1

--Q7. Write a SQL Query to calculate average sale for each month. Find out best selling month of each year.
SELECT
     year,
     month,
	 avg_sale
FROM
(
SELECT 
      EXTRACT(YEAR FROM sale_date) as year,
      EXTRACT(MONTH FROM sale_date) as month,
      AVG(total_sale) as avg_sale,   -- <--- comma added here
      RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank = 1

--Q8. Write a SQL Query to find top 5 customers based on highest total_sale
SELECT
      customer_id,
	  SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

---Q9. Write a SQL Query to find the number of unique customers who purchased items from each category
SELECT
      category,
	  COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

---Q10. Write a SQL Query to create each shift and number of orders
WITH hourly_sale
AS
(
SELECT*,
   CASE
   WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
  ELSE 'Evening'
 END as shift
FROM retail_sales
)
SELECT
     shift,
     COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
SELECT EXTRACT(HOUR FROM CURRENT_TIME)






