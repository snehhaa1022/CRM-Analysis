create database crm;
select * from crm.book1;
select * from crm.book2;
select * from crm.book3;
select * from account;

-- overview of lead-opp-acc
SELECT 
  (SELECT COUNT(`Lead ID`) FROM book2) AS total_leads,
  (SELECT COUNT(`Opportunity ID`) FROM book3) AS total_opportunities,
  (SELECT COUNT(`Account ID`) FROM book1) AS total_accounts;
  
 -- revenue analysis 
  SELECT 
  concat('$',round(SUM(`Total Price`)/10000000,2),'M')AS total_revenue FROM book4;
  select
	concat('$',round(SUM(`Sales Price`)/10000000,2),'M')AS total_salesprice FROM book4;
 select
	concat('$',round(SUM(`Expected Amount`)/10000000,2),'M')AS total_expected_amnt FROM book3;
  
  -- win and loss analysis 
  SELECT 
COUNT(`Opportunity ID`) AS deals,
ROUND(SUM(CASE WHEN stage = 'Closed Won' THEN 1 ELSE 0 END) * 100.0 /COUNT(*), 2) AS win_rate,
ROUND(SUM(CASE WHEN stage = 'Closed Lost' THEN 1 ELSE 0 END) * 100.0 /COUNT(*), 2) AS loss_rate 
FROM book3 WHERE stage IN ('Closed Won', 'Closed Lost') ;

-- Conversion percentage 
SELECT 
  ROUND(
    (SELECT COUNT(*) FROM book3 WHERE stage = 'Closed Won') * 100.0 /
    (SELECT COUNT(*) FROM book2), 2) AS conversion_rate;
    
    SELECT 
  ROUND(
    (SELECT COUNT(*) FROM book3 WHERE stage = 'closed Lost') * 100.0 /
    (SELECT COUNT(*) FROM book2), 2) AS conversion_rate;
    
  
  -- products with totalprice and quantity
  SELECT 
 `Product Name`,
  concat('$',round(SUM(`Total Price`)/1000000,2),'M') AS revenue,
  SUM(Quantity) AS total_quantity
FROM book4
GROUP BY `Product Name`
ORDER BY revenue DESC;

-- users with total price by opp
SELECT 
  u.`User ID`,
  concat('$',round(SUM(p.`Total Price`)/1000000,2),'M') AS revenue
FROM book3 o
JOIN book5 u ON o.`Owner ID` = u.`User ID`
JOIN book4 p ON o.`Opportunity ID` = p.`Opportunity ID`
GROUP BY u.`User ID`
ORDER BY revenue DESC;

-- country and industry wise leads and opp
SELECT Country,
  COUNT(`Lead ID`) AS count,'Leads' AS type
FROM book2 GROUP BY Country; 

SELECT Industry,
  COUNT(`Lead ID`) AS count,'Leads' AS type
FROM book2 GROUP BY Industry; 

SELECT a.`Billing Country`,
 COUNT(o.`Opportunity ID`) as count ,'Opportunities'
FROM book3 o JOIN book1 a  ON o.`Account ID` = a.`Account ID`
GROUP BY a.`Billing Country`;

SELECT a.Industry,
 COUNT(o.`Opportunity ID`) as count ,'Opportunities'
FROM book3 o JOIN book1 a  ON o.`Account ID` = a.`Account ID`
GROUP BY a.Industry;

-- avg days took to close by billing state
SELECT 
  round(AVG( `Created Date`),2)AS avg_days_to_close
FROM book1
WHERE `Billing State/Province`= false;

-- pipeline value by stage
SELECT 
  CONCAT('$',ROUND(SUM(Amount)/10000000,2),'M') AS pipeline_value
FROM book3
WHERE stage NOT IN ('Closed Won', 'Closed Lost');

-- total deals/opp closed in loss
SELECT 
  p.`Product Name`,
  COUNT(*) AS lost_deals
FROM book3 o
JOIN book4 p ON o.`Opportunity ID`= p.`Opportunity ID`
WHERE o.stage = 'Closed Lost'
GROUP BY p.`Product Name`
ORDER BY lost_deals DESC;

-- total price by stage 
SELECT 
  o.stage,
  CONCAT('$',ROUND(SUM(p.`Total Price`)/10000000,2),'M') AS revenue
FROM book3 o
JOIN book4 p ON o.`Opportunity ID`= p.`Opportunity ID`
GROUP BY o.stage order by revenue desc;