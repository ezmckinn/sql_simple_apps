
-- Selecting from page_visits database.

SELECT * FROM page_visits LIMIT 3;

-- see how many campaigns you have 
SELECT COUNT(DISTINCT(utm_campaign)) FROM page_visits;

-- see how many sources you have
SELECT COUNT(DISTINCT(utm_source)) FROM page_visits; 

-- see how they are related (for each distinct in one column, list the other ones)
SELECT DISTINCT utm_source, utm_campaign FROM page_visits ORDER BY utm_source;

-- what pages are on the Cool T-Shirts website

SELECT DISTINCT page_name FROM page_visits;

-- how many first touches is each campaign responsible for.

WITH first_touch AS (SELECT user_id, utm_campaign, MIN(timestamp) as 'first_touch_at' -- say what columns you want
FROM page_visits
GROUP BY user_id) -- you want the first touch for each user.
SELECT utm_campaign, COUNT(user_id) FROM first_touch GROUP BY utm_campaign;

WITH last_touch AS (SELECT user_id, utm_campaign, MAX(timestamp) as 'last_touch_at' -- say what columns you want
FROM page_visits
GROUP BY user_id) -- you want the first touch for each user.
SELECT utm_campaign, COUNT(user_id) FROM last_touch GROUP BY utm_campaign;

-- how many visitors make a purchase?
SELECT COUNT(DISTINCT(user_id)) FROM page_visits WHERE page_name = '4 - purchase';

-- how many last touches on the purchase page is each campaign responsible for?
WITH last_touch AS (SELECT page_name, user_id, utm_campaign, MAX(timestamp) as 'last_touch_at' -- say what columns you want
FROM page_visits
GROUP BY user_id) -- you want the first touch for each user.
SELECT page_name, utm_campaign, COUNT(user_id) as 'total'
FROM last_touch 
WHERE page_name = '4 - purchase' 
GROUP BY utm_campaign
ORDER BY total DESC LIMIT 5;