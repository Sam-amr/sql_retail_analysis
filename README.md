# RETAIL ANALYSIS USING SQL 

## Overview
The retail sales analysis project focuses on understanding sales data from a retail store using SQL queries. The main tasks include cleaning the data, exploring customer and product information, and analyzing sales trends. Key insights include total sales per category, average monthly sales, top customers, peak shopping hours, and customer demographics. This helps businesses make data-driven decisions to improve sales, optimize inventory, and understand customer behavior.

## Objectives: 

1. Clean the data by identifying and removing rows with missing or NULL values to ensure accurate analysis.

2. Explore the data to understand total sales, customers, and product categories.

3. Analyze sales patterns by calculating total sales per category, average sales per month, and identifying top-selling products or periods.

4. Understand customer behavior by finding average age of buyers in each category, top customers, and gender-based purchase trends.

5. Generate operational insights by identifying peak shopping shifts and large transactions to help business decisions.

## Tool Used
PostgreSQL

## Data Source
Kaggle

## Schema 
``` sql
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
SELECT * FROM retail_sales;
```
## Find And Delete The Null Values In The Table 

``` sql
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

```

## Data Exploration 

### Number of Sales
``` sql
 SELECT COUNT(*) as total_sale FROM retail_sales
```

### Number of Customers
``` sql
SELECT COUNT(DISTINCT customer_id)as total_sale FROM retail_sales
```

### Number of Categories and their Names
``` sql
SELECT COUNT(DISTINCT category)as total_sale FROM retail_sales
 SELECT DISTINCT category FROM retail_sales
```

## Data  Analysis 
### Q1. . Write a SQL Querry to retrieve all columns for sales made on 2022-11-05
``` sql
SELECT*
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### Q2. Write a SQL Querry to retrieve all transactions where the category is clothing, quantity sold is more than 3 in the month of Nov-2022
``` sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 3
```

### Q3. Write a SQL Querry to calculate total sales for each category
``` sql
SELECT
      category,
	  SUM(total_sale) as net_sale,
	  COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

### Q4. Write a SQL Query to find average age of customers who bought items from beauty category
``` sql
SELECT 
   ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category='Beauty'
```

### Q5. Write a SQL Query to find all transactions where total_sale is greater than 1000
``` sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

### Q6. Write a SQL Query to find the total number of transactions made by each gender in each category.
``` sql
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
```

### Q7. Write a SQL Query to calculate average sale for each month. Find out best selling month of each year.
``` sql
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
````

### Q8. Write a SQL Query to find top 5 customers based on highest total_sale
``` sql
SELECT
      customer_id,
	  SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

### Q9. Write a SQL Query to find the number of unique customers who purchased items from each category
``` sql 
SELECT
      category,
	  COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

### Q10. Write a SQL Query to create each shift and number of orders
``` sql
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
```
## Key Insights 
1. The dataset contains a clear picture of total sales and the number of unique customers, helping understand overall business volume.

2. Analysis of sales by category shows which product categories generate the highest revenue and the most orders.

3. The average age of customers per category highlights the primary age groups interested in specific products.

4. Gender-wise transaction counts reveal the distribution of sales between male and female customers in each category.

5. High-value transactions (total sales above 1000) indicate premium purchases and important customers for the business.

6. Top customers were identified based on total sales, highlighting loyal and high-value buyers.

7. Monthly sales trends and ranking show peak sales months, helping to plan inventory and marketing strategies.

8. Shift-wise analysis indicates the busiest times of day for sales, useful for operational planning.

9. Analysis of bulk purchases (e.g., clothing with quantity >=3) reveals customer buying patterns for large orders.

10. Counting unique customers per category shows the reach and popularity of each product type among the customer base.

## Conclusion
In this project, I cleaned the retail sales data by removing missing values, explored key information such as total sales, customers, and product categories, and performed various analyses using SQL. I calculated total and average sales, identified top customers and best-selling categories, analyzed customer demographics like age and gender, and examined sales patterns by month and shopping shifts. Overall, the project demonstrated how to use SQL to extract meaningful insights from retail data to support business decisions.
