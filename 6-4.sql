USE test_db;

-- 1. Xóa các bảng theo thứ tự từ bảng con đến bảng mẹ để tránh lỗi Foreign Key
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS Order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- 2. Khởi tạo lại các bảng mẹ
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    category_id INT
);

-- 3. Khởi tạo lại các bảng con (có chứa Foreign Key)
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT,
    price DOUBLE,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 4. Chèn dữ liệu mẫu ban đầu cho customers & products
INSERT INTO customers (name, email) VALUES 
('Nguyễn Văn An', 'an@example.com'),
('Trần Thị Bình', 'binh@example.com');

INSERT INTO products (name, price, category_id) VALUES
('Laptop Dell Inspiron 15', 14500000, 1),
('Laptop Asus ROG Strix', 28000000, 1),
('Laptop Acer Aspire', 11000000, 1),
('Điện thoại iPhone 15 Pro', 26000000, 2),
('Điện thoại Samsung Galaxy S23', 18500000, 2),
('Điện thoại Xiaomi Redmi Note 13', 4800000, 2),
('Chuột không dây Logitech', 450000, 3),
('Bàn phím cơ DareU', 850000, 3),
('Tai nghe Sony WH-1000XM5', 6500000, 3);

-- 5. Thực hiện các truy vấn SELECT lọc sản phẩm
-- Lọc sản phẩm theo khoảng giá
SELECT id, name, price, category_id
FROM products
WHERE price BETWEEN 5000000 AND 20000000;

-- Tìm sản phẩm chứa từ "Pro"
SELECT id, name, price, category_id
FROM products
WHERE name LIKE '%Pro%';

-- Giá trung bình theo danh mục
SELECT 
    category_id,
    ROUND(AVG(price), 2) AS average_price
FROM products
GROUP BY category_id;

-- Sản phẩm có giá cao hơn mức trung bình chung
SELECT id, name, price, category_id
FROM products
WHERE price > (
    SELECT AVG(price) 
    FROM products
);

-- Sản phẩm rẻ nhất theo từng danh mục (Correlated Subquery)
SELECT p.id, p.name, p.price, p.category_id
FROM products p
WHERE p.price = (
    SELECT MIN(sub.price)
    FROM products sub
    WHERE sub.category_id = p.category_id
);

-- 6. Tạo 3 đơn hàng giả định đầu tiên để đơn hàng tiếp theo tự động lấy ID = 4
INSERT INTO orders (customer_id, order_date) VALUES 
(1, '2026-10-01'),
(1, '2026-10-10'),
(2, '2026-10-15');

-- Thêm đơn hàng thứ 4 (Sẽ nhận id = 4)
INSERT INTO orders (customer_id, order_date) 
VALUES (1, '2026-10-25');

-- Thêm chi tiết cho đơn hàng id = 4 (Sản phẩm id 1 & 3 đều tồn tại trong bảng products)
INSERT INTO order_details (order_id, product_id, quantity, price) 
VALUES 
    (4, 1, 2, 14500000),
    (4, 3, 3, 500000);

-- 7. Kiểm tra lại dữ liệu vừa chèn
SELECT * FROM orders WHERE id = 4;
SELECT * FROM order_details WHERE order_id = 4;

SELECT SUM(quantity * price) AS total_store_revenue
FROM order_details;

SELECT ROUND(AVG(order_total), 2) AS average_order_revenue
FROM (
    SELECT order_id, SUM(quantity * price) AS order_total
    FROM order_details
    GROUP BY order_id
) AS order_summary;

SELECT 
    o.id AS order_id,
    o.customer_id,
    o.order_date,
    SUM(od.quantity * od.price) AS total_revenue
FROM orders o
INNER JOIN order_details od ON o.id = od.order_id
GROUP BY o.id, o.customer_id, o.order_date
ORDER BY total_revenue DESC
LIMIT 1;

SELECT 
    p.id AS product_id,
    p.name AS product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM products p
INNER JOIN order_details od ON p.id = od.product_id
GROUP BY p.id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 3;

