-- SQL Coffe shop sales analysis
CREATE DATABASE sql_cofee_shop_sales;
USE sql_coffee_shop_sales;


 /* sample data sets

-- Insert Products (7 items from your list)
INSERT INTO products (product_id, product_name, category, price) VALUES
(1001, 'Espresso', 'Coffee', 3.25),
(1002, 'Americano', 'Coffee', 3.75),
(1003, 'Mocha', 'Coffee', 4.75),
(1004, 'Croissant', 'Bakery', 2.75),
(1005, 'Muffin', 'Bakery', 3.25),
(1006, 'Cookie', 'Bakery', 2.25),
(1007, 'Brownie', 'Bakery', 3.50);

-- Insert Stores (6 stores from our discussion)
INSERT INTO stores (store_id, location, city, manager) VALUES
(1, 'Downtown', 'New York', 'Sarah Johnson'),
(2, 'Campus', 'Boston', 'Michael Chen'),
(3, 'Mall', 'Chicago', 'David Wilson'),
(4, 'Station', 'Houston', 'Emily Brown'),
(5, 'Park', 'Miami', 'Robert Garcia'),
(6, 'Airport', 'Denver', 'Lisa Martinez');

-- Insert Sample Customers (10 customers)
 INSERT INTO customers (customer_id, first_name, last_name, email, preferred_store) VALUES
(1, 'James', 'Smith', 'james.smith@email.com', 1),
(2, 'Maria', 'Garcia', 'maria.garcia@email.com', 3),
(3, 'David', 'Johnson', 'david.johnson@email.com', 2),
(4, 'Sarah', 'Williams', 'sarah.williams@email.com', 1),
(5, 'Robert', 'Brown', 'robert.brown@email.com', 4),
(6, 'Lisa', 'Jones', 'lisa.jones@email.com', 5),
(7, 'Michael', 'Miller', 'michael.miller@email.com', 6),
(8, 'Emily', 'Davis', 'emily.davis@email.com', 3),
(9, 'Daniel', 'Martinez', 'daniel.martinez@email.com', 2),
(10, 'Jennifer', 'Hernandez', 'jennifer.hernandez@email.com', 1);

-- Insert Sample Transactions (20 transactions)
INSERT INTO transactions (transaction_id, transaction_date, store_id, customer_id, product_id, quantity, total_amount) VALUES
(100001, '2024-01-15', 3, 1, 1001, 1, 3.25),
(100002, '2024-01-15', 3, NULL, 1004, 2, 5.50),
(100003, '2024-01-15', 5, 3, 1003, 1, 4.75),
(100004, '2024-01-16', 2, 1, 1002, 1, 3.75),
(100005, '2024-01-16', 6, NULL, 1006, 3, 6.75),
(100006, '2024-01-17', 1, 2, 1005, 2, 6.50),
(100007, '2024-01-17', 4, 5, 1007, 1, 3.50),
(100008, '2024-01-18', 3, 4, 1001, 1, 3.25),
(100009, '2024-01-18', 2, NULL, 1004, 1, 2.75),
(100010, '2024-01-19', 5, 6, 1003, 2, 9.50),
(100011, '2024-01-20', 1, 7, 1002, 1, 3.75),
(100012, '2024-01-21', 4, NULL, 1006, 2, 4.50),
(100013, '2024-01-22', 6, 8, 1005, 3, 9.75),
(100014, '2024-01-23', 3, 9, 1007, 1, 3.50),
(100015, '2024-01-24', 2, NULL, 1001, 2, 6.50),
(100016, '2024-01-25', 5, 10, 1004, 1, 2.75),
(100017, '2024-01-26', 1, 1, 1003, 1, 4.75),
(100018, '2024-02-01', 3, 2, 1002, 2, 7.50),
(100019, '2024-02-02', 4, NULL, 1006, 1, 2.25),
(100020, '2024-02-03', 6, 3, 1005, 1, 3.25);
*/


-- creating tables

CREATE TABLE products (
	   product_id INT PRIMARY KEY,
       product_name VARCHAR (25),
       category VARCHAR (25),
       price FLOAT
       );
       
