-- 1.	WHAT IS THE TOTAL NUMBER OF TRANSACTIONS GENERATED PER OPERATING
-- SYSTEM IN MAY AND JUNE OF 2017?

SELECT
device.operatingSystem,
SUM ( totals.transactions ) AS total_transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
_TABLE_SUFFIX BETWEEN '20170501' AND '20170630'
GROUP BY
device.operatingSystem
ORDER BY
total_transactions DESC

-- 2.	HOW POPULAR IS THE ANDROID OPERATING
-- SYSTEM WITH YOUR USERS (WHERE DEVICE.OPERATINGSYSTEM = 'ANDROID')?

-- 3.	ARE MOST OF YOUR USERS ACCESSING THE SITE FROM A MOBILE DEVICE?

-- 4.	THE REAL BOUNCE RATE IS DEFINED AS THE PERCENTAGE OF VISITS WITH A SINGLE
-- PAGEVIEW. FOR TRAFFIC SOURCES WHERE WE HAD MORE THAN 100 VISITS, WHAT
-- WAS THE REAL BOUNCE RATE PER TRAFFIC SOURCE?

SELECT
  trafficSource.source AS source,
  COUNT(*) AS total_visits,
  COUNTIF(totals.hits = 1) AS single_page_visits,
  ROUND(COUNTIF(totals.hits = 1) / COUNT(*) * 100, 2) AS bounce_rate
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE
  trafficSource.source != '(direct)' -- exclude direct traffic
GROUP BY
  source
HAVING
  COUNT(*) > 100 -- filter for sources with more than 100 visits
ORDER BY
  total_visits DESC


-- 5.	GIVEN THAT THIS IS GOOGLE'S STORE, WHAT IDEAS DO YOU THINK OUR MARKETERS
-- SHOULD TAKE AWAY FROM THIS?
-- 6.	FOR USERS WHO CAME TO US FROM YOUTUBE.COM (WHERE TRAFFICSOURCE.SOURCE
-- = 'YOUTUBE.COM'), WHAT WAS THE AVERAGE NUMBER OF PRODUCT PAGEVIEWS FOR
-- USERS WHO MADE A PURCHASE IN MAY AND JUNE OF 2017?

#standardSQL
SELECT
( SUM(total_pagesviews_per_user) / COUNT(users) ) AS avg_pageviews_per_user
FROM (
SELECT
fullVisitorId AS users,
SUM(totals.pageviews) AS total_pagesviews_per_user
FROM`bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
_TABLE_SUFFIX BETWEEN '20170501' AND '20170630' 
AND
totals.transactions >=1
AND 
trafficSource.source = 'youtube.com'
GROUP BY
users )


-- Ans 32


-- 7.	FOR USERS WHO CAME TO US FROM YOUTUBE.COM, WHAT WAS THE AVERAGE
-- NUMBER OF PRODUCT PAGEVIEWS FOR USERS WHO DID NOT MAKE A PURCHASE IN
-- MAY AND JUNE OF 2017 ?

#standardSQL
SELECT
( SUM(total_pagesviews_per_user) / COUNT(users) ) AS avg_pageviews_per_user
FROM (
SELECT
fullVisitorId AS users,
SUM(totals.pageviews) AS total_pagesviews_per_user
FROM`bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
_TABLE_SUFFIX BETWEEN '20170501' AND '20170630'
AND
totals.transactions IS NULL
AND 
trafficSource.source = 'youtube.com'
GROUP BY
users )


-- 2.2875776397515528



