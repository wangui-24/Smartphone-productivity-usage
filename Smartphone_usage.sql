-- DATA CLEANING--
-- Removing duplicates--
SELECT User_ID, COUNT(*) FROM smartphone_usage_productivity
GROUP BY User_ID
having count(*)>1;

-- CHECKING MISSING VALUES --
SELECT count(*) FROM smartphone_usage_productivity
WHERE Sleep_Hours IS NULL
OR Daily_Phone_Hours IS NULL
OR Social_Media_Hours IS NULL
OR Work_Productivity_Score IS NULL
OR Stress_Level IS NULL
OR Occupation IS NULL
OR Age IS NULL
OR Gender IS NULL
OR App_Usage_Count IS NULL
OR Caffeine_Intake_Cups IS NULL
OR Weekend_Screen_Time_Hours IS NULL;

-- CHECK DATA TYPES --
DESCRIBE smartphone_usage_productivity;

-- CHECK FOR OUTLIERS --

SELECT *
FROM smartphone_usage_productivity
WHERE Daily_Phone_Hours > 24
   OR Sleep_Hours > 24
   OR Age > 60;


-- DATA ANALYSIS--

-- correlation between daily phone hours and work productivity score
SELECT 
(
    COUNT(*) * SUM(Daily_Phone_Hours * Work_Productivity_Score) 
    - SUM(Daily_Phone_Hours) * SUM(Work_Productivity_Score)
) /
SQRT(
    (COUNT(*) * SUM(POWER(Daily_Phone_Hours, 2)) - POWER(SUM(Daily_Phone_Hours), 2)) *
    (COUNT(*) * SUM(POWER(Work_Productivity_Score, 2)) - POWER(SUM(Work_Productivity_Score), 2))
) AS correlation
FROM smartphone_usage_productivity;

-- DESCRIPTIVE STATISTICS --
-- MEAN--

SELECT
AVG(Daily_Phone_Hours) AS avg_phone_hours,
AVG(Social_Media_Hours) AS avg_social_hours,
AVG(Work_Productivity_Score) AS avg_productivity,
AVG(Sleep_Hours) AS avg_sleep,
AVG(Stress_Level) AS avg_stress
FROM smartphone_usage_productivity;

-- MINIMUM & MAXIMUM--
SELECT
MIN(Daily_Phone_Hours) AS min_phone,
MAX(Daily_Phone_Hours) AS max_phone,
MIN(Sleep_Hours) AS min_sleep,
MAX(Sleep_Hours) AS max_sleep
FROM smartphone_usage_productivity;

-- STANDARD DEVIATION--
SELECT
STDDEV(Daily_Phone_Hours) AS std_phone,
STDDEV(Work_Productivity_Score) AS std_productivity
FROM smartphone_usage_productivity;

-- PIVOT TABLES --
-- OCCUPATION VS PHONE USAGE--smartphone_usage_productivity
SELECT Occupation, round(AVG (Daily_Phone_Hours),2) AS avg_phone_usage
FROM smartphone_usage_productivity
GROUP BY Occupation
ORDER BY avg_phone_usage DESC;

# BUSINESS OWNERS HAVE THE HIGHEST PHONE USAGE#


-- GENDER VS SOCIAL MEDIA HOURS --
SELECT Gender, ROUND(avg(Social_media_hours),2) AS avg_social_media
FROM smartphone_usage_productivity
GROUP BY Gender
ORDER BY avg_social_media DESC;

# The results indicate that Female users have the highest avg social media usage among all gender groups #

-- PRODUCTIVITY VS PHONE_USAGE --
SELECT
CASE
WHEN Daily_Phone_Hours < 3 THEN 'Low Usage'
WHEN Daily_Phone_Hours BETWEEN 3 AND 6 THEN 'Moderate Usage'
ELSE 'Heavy Usage'
END AS phone_usage_group,
AVG(Work_Productivity_Score) AS avg_productivity
FROM smartphone_usage_productivity
GROUP BY phone_usage_group;

# Heavy users may have lower productivity #

-- STRESS_LEVEL VS SOCIAL_MEDIA_USAGE
SELECT 
CASE 
WHEN Social_Media_Hours<2 Then'Low social media'
WHEN Social_Media_Hours BETWEEN 2 AND 5 THEN 'moderate social media'
ELSE'high'
END AS social_media_group,
AVG(stress_level) AS avg_stress
FROM smartphone_usage_productivity
GROUP BY social_media_group
ORDER BY avg_stress DESC;

# Low social media usage increases level of stress #

-- AVERAGE_SLEEP VS CAFFEINE_INTAKE --
SELECT Caffeine_intake_cups,
AVG(sleep_hours) AS avg_sleep
FROM smartphone_usage_productivity
GROUP BY Caffeine_Intake_Cups
ORDER BY Caffeine_Intake_Cups;

# Higher caffeine intake less sleep #

-- AGE GROUP PRODUCTIVITY COMPARISON --
SELECT
CASE
WHEN Age BETWEEN 18 AND 30 THEN 'YOUNG'
WHEN Age BETWEEN 30 AND 40 THEN 'MIDDLE_AGE'
ELSE 'OLD'
END AS age_group,
AVG(Work_Productivity_Score) AS avg_productivity
FROM smartphone_usage_productivity
GROUP BY age_group
ORDER BY age_group DESC;

# Young people are more productive #

-- DEVICE_TYPE VS IOS USAGE_HOURS--
SELECT 
Device_Type,
ROUND(AVG(Daily_phone_hours),2)AS avg_phone_usage,
ROUND(AVG(social_media_hours),2)AS avg_social_usage
FROM smartphone_usage_productivity
GROUP BY device_type;

#The analysis shows that Android and iOS users have very similar smartphone usage pattern #
#The average daily phone usage and social media usage do not differ significantly between the two device types #

-- APP_USAGE VS PRODUCTIVITY --
SELECT 
App_usage_count,
AVG(Work_productivity_score) AS avg_productivity
FROM smartphone_usage_productivity
GROUP BY App_Usage_Count
ORDER BY App_Usage_Count DESC
limit 10;


