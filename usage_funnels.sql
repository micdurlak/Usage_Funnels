-- quiz funnel

-- number of responses for each question
 SELECT question, COUNT(DISTINCT user_id) AS num_of_answers
 FROM survey
 GROUP BY question;

-- home try-on funnel

-- I used a LEFT JOIN to combine the three tables,
-- starting at the top of the funnel (browse) and ending with the bottom of the funnel (purchase) 
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id;

-- once we had the data in this format, I could analyze it
-- I could calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5
WITH funnel_query AS (
SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL AS is_home_try_on,
       h.number_of_pairs,
       p.user_id IS NOT NULL AS is_purchase
FROM quiz AS q
LEFT JOIN home_try_on AS h ON q.user_id = h.user_id
LEFT JOIN purchase AS p ON q.user_id = p.user_id
WHERE number_of_pairs IS NOT NULL)
SELECT 
  number_of_pairs AS num_of_glasses_try_on,
  COUNT(*) AS 'num_of_customers',
  SUM(is_purchase) AS 'num_of_purchase',
  1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try_to_purchase'
FROM funnel_query
GROUP BY 1
ORDER BY 1;

-- the most common results of the style quiz
SELECT style, COUNT(user_id) AS amount
FROM quiz
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- other calculations
-- the most common types of purchase made
SELECT model_name, COUNT(user_id) AS amount
FROM purchase
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;