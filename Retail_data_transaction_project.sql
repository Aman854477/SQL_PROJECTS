Create database RetailSalesData;
USE RetailSalesData;

Create Table Sales_Data_Transactions( 
customer_id varchar(255),
trans_date VARCHAR(255),
tran_amount INT
);

Create Table Sales_Data_Response ( 
customer_id varchar(255) PRIMARY KEY,
response INT
);

DROP Table Sales_Data_Transactions;
DROP Table Sales_Data_Response;
LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\Retails_Data_Transactions.csv'
INTO TABLE Sales_Data_Transactions
FIELDS terminated by ','
LINES terminated by '/n'
IGNORE 1 ROWS;

-- Retrieve all data from sales_data_transactions
Select * From sales_data_transactions;

-- Retrieve all data from sales_data_response
Select * From sales_data_response;

-- Retrieve SUM of transaction amount,customer id from sales_data_transactions

SELECT customer_id, SUM(tran_amount) AS total_spent
FROM sales_data_transactions
GROUP BY customer_id;


-- Retrieve Avg of transactions amount ,group by customer id from sales_data_transactions
SELECT customer_id, AVG(tran_amount) AS avg_transaction
FROM sales_data_transactions
GROUP BY customer_id;

-- Max and Min transactions date from sales_data_transactions
SELECT 
    customer_id,
    MIN(trans_date) AS first_transaction,
    MAX(trans_date) AS last_transaction
FROM sales_data_transactions
GROUP BY customer_id;

-- Ranking of Top 5 customers according to transaction date and amount
SELECT customer_id, trans_date, tran_amount
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY customer_id ORDER BY tran_amount DESC) AS rnk
    FROM sales_data_transactions
) ranked
WHERE rnk <= 5;

-- count the number of occurrences of each response type in the sales_data_response table.
SELECT 
    customer_id,
    response,
    COUNT(*) AS response_count
FROM sales_data_response
GROUP BY customer_id, response;

-- Calculate the average response given by each customer.
SELECT 
    customer_id,
    AVG(CAST(response AS FLOAT)) AS response_rate
FROM sales_data_response
GROUP BY customer_id;


-- List the customers whose responses are always 1
SELECT customer_id
FROM sales_data_response
GROUP BY customer_id
HAVING MIN(response) = 1 AND MAX(response) = 1;

-- List the 10 customers who submitted the highest number of responses, in descending order.
SELECT 
    customer_id,
    COUNT(*) AS total_responses
FROM sales_data_response
GROUP BY customer_id
ORDER BY total_responses DESC
LIMIT 10;
