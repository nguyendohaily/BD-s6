USE test_db;

-- 1. Xóa các bảng theo đúng thứ tự (bảng con xóa trước)
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS Order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- 2. Tạo bảng customers
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255)
);

-- 3. Tạo bảng products (Sản phẩm)
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL
);

-- 4. Tạo bảng orders
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- 5. Tạo bảng order_details
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT,
    price DOUBLE,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 6. Chèn dữ liệu theo thứ tự bảng mẹ trước, bảng con sau
INSERT INTO customers (name, email) VALUES 
('Nguyễn Văn An', 'an@example.com'),
('Trần Thị Bình', 'binh@example.com'),
('Lê Hoàng Cường', 'cuong@example.com');

-- Chèn dữ liệu cho bảng products để tạo ID 1, 2, 3
INSERT INTO products (id, name, price) VALUES 
(1, 'Laptop Dell Inspiron', 15000000),
(2, 'iPhone 15 Pro', 26000000),
(3, 'Chuột không dây', 500000);

INSERT INTO orders (customer_id, order_date) VALUES 
(1, '2026-10-01'),
(1, '2026-10-15'),
(2, '2026-10-20');

-- Bây giờ chèn vào order_details sẽ thành công 100%
INSERT INTO order_details (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 15000000),
(1, 3, 2, 500000),
(2, 1, 1, 14500000),
(3, 2, 1, 26000000);

INSERT INTO customers (name, email) VALUES 
('Phạm Minh Đức', 'duc@example.com'),
('Đỗ Quỳnh Anh', 'quynhanh@example.com');

-- Kiểm tra lại bảng customers
SELECT * FROM customers;

SELECT DISTINCT 
    c.id, 
    c.name, 
    c.email
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id;

SELECT 
    c.id, 
    c.name, 
    c.email
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

SELECT 
    c.id, 
    c.name, 
    COALESCE(SUM(od.quantity * od.price), 0) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
LEFT JOIN order_details od ON o.id = od.order_id
GROUP BY c.id, c.name;

SELECT DISTINCT 
    c.id, 
    c.name, 
    od.price AS highest_product_price
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
INNER JOIN order_details od ON o.id = od.order_id
WHERE od.price = (
    SELECT MAX(price) 
    FROM order_details
);