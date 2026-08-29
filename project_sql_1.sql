use sql_project;
-- Who are the customers likely to still be buying two years from now, and what do they look like today?
SELECT-- what do they like today
CASE
    WHEN age < 25 THEN 'Young'
    WHEN age BETWEEN 25 AND 40 THEN 'Adult'
    ELSE 'Senior'
END AS age_group,
COUNT(*) AS customers
FROM dataset
WHERE `Previous Purchases` >= 20 and `Purchase Amount (USD)`>=60
 and`Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly') and `Subscription Status`='Yes'
GROUP BY age_group;
select `ï»¿Customer ID` from dataset-- likely to still be buying two years from now
WHERE `Previous Purchases` >= 20 and `Purchase Amount (USD)`>=60 and`Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly') and `Subscription Status`='Yes'
group by `ï»¿Customer ID`;
-- QUESTION NO 2
SELECT 
    `Discount Applied`,
    COUNT(DISTINCT `ï»¿Customer ID`) AS customers,
    round(AVG(`Previous Purchases`)) AS avg_prev_purchase,
    AVG(`Purchase Amount (USD)`) AS avg_spending
FROM dataset
GROUP BY `Discount Applied`;
SELECT
    `Promo Code Used`,
    `Frequency of Purchases`,
    COUNT(*) AS total
FROM dataset
GROUP BY 
    `Promo Code Used`,
    `Frequency of Purchases`
ORDER BY total DESC;
select `Promo Code Used`,`Subscription Status`,count(*)
 from dataset
group by `Promo Code Used`,`Subscription Status`;
-- 	QUESTION NO 3
-- lower purchase history
select `Category`,sum(`Purchase Amount (USD)`) as total,count(*),avg(`Previous Purchases`) as tenure 
 from sql_project.dataset group by Category order by total asc limit  2; 
 -- most among high frequency and high tenure
SELECT Category,
    COUNT(*) AS customer_count
FROM sql_project.dataset
WHERE `Previous Purchases` >
      (SELECT AVG(`Previous Purchases`)
       FROM sql_project.dataset)
AND `Frequency of Purchases` IN ('Weekly','Fortnightly','Bi-Weekly')
GROUP BY Category
ORDER BY customer_count DESC limit 2;
 -- QUESTION NO 4
select Location,`Category`,sum(`Purchase Amount (USD)`) as 'purc_amount',count(*) 
 from dataset 
group by Location,`Category`;
select Location,sum(`Purchase Amount (USD)`) as 'total_spend',count(*) 
 from dataset where `Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly') 
group by Location
order by total_spend desc;-- high tenure places
-- QUESTION NO 5
select T.age_group,T.paym_pref,count(*) from(
SELECT
CASE
	when age<15 then 'child'
    WHEN age between 15 and 25 THEN 'Young'
    WHEN age BETWEEN 25 AND 40 THEN 'Adult'
    ELSE 'Senior'
END AS age_group,
`Payment Method` as 'paym_pref'
FROM dataset
WHERE `Previous Purchases` >= 20 and `Purchase Amount (USD)`>=60 and`Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly')) T
group by T.age_group,T.paym_pref;
select T.age_group,T.item_pref,count(*) from(
SELECT
CASE
	when age<15 then 'child'
    WHEN age between 15 and 25 THEN 'Young'
    WHEN age BETWEEN 25 AND 40 THEN 'Adult'
    ELSE 'Senior'
END AS age_group,
`Item Purchased` as 'item_pref'
FROM dataset
WHERE `Previous Purchases` >= 20 and`Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly')) T
group by T.age_group,T.item_pref;
-- NEXT QUESTION TO ANSWER
-- QUESTION NO 1
-- genuinly loyal customer
select distinct(`ï»¿Customer ID`) from dataset where 
`Previous Purchases` >= 20 and`Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly') and 
`Subscription Status`='Yes';
-- buy when there is a discount
select distinct(`ï»¿Customer ID`) from dataset where 
`Subscription Status`='No' and `Discount Applied`='Yes';
-- QUESTION NO 3
select t.Location from(
select Location,count(*) as 'a',AVG(`Purchase Amount (USD)`) as 'b' from dataset group by
 Location) t
 WHERE a>=80 and b<=60;
 -- QUESTION NO 5
select CASE
	when m.age<15 then 'child'
    WHEN m.age between 15 and 25 THEN 'Young'
    WHEN m.age BETWEEN 25 AND 40 THEN 'Adult'
    ELSE 'Senior'
END AS age_group,m.Location,m.`Item Purchased`,m.`Shipping Type`,m.`Payment Method`
 from 
 (SELECT *
FROM dataset
WHERE `Purchase Amount (USD)` > (
    SELECT AVG(`Purchase Amount (USD)`)
    FROM dataset
)
AND `Subscription Status` = 'Yes'
AND `Frequency of Purchases` IN (
    'Weekly',
    'Fortnightly',
    'Bi-Weekly',
    'Monthly'
)) m;
-- CUSTOMER SEGMENTATION AND ANALYSIS
-- QUESTION NO 1
select Location,sum(`Purchase Amount (USD)`) as 'purc_amount',count(*)
 from dataset where  
`Previous Purchases` >= 20 and`Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly') and 
`Subscription Status`='Yes' group by Location order by purc_amount desc limit 5;
select Location,sum(`Purchase Amount (USD)`) as 'purc_amount',count(*)
 from dataset  where  
`Previous Purchases` <= 20 and`Frequency of Purchases` not in
('Weekly','Fortnightly','Bi-Weekly','Monthly') and 
`Subscription Status`='No' group by Location order by purc_amount asc limit 5;
-- above shows Location's that separates high/low values customer
-- for high value customer
select `Shipping Type`,count(*) as 'num'
 from dataset  where  
`Previous Purchases` >= 20 and`Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly') and 
`Subscription Status`='Yes' group by `Shipping Type` order by num desc limit 3;
-- for low value customer
select `Shipping Type`,count(*) as 'num'
 from dataset  where  
`Previous Purchases` <= 20 and`Frequency of Purchases` not in
('Weekly','Fortnightly','Bi-Weekly','Monthly') and 
`Subscription Status`='No' group by `Shipping Type` order by num desc limit 3;
-- above shows shipping type differ between high/low values customer
-- which profiles shows strongest repeat purchase behaviour
select Gender,Category,`Subscription Status`,count(*) AS 'customer' 
 from dataset
 WHERE `Frequency of Purchases` in
('Weekly','Fortnightly','Bi-Weekly','Monthly') 
group by Gender,Category,`Subscription Status`;
-- 2nd NO QUESTION
-- Which seasons and categories are associated with lower-tenure customers versus those with high
-- previous purchase counts?
select Season,Category,count(*) as 'a' from dataset where `Previous Purchases` <= 15 
group by `Season`,Category order by a desc limit 5;
select Season,Category,count(*) as 'a' from dataset where `Previous Purchases` >= 20 
group by `Season`,Category order by a desc limit 5;
-- QUESTION 3
select Location,count(*) as 'count_' from dataset where 
`Previous Purchases` >= 15 and 
`Subscription Status`='Yes' group by Location order by count_ desc limit 5;
 select Location,count(*) as 'count_' from dataset where 
`Previous Purchases` <= 15 and 
`Discount Applied`='Yes' group by Location order by count_ desc limit 5;