-- ******************************* ---------- Walmart Sales Data ---------- ******************************** --

SELECT * FROM walmartsalesdata.sales;

-- ********** --------------- ************* ----- Feature Engineering ----- ********** --------------- ************* --
											 -- *** -- time_of_day -- *** --

select time from sales;

select time, 
	( case 
		when time between "00:00:00" and "12:00:00" then "Morning"
        when time between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
    )as time_of_day
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
	case 
		when time between "00:00:00" and "12:00:00" then "Morning"
        when time between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
);

											  -- *** -- dat_name -- *** --
                                              
select date from sales;

select date, dayname(date)
from sales;

alter table sales add column day_name varchar(10);

update sales 
set day_name = dayname(date);


										     -- *** -- month_name -- *** --
                                             
select date, monthname(date) from sales;
 
alter table sales add column month_name varchar(10);

update sales 
set month_name = monthname(date);

-- ********** --------------- ************* ----- ********************** ----- ********** --------------- ************* --


-- ********** --------------- ************* ----- Generic questions ----- ********** --------------- ************* --

-- ** 01. How many unique cities does the data have?

select distinct city from sales;

-- ** 02. In which city is each branch?

select distinct branch from sales;

select distinct city, branch from sales;


-- ********** --------------- ************* ----- Product questions ----- ********** --------------- ************* --

-- ** 01. How many unique product lines does the data have?

select distinct product_line from sales;

select count(distinct product_line) from sales;

-- ** 02. What is the most common payment method?

select distinct payment_method from sales;

select count(distinct payment_method) from sales;

select payment_method, count(payment_method) as count from sales group by payment_method order by count desc;

-- ** 03. What is the most selling product line?

select product_line, count(product_line) as count from sales group by product_line order by count desc;

-- ** 04. What is the total revenue by month?

select month_name as month from sales;

select 
	month_name as month,
	sum(total) as total_revenue
from sales group by month_name
order by total_revenue desc;

-- ** 05. What month had the largest COGS?

select 
	month_name as month,
    sum(cogs) as cogs
from sales group by month_name
order by cogs desc;

-- ** 06. What product line had the largest revenue?

select 
	 product_line,
     sum(total) as total_revenue
from sales group by product_line
order by total_revenue desc;

-- ** 07. What is the city with the largest revenue?

select 
	 branch,
	 city,
     sum(total) as total_revenue
from sales group by city, branch
order by total_revenue desc;

-- ** 08. What product line had the largest VAT?

select 
	product_line,
	avg(vat) as avg_tax
    from sales
    group by product_line
    order by avg_tax desc;
    
-- ** 09. Which branch sold more products than average product sold?    

select 
	branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- ** 10. What is the most common product line by gender?

select 
	gender,
	product_line,
    count(gender) as total_count
from sales
group by gender, product_line
order by total_count desc;


-- ** 11. What is the average rating of each product line?

select round(avg(rating),2) as avg_rating,
	product_line
from sales
group by product_line
order by avg_rating desc;

-- ** 12. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select quantity from sales;

select 
	product_line,
	case 
		when avg(quantity)  > 6 then "Good"
        else "Bad"
	end as remark
	from sales group by product_line;


-- ********** --------------- ************* ----- Sales questions ----- ********** --------------- ************* --


-- ** 01. Number of sales made in each time of the day per weekday

select time_of_day, count(*) as total_sales from sales group by time_of_day order by total_sales desc;

select time_of_day, count(*) as total_sales from sales where day_name = "Monday" group by time_of_day order by total_sales desc;

select time_of_day, count(*) as total_sales from sales where day_name = "Sunday" group by time_of_day order by total_sales desc;

-- ** 02. Which of the customer types brings the most revenue?

select distinct customer_type from sales;

select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;

-- ** 03. Which city has the largest tax percent/ VAT (Value Added Tax)?

select city from sales;

select city, avg(VAT) as total_vat from sales group by city order by total_vat desc;

-- ** 04. Which customer type pays the most in VAT?

select customer_type from sales;

select customer_type, avg(VAT) as total_vat from sales group by customer_type order by total_vat desc;

-- ********** --------------- ************* ----- Customer questions ----- ********** --------------- ************* --

-- ** 01. How many unique customer types does the data have?

select distinct customer_type from sales;

select count(distinct customer_type) from sales;

-- ** 02. How many unique payment methods does the data have?

select distinct payment_method from sales;

-- ** 03. What is the most common customer type?

select distinct customer_type from sales;


-- ** 04. Which customer type buys the most?

select customer_type, count(*) as costomer_count from sales group by customer_type order by costomer_count desc;

-- ** 05. What is the gender of most of the customers?

select gender from sales;

select gender, count(*) gender_count from sales group by gender order by gender_count desc;

-- ** 06. What is the gender distribution per branch?

select gender, count(*) gender_count from sales where branch = "c" group by gender order by gender_count desc;

select gender, count(*) gender_count from sales where branch = "a" group by gender order by gender_count desc;

select gender, count(*) gender_count from sales where branch = "b" group by gender order by gender_count desc;


-- ** 07. Which time of the day do customers give most ratings?

select time_of_day, avg(rating) as avg_rating from sales group by time_of_day order by avg_rating desc;


-- ** 08. Which time of the day do customers give most ratings per branch?

select time_of_day, avg(rating) as avg_rating from sales where branch = "c" group by time_of_day order by avg_rating desc;
 
select time_of_day, avg(rating) as avg_rating from sales where branch = "a" group by time_of_day order by avg_rating desc;

select time_of_day, avg(rating) as avg_rating from sales where branch = "b" group by time_of_day order by avg_rating desc;

-- ** 09. Which day fo the week has the best avg ratings?

select day_name from sales;

select day_name, avg(rating) as avg_rating from sales group by day_name order by avg_rating desc;

-- ** 10. Which day of the week has the best average ratings per branch?

select day_name, avg(rating) as avg_rating from sales where branch = "a" group by day_name order by avg_rating desc;


select day_name, avg(rating) as avg_rating from sales where branch = "b" group by day_name order by avg_rating desc;

select day_name, avg(rating) as avg_rating from sales where branch = "c" group by day_name order by avg_rating desc;










