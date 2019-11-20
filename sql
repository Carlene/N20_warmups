-- For each country calculate the total spending for each customer, and 
-- include a column (called 'difference') showing how much more each customer 
-- spent compared to the next highest spender in that country. 
-- For the 'difference' column, fill any nulls with zero.
-- ROUND your all of your results to the next penny.

-- hints: 
-- keywords to google - lead, lag, coalesce
-- If rounding isn't working: 
-- https://stackoverflow.com/questions/13113096/how-to-round-an-average-to-2-decimal-places-in-postgresql/20934099

WITH total_spending AS (
SELECT
	c.customerid
	,c.country
	,SUM(od.unitprice * od.quantity) as full_price

FROM
	orderdetails as od 
JOIN 
	orders as o 
ON
	od.orderid = o.orderid
JOIN 
	customers as c 
ON
	o.customerid = c.customerid

GROUP BY
	2, 1

ORDER BY
	2)

SELECT
	leading_price.customerid
	,leading_price.country
	,leading_price.full_price
	,leading_price.spent_more
	,full_price - spent_more as difference

FROM (
SELECT
	ts.customerid
	,ts.country
	,ts.full_price
	,coalesce(lead(ts.full_price, 1) OVER (order by country)) as spent_more

FROM
	total_spending as ts) AS leading_price
