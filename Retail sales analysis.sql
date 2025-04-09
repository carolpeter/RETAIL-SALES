Create a database 

CREATE DATABASE RETAIL_SALES_ANALYSIS

Create a table

CREATE TABLE RETAIL_SALES (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(45),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

DATA CLEANING
CHECK FOR NULLS

SELECT *
FROM retail_sales
WHERE sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit	IS NULL
OR cogs IS NULL
OR total_sale IS NULL;


DATA EXPLORATION

1. How many sales we have 

SELECT
COUNT(*) AS TOTAL_SALES
FROM retail_sales;

2. How many unique customers we have 

SELECT 
COUNT(DISTINCT customer_id) AS TOTAL_NUMBER_OF_CUSTOMERS
FROM retail_sales;

3.How many unique categories we have 

SELECT 
COUNT(DISTINCT category) AS TOTAL_NUMBER_OF_CATEGORIES
FROM retail_sales;

DATA ANALYSIS & KEY BUSINESS PROBLEMS

1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >=4
AND sale_date LIKE '2022-11-_%';
    
3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
category,
SUM(total_sale) AS TOTAL_SALES
FROM retail_sales
GROUP BY category;

4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
category,
ROUND(AVG(age),2) AS AVG_AGE
FROM retail_sales
WHERE category = 'Beauty';

OR 

SELECT
ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT*
FROM retail_sales
WHERE total_sale > 1000;

6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
category,
gender,
COUNT(transactions_id) AS TOTAL_NUMBER_OF_TRANSACTIONS
FROM retail_sales
GROUP BY gender,category
ORDER BY category;

7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

(WITHOUT RANKS)
SELECT 
YEAR(sale_date) AS YEAR,
MONTH(sale_date) AS MONTH,
AVG(total_sale) AS AVG_SALES
FROM retail_sales
GROUP BY MONTH(sale_date),YEAR(sale_date)
ORDER BY AVG_SALES DESC;

(WITH RANKS)

SELECT 
YEAR(sale_date) AS YEAR,
MONTH(sale_date) AS MONTH,
AVG(total_sale) AS AVG_SALES,
RANK() OVER (
PARTITION BY YEAR(sale_date)
ORDER BY AVG(total_sale) DESC
) AS RANKS
FROM retail_sales
GROUP BY MONTH(sale_date),YEAR(sale_date)
ORDER BY RANKS;

8. Write a SQL query to find the top 5 customers based on the highest total sales

(WITHOU RANKS)
SELECT
customer_id,
SUM(total_sale) AS TOTAL_SALES
FROM retail_sales
GROUP BY customer_id
ORDER BY TOTAL_SALES DESC
LIMIT 5;

(WITH RANKS)

SELECT
customer_id,
SUM(total_sale) AS TOTAL_SALES,
RANK() OVER (
ORDER BY SUM(total_sale) DESC
) AS RANKS
FROM retail_sales
GROUP BY customer_id
ORDER BY RANKS
LIMIT 5;


9. Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT
category,
COUNT(DISTINCT customer_id) AS CUSTOMERS_PER_CATEGORY
FROM retail_sales
GROUP BY category;

10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'MORNING'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS SHIFT,
    COUNT(transactions_id) AS NUMBER_OF_ORDERS
FROM retail_sales
GROUP BY 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'MORNING'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END
ORDER BY SHIFT;
