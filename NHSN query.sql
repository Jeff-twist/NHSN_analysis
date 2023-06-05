- Facilty with the highest average number of daily cases in 2021
SELECT TOP 10 Provider_Name, ROUND(AVG(Residents_Weekly_Confirmed_COVID_19),1) AS average_daily_cases
FROM faclevel21
GROUP BY Provider_Name
ORDER BY average_daily_cases DESC;

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 - 7 day moving average
WITH cte AS (
  SELECT 
    Provider_Name,
    [Week_Ending],
    [Residents_Weekly_Confirmed_COVID_19],
    AVG([Residents_Weekly_Confirmed_COVID_19]) OVER (
      PARTITION BY [Provider_Name] 
      ORDER BY CONVERT(DATE, [Week_Ending]) 
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_average
  FROM (
    SELECT [Provider_Name], [Week_Ending], [Residents_Weekly_Confirmed_COVID_19] 
    FROM faclevel_2020
    UNION ALL
    SELECT [Provider_Name], [Week_Ending], [Residents_Weekly_Confirmed_COVID_19]
    FROM faclevel21
    UNION ALL
    SELECT [Provider_Name], [Week_Ending], [Residents_Weekly_Confirmed_COVID_19]
    FROM faclevel22
    UNION ALL
    SELECT [Provider_Name], [Week_Ending], [Residents_Weekly_Confirmed_COVID_19]
    FROM faclevel23
  ) AS merged
)
SELECT TOP 10 [Provider_Name], MAX(moving_average) AS highest_peak
FROM cte
GROUP BY [Provider_Name]
ORDER BY highest_peak DESC;

select * from faclevel21;

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Top 5 states with the highest mortality rate in 2022.
WITH cte AS (
  SELECT
    [Provider_State] AS State,
    SUM([Residents_Weekly_Confirmed_COVID_19]) AS Total_Cases,
    SUM([Residents_Weekly_All_Deaths]) AS Total_Deaths,
    SUM([Residents_Weekly_Confirmed_COVID_19] - [Residents_Weekly_All_Deaths]) AS Total_Recoveries
  FROM faclevel22
  GROUP BY [Provider_State]
)
SELECT TOP 5
  State,
  Total_Deaths,
  Total_Cases,
  ROUND(Total_Deaths * 100.0 / Total_Cases,1) AS Mortality_Rate
FROM cte
ORDER BY Mortality_Rate DESC;

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 - Total Deaths, Cases, and recoveries for each states
  SELECT
    [Provider_State] AS State,
    SUM([Residents_Weekly_Confirmed_COVID_19]) AS Total_Cases,
    SUM([Residents_Weekly_All_Deaths]) AS Total_Deaths,
    SUM([Residents_Weekly_Confirmed_COVID_19] - [Residents_Weekly_All_Deaths]) AS Total_Recoveries
  FROM (
    SELECT [Provider_State], [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel_2020
    UNION ALL
    SELECT [Provider_State], [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel21
    UNION ALL
    SELECT [Provider_State], [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel22
    UNION ALL
    SELECT [Provider_State], [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel23
  ) AS merged
  GROUP BY [Provider_State]

SELECT State, Total_Cases, Total_Deaths, Total_Recoveries
FROM cte;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Healthcare facilities that experienced a significant increase in COVID-19 cases from 2020 to 2021 (more than 50% increase). 
WITH cte AS (
  SELECT
    [Provider_Name],
    SUM([Residents_Weekly_Confirmed_COVID_19]) AS Cases_yr20,
    (SELECT SUM([Residents_Weekly_Confirmed_COVID_19])
     FROM faclevel21
     WHERE [Provider_Name] = yr.[Provider_Name]) AS Cases_yr21
  FROM faclevel_2020 yr
  GROUP BY [Provider_Name]
)
SELECT TOP 10
  [Provider_Name],
  CASE WHEN Cases_yr20 = 0 THEN NULL
       ELSE ((Cases_yr21 - Cases_yr20) * 100.0 / NULLIF(Cases_yr20, 0))
  END AS Percent_Incr
FROM cte
WHERE Cases_yr21 > Cases_yr20 * 1.5
ORDER BY Percent_Incr DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Total number of COVID-19 cases, deaths, and recoveries recorded in the datasets?
SELECT
    SUM([Residents_Weekly_Confirmed_COVID_19]) AS TotalCases,
    SUM([Residents_Weekly_All_Deaths]) AS TotalDeaths,
    SUM([Residents_Weekly_Confirmed_COVID_19] - [Residents_Weekly_All_Deaths]) AS TotalRecoveries
FROM (
    SELECT [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel_2020
    UNION ALL
    SELECT [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel21
    UNION ALL
    SELECT [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel22
    UNION ALL
    SELECT [Residents_Weekly_Confirmed_COVID_19], [Residents_Weekly_All_Deaths]
    FROM faclevel23
) AS merged;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Healthcare facilities that had a consistent increase in COVID-19 cases
WITH cte AS (
  SELECT
    [Provider_Name],
    [Week_Ending],
    [Residents_Weekly_Confirmed_COVID_19],
    ROW_NUMBER() OVER (PARTITION BY [Provider_Name] ORDER BY [Week_Ending]) AS RowNum
  FROM faclevel_2020
  UNION ALL
  SELECT
    [Provider_Name],
    [Week_Ending],
    [Residents_Weekly_Confirmed_COVID_19],
    ROW_NUMBER() OVER (PARTITION BY [Provider_Name] ORDER BY [Week_Ending]) AS RowNum
  FROM faclevel21
  UNION ALL
  SELECT
    [Provider_Name],
    [Week_Ending],
    [Residents_Weekly_Confirmed_COVID_19],
    ROW_NUMBER() OVER (PARTITION BY [Provider_Name] ORDER BY [Week_Ending]) AS RowNum
  FROM faclevel22
  UNION ALL
  SELECT
    [Provider_Name],
    [Week_Ending],
    [Residents_Weekly_Confirmed_COVID_19],
    ROW_NUMBER() OVER (PARTITION BY [Provider_Name] ORDER BY [Week_Ending]) AS RowNum
  FROM faclevel22
)
SELECT
  top 10 [Provider_Name],
  MIN([Week_Ending]) AS StartDate,
  MAX([Week_Ending]) AS EndDate
FROM cte
WHERE [Residents_Weekly_Confirmed_COVID_19] > 0
GROUP BY [Provider_Name], [Residents_Weekly_Confirmed_COVID_19] - RowNum
HAVING COUNT(*) >= 5;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Mortality rate (deaths per COVID-19 case) for each healthcare facility.
WITH cte AS (
  SELECT
    [Provider_Name],
    SUM(CAST([Residents_Weekly_Confirmed_COVID_19] AS int)) AS Cases,
    SUM(CAST([Residents_Weekly_COVID_19_Deaths] AS int)) AS Deaths
  FROM faclevel_2020
  GROUP BY [Provider_Name]
  UNION ALL
  SELECT
    [Provider_Name],
    SUM(CAST([Residents_Weekly_Confirmed_COVID_19] AS int)) AS Cases,
    SUM(CAST([Residents_Weekly_COVID_19_Deaths] AS int)) AS Deaths
  FROM faclevel21
  GROUP BY [Provider_Name]
  UNION ALL
  SELECT
    [Provider_Name],
    SUM(CAST([Residents_Weekly_Confirmed_COVID_19] AS int)) AS Cases,
    SUM(CAST([Residents_Weekly_COVID_19_Deaths] AS int)) AS Deaths
  FROM faclevel22
  GROUP BY [Provider_Name]
  UNION ALL
  SELECT
    [Provider_Name],
    SUM(CAST([Residents_Weekly_Confirmed_COVID_19] AS int)) AS Cases,
    SUM(CAST([Residents_Weekly_COVID_19_Deaths] AS int)) AS Deaths
  FROM faclevel23
  GROUP BY [Provider_Name]
)
SELECT
  top 10 [Provider_Name],
  ROUND(Deaths * 100.0 / Cases,0) AS MortalityRate
FROM cte
WHERE Cases > 0
ORDER BY MortalityRate DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH cte AS (
  SELECT
    [Provider_Name] AS Provider_Name,
    CASE [Provider_State]
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AK' THEN 'Alaska'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'ME' THEN 'Maine'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MS' THEN 'Mississippi'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NE' THEN 'Nebraska'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NH' THEN 'New Hampshire'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NY' THEN 'New York'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'SD' THEN 'South Dakota'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VT' THEN 'Vermont'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WV' THEN 'West Virginia'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WY' THEN 'Wyoming'
		WHEN 'DC' THEN 'Washington DC'
        WHEN 'PR' THEN 'Puerto Rico'
        WHEN 'GU' THEN 'Guam'
        ELSE [Provider_State]  -- Use the original value if no match is found
    END AS Provider_State
  FROM faclevel_2020
  UNION ALL
  SELECT
    [Provider_Name] AS Provider_Name,
    CASE [Provider_State]
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AK' THEN 'Alaska'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'ME' THEN 'Maine'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MS' THEN 'Mississippi'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NE' THEN 'Nebraska'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NH' THEN 'New Hampshire'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NY' THEN 'New York'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'SD' THEN 'South Dakota'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VT' THEN 'Vermont'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WV' THEN 'West Virginia'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WY' THEN 'Wyoming'
		WHEN 'DC' THEN 'Washington DC'
        WHEN 'PR' THEN 'Puerto Rico'
        WHEN 'GU' THEN 'Guam'
        ELSE [Provider_State]  -- Use the original value if no match is found
    END AS Provider_State
  FROM faclevel21
  UNION ALL
  SELECT
    [Provider_Name] AS Provider_Name,
    CASE [Provider_State]
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AK' THEN 'Alaska'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'ME' THEN 'Maine'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MS' THEN 'Mississippi'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NE' THEN 'Nebraska'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NH' THEN 'New Hampshire'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NY' THEN 'New York'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'SD' THEN 'South Dakota'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VT' THEN 'Vermont'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WV' THEN 'West Virginia'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WY' THEN 'Wyoming'
		WHEN 'DC' THEN 'Washington DC'
        WHEN 'PR' THEN 'Puerto Rico'
        WHEN 'GU' THEN 'Guam'
        ELSE [Provider_State]  -- Use the original value if no match is found
    END AS Provider_State
  FROM faclevel22
  UNION ALL
  SELECT
    [Provider_Name] AS Provider_Name,
    CASE [Provider_State]
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AK' THEN 'Alaska'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'ME' THEN 'Maine'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MS' THEN 'Mississippi'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NE' THEN 'Nebraska'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NH' THEN 'New Hampshire'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NY' THEN 'New York'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'SD' THEN 'South Dakota'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VT' THEN 'Vermont'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WV' THEN 'West Virginia'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WY' THEN 'Wyoming'
		WHEN 'DC' THEN 'Washington DC'
        WHEN 'PR' THEN 'Puerto Rico'
        WHEN 'GU' THEN 'Guam'
        ELSE [Provider_State]  -- Use the original value if no match is found
    END AS Provider_State
  FROM faclevel23
)

SELECT
  [Provider_State],
  COUNT(DISTINCT [Provider_Name]) AS FacilityCount
FROM cte
GROUP BY [Provider_State]
ORDER BY FacilityCount DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
select * from faclevel_2020;
select * from faclevel21;
select * from faclevel22;
select * from faclevel23;