-- ----------------------------
-- 1. SUPPLIERS (Strong Entity)
-- ------------------------------
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_email VARCHAR(150) UNIQUE NOT NULL,
    supplier_phone VARCHAR(20) NOT NULL
);

-- --------------------------------
-- 2. PRODUCTS (Strong Entity)
-- ---------------------------------
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    product_price NUMERIC(10,2) NOT NULL CHECK (product_price >= 0),
    reorder_level INT NOT NULL CHECK (reorder_level >= 0),
    supplier_id INT NOT NULL,
    
    CONSTRAINT fk_products_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES Suppliers(supplier_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ----------------------------------
-- 3. STOCK LEVELS (Strong Entity)
-- -----------------------------------
CREATE TABLE StockLevels (
    stock_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    last_updated TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_stock_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- -------------------------------
-- 4. PURCHASE ORDERS (Strong Entity)
-- ----------------------------------
CREATE TABLE PurchaseOrders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Pending','Delivered','Cancelled')),
    supplier_id INT NOT NULL,

    CONSTRAINT fk_purchaseOrder_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES Suppliers(supplier_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ----------------------------------------
-- 5. PURCHASE ORDER ITEMS (Weak Entity)
-- ----------------------------------------
CREATE TABLE PurchaseOrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),

    CONSTRAINT fk_purchaseOrderItems_order
        FOREIGN KEY (order_id)
        REFERENCES PurchaseOrders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_purchaseOrderItems_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ------------------------------
-- 6. SALES (Strong Entity)
-- ------------------------------
CREATE TABLE Sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0)
);

