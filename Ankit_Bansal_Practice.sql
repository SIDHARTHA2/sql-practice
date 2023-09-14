use practice;
-- 1. Department wise highest salary
with sal_rnk as (
select emp_id,emp_name,dept_id,salary
,rank() over(partition by dept_id order by salary desc) as rnk from employee)
select * from sal_rnk where rnk=1;
--
-- 2. Cricket match no.of matches won and loss by team
Select Team_Name,count(1) as no_of_matches_played,sum(win_ind) as no_of_wins,
count(1) - sum(win_ind) as no_of_losses
from ( 
select team_1  as Team_Name,
case when team_1=winner then 1 else 0 end as win_ind  
from icc_world_cup
union all
select team_2 as Team_Name,
case when team_2=winner then 1 else 0 end as win_ind  
from icc_world_cup) A
group by 1 order by 3 desc;
--
-- 3. Find Employee details whose salary is more than their Manager salary.
select e.emp_name,m.emp_name as Manager_Name,e.salary,m.salary as Manager_Salary
from emp_manager e inner join emp_manager m 
-- on e.manager_id = m.emp_id
on e.emp_id = m.manager_id
where e.salary > m.salary;
--
-- 4. find new customer count,repeat customer count,new cust revenue,repeat cust revenue by order date
select * from customer_orders;
with first_visit AS(
select customer_id,min(order_date) as first_visit_date from customer_orders group by customer_id)
select co.order_date,
sum(CASE WHEN co.order_date=fv.first_visit_date THEN 1 ELSE 0 END) AS no_of_new_cust,
sum(CASE WHEN co.order_date!=fv.first_visit_date THEN 1 ELSE 0 END) AS no_of_repeat_cust,
sum(CASE WHEN co.order_date=fv.first_visit_date THEN order_amount ELSE 0 END) AS new_cust_revenue,
sum(CASE WHEN co.order_date<>fv.first_visit_date THEN order_amount ELSE 0 END) AS repeat_cust_revenue
 from customer_orders co inner join first_visit fv on co.customer_id = fv.customer_id
 group by 1; 

