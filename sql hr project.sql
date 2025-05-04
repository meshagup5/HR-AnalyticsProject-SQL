SELECT * FROM sql_project.adviti_hr_data;
use  sql_project;
--  PS 01 identify factors influencing employee attrition
-- PS 02 enhance employee engagement

-- create age groups
-- club positions : Account exec. ,account executive ,  Accountexec. , accountexecutive
-- content creator ,creator 
-- Data Analyst , DataAnalyst
-- Analytics intern , intern , se intern 
-- Club gender 
-- salary category 
-- training hours category 
-- Absenteeism category
-- distane from work category
-- sum up to 100%

CREATE TABLE adviti_hr_data_analysis AS 
SELECT 
Employee_ID,
Employee_Name,
Age,
CASE 
	WHEN Age BETWEEN 21 AND 25 THEN '21-25'
	WHEN Age BETWEEN 26 AND 30 THEN '26-30'
    WHEN Age BETWEEN 31 AND 35 THEN '31-35'
    WHEN Age BETWEEN 36 AND 40 THEN '36-40'
    WHEN Age BETWEEN 41 AND 45 THEN '41-45'
    WHEN Age BETWEEN 46 AND 50 THEN '46-50'
    ELSE '<=20'
END AS AgeGroup,
Years_of_Service,
Position,
CASE 
	WHEN Position IN ('Account Exec.', 'Account Executive', 'AccountExec.', 'AccountExecutive') THEN 'Account Executive'
    WHEN Position IN ('Content Creator', 'Creator') THEN 'Content Creator'
    WHEN Position IN ('DataAnalyst', 'Data Analyst') THEN 'Data Analyst'
    WHEN Position IN ('Analytics Intern', 'Intern', 'SE Interns') THEN 'Interns'
    ELSE Position
END AS Position_updated,
REPLACE(REPLACE(REPLACE(REPLACE(Gender, 'Male', 'M'), 'Female', 'F'), 'M', 'Male'), 'F', 'Female') AS Gender,
CASE 
	WHEN Department = '' THEN 'Management' 
    ELSE Department 
END AS Department,
Salary,
    CASE 
		WHEN Salary >= 5000000 THEN '> 50L'
        WHEN Salary >= 4000000 THEN '40L - 50L'
        WHEN Salary >= 3000000 THEN '30L - 40L'
        WHEN Salary >= 2000000 THEN '20L - 30L'
        WHEN Salary >= 1000000 THEN '10L - 20L'
        ELSE '< 10L'
	END AS Salary_Buckets,
Performance_Rating,
Work_Hours,
Attrition,
Promotion,
Training_Hours,
CASE 
	WHEN Training_Hours >= 40 THEN '40+ Hours'
	WHEN Training_Hours >= 30 THEN '30 - 40 Hours'
	WHEN Training_Hours >= 20 THEN '20 - 30 Hours'
	WHEN Training_Hours >= 10 THEN '10 - 20 Hours'
	ELSE '< 10 Hours'
END AS Training_Hours_Buckets,
Satisfaction_Score,
Education_Level,
Employee_Engagement_Score,
Absenteeism,
CASE
	WHEN Absenteeism = 0 THEN 'No Leaves'
	WHEN Absenteeism BETWEEN 1 AND 5 THEN '1-5 days'
	WHEN Absenteeism BETWEEN 6 AND 10 THEN '6-10 days'
	WHEN Absenteeism BETWEEN 11 AND 15 THEN '11-15 days'
	ELSE '15+ days'
END AS Absenteeism_Buckets,
Distance_from_Work,
CASE 
	WHEN Distance_from_Work >= 40 THEN '40+ Kms'
	WHEN Distance_from_Work >= 30 THEN '30 - 40 Kms'
	WHEN Distance_from_Work >= 20 THEN '20 - 30 Kms'
	WHEN Distance_from_Work >= 10 THEN '10 - 20 Kms'
	ELSE '< 10 Kms'
END AS Distance_from_Work_Buckets,
JobSatisfaction_PeerRelationship,
JobSatisfaction_WorkLifeBalance,
JobSatisfaction_Compensation,
JobSatisfaction_Management,
JobSatisfaction_JobSecurity,
(JobSatisfaction_PeerRelationship +
JobSatisfaction_WorkLifeBalance +
JobSatisfaction_Compensation +
JobSatisfaction_Management +
JobSatisfaction_JobSecurity)/5*100 AS JobSatisfaction_rate,    
EmployeeBenefit_HealthInsurance,
EmployeeBenefit_PaidLeave,
EmployeeBenefit_RetirementPlan,
EmployeeBenefit_GymMembership,
EmployeeBenefit_ChildCare,
(EmployeeBenefit_HealthInsurance +
EmployeeBenefit_PaidLeave +
EmployeeBenefit_RetirementPlan +
EmployeeBenefit_GymMembership +
EmployeeBenefit_ChildCare)/5*100 AS EmployeeBenefit_Satisfaction_rate
FROM adviti_hr_data;

-- Attrition rate is 48%
-- No effect of gender on Attrition
-- Sales , HR , IT has the highest Attrition Rate
-- people with 20L-30L salary has highest attrition rate from hr and sales department
-- Dstance from work also have contribution in attrition 
-- not get promoted after a long year of service leads to attrition
-- people with 1 year of work got promotion but people with 5 and 6 year ofwork does not get promoted 
-- Age group of 21-25 and 41-45 has highest attrition
-- 21-25 has good number of service year had salary less then 10L and some of them even don't get promotion 
-- 41-45 has good number of service year had salary less then 10L and some of them even don't get promotion
-- people with 5 year of service not get promotion and they left the company
-- Satisfaction score also can't clarify attrition as score of 5 has 50% attrition
-- low employee engagement score shows attrition 
-- Job satisfaction rate for Operations Are gudd but employee benefit is low
-- somewhat working hours also effects
-- high performers feel undervalued , employee benefit


