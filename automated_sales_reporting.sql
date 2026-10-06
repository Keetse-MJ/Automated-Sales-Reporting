CREATE DATABASE automated_sales_reporting;
USE automated_sales_reporting;

CREATE TABLE sales (
    sale_id INT,
    salesperson VARCHAR(50),
    region VARCHAR(50),
    product VARCHAR(50),
    category VARCHAR(50),
    quantity INT,
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO sales
VALUES
(1, 'Thabo', 'Gauteng', 'Laptop', 'Electronics', 1, 8500, '2026-01-05'),
(2, 'Sarah', 'Gauteng', 'Phone', 'Electronics', 2, 6500, '2026-01-07'),
(3, 'Lerato', 'Gauteng', 'Monitor', 'Electronics', 1, 5000, '2026-01-10'),
(4, 'John', 'Gauteng', 'Keyboard', 'Accessories', 3, 2400, '2026-01-12'),
(5, 'Thabo', 'Gauteng', 'Phone', 'Electronics', 1, 3200, '2026-01-15'),
(6, 'Sarah', 'Gauteng', 'Laptop', 'Electronics', 1, 8500, '2026-01-18'),
(7, 'Lerato', 'Gauteng', 'Keyboard', 'Accessories', 2, 1600, '2026-01-20'),
(8, 'John', 'Gauteng', 'Monitor', 'Electronics', 2, 5000, '2026-01-22'),
(9, 'Thabo', 'Gauteng', 'Mouse', 'Accessories', 4, 1200, '2026-01-25'),
(10, 'Sarah', 'Gauteng', 'Phone', 'Electronics', 2, 6400, '2026-01-28'),
(11, 'Lerato', 'Gauteng', 'Laptop', 'Electronics', 1, 8500, '2026-02-02'),
(12, 'John', 'Gauteng', 'Phone', 'Electronics', 1, 3200, '2026-02-05'),
(13, 'Thabo', 'Gauteng', 'Monitor', 'Electronics', 1, 2500, '2026-02-08'),
(14, 'Sarah', 'Gauteng', 'Keyboard', 'Accessories', 3, 2400, '2026-02-10'),
(15, 'Lerato', 'Gauteng', 'Phone', 'Electronics', 2, 6400, '2026-02-12'),
(16, 'John', 'Gauteng', 'Laptop', 'Electronics', 1, 8500, '2026-02-15'),
(17, 'Thabo', 'Gauteng', 'Keyboard', 'Accessories', 2, 1600, '2026-02-18'),
(18, 'Sarah', 'Gauteng', 'Monitor', 'Electronics', 1, 2500, '2026-02-20'),
(19, 'Lerato', 'Gauteng', 'Mouse', 'Accessories', 3, 900, '2026-02-22'),
(20, 'John', 'Gauteng', 'Phone', 'Electronics', 2, 6400, '2026-02-25'),
(21, 'Thabo', 'Gauteng', 'Laptop', 'Electronics', 1, 8500, '2026-03-02'),
(22, 'Sarah', 'Gauteng', 'Phone', 'Electronics', 1, 3200, '2026-03-05'),
(23, 'Lerato', 'Gauteng', 'Monitor', 'Electronics', 2, 5000, '2026-03-08'),
(24, 'John', 'Gauteng', 'Keyboard', 'Accessories', 3, 2400, '2026-03-10'),
(25, 'Thabo', 'Gauteng', 'Phone', 'Electronics', 2, 6400, '2026-03-12');