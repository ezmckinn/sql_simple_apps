-- get familiar with data
 SELECT * FROM subscriptions LIMIT 100;

 -- how many different segments?
 SELECT COUNT (DISTINCT(segment)) from subscriptions as 'Number of Segments';

 -- determine range of months of data provided

SELECT subscription_end, COUNT(subscription_end)
FROM subscriptions 
GROUP BY subscription_end;

-- Set up months table

WITH months as (SELECT 
  '2017-01-01' as first_day,
  '2017-01-31' as last_day,
  segment
  FROM subscriptions
UNION
SELECT 
  '2017-02-01' as first_day,
  '2017-02-28' as last_day,
  segment
  FROM subscriptions
UNION
SELECT 
  '2017-03-01' as first_day,
  '2017-03-31' as last_day,
  segment
  FROM subscriptions),
cross_join as 
(SELECT * 
FROM subscriptions
CROSS JOIN months 
),
status as
(SELECT id, first_day as 'month'
  CASE
  WHEN segment = 87 AND
    subscription_start < first_day AND
    (subscription_end > last_day OR subscription_end IS NULL) THEN 1
    ELSE 0
  END AS 'is_active_87'
  WHEN segment = 30 AND
    subscription_start < first_day AND
    (subscription_end > last_day OR subscription_end IS NULL) THEN 1
    ELSE 0
  END AS 'is_active_30'
  WHEN segment = 87 AND
    subscription_start < first_day AND
    (subscription_end BETWEEN first_day AND last_day) THEN 1
    ELSE 0
  END AS 'is_canceled_87'
  WHEN segment = 30 AND
    subscription_start < first_day AND
    (subscription_end BETWEEN first_day AND last_day) THEN 1
    ELSE 0
  END AS 'is_canceled_30'
FROM cross_join
),
status_aggregate as
(SELECT 
month,
SUM(is_active_87) AS 'sum_active_87',
SUM(is_active_30) AS 'sum_active_30',
SUM(is_canceled_87) AS 'sum_canceled_87',
SUM(is_canceled_87) AS 'sum_canceled_87',
FROM status 
),
churn_rates as
(
SELECT month, 
churn_rate_87 AS sum_canceled_87/sum_active_87,
SELECT churn_rate_30 AS sum_canceled_30/sum_active_30,
FROM status_aggregate);
