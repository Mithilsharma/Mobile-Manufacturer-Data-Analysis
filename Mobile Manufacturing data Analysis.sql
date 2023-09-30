                             --Case study 2
use case_study2
select top 1 * from [dbo].[DIM_CUSTOMER]
select top 1 * from [dbo].[DIM_DATE]
select top 1 * from [dbo].[DIM_LOCATION]
select top 1 * from [dbo].[DIM_MANUFACTURER]
select top 1 * from [dbo].[DIM_MODEL]
select top 1 * from [dbo].[FACT_TRANSACTIONS]

--Q1 begin here
select state , sum(quantity) as ttl_quantity , year(date) as [Year]  from DIM_LOCATION as l 
join FACT_TRANSACTIONS as t on l.IDLocation=t.IDLocation 
where year(date)>=2005
group by state , year(date) 

--q1 end here

--Q2-- Begins here

select state ,count(*) as quantity from DIM_LOCATION  as l
join FACT_TRANSACTIONS as t on l.IDLocation = t.IDLocation 
join DIM_MODEL as m on t.IDModel=m.IDModel
join DIM_MANUFACTURER as mm on m.IDManufacturer=mm.IDManufacturer
where Manufacturer_Name ='samsung' and country ='us'
group by state

-- Q2 ends here

--Q3  Begins here

select IDModel,state,ZipCode , count(*) as ttl_trns  from FACT_TRANSACTIONS as t 
join DIM_LOCATION as l on t.IDLocation=l.IDLocation
group by IDModel,state,ZipCode
order by ttl_trns desc

--Q3 ends here

--Q4 Begins here

select top 1 Model_Name, unit_price from DIM_MODEL
order by Unit_price asc

--Q4 ends here


--Q5 begins here

select m.idmodel,manufacturer_name , avg(totalprice) as avg_price,sum(quantity) as quantity from FACT_TRANSACTIONS as ft
join 
DIM_MODEL as m on ft.IDModel=m.IDModel 
join DIM_MANUFACTURER as mm on m.IDManufacturer=mm.IDManufacturer
where manufacturer_name in (  select top 5 manufacturer_name  from DIM_MANUFACTURER as m
             join 
            DIM_MODEL as mdl on m.IDManufacturer=mdl.IDManufacturer
            join FACT_TRANSACTIONS as ft on mdl.IDModel=ft.IDModel
            group by Manufacturer_Name
            order by sum(totalprice) desc)
group by m.idmodel ,Manufacturer_Name
order by avg_price desc 

-- Q5 ends here

--Q6 begins here
select customer_name ,year(date) as year ,  avg(totalprice) as avg_price from DIM_CUSTOMER as c
join FACT_TRANSACTIONS as ft on c.IDCustomer=ft.IDCustomer
where year(date) = 2009 
group by Customer_Name , year(date)
having avg(totalprice) > 500

--Q6 ends here


select top 1 * from [dbo].[DIM_CUSTOMER]
select top 1 * from [dbo].[DIM_DATE]
select top 1 * from [dbo].[DIM_LOCATION]
select top 1 * from [dbo].[DIM_MANUFACTURER]
select top 1 * from [dbo].[DIM_MODEL]
select top 1 * from [dbo].[FACT_TRANSACTIONS]

--Q7  Begins here
 select  * from (
 select top 5 idmodel  from FACT_TRANSACTIONS
 where year(date) = 2008
 group by idmodel, year(date)
     order by sum(quantity)   desc            ) as a
 intersect
select * from (
 select top 5 idmodel from FACT_TRANSACTIONS
 where year(date) = 2009
 group by idmodel, year(date)
                order by sum(quantity) desc     ) as b
intersect
select * from (
 select top 5 idmodel from FACT_TRANSACTIONS
 where year(date) = 2010
 group by idmodel, year(date)
 order by sum(quantity) desc ) as c

 -- Q7 ends here

 
 -- Q8 Begins here
 select * from (
 select top 1 * from (
 select top 2 manufacturer_name, sum(totalprice) as sales ,  year(date) as year from 
 DIM_MANUFACTURER as m 
 join DIM_MODEL as dm on 
 m.IDManufacturer=dm.IDManufacturer
 join FACT_TRANSACTIONS as ft on 
 dm.IDModel =ft.IDModel
 where year(date) =2009
 group by Manufacturer_Name , year(date)
 order by sales desc   ) as a
 order by sales asc ) as b
 
 union all
 
 select * from (
 select top 1 * from (
 select top 2 manufacturer_name, sum(totalprice) as sales ,  year(date) as year from 
 DIM_MANUFACTURER as m 
 join DIM_MODEL as dm on 
 m.IDManufacturer=dm.IDManufacturer
 join FACT_TRANSACTIONS as ft on 
 dm.IDModel =ft.IDModel
 where year(date) =2010
 group by Manufacturer_Name , year(date)
 order by sales desc   ) as a
 order by sales asc 
 )as c

 --Q8 ends here 


-- Q9 Begins here

select distinct manufacturer_name , year(date) as year from DIM_MANUFACTURER as m
join DIM_MODEL as dm on m.IDManufacturer=dm.IDManufacturer
join FACT_TRANSACTIONS as ft on dm.IDModel=ft.IDModel
where year(date) = 2010 and manufacturer_name not in (
                                    select distinct manufacturer_name from DIM_MANUFACTURER as m
                                    join DIM_MODEL as dm on m.IDManufacturer=dm.IDManufacturer
                                    join FACT_TRANSACTIONS as ft on dm.IDModel=ft.IDModel
									where year(date) = 2009
									)

--- Q9 ends here
select top 1 * from FACT_TRANSACTIONS
--Q10 Begins here
select * , (avg_price-lag_price)/lag_price as percentage_change from (
select *, lag(avg_price , 1) over (partition by idcustomer order by year) as lag_price from (
select top 100  idcustomer,avg(totalprice) as avg_price, sum(quantity) as quantity,  year(date) as year from FACT_TRANSACTIONS
where IDCustomer in (
select top 100 idcustomer 
from FACT_TRANSACTIONS as ft
group  by IDCustomer 
order by sum(TotalPrice) desc 
) 
group by IDCustomer,year(date)
) as c  ) as d

-- Q10 Ends here

-- Q10 ends here











