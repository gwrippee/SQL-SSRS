/*********************************************************************************************
-- http://www.sqlservercentral.com/Forums/Topic665512-145-1.aspx

Use = when the subquery will return only one value for a match. When it can return multiple, use IN.

You're kinda on the right track, but not quite. There's no need for the @CaracasOrders table and you never assign a value to @OrderID (which you're using in the top query). I would do something like this.
**********************************************************************************************/

DECLARE @OrderId int
DECLARE @Orders TABLE (
        OrderId int,
        ProductId int,
        ItemTotal money
)

INSERT INTO @Orders (OrderID, ProductID, ItemTotal)
SELECT OrderID , ProductId, (Quantity * UnitPrice) As ItemTotal FROM [Order Details] 
WHERE OrderID IN (SELECT OrderID FROM Orders WHERE ShipCity = 'Caracas')

SELECT * FROM @Orders