CREATE TABLE Customers (
	   customer_id INT PRIMARY KEY,
       first_name VARCHAR(30),
       last_name VARCHAR(30),
	   email VARCHAR(80),
       preferred_store INT -- fk
       );
 CREATE TABLE stores (
        store_id INT PRIMARY KEY,
        location VARCHAR(25),
        city VARCHAR(25),
        manager VARCHAR(25)
        );
 CREATE TABLE transactions (
        transaction_id INT PRIMARY KEY,
        transaction_date DATE,
        store_id INT, -- fk
        customer_id INT, -- fk
        product_id INT, -- fk
        quantity INT,
        total_amount FLOAT
        );
        
   CREATE TABLE transactions1 (
        transaction_id INT PRIMARY KEY,
        transaction_date DATE,
        store_id INT, -- fk
        customer_id INT, -- fk
        product_id INT, -- fk
        quantity INT,
        total_amount FLOAT
        );     
  
  
 -- foreign key
  ALTER TABLE customers
  ADD FOREIGN KEY (preferred_store)
  REFERENCES stores(store_id);
  
  ALTER TABLE transactions
  ADD FOREIGN KEY (store_id) REFERENCES stores(store_id),
  ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  ADD FOREIGN KEY (product_id) REFERENCES products(product_id);
  
 
 -- project task
 
 -- Task 1: Find total revenue by product category
	SELECT 
           p.category,
           ROUND(SUM(t.total_amount),2) AS total_revenue
	FROM products p
    JOIN transactions t USING (product_id)
    GROUP BY p.category;
  
  -- Task2: Find best selling products by quantity in all stores
  SELECT 
        p.product_id,
        p.product_name,
        p.category,
        SUM(t.quantity) AS total_quantity_sold,
        'Best Selling' AS status
FROM 	products p
JOIN transactions t USING (product_id)
GROUP BY p.product_id, p.product_name
HAVING SUM(t.quantity) = 13
ORDER BY total_quantity_sold DESC;

-- Task 3: List top 5 customers by total spending
SELECT c.customer_id,
       c.first_name,
       ROUND(SUM(t.total_amount),2) AS total_spent
       FROM transactions t
       JOIN customers c ON t.customer_id = c.customer_id
       JOIN products p USING (product_id)
       GROUP BY c.customer_id, c.first_name
       ORDER BY total_spent DESC
       LIMIT 5;

   -- Task 4:Which store has the highest sales by revenue    
   SELECT 
         s.store_id,
         s.location,
         s.city,
         ROUND(SUM(t.total_amount),2) AS total_revenue,
         COUNT(t.transaction_id) AS total_transaction
   FROM stores s
   JOIN transactions t USING (store_id)
   GROUP BY s.store_id, s.location
   ORDER BY total_revenue DESC;
   
   -- Task 5: Write an SQL query to find the best selling year
    SELECT 
         YEAR(transaction_date) AS yearly_sales,
         ROUND(SUM(total_amount),2) AS yearly_revenue
    FROM transactions
    GROUP BY yearly_sales
    ORDER BY yearly_revenue DESC;
    
-- Task 6: Total number of customers each store has in year 2024
SELECT 
     s.location,
     s.city,
     COUNT( DISTINCT t.customer_id) AS total_customers
FROM stores s
JOIN transactions t USING (store_id)
WHERE YEAR(transaction_date) =2024
GROUP BY S.store_id, s.location, s.city
ORDER BY total_customers;
  
  -- Task 7: Write an sql query to calculate the average sale for each month. Find out the best selling month in each year
  SELECT 
       year, 
       month,
       average_sale
       FROM (
            SELECT
                YEAR(transaction_date) AS year,
                MONTH(transaction_date) AS month,
                ROUND(AVG(total_amount),2) AS average_sale,
                RANK() OVER(PARTITION BY YEAR(transaction_date) ORDER BY 
                AVG(total_amount) DESC) AS h
                FROM transactions
                GROUP BY year, month
                ) AS h
        WHERE h =1  
        ORDER BY average_sale
  
  
  


  
  
  
  
  
  
  
          