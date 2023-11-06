--"Revitalizing Retail: A Data-Driven Transformation in Scale Model Car Sales"

--Introduction
/*In the world of modern business, data is the key to informed decision-making and sustainable growth. This project takes us into the realm of a scale model car store, where data is about to unlock new avenues for success. With a comprehensive exploration of the database, we aim to answer critical questions and derive actionable insights that will guide strategic choices, from inventory management to customer engagement.

As we journey through this project, we'll uncover the secrets of optimizing product stock levels, discover the VIP customers who are the lifeblood of the business, and determine how much budget should be allocated to acquiring new customers. The store's transformation from a data-driven perspective will serve as a testament to the power of information in shaping the future of retail. Join us on this adventure as we unveil the potential within the data and embark on a quest for sustainable business growth.
*/

/* The scale model cars database contains eight tables:

Customers: customer data
Employees: all employee information
Offices: sales office information
Orders: customers' sales orders
OrderDetails: sales order line for each sales order
Payments: customers' payment records
Products: a list of scale model cars
ProductLines: a list of product line categories

Connections:
ProductLines -> Products
Products -> orderdetails
orderdetails -> orders
orders -> customers
customers -> payments and employees
employees -> offices
 */
 
-- Customers
SELECT 'Customers' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('customers')) AS number_of_attributes,
       (SELECT COUNT(*) FROM customers) AS number_of_rows

UNION ALL

-- Products
SELECT 'Products' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('products')) AS number_of_attributes,
       (SELECT COUNT(*) FROM products) AS number_of_rows

UNION ALL

-- ProductLines
SELECT 'ProductLines' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('productlines')) AS number_of_attributes,
       (SELECT COUNT(*) FROM productlines) AS number_of_rows

UNION ALL

-- Orders
SELECT 'Orders' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('orders')) AS number_of_attributes,
       (SELECT COUNT(*) FROM orders) AS number_of_rows

UNION ALL

-- OrderDetails
SELECT 'OrderDetails' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('orderdetails')) AS number_of_attributes,
       (SELECT COUNT(*) FROM orderdetails) AS number_of_rows

UNION ALL

-- Payments
SELECT 'Payments' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('payments')) AS number_of_attributes,
       (SELECT COUNT(*) FROM payments) AS number_of_rows

UNION ALL

-- Employees
SELECT 'Employees' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('employees')) AS number_of_attributes,
       (SELECT COUNT(*) FROM employees) AS number_of_rows

UNION ALL

-- Offices
SELECT 'Offices' AS table_name,
       (SELECT COUNT(*) FROM pragma_table_info('offices')) AS number_of_attributes,
       (SELECT COUNT(*) FROM offices) AS number_of_rows;
       
/*Now that we know the database a little better, we can answer the first question: which products should we order more of or less of? This question refers to inventory reports, including low stock(i.e. product in demand) and product performance. This will optimize the supply and the user experience by preventing the best-selling products from going out-of-stock.

The low stock represents the quantity of the sum of each product ordered divided by the quantity of product in stock. We can consider the ten highest rates. These will be the top ten products that are almost out-of-stock or completely out-of-stock.

The product performance represents the sum of sales per product.

Priority products for restocking are those with high product performance that are on the brink of being out of stock.*/

WITH 

