USE test_db;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS Order_items;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    category_id INT
);

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

SELECT id, name, price, category_id
FROM products
WHERE price BETWEEN 5000000 AND 20000000;

-- Ví dụ: Tìm các sản phẩm có tên chứa chuỗi "Pro"
SELECT id, name, price, category_id
FROM products
WHERE name LIKE '%Pro%';

SELECT 
    category_id,
    ROUND(AVG(price), 2) AS average_price
FROM products
GROUP BY category_id;

SELECT id, name, price, category_id
FROM products
WHERE price > (
    SELECT AVG(price) 
    FROM products
);

SELECT p.id, p.name, p.price, p.category_id
FROM products p
WHERE p.price = (
    SELECT MIN(sub.price)
    FROM products sub
    WHERE sub.category_id = p.category_id
);