-- ------------------------------------
-- 7. SALES ITEMS (Weak Entity)
-- --------------------------------------
CREATE TABLE SalesItems (
    sale_item_id SERIAL PRIMARY KEY,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_sale NUMERIC(10,2) NOT NULL CHECK (price_at_sale >= 0),

    CONSTRAINT fk_salesItems_sale
        FOREIGN KEY (sale_id)
        REFERENCES Sales(sale_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_salesItems_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
-- =========================================
-- SEED SUPPLIERS
-- =========================================
INSERT INTO Suppliers (supplier_name, supplier_email, supplier_phone) VALUES
('Dublin Fresh Foods Ltd.',      'info@dublinfreshfoods.ie',      '018765432'),
('Green Valley Produce',         'contact@greenvalley.ie',        '015432187'),
('Emerald Dairy Co.',            'sales@emeralddairy.ie',         '016789543'),
('Atlantic Seafood Supplies',    'orders@atlanticseafood.ie',     '017654321'),
('Ballymore Bakery',             'hello@ballymorebakery.ie',      '018901234'),
('Celtic Beverages Ltd.',        'support@celticbev.ie',          '015678234'),
('Harvest Grain Foods',          'info@harvestgrain.ie',          '016543278'),
('Irish Pantry Goods',           'orders@irishpantry.ie',         '018765123'),
('Liffey Snacks Distribution',   'sales@liffeysnacks.ie',         '017890456'),
('Oakfield Frozen Foods',        'contact@oakfieldfrozen.ie',     '016789012'),
('Silverstream Household Supply','info@silverstream.ie',          '015678901'),
('Golden Fields Organics',       'hello@goldenfields.ie',         '018902345'),
('Shamrock Drinks Co.',          'orders@shamrockdrinks.ie',      '017654890'),
('Northside Wholesale Grocers',  'sales@northsidegrocers.ie',     '016543210'),
('Southport Food Distribution',  'info@southportfoods.ie',        '015432678');

-- =========================================
-- SEED PRODUCTS (40 PRODUCTS)
-- =========================================
INSERT INTO Products (product_name, category, product_price, reorder_level, supplier_id) VALUES
('Whole Milk 1L',              'Dairy',      1.29, 10, 3),
('Semi-Skimmed Milk 1L',       'Dairy',      1.25, 10, 3),
('Cheddar Cheese 200g',        'Dairy',      2.49,  8, 3),
('Butter 250g',                'Dairy',      2.10,  8, 3),

('Brown Sliced Pan',           'Bakery',     1.80, 12, 5),
('White Sliced Pan',           'Bakery',     1.75, 12, 5),
('Croissant 2-Pack',           'Bakery',     2.20,  6, 5),
('Blueberry Muffin',           'Bakery',     1.50,  6, 5),

('Free-Range Eggs 6-Pack',     'Chilled',    2.30, 10, 2),
('Smoked Back Bacon 200g',     'Chilled',    3.50,  6, 2),
('Irish Pork Sausages 400g',   'Chilled',    3.20,  6, 2),

('Tayto Cheese & Onion 45g',   'Snacks',     1.20, 20, 9),
('Tayto Salt & Vinegar 45g',   'Snacks',     1.20, 20, 9),
('King Crisps 45g',            'Snacks',     1.15, 20, 9),
('Chocolate Bar 55g',          'Snacks',     1.10, 25, 9),

('Still Water 500ml',          'Drinks',     1.00, 24, 6),
('Sparkling Water 500ml',      'Drinks',     1.10, 24, 6),
('Orange Juice 1L',            'Drinks',     2.40, 10, 6),
('Apple Juice 1L',             'Drinks',     2.40, 10, 6),
('Cola 500ml',                 'Drinks',     1.50, 24, 6),

('Frozen Peas 1kg',            'Frozen',     2.80,  8, 10),
('Frozen Chips 1.5kg',         'Frozen',     3.50,  8, 10),
('Frozen Pizza Margherita',    'Frozen',     3.99,  6, 10),
('Vanilla Ice Cream 1L',       'Frozen',     3.60,  6, 10),

('Spaghetti 500g',             'Grocery',    1.20, 15, 7),
('Basmati Rice 1kg',           'Grocery',    2.50, 12, 7),
('Tomato Pasta Sauce 500g',    'Grocery',    2.10, 10, 7),
('Baked Beans 415g',           'Grocery',    1.00, 18, 7),
('Tinned Chopped Tomatoes',    'Grocery',    1.10, 18, 7),

('Washing-Up Liquid 500ml',    'Household',  2.20, 10, 11),
('Laundry Detergent 2L',       'Household',  7.50,  6, 11),
('Kitchen Roll 4-Pack',        'Household',  3.80,  8, 11),
('Toilet Tissue 9-Pack',       'Household',  5.50,  8, 11),

('Shampoo 400ml',              'Toiletries', 3.90,  8, 12),
('Shower Gel 400ml',           'Toiletries', 3.20,  8, 12),
('Toothpaste 100ml',           'Toiletries', 2.50, 10, 12),
('Hand Soap 250ml',            'Toiletries', 1.80, 10, 12),

('Granola Cereal 500g',        'Breakfast',  3.40, 10, 13),
('Cornflakes 500g',            'Breakfast',  2.60, 10, 13),
('Instant Coffee 200g',        'Breakfast',  4.50,  6, 13),
('Tea Bags 80-Pack',           'Breakfast',  3.20, 10, 13);

-- =========================================
-- SEED STOCK LEVELS (ONE PER PRODUCT)
-- =========================================
INSERT INTO StockLevels (product_id, quantity, last_updated)
SELECT p.product_id,
       (50 + (random() * 100)::INT) AS quantity,
       NOW() - (random() * INTERVAL '30 days') AS last_updated
FROM Products p;

-- =========================================
-- PURCHASE ORDERS (200 ROWS)
-- =========================================
-- Simple pattern: random supplier, random date in last 90 days, random status
INSERT INTO PurchaseOrders (order_date, status, supplier_id)
SELECT
    (CURRENT_DATE - (trunc(random() * 90))::INT) AS order_date,
    (ARRAY['Pending','Delivered','Cancelled'])[1 + (random()*2)::INT] AS status,
    (SELECT supplier_id FROM Suppliers ORDER BY random() LIMIT 1) AS supplier_id
FROM generate_series(1, 200);

-- =========================================
-- PURCHASE ORDER ITEMS (200 ROWS)
-- =========================================
-- Each item links a random existing order and product
INSERT INTO PurchaseOrderItems (order_id, product_id, quantity)
SELECT
    (SELECT order_id FROM PurchaseOrders ORDER BY random() LIMIT 1) AS order_id,
    (SELECT product_id FROM Products ORDER BY random() LIMIT 1) AS product_id,
    (1 + (random() * 20)::INT) AS quantity
FROM generate_series(1, 200);

-- =========================================
-- SALES (200 ROWS)
-- =========================================
INSERT INTO Sales (sale_date, total_amount)
SELECT
    (CURRENT_DATE - (trunc(random() * 60))::INT) AS sale_date,
    -- temporary placeholder, will not perfectly match items but acceptable for assignment
    (5 + random() * 60)::NUMERIC(10,2) AS total_amount
FROM generate_series(1, 200);

-- =========================================
-- SALES ITEMS (200 ROWS)
-- =========================================
INSERT INTO SalesItems (sale_id, product_id, quantity, price_at_sale)
SELECT
    (SELECT sale_id FROM Sales ORDER BY random() LIMIT 1) AS sale_id,
    (SELECT product_id FROM Products ORDER BY random() LIMIT 1) AS product_id,
    (1 + (random() * 5)::INT) AS quantity,
    -- use current product price as price_at_sale
    (SELECT product_price FROM Products ORDER BY random() LIMIT 1) AS price_at_sale
FROM generate_series(1, 200);
-----------------------------------------------------------------------------------------------------------------------------
-- Q1 Non-correlated subquery
EXPLAIN ANALYZE
SELECT 
product_id,
product_name,
product_price
FROM Products
WHERE product_price > (
SELECT AVG(product_price) FROM Products
);
-- Q2 One correlated subquery
EXPLAIN ANALYZE
SELECT 
p.product_id,
p.product_name,
(
SELECT COALESCE(SUM(poi.quantity),0)
FROM PurchaseOrderItems poi
WHERE poi.product_id=p.product_id
)AS total_quantity_ordered
FROM Products p;
--	Q3 One CTE (WITH) query
EXPLAIN ANALYZE
WITH product_sales AS(
SELECT 
si.product_id,
SUM(si.quantity*si.price_at_sale)AS total_revenue
FROM SalesItems si
GROUP BY si.product_id
)
SELECT 
ps.product_id,
p.product_name,
ps.total_revenue
FROM product_sales ps
JOIN Products p 
ON p.product_id = ps.product_id;
-- Q4 One query using a Window Function 
EXPLAIN ANALYZE
SELECT
p.product_name,
p.category,
p.product_price,
RANK()OVER(
PARTITION BY p.category
ORDER BY p.product_price
)AS price_rank
FROM Products p;
-- Q5 One additional Window Function query 
EXPLAIN ANALYZE
SELECT 
sale_date,
total_amount,
SUM(total_amount)OVER(
ORDER BY sale_date
)AS running_total
FROM Sales;
-- Q6 One query that produces a meaningful business insight
EXPLAIN ANALYZE
SELECT
s.supplier_name,
SUM(poi.quantity)AS total_products_delivered
FROM Suppliers s
INNER JOIN Products p
ON p.supplier_id=s.supplier_id
INNER JOIN PurchaseOrderItems poi
ON poi.product_id=p.product_id
GROUP BY s.supplier_name
LIMIT 1;
-- Q7 One stored procedure or function that supports business logic
CREATE OR REPLACE PROCEDURE update_product_price(
IN p_product_id INT,
IN p_new_price NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE Products
SET product_price=p_new_price
WHERE product_id=p_product_id;
END;
$$;
--CALL update_product_price(1, 2.99);
EXPLAIN ANALYZE
SELECT 
product_id,
product_price
FROM Products
WHERE product_id=1;
-- Q8 One trigger
---- create table
CREATE TABLE stock_history (
history_id SERIAL PRIMARY KEY,
product_id INT,
old_quantity INT,
new_quantity INT,
changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
----create trigger function
CREATE OR REPLACE FUNCTION log_stock_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO stock_history(product_id, old_quantity, new_quantity)
VALUES (OLD.product_id, OLD.quantity, NEW.quantity);
RETURN NEW;
END;
$$;
----create trigger
CREATE TRIGGER trigger_stock_update
AFTER UPDATE ON StockLevels
FOR EACH ROW
WHEN (OLD.quantity IS DISTINCT FROM NEW.quantity)
EXECUTE FUNCTION log_stock_update();
-----DEMO
--before update
SELECT *
FROM StockLevels
WHERE product_id = 1;
--perform update
UPDATE StockLevels
SET quantity = quantity - 7
WHERE product_id = 1;
--after update
SELECT* 
FROM stock_history 
WHERE product_id = 1;
-- Q9 Demonstrate a transaction using 
--BEGIN / COMMIT / ROLLBACK with a realistic scenario
BEGIN;
INSERT INTO Sales(sale_date, total_amount)
VALUES (
CURRENT_DATE, 
9.98);
INSERT INTO SalesItems(sale_id, 
product_id, 
quantity, 
price_at_sale)
VALUES (
201,
5,
2,
4.99);
UPDATE StockLevels
SET quantity = quantity - 2
WHERE product_id = 5;
COMMIT;
ROLLBACK;

--Q11 Demonstrate performance tuning 
----Identify one slow analytical query and capture EXPLAIN ANALYZE before indexing
EXPLAIN ANALYZE
SELECT p.product_name,
SUM(si.quantity)
FROM Products p
INNER JOIN SalesItems si
ON si.product_id=p.product_id
GROUP BY p.product_name;
-----Create an appropriate index and capture EXPLAIN ANALYZE after indexing
CREATE INDEX index_salesitems_product
ON SalesItems (product_id);
-----Compare and explain what changed
EXPLAIN ANALYZE
SELECT p.product_name,
SUM(si.quantity)
FROM Products p
INNER JOIN SalesItems si
ON si.product_id=p.product_id
GROUP BY p.product_name;
-- Q12 Create at least two roles
----Admin
--create role
CREATE ROLE admin;
--grant permisions
GRANT SELECT, INSERT, UPDATE, DELETE ON Products TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON SalesItems TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON StockLevels TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON stock_history TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Suppliers TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON PurchaseOrders TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON PurchaseOrderItems TO admin;
--create user
CREATE USER user_admin WITH PASSWORD 'pass1';
--assign role
GRANT admin TO user_admin;
----Staff
--create role
CREATE ROLE staff;
--grant permisions
GRANT SELECT ON Products TO staff;
GRANT SELECT ON Sales TO staff;
GRANT SELECT ON SalesItems TO staff;
GRANT SELECT ON StockLevels TO staff;
GRANT SELECT ON stock_history TO staff;
--create user
CREATE USER user_staff WITH PASSWORD 'pass2';
--assign role
GRANT staff TO user_staff;
