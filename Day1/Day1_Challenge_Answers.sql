/*SQL Tasks
#1. List all customers who have placed at least one order.
2. Find the total amount spent by each customer.
3. Display the top 3 customers based on total spending.
4. Retrieve all orders placed in the last 7 days (from latest order date).
5. Show customers who have never placed an order.
6. Find the restaurant that received the highest number of orders.
7. List customers from “Bengaluru” who spent more than ₹1000.
8. Show the total number of orders placed per city.
9. Find the average order amount for each restaurant.
10. Identify customers who placed more than 5 orders.//..*/

create database online_food
use online_food
create table Customers(
customer_id INT primary key,
name VARCHAR(50),
city VARCHAR(50)
);

create table Orders(
order_id INT primary key,
customer_id INT,
restaurant VARCHAR(50),
amount DECIMAL(10,2),
order_date DATE)

INSERT INTO Customers (customer_id, name, city) VALUES
(1, 'Arjun', 'Bengaluru'),
(2, 'Sneha', 'Hyderabad'),
(3, 'Rahul', 'Chennai'),
(4, 'Priya', 'Bengaluru'),
(5, 'Kiran', 'Mumbai'),
(6, 'Divya', 'Bengaluru'),
(7, 'Vikram', 'Hyderabad'),
(8, 'Asha', 'Chennai'),
(9, 'Manoj', 'Pune'),
(10, 'Swathi', 'Bengaluru');

INSERT INTO Orders (order_id, customer_id, restaurant, amount, order_date) VALUES
(101, 1, 'Meghana Foods', 550.00, '2025-01-01'),
(102, 2, 'Paradise Biryani', 780.00, '2025-01-03'),
(103, 3, 'KFC', 420.00, '2025-01-05'),
(104, 1, 'Empire Restaurant', 300.00, '2025-01-08'),
(105, 4, 'Meghana Foods', 950.00, '2025-01-10'),
(106, 6, 'Truffles', 1100.00, '2025-01-11'),
(107, 7, 'Kritunga', 650.00, '2025-01-12'),
(108, 4, 'KFC', 350.00, '2025-01-14'),
(109, 9, 'Burger King', 270.00, '2025-01-15'),
(110, 10, 'Meghana Foods', 1250.00, '2025-01-16');

select * from customers
select * from orders


-- 1. List all customers who have placed at least one order.
SELECT DISTINCT
    c.customer_id, c.name, c.city
FROM
    Customers c
        JOIN
    Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- 2. Find the total amount spent by each customer.

SELECT 
    c.customer_id,
    c.name,
    COALESCE(SUM(o.amount), 0) AS total_spent
FROM
    Customers c
LEFT JOIN Orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.name
ORDER BY total_spent DESC;

-- 3. Display the top 3 customers based on total spending.
SELECT 
    c.customer_id,
    c.name,
    COALESCE(SUM(o.amount), 0) AS total_spent
FROM
    Customers c
LEFT JOIN Orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.name
ORDER BY total_spent DESC limit 3;

-- 4. Retrieve all orders placed in the last 7 days (from latest order date).
SELECT 
    *
FROM
    orders
WHERE
    order_date >= (SELECT 
            DATE_SUB(MAX(order_date),
                    INTERVAL 6 DAY)
        FROM
            orders)
ORDER BY order_date

-- 5. Show customers who have never placed an order.
SELECT 
    c.customer_id, c.name, c.city
FROM
    customers c
        LEFT JOIN
    orders o ON o.customer_id = c.customer_id
WHERE
    order_id IS NULL
GROUP BY customer_id

-- 6. Find the restaurant that received the highest number of orders.
SELECT 
    restaurant, COUNT(*) AS num_orders
FROM
    Orders
GROUP BY restaurant
HAVING COUNT(*) = (SELECT 
        MAX(cnt)
    FROM
        (SELECT 
            restaurant, COUNT(*) AS cnt
        FROM
            Orders
        GROUP BY restaurant) AS t)
ORDER BY restaurant;

-- 7. Bengaluru customers who spent more than ₹1000
SELECT 
    c.customer_id, c.name, SUM(o.amount) AS total_spent
FROM
    Customers c
        JOIN
    Orders o ON c.customer_id = o.customer_id
WHERE
    c.city = 'Bengaluru'
GROUP BY c.customer_id , c.name
HAVING total_spent > 1000
ORDER BY total_spent DESC;

-- 8. Total number of orders placed per city
SELECT 
    c.city, COUNT(o.order_id) AS total_orders
FROM
    Customers c
        LEFT JOIN
    Orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;

-- 9. Average order amount per restaurant
SELECT 
    restaurant,
    ROUND(AVG(amount), 2) AS avg_amount,
    COUNT(*) AS orders_count
FROM
    Orders
GROUP BY restaurant
ORDER BY avg_amount DESC;

-- 10. Customers who placed more than 5 orders
SELECT 
    c.customer_id, c.name, COUNT(o.order_id) AS num_orders
FROM
    Customers c
        JOIN
    Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.name
HAVING num_orders > 5
ORDER BY num_orders DESC;
