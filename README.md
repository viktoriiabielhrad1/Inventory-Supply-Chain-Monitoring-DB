Inventory & Supply Chain Monitoring Database
-
A PostgreSQL project developed in pgAdmin to model inventory, suppliers, stock levels, 
sales, and operational workflows. The system demonstrates advanced SQL techniques including 
subqueries, CTEs, window functions, triggers, stored procedures, transactions, indexing, and 
role‑based access control.

Overview
-
The database supports core supply‑chain operations such as tracking product stock, 
recording supplier deliveries, processing sales, analysing performance, and maintaining
historical logs. The project focuses on relational modelling, data integrity, and analytical SQL.

SQL Features Implemented
-
Subqueries:
Non‑correlated subquery comparing product prices to the average price.
Correlated subquery calculating total quantity ordered per product.

CTE (WITH) Queries
-
Revenue calculation using aggregated sales data and joining with product information.

Window Functions
-
Ranking products by price within each category.
Running totals of sales amounts over time.

Business Insight Query
-
Identifying the supplier with the highest total delivered quantity.

Stored Procedure
-
update_product_price procedure to update product pricing as part of business logic.

Trigger & Audit Table
-
stock_history table logs quantity changes.
Trigger records old and new stock levels after updates.

Transactions
-
Demonstration of BEGIN, COMMIT, and ROLLBACK for safe multi‑step sales operations.

Performance Tuning
-
EXPLAIN ANALYZE used before and after indexing.
Index on SalesItems(product_id) improves join performance.

Roles & Permissions
-
Admin role with full CRUD access.
Staff role with read‑only access to operational tables.
Users assigned to roles for controlled database access.

Database Structure
-
Includes tables for products, suppliers, purchase orders, sales, sales items,
stock levels, and audit history. All tables use primary keys, foreign keys, 
constraints, and cascading rules to maintain data consistency.

Purpose
-
This project was completed in pgAdmin as part of a database module to demonstrate advanced SQL, 
relational design, and operational analysis within an inventory and supply‑chain context.
