# COVID-19 National Healthcare Safety Network (NHSN) Data Analysis
### Project Overview:

The goal of this project is to perform a comprehensive analysis of the COVID-19 National Healthcare Safety Network (NHSN) data. The data is available in four zip files representing the years 2020, 2021, 2022, and 2023.

**Objectives**:

* Extract and import the data from the zip files into a SQL database.	
* Clean and transform the data to ensure consistency and accuracy.
* Conduct exploratory data analysis to identify trends, patterns, and insights.
* Perform statistical analysis to understand the impact of COVID-19 on healthcare facilities. 
* Generate meaningful visualizations and reports to present the findings to stakeholders. 
* Identify potential areas for improvement in healthcare practices based on the analysis. 

**Data Sources**: The data was gotten from the following URLs: 
*	2020 data: https://download.cms.gov/covid_nhsn/faclevel_2020.zip 
* 2021 data: https://download.cms.gov/covid_nhsn/faclevel_2021.zip 
* 2022 data: https://download.cms.gov/covid_nhsn/faclevel_2022.zip 
* 2023 data: https://download.cms.gov/covid_nhsn/faclevel_2023.zip 

**Methodology**: 
* Extract the zip files and import the data into a SQL database. 
* Perform data cleaning and preprocessing to address missing values, duplicates, and inconsistencies. 
* Explore the data using SQL queries to identify key metrics, trends, and patterns. 
* Conduct statistical analysis to understand the impact of COVID-19 on different healthcare facilities. 
* Utilize SQL functions, aggregations, and joins to derive meaningful insights from the data. 
* Create visualizations and reports using SQL or export the data to external tools for visualization.

#### Questions: 
1. Which healthcare facilities had the highest average number of daily COVID-19 cases in 2021? Display the top 10 facilities. 
2. Calculate the 7-day moving average of new COVID-19 cases for each healthcare facility. Which facility had the highest peak in the moving average?
3. Determine the total number of COVID-19 cases, deaths, and recoveries for each state. Include the state's name and the corresponding counts in the result.
4. Find the top 5 states with the highest mortality rate (deaths per COVID-19 case) in 2022
5. Identify the healthcare facilities that experienced a significant increase in COVID-19 cases from 2020 to 2021 (more than 50% increase). Display the facility names and the percentage increase
6. Calculate the average length of hospital stay for COVID-19 patients.
7. Identify the top 3 states with the highest overall COVID-19 testing rates (tests per 1000 people) in 2023.
8. What is the total number of COVID-19 cases, deaths, and recoveries recorded in the dataset?
9. Find the healthcare facilities that had a consistent increase in COVID-19 cases for at least 5 consecutive months. Display the facility names and the corresponding months.
10. Calculate the mortality rate (deaths per COVID-19 case) for each healthcare facility.
11. Are there any significant differences in COVID-19 outcomes based on the type of healthcare facility (e.g., hospital, nursing home)?
12. How has the number of COVID-19 cases evolved over time (monthly or quarterly)?
13. What is the distribution of healthcare facilities by state?
14. Find the healthcare facilities with the highest occupancy rates for COVID-19 patients.
15. Find the healthcare facilities with the highest occupancy rates for COVID-19 patients.

### Data cleaning 
I extracted the data from Google drive and imported to Excel where I decided to transform the data using **Power Query**.
I removed all unwanted columns leaving only the ones needed for my analysis, which are;
facility_no,
facility_name,
facility_add,
city,
state,
zip_code,
county,
weekly_resident_covid_admission,
tot_resident_covid_admission,
weekly_resident_covid_cases,
tot_resident_covid_cases,
weekly_resident_all_deaths,
tot_all_resident_deaths,
weekly_resident_covid_deaths,
tot_resident_covid_deaths,
no_all_beds,
tot_no_occup_beds,
weekly_staff_covid_case,
tot_staff_covid_case,
weekly_staff_covid_death,
tot_staff_covid_death,
staff_shortage,
nursing_staff_shortage,
clinical_staff_shortage,
aides_shortage,
other_staff_shortage

After transforming with Power query, I imported the data to Microsoft SQL Server for analysis, The codes I used in the Mining and exploration can be found in the **NHSN Query** file uploaded in this    Repository.

## Recommendations
1. Increase Vaccination Efforts: Promote and encourage vaccination campaigns to increase the number of vaccinated individuals across the country. Focus on addressing vaccine hesitancy and ensuring equitable access to vaccines for all communities.
2. Implement and Enforce Public Health Measures: Reinforce the importance of following public health measures such as wearing masks, practicing social distancing, and maintaining good hand hygiene. Continuously educate the public about the significance of these measures in preventing the spread of the virus.
3. Improve Testing and Contact Tracing: Strengthen testing capabilities and ensure widespread availability of COVID-19 tests. Enhance contact tracing efforts to quickly identify and isolate individuals who may have been exposed to the virus.
4. Enhance Healthcare System Preparedness: Provide additional support and resources to healthcare systems to effectively manage COVID-19 cases. This includes ensuring sufficient availability of medical supplies, equipment, and personnel, as well as coordinating with healthcare facilities to handle potential surges in cases.
5. Promote Health Education and Awareness: Launch public awareness campaigns to educate individuals about the importance of COVID-19 prevention, symptoms, and when to seek medical attention. Disseminate accurate and up-to-date information to combat misinformation and promote responsible behavior.
6. Support Vulnerable Populations: Implement targeted interventions to protect and support vulnerable populations, including the elderly, individuals with underlying health conditions, and communities with limited access to healthcare resources. Ensure they have access to necessary healthcare services, vaccination opportunities, and support for quarantine and isolation.
7. Collaborate and Share Data: Foster collaboration and information sharing between federal, state, and local health authorities to enable a coordinated response to the pandemic. Facilitate the sharing of data and best practices to enhance decision-making and response efforts.
8. Monitor Variants and Emerging Trends: Continuously monitor and analyze COVID-19 variants and emerging trends in order to adapt strategies accordingly. Stay vigilant to the potential impact of new variants on transmission, severity, and vaccine effectiveness, and adjust public health measures as needed.
9. Prepare for Future Outbreaks: Use the lessons learned from the current pandemic to strengthen preparedness for future outbreaks or public health emergencies. Invest in research, infrastructure, and systems that can better respond to and mitigate the impact of similar crises in the future.
