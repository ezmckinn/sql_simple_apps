 -- calculating churn rates based on survey data from Warby Parker
 
 SELECT * FROM survey LIMIT 10;

 SELECT question, COUNT(DISTINCT(user_id)) as 'responses' 
 FROM survey
 GROUP BY question;

 -- questions with lowest completion rates are the ones about the last eye exam. People don't know. 

 -- Examining tables & column names

 SELECT * FROM quiz
 LIMIT 5;

 SELECT * FROM home_try_on
 LIMIT 5;

 SELECT * FROM purchase
 LIMIT 5;

 -- Create Funnel

WITH funnel AS (SELECT DISTINCT q.style, q.user_id, 
h.user_id IS NOT NULL AS 'is_home_try_on', -- create a binary column saying whether a user tried it on
h.number_of_pairs, 
p.user_id IS NOT NULL AS 'is_purchase' -- create a binary column sayin
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id 
LEFT JOIN purchase as 'p'
ON q.user_id = p.user_id)
SELECT style, COUNT(user_id) as 'quiz_total',
SUM(is_home_try_on) as 'try_on_total',
1.0 * SUM(is_home_try_on) / COUNT(user_id) as 'quiz_to_try_on',
1.0 * SUM(is_purchase) / SUM(is_home_try_on) as 'try_on_to_purchase'
FROM funnel
GROUP BY style;

-- Insights

