Create Database Consumer_Behaviour_Project;
use Consumer_Behaviour_Project;
SELECT * from consumer_behaviour_analysis;

-- Business Insights --

-- Q1. Which Category Generates Highest Revenue ? --
Select category , round(sum(purchase_amount),2) as Highest_revenue
from consumer_behaviour_analysis
group by category
order by Highest_revenue desc;

-- With this insight we are trying to help find the highest segment of category which generates the hisghest revernue for the company, This will help with :-
-- 1. Priortizing high performance categories
-- 2. Optimizes inventory planning
-- 3. Will improve marketing ROI --

-- Q2. What is the impact of discounting on Purchase value ? --
Select discount_applied , round(sum(purchase_amount),2) as Total_revenue ,
round(avg(purchase_amount),2) as avg_purchase
from consumer_behaviour_analysis
group by discount_applied;

-- With the insight we can understand which product or segment we can apply our discounts on, This will help with :-
-- 1. Indentify weffectivenedd of the discounts
-- 2. Reduces unnecessary discounting on products
-- 3. Iprove profit margins --

-- Q3. What is the toatl revenue generate by male or female ? --
Select gender , round(sum(purchase_amount),2) as Revenue_as_per_gender
from consumer_behaviour_analysis
group by gender
order by Revenue_as_per_gender desc;

-- This is insight helps us to indetify which segment of gender is generating the highest revenue for the business, this will help us with :-
-- 1. Designing the market campaigns targeting the hightest revenue generating segment.
-- 2. Improves customer segmentation stratergy
-- 3. Enhance personalization efforts --

-- Q4. Which customer uses the discount but still spent more than the average purchase amount ? --
Select customer_id, purchase_amount, discount_applied
from consumer_behaviour_analysis
where discount_applied = "Yes" 
And purchase_amount > (select avg(purchase_amount) from consumer_behaviour_analysis)
limit 10;

-- This insight help us to indentify high spending customers that applied discount at the same time, this will help us with :-
-- 1. Identifiying premium discount-sensitive customers.
-- 2. Target campaigns can be generated for them as the spend more than usual customer to generate profit
-- 3. Campaigns would improve customer retention and turnaround count of premimum customers.

-- Q5. Which are the Top and Bottom 5 products with highest average review rating ? --
select item_purchased, avg(review_rating) as Average_rating
from consumer_behaviour_analysis
group by item_purchased
order by Average_rating desc limit 5;

select item_purchased, avg(review_rating) as Average_rating
from consumer_behaviour_analysis
group by item_purchased
order by Average_rating asc limit 5;

-- This insight helped us identify the visbilty of the performance for the products, this will help us with:-
-- 1. Promoting high performing products
-- 2. Improving low performing products
-- 3. Enhance customer satisfaction --

-- Q6. Does faster mode of shipping generate more revenue ? -- 
Select shipping_type, count(distinct customer_id) as order_placed , round(avg(purchase_amount),2) as average_purchase, round(sum(purchase_amount),2) as total_revenue
from consumer_behaviour_analysis
group by shipping_type
order by total_revenue desc;

-- This insight projected whether faster shipping leads to higher spending and generate revenue or not, this helps us with:-
-- 1. Optimizing shipping price stratergy
-- 2. Encourge premimum shipping adoption 
-- 3. Increase avg order purchased for each segment through revised shipping cost --

-- Q7. Do subscribed customers spend more ? Which segment is generating more profit Subscribed or Non-Subscribed --
Select subscription_status, count(customer_id) ,round(avg(purchase_amount),2) as avg_revenue , round(sum(purchase_amount),2) as total_revenue
from consumer_behaviour_analysis
group by subscription_status
order by total_revenue desc;

-- The insight projected that non subscribed customers generate more revenue, this will help us:-
-- 1. Validating subscription model performance
-- 2. Improve customer loyalty program so that more customers subscribe
-- 3. Improving customer lifetime value (CLV)

-- Q8. Top 5 products with Highest discount usage in percent ? --
Select item_purchased , 
count(item_purchased) as total_number_of_times_sold,
count( case when discount_applied="Yes" Then 1 End) as Number_of_times_sold_when_discount_applied,
count( case when discount_applied="Yes" Then 1 End) * 100.0 / count(*) as discount_in_percent
from consumer_behaviour_analysis
group by item_purchased
order by discount_in_percent desc limit 5;

-- This insight projects that some products are overly dependent on discounting, this will help us with:-
-- 1. Identify discount-driven products
-- 2. Help us optimize pricing and discounting stratergy
-- 3. Reduce profit margin loss -- 

-- Q9. Segment customers into new, returning and loyal based on their total number of previous purchase and display the count of each segment --
select 
	case 
		when previous_purchases = '0' Then "New Customers"
        when previous_purchases between 1 and 15 then "Returning Customers"
	else "Loyal Customers"
end as Customer_segment,
count(*) as customer_count
from consumer_behaviour_analysis
group by case 
		when previous_purchases = '0' Then "New Customers"
        when previous_purchases between 1 and 15 then "Returning Customers"
	else "Loyal Customers"
End;

-- This insight helps to eliminate generic stratergizing due to lack of customer segmentation. It will :-
-- 1. Help us enable personilized marketing 
-- 2. Improve retention strategies
-- 3. Increase conversion rates --

-- Q10. What are the top 3 products purchased in each category ? --
with CTE as (
Select category, item_purchased, count(item_purchased) as most_purchased,
rank()over(partition by category order by count(item_purchased) desc) as rnk
from consumer_behaviour_analysis
group by category, item_purchased
)
Select * from CTE
Where rnk <= 3;

-- The insight projects the top performing products for each category which can help business with:-
-- 1. Improving product placement and recommendations
-- 2. Inventory optimization
-- 3. Increase sales through best-sellers -- 

-- Q11. Are customers who are repeat buyers also likely to subscribe ? ( criteria : more than 5 previous purchases ) --
Select 
	case 
		when previous_purchases > 5 then "Repeat Buyers"
	else "Normal Buyers"
End as customer_type, subscription_status,
count(*) as customer_count,
count(*) * 100.0/ sum(count(*)) over (partition by case
									when previous_purchases > 5 then "Repeat Buyers"
                                    else "Normal Buyers"
								end ) as percents
from consumer_behaviour_analysis
group by case 
		when previous_purchases > 5 then "Repeat Buyers"
	    else "Normal Buyers"
	End, subscription_status;

-- This insight projects the clear relationship between loyalty of a customer and the subscription status. Impact :-
-- 1. Improves subscription targeting 
-- 2. Increase conversion to paid programs
-- 3. Help us improve customer retention strategy --

-- Q12. What is the revenue countribution by each age group ? -- 
Select 
	case
		when age between 18 and 25 then  "18-25"
        when age between 26 and 35 then  "25-35"
        when age between 36 and 50 then  "35-50"
        Else "51+"
	End as Age_group,
    round(sum(purchase_amount),2) as total_revenue
    from consumer_behaviour_analysis
    group by case
		when age between 18 and 25 then  "18-25"
        when age between 26 and 35 then  "25-35"
        when age between 36 and 50 then  "35-50"
        Else "51+"
	End 
    order by total_revenue desc;
    
-- This insights provides us the visibility for the revenue generation and its contribution as per the age group, this can help us with:-
-- 1. Age-based targeting for profit analysis
-- 2. Enhancing marketing efficiency by running campaigns according to age group -- 