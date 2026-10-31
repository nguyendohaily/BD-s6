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

SELECT 
    p.id AS product_id,
    p.name AS product_name,
    p.price,
    c.name AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.id;

SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    SUM(od.quantity * od.price) AS total_spent
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
INNER JOIN order_details od ON o.id = od.order_id
GROUP BY c.id, c.name
ORDER BY total_spent DESC
LIMIT 5;

SELECT 
    p.id AS product_id,
    p.name AS product_name,
    p.price
FROM products p
LEFT JOIN order_details od ON p.id = od.product_id
WHERE od.product_id IS NULL;

SELECT DISTINCT 
    c.id AS customer_id, 
    c.name AS customer_name, 
    c.email
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
INNER JOIN order_details od ON o.id = od.order_id
INNER JOIN products p ON od.product_id = p.id
WHERE p.category_id = (
    -- Subquery: Tìm danh mục (category_id) có số lượng sản phẩm nhiều nhất
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY COUNT(id) DESC
    LIMIT 1
);

