USE test_db;

DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

-- 1. Tạo bảng categories
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

-- 2. Tạo bảng products
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Thêm một số danh mục mẫu để liên kết
INSERT INTO categories (name) VALUES 
('Laptop'),
('Điện thoại'),
('Phụ kiện');

INSERT INTO products (name, price, category_id) VALUES 
('Laptop Dell Inspiron', 15000000, 1),
('iPhone 15 Pro', 26000000, 2),
('Tai nghe Sony WH-1000XM5', 6500000, 3);

-- Kiểm tra danh sách sau khi thêm
SELECT * FROM products;

UPDATE products
SET price = 14500000
WHERE id = 1;

-- Kiểm tra lại sản phẩm vừa cập nhật
SELECT * FROM products WHERE id = 1;

DELETE FROM products
WHERE id = 3;

-- Kiểm tra lại bảng sau khi xóa
SELECT * FROM products;


vocab
vocab

100%
10
A23

SELECT 
    p.id, 
    p.name AS product_name, 
    p.price, 
    c.name AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
ORDER BY p.price DESC;
 
 
 	
SELECT 
    p.id, 
    p.name AS product_name, 
    p.price, 
    c.name AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
ORDER BY p.price DESC;

SELECT 
    c.id AS category_id,
    c.name AS category_name,
    COUNT(p.id) AS total_products
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name;

