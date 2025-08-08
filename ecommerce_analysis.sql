
-- 1. Select users who signed up after 2024-01-01
SELECT * FROM users WHERE created_at > '2024-01-01';

-- 2. Get total revenue per user (GROUP BY + JOIN)
SELECT u.user_id, u.name, SUM(o.total_amount) AS total_revenue
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_revenue DESC;

-- 3. Count of orders per day (GROUP BY + aggregate)
SELECT order_date, COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- 4. Average revenue per user
SELECT AVG(user_total) AS avg_revenue_per_user
FROM (
    SELECT user_id, SUM(total_amount) AS user_total
    FROM orders
    GROUP BY user_id
) AS subquery;

-- 5. Products with no orders (LEFT JOIN)
SELECT p.product_id, p.name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 6. Top 5 selling products (JOIN + GROUP BY + ORDER BY)
SELECT p.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 5;

-- 7. Create a view for total revenue per category
CREATE VIEW category_revenue AS
SELECT p.category, SUM(oi.quantity * oi.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category;

-- 8. Subquery: Users with revenue above average
SELECT u.user_id, u.name
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
HAVING SUM(o.total_amount) > (
    SELECT AVG(user_total)
    FROM (
        SELECT user_id, SUM(total_amount) AS user_total
        FROM orders
        GROUP BY user_id
    ) AS avg_subquery
);

-- 9. Optimizing query using index (Example syntax)
-- CREATE INDEX idx_orders_user_id ON orders(user_id);

-- 10. INNER JOIN of orders with order items
SELECT o.order_id, o.order_date, p.name AS product_name, oi.quantity
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;
