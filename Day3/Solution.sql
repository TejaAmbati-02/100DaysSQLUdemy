USE UdemyNamasteSQL;
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000);



SELECT * FROM customer_orders;

WITH cte AS(select order_date, ROW_NUMBER() over (PARTITION BY customer_id ORDER BY order_date) AS RN
from customer_orders)
SELECT order_date,
SUM(CASE WHEN RN = 1 THEN 1 ELSE 0 END) AS new_customers,
SUM(CASE WHEN RN<>1 THEN 1 ELSE 0 END) AS repeat_customers
FROM cte
GROUP BY order_date;


WITH first_visitors_cte AS (SELECT customer_id,
       MIN(order_date) AS first_visit_date
FROM customer_orders
GROUP BY customer_id)
SELECT co.order_date,
       SUM(CASE WHEN co.order_date = fv.first_visit_date THEN 1 ELSE 0 END) AS first_visit_flag,
       SUM(CASE WHEN co.order_date != fv.first_visit_date THEN 1 ELSE 0 END) AS repeat_visit_flag
FROM customer_orders co
INNER JOIN first_visitors_cte fv ON co.customer_id = fv.customer_id
GROUP BY co.order_date;