SELECT 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'; 

SELECT Gender, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Gender;

SELECT AgeGroup, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY AgeGroup;

SELECT Years_of_Service, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Years_of_Service;

SELECT Position_updated, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Position_updated
ORDER BY "Attrition_Yes_%" DESC;

SELECT Department, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Department
ORDER BY "Attrition_Yes_%" DESC;

SELECT Salary_Buckets, department,Years_of_Service,AgeGroup,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets ,department,Years_of_Service,AgeGroup
ORDER BY "Attrition_Yes_%" DESC;

SELECT Promotion, Years_of_Service,AgeGroup,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Promotion ,Years_of_Service,AgeGroup
ORDER BY "Attrition_Yes_%" DESC;


SELECT Distance_from_Work_Buckets, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Distance_from_Work_Buckets;

SELECT Distance_from_Work_Buckets, JobSatisfaction_rate,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Distance_from_Work_Buckets,JobSatisfaction_rate;

SELECT Distance_from_Work_Buckets,EmployeeBenefit_Satisfaction_rate,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Distance_from_Work_Buckets,EmployeeBenefit_Satisfaction_rate;


SELECT Promotion, Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Promotion, Years_of_Service
ORDER BY "Attrition_Yes_%" DESC;

SELECT AgeGroup, Salary_Buckets,Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY AgeGroup,Salary_Buckets,Years_of_Service;

SELECT Years_of_Service, Promotion,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Years_of_Service,Promotion;

SELECT Performance_Rating, Promotion,Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and Performance_Rating = 5 
GROUP BY Performance_Rating,Promotion,Years_of_Service;

SELECT Satisfaction_Score,  Work_Hours,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and Work_Hours >= 50
GROUP BY Satisfaction_Score,Work_Hours;

SELECT  Department, JobSatisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY  Department,JobSatisfaction_rate;

SELECT  Department, Distance_from_Work_Buckets,Work_Hours,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and department in ( 'Operations' , 'HR')
GROUP BY  Department, Distance_from_Work_Buckets, Work_Hours;


SELECT  Position_updated, department,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY  Position_updated,department;

SELECT Performance_Rating, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY  Performance_Rating;

SELECT  Performance_Rating,Promotion,Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and Promotion != 'Yes'
GROUP BY   Performance_Rating, Promotion,Years_of_Service;

SELECT  Performance_Rating,Work_Hours,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' 
GROUP BY   Performance_Rating, Work_Hours;

SELECT 
    Satisfaction_score, 
    COUNT(Employee_ID) AS Total_employee ,
    (COUNT(Employee_ID) * 100.0 / SUM(COUNT(Employee_ID)) OVER ()) AS PercentageOfTotal
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY 
    Satisfaction_score;
    
   SELECT 
    Performance_Rating, 
    COUNT(Employee_ID) AS Total_employee ,
    (COUNT(Employee_ID) * 100.0 / SUM(COUNT(Employee_ID)) OVER ()) AS PercentageOfTotal
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY 
    Performance_Rating;
    
    
SELECT  Performance_Rating,EmployeeBenefit_Satisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY   Performance_Rating,EmployeeBenefit_Satisfaction_rate;


-- Second Problem 

SELECT 
    Employee_Engagement_Score, 
    COUNT(Employee_ID) AS Total_employee ,
    (COUNT(Employee_ID) * 100.0 / SUM(COUNT(Employee_ID)) OVER ()) AS PercentageOfTotal
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY 
    Employee_Engagement_Score;
    
    SELECT 
    Employee_Engagement_Score, JobSatisfaction_rate,
    COUNT(Employee_ID) AS Total_employee 
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY 
    Employee_Engagement_Score, JobSatisfaction_rate;
    
    SELECT 
    Employee_Engagement_Score, Work_Hours,
    COUNT(Employee_ID) AS Total_employee 
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY 
    Employee_Engagement_Score, Work_Hours;
    
       SELECT 
    Employee_Engagement_Score, Promotion,
    COUNT(Employee_ID) AS Total_employee 
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1 
GROUP BY 
    Employee_Engagement_Score, Promotion;
    
    SELECT 
    Employee_Engagement_Score, Distance_from_Work_Buckets,
    COUNT(Employee_ID) AS Total_employee 
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1 
GROUP BY 
    Employee_Engagement_Score, Distance_from_Work_Buckets;
    
    SELECT 
    Employee_Engagement_Score, Salary_Buckets,Years_of_Service,
    COUNT(Employee_ID) AS Total_employee 
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns' and Years_of_Service >=4
GROUP BY 
    Employee_Engagement_Score, Salary_Buckets, Years_of_Service;
    
    SELECT 
    Employee_Engagement_Score, AgeGroup,EmployeeBenefit_Satisfaction_rate,
    COUNT(Employee_ID) AS Total_employee 
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns' and  Employee_Engagement_Score =3
GROUP BY 
    Employee_Engagement_Score,AgeGroup, EmployeeBenefit_Satisfaction_rate;
    
     SELECT 
    Employee_Engagement_Score, Promotion,Years_of_Service,AgeGroup,
    COUNT(Employee_ID) AS Total_employee 
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns' and  Employee_Engagement_Score =3 and Promotion = 'No'
GROUP BY 
    Employee_Engagement_Score,Promotion,Years_of_Service,AgeGroup;