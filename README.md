# **HR Analytics: Employee Attrition & Engagement Analysis**  

## **Project Overview**  
This project analyzes workforce data for *Adviti Pvt. Ltd.* to identify key drivers of employee attrition and engagement. Using SQL and data visualization, we uncover actionable insights to improve retention, productivity, and workplace satisfaction.  

### **Objectives**  
1. **Identify Factors Influencing Employee Attrition**  
   - Analyze turnover trends by department, role, tenure, and demographics.  
   - Pinpoint root causes (e.g., compensation, promotions, workload).  

2. **Enhance Employee Engagement**  
   - Evaluate engagement scores linked to job satisfaction, benefits, and career growth.  
   - Recommend strategies to boost motivation and retention.  

---

## **Dataset**  
**Source:** Adviti Pvt. Ltd. HR Records  
**Key Variables:**  
- `Employee_ID`, `Age`, `Gender`, `Department`, `Position`  
- `Years_of_Service`, `Salary`, `Performance_Rating`, `Attrition` (Yes/No)  
- `Promotion`, `Training_Hours`, `JobSatisfaction_rate`, `Employee_Engagement_Score`  
- `Distance_from_Work`, `Absenteeism`, `EmployeeBenefit_Satisfaction_rate`  

---

## **Methodology**  
### **1. Data Cleaning & Feature Engineering (SQL)**  
- Standardized categories (e.g., merged "Account Exec." variants into "Account Executive").  
- Created buckets for continuous variables:  
  - **Salary:** `<10L`, `10L-20L`, ..., `>50L`  
  - **Age Groups:** `21-25`, `26-30`, etc.  
  - **Distance from Work:** `<10 km`, `10-20 km`, etc.  
- Calculated composite metrics:  
  ```sql
  (JobSatisfaction_PeerRelationship + WorkLifeBalance + ... ) / 5 * 100 AS JobSatisfaction_rate
  ```

### **2. Exploratory Data Analysis (SQL + Visualizations)**  
**Key Findings:**  
#### **Attrition Analysis (48% Overall Rate)**  
- **Highest Attrition Roles:** SD1 (83.3%), Account Executive (68.4%), HR roles (~63%).  
- **Critical Drivers:**  
  - **Lack of Promotions:** Employees with 3–5 years of service had high attrition if unpromoted.  
  - **Salary Stagnation:** 21–25-year-olds with <₹10L salaries left despite tenure.  
  - **Commute Stress:** 40+ km distance correlated with 53.7% attrition.  

#### **Engagement Analysis**  
- **Low Engagement** linked to:  
  - **Poor Job Satisfaction** (20% satisfaction → 70% attrition).  
  - **No Promotions** (Employees with 4+ years and low salaries disengaged).  

---

## **Key Insights & Recommendations**  
### **Attrition Reduction Strategies**  
- **Career Progression:** Structured promotion paths for mid-tenure employees (3–5 years).  
- **Compensation Review:** Address salary gaps for high-attrition roles (e.g., SD1, HR).  
- **Remote Work Options:** Offer flexibility for employees with long commutes (40+ km).  

### **Engagement Boosters**  
- **Recognition Programs:** Reward high performers to reduce "undervalued" attrition.  
- **Targeted Training:** Upskill roles with low satisfaction (e.g., Account Executives).  
- **Workload Balance:** Reassess overtime in Operations/HR (40+ work hours/week).  

---

## **Real-World Impact**  
This analysis mirrors real HR analytics workflows, enabling data-driven decisions to:  
- Reduce turnover costs by addressing preventable attrition.  
- Improve employee satisfaction through targeted interventions.  
- Optimize resource allocation (e.g., training budgets, hybrid work policies).  

**Tools Used:** SQL (Data Cleaning, Aggregation) 

---


