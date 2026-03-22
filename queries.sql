
# Question 1. Determine the overall monetary value of inventory held in each store and assess the quantity of stock available. (this helps in understanding which store holds most inventory and in planning for restocking and sales strategies).

select  i.Store_id, sum(i.Stock_On_Hand) as total_stock, sum(p.Product_Price * i.Stock_On_Hand) as total_price
from `Toys.inventory` i
join `Toys.product` p
on p.Product_ID = i.Product_ID
group by i.Store_id


# Question 2: Analyze the impact of a store's location on its sales figures and identify which geographic areas contribute the most to the company's revenue. (Understanding location based sales performance can inform future stores placement and targeted marketing efforts).

select st.Store_Location, sum(s.units * p.Product_Price) as total_sales, sum(s.units * (p.Product_Price - Product_Cost)) as total_profit
from `Toys.stores` st 
left join `Toys.sales` s
on st.Store_ID = s.Store_ID
join `Toys.product` p
on p.Product_ID = s.Product_ID
group by st.Store_Location
order by total_profit desc ;


#Question 3: Determine which products have a presence in every store and quantify their sales volume. (This helps in identifying universally popular product and can guide stocking decision and promotional strategies).

with cte as
( select Product_ID, count(distinct Store_ID) as total_stores
from `Toys.sales`
group by Product_ID
having total_stores = (select count (Store_ID)
from `Toys.stores`))

select
Product_ID, sum(Units)
from `Toys.sales`
where Product_ID in (select product_ID from cte)
group by Product_ID


Question 4. Analyze how the retail price of products affects their sales volume and identify which price ranges are associated with the highest sales. This analysis can guide pricing strategies by identifying optimal price points that maximize sales.

with cte as
(select *,
case 
when Product_Price < 5 then 'less than 5'
when Product_Price between 5 and 10 then '5-10'
when Product_Price between 11 and 25 then '11-25'
when Product_Price between 26 and 50 then '26-50'
else '50+'
end as price_range
from `Toys.product`)

select price_range, sum(s.Units) total_units
from cte c 
join `Toys.sales` s
on c.Product_ID = s.Product_ID
group by price_range

Question 5: Find products with same price within the same category to assess pricing strategies and potential competition among products. 

select 
p1.Product_Name p1_Name,
p2.Product_Name p2_Name, 
p1.Product_Price,
p1.Product_Category
from `Toys.product` p1
inner join `Toys.product` p2
on p1.Product_Price = p2.Product_Price and p1.Product_Category = p2.Product_Category
and p1.Product_ID < p2.Product_ID

Question 6: Analyze the monthly sales performance for each year, and evaluate the cumulative sales trend over time. This helps in assessing seasonal impacts and overall growth patterns.

with cte as
(select
extract(year from s.Date) year,
extract(month from s.Date) month,
sum(s.Units * p.Product_Price) tot_sales
from `Toys.sales` s
join `Toys.product` p
on s.Product_ID = p.Product_ID
group by year, month)

select
year, month,
sum(tot_sales) over(partition by year order by month) cumulative_sales
from cte



























