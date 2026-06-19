Queries

Queries 
P1



# 1) What are the average prices of products by category, filtered to only show categories with an average price greater than $100?
use ecommerce;
select category, avg(price) as Average_Price
from products
group by category 
having avg(price)> 100;

# 7) Create a view that shows all orders along with customer names and order statuses, and how can you query this view to get all 'Shipped' orders?

create view Order_Details as
select 
o.orderID,
c.Name as Customer_Name,
o.orderdate,
o.totalamount,
o.status
FROM Orders o
JOIN Customers c
ON o.CustomerID = c.CustomerID;
select * from order_details;

SELECT *
FROM Order_Details
WHERE Status = 'Shipped';

#13) What is the delivery time for each completed order?

SELECT
    OrderID,
    ShippedDate,
    DeliveredDate,	
    DATEDIFF(DeliveredDate, ShippedDate) AS Delivery_Days
FROM Shipments
WHERE Status = 'Delivered'; 	
 
P2
# 2 What are the top 5 best-selling products
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS Total_Quantity_Sold
FROM Products p
JOIN OrderDetails od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 5;

# 8 Which customers have spent the most?
SELECT 
    c.CustomerID,
    c.Name,
    SUM(o.TotalAmount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

# 14 How can products be categorized by price range?
SELECT 
    ProductID,
    ProductName,
    Price,
    CASE
        WHEN Price < 100 THEN 'Low Price'
        WHEN Price BETWEEN 100 AND 500 THEN 'Medium Price'
        ELSE 'High Price'
    END AS Price_Range
FROM Products;

P3
#Q 3. Write a trigger that automatically updates the stock of a product when an order is placed.
CREATE TRIGGER UpdateStock
AFTER INSERT ON OrderDetails
FOR EACH ROW
UPDATE Products
SET Stock = Stock - NEW.Quantity
WHERE ProductID = NEW.ProductID;


# Q9. What is the average rating and total reviews for each product?
SELECT ProductID,
AVG(Rating),
COUNT(*)
FROM ProductReviews
GROUP BY ProductID;

# 011. Which orders were placed in the year 2024?
SELECT * FROM Orders
WHERE YEAR(OrderDate) = 2024;

P4
#Q6. How many orders were placed each month?
SELECT MONTH(OrderDate) AS Month,
       COUNT(*) AS TotalOrders
FROM Orders
GROUP BY MONTH(OrderDate);

#Q15. How many unique delivered orders were made by each customer?

SELECT CustomerID,
       COUNT(*) AS DeliveredOrders
FROM Orders
WHERE Status = 'Delivered'
GROUP BY CustomerID;

P5
use e_commerce_order_trends;
#Q5. How much discount has been applied to each order?
SELECT o.OrderID, oc.DiscountAmount
FROM Orders o
LEFT JOIN OrderCoupons oc
ON o.OrderID = oc.OrderID;

#Q12.  How can you rank customers based on their total spending using a window function?
SELECT c.CustomerID,
       c.Name,
       SUM(o.TotalAmount) AS TotalSpent,
       RANK() OVER (ORDER BY SUM(o.TotalAmount) DESC) AS CustomerRank
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name;

P6
# 4 Which products have received 5-star reviews?
SELECT p.ProductID,
       p.ProductName
FROM Products p
JOIN ProductReviews pr
    ON p.ProductID = pr.ProductID
WHERE pr.Rating = 5;

# 10 How many shipments were handled by each carrier?
SELECT Carrier,
       COUNT(*) AS TotalShipments
FROM Shipments
GROUP BY Carrier;