low_stock_table AS (
SELECT productCode, 
       ROUND(SUM(quantityOrdered) * 1.0/(SELECT quantityInStock
                                           FROM products p
                                          WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails od
 GROUP BY productCode
 ORDER BY low_stock DESC
 LIMIT 10
),

product_performance AS (SELECT productCode, 
       SUM(quantityOrdered * priceEach) AS prod_perf
  FROM orderdetails od
 GROUP BY productCode 
 ORDER BY prod_perf DESC
 LIMIT 10)
 
SELECT 
    p.productCode, p.productName, p.productLine
FROM
    products p
WHERE
    p.productCode IN (SELECT productCode FROM product_performance);

/*After evaluating the inventory data, it is evident that there are specific products in urgent need of restocking to optimize supply and improve the user experience by preventing best-selling products from going out of stock. The following products have been identified as the top priority for restocking:

1952 Alpine Renault 1300 (Classic Cars)
2003 Harley-Davidson Eagle Drag Bike (Motorcycles)
1968 Ford Mustang (Classic Cars)
2001 Ferrari Enzo (Classic Cars)
2002 Suzuki XREO (Motorcycles)
1969 Ford Falcon (Classic Cars)
1980s Black Hawk Helicopter (Planes)
1917 Grand Touring Sedan (Vintage Cars)
1998 Chrysler Plymouth Prowler (Classic Cars)
1992 Ferrari 360 Spider red (Classic Cars)
These products exhibit a combination of low stock levels and high product performance, indicating strong customer demand. Restocking these items is essential to ensure a steady supply and meet customer expectations. Failure to do so may lead to customer dissatisfaction and missed sales opportunities. Proper inventory management and timely restocking of these priority products are critical for maintaining a positive user experience and maximizing revenue.
*/

/*Question 2: Aligning Marketing and Communication Strategies with Customer Behavior

Understanding Customer Segmentation for Effective Strategies

In the second phase of this project, we delve into the realm of customer information to address a fundamental question: How should we tailor our marketing and communication strategies to match customer behaviors? The success of any business hinges on the ability to categorize customers effectively, distinguishing between the VIP (Very Important Person) customers and those who are less engaged.

VIP customers, the cornerstone of a profitable business, contribute significantly to the store's revenue. Identifying and nurturing these key customers is vital.

Conversely, less-engaged customers, while still important, contribute to a lesser extent to the overall profit. They represent an opportunity for improvement and re-engagement.

To illustrate, one approach could be organizing exclusive events aimed at building loyalty among VIP customers, while simultaneously launching targeted campaigns to rekindle the interest of the less engaged.

Before we embark on crafting these strategies, it is imperative to understand the monetary value each customer brings to the business. We need to compute the profit generated by each customer to make informed decisions regarding marketing and communication strategies.*/

-- Top 5 VIP Customers
WITH

customer_profit_table AS (
SELECT o.customerNumber, SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS customer_profit
  FROM orders AS o
  JOIN orderdetails AS od
    ON o.orderNumber = od.orderNumber
  JOIN products AS p
    ON od.productCode = p.productCode
 GROUP BY customerNumber
 ORDER BY customer_profit DESC
)

SELECT c.contactLastName, c.contactFirstName, c.city, c.country, cp.customer_profit
  FROM customers AS c
  JOIN customer_profit_table AS cp
    ON c.customerNumber = cp.customerNumber
 GROUP BY c.customerNumber
 ORDER BY cp.customer_profit DESC
 LIMIT 5;

/*
Analysis of Top 5 VIP Customers

In our quest to understand and cater to customer behavior effectively, it's crucial to highlight our top 5 VIP (Very Important Person) customers based on their significant profit contributions:

Diego Freyre (Madrid, Spain) - Total Profit: $326,519.66
Diego Freyre is our most profitable customer, emphasizing his importance to our business. Fostering a strong relationship with Diego is vital for sustained revenue growth.

Susan Nelson (San Rafael, USA) - Total Profit: $236,769.39
Susan Nelson is the second-highest profit generator. Strategies should aim to enhance her loyalty and further amplify her impact.

Jeff Young (New York City, USA) - Total Profit: $72,370.09
Jeff Young's contribution is notable. Tailored strategies can unlock further growth potential.

Peter Ferguson (Melbourne, Australia) - Total Profit: $70,311.07
Peter Ferguson's substantial profit highlights the global reach of our business. Personalized engagement strategies are key to nurturing his loyalty.

Janine Labrune (Nantes, France) - Total Profit: $60,875.30
Janine Labrune secures the fifth position among our VIP customers. Developing strategies to strengthen the bond with Janine can lead to increased profitability.

In summary, these top 5 VIP customers play a significant role in our business's success. Recognizing their value and devising strategies to enhance their loyalty and engagement is crucial. By nurturing these relationships and optimizing their experience, we can continue to maximize revenue and strengthen our market position.
*/

--Less Engaged Customers
WITH
customer_profit_table AS (
SELECT o.customerNumber, SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS customer_profit
  FROM orders AS o
  JOIN orderdetails AS od
    ON o.orderNumber = od.orderNumber
  JOIN products AS p
    ON od.productCode = p.productCode
 GROUP BY customerNumber
 ORDER BY customer_profit DESC
)

SELECT c.contactLastName, c.contactFirstName, c.city, c.country, cp.customer_profit
  FROM customers AS c
  JOIN customer_profit_table AS cp
    ON c.customerNumber = cp.customerNumber
 GROUP BY c.customerNumber
 ORDER BY cp.customer_profit 
 LIMIT 5;
 
/*
Analysis of Less-Engaged Customers: Opportunities for Growth

While VIP customers are essential to our business, we must not overlook the potential for growth among our less-engaged customers. Understanding their behavior and preferences can help rekindle their interest and increase their contribution to our revenue. Let's explore the profiles of these less-engaged customers and the opportunities they present:

Mary Young, Glendale, USA

Mary Young, residing in Glendale, USA, has contributed $2,610.87 in profit. Although her engagement is currently limited, with the right targeted campaigns, incentives, and personalized communication, we have an opportunity to re-engage Mary and elevate her contribution to our business.
Leslie Taylor, Brickhaven, USA

Leslie Taylor, based in Brickhaven, USA, has generated $6,586.02 in profit. While Leslie's contributions are noteworthy, there is potential for further growth. Tailored campaigns and communication strategies can be employed to revive her interest and boost her spending.
Franco Ricotti, Milan, Italy

Franco Ricotti, from Milan, Italy, has contributed $9,532.93 in profit. Targeted international strategies, considering Franco's preferences and interests, can help us tap into this potential for growth and expand our reach.
Carine Schmitt, Nantes, France

Carine Schmitt, also from Nantes, France, has generated $10,063.80 in profit. By tailoring communication and offers to Carine's specific needs and preferences, we can work to re-engage her and maximize her spending.
Thomas Smith, London, UK

Thomas Smith, based in London, UK, has contributed $10,868.04 in profit. While Thomas's contributions are significant, there is potential to further engage and retain his loyalty through personalized campaigns and communication.
In summary, these less-engaged customers represent opportunities for growth within our customer base. By deploying targeted strategies that take into account their unique preferences and behavior, we can rekindle their interest and increase their contribution to our business. Understanding and addressing their specific needs will be instrumental in converting them into more engaged, loyal customers.*/

--Question 3: How Much Can We Spend on Acquiring New Customers?

/* 
Before answering this question, let's find the number of new customers arriving each month. That way we can check if it's worth spending money on acquiring new customers. This query helps to find these numbers.
*/

WITH 

payment_with_year_month_table AS (
SELECT *, 
       CAST(SUBSTR(paymentDate, 1,4) AS INTEGER)*100 + CAST(SUBSTR(paymentDate, 6,7) AS INTEGER) AS year_month
  FROM payments p
),

customers_by_month_table AS (
SELECT p1.year_month, COUNT(*) AS number_of_customers, SUM(p1.amount) AS total
  FROM payment_with_year_month_table p1
 GROUP BY p1.year_month
),

new_customers_by_month_table AS (
SELECT p1.year_month, 
       COUNT(*) AS number_of_new_customers,
       SUM(p1.amount) AS new_customer_total,
       (SELECT number_of_customers
          FROM customers_by_month_table c
        WHERE c.year_month = p1.year_month) AS number_of_customers,
       (SELECT total
          FROM customers_by_month_table c
         WHERE c.year_month = p1.year_month) AS total
  FROM payment_with_year_month_table p1
 WHERE p1.customerNumber NOT IN (SELECT customerNumber
                                   FROM payment_with_year_month_table p2
                                  WHERE p2.year_month < p1.year_month)
 GROUP BY p1.year_month
)

SELECT year_month, 
       ROUND(number_of_new_customers*100/number_of_customers,1) AS number_of_new_customers_props,
       ROUND(new_customer_total*100/total,1) AS new_customers_total_props
  FROM new_customers_by_month_table;


/*
As we can see, the number of clients has been decreasing since 2003, and in 2004, we had the lowest values. The year 2005, which is present in the database as well, isn't present in the table above, this means that the store has not had any new customers since September of 2004. This means it makes sense to spend money acquiring new customers.

To determine how much money we can spend acquiring new customers, we can compute the Customer Lifetime Value (LTV), which represents the average amount of money a customer generates. We can then determine how much we can spend on marketing.
*/

WITH
customer_profit_table AS (
SELECT o.customerNumber, SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS customer_profit
  FROM orders AS o
  JOIN orderdetails AS od
    ON o.orderNumber = od.orderNumber
  JOIN products AS p
    ON od.productCode = p.productCode
 GROUP BY customerNumber
 ORDER BY customer_profit DESC
)

SELECT AVG(cp.customer_profit) AS ltv
  FROM customer_profit_table AS cp;

/* LTV tells us how much profit an average customer generates during their lifetime with our store. We can use it to predict our future profit. So, if we get ten new customers next month, we'll earn 390,395 dollars, and we can decide based on this prediction how much we can spend on acquiring new customers.*/

--Conclusion

/*
In this project, we embarked on a comprehensive exploration of a scale model cars database, aiming to derive actionable insights to enhance business performance. Our analysis revolved around three key questions:

Optimizing Product Stock Levels: We identified the top ten priority products for restocking by evaluating their low stock levels and high product performance. Addressing the stock needs of these products is vital to prevent customer dissatisfaction and missed sales opportunities. Proper inventory management and timely restocking are crucial for enhancing the user experience and maximizing revenue.

Segmenting Customers for Targeted Strategies: Our analysis revealed five VIP customers who significantly contribute to our profitability. Recognizing their value and implementing strategies to nurture their loyalty and engagement is crucial for sustained success. Additionally, we highlighted less-engaged customers as an untapped growth opportunity. Tailored campaigns and communication strategies are key to rekindling their interest and increasing their contribution to our business.

Determining Budget for Acquiring New Customers: By examining the trend of new customer arrivals over time, we found that the number of new customers has been declining since 2003. This decline underlines the importance of investing in customer acquisition. To determine the budget for acquiring new customers, we computed the Customer Lifetime Value (LTV) to predict future profits. This metric guides our spending decisions on marketing to ensure optimal utilization of resources.

In conclusion, this project has equipped us with valuable insights to drive strategic decision-making. By optimizing product stock levels, nurturing our VIP customers, and effectively targeting new customer acquisition, we are poised to enhance business performance, ensure customer satisfaction, and foster sustainable growth.
*/

--Project Overview: A Tale of Data-Driven Business Transformation

/*Once upon a time in the world of retail, there was a store specializing in scale model cars. This store was determined to leverage the power of data to make informed decisions and drive growth. Join us on a journey through their transformative project.

Chapter 1: Unveiling the Data Landscape
The project began with a deep dive into the store's database, comprising eight tables, each holding a piece of the puzzle. Understanding the structure of the data was the first step in unraveling its potential.

Chapter 2: Stocking Wisely
The store's first challenge was to optimize inventory management. By analyzing low stock levels and product performance, the team identified the top ten priority products for restocking. These insights would prevent customer dissatisfaction, missed sales, and enhance the overall user experience.

Chapter 3: The VIP Connection
Recognizing the importance of customer segmentation, the store unearthed its top VIP customers. Five distinguished patrons were unveiled, contributing significantly to profitability. Their loyalty and engagement were now the focus of tailored strategies for sustained success. But that was not the end; less-engaged customers were discovered as an untapped goldmine, ready for reengagement and growth.

Chapter 4: Budgeting for Success
As the story unfolded, the store noticed a decline in new customer arrivals. To address this challenge, the team sought to determine how much they could invest in acquiring new customers. The concept of Customer Lifetime Value (LTV) emerged as a beacon to guide marketing budgets, ensuring that every dollar spent would result in maximum return on investment.

Chapter 5: A Data-Driven Transformation
In the end, the store's data-driven journey led to a brighter future. Armed with insights into product stock optimization, customer segmentation, and budget allocation, the store was ready to make informed decisions to enhance business performance. The power of data had unlocked a new chapter in their success story, one filled with satisfied customers and sustainable growth. And the journey continued, with new questions and new insights awaiting discovery in the ever-evolving world of retail.
*/
