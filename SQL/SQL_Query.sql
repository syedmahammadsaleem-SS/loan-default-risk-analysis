
-- Create Database

CREATE DATABASE loan_default_db;
show databases;
-- Use database

USE loan_default_db;

-- Create Tables
-- Table 1: applicants

CREATE TABLE applicants (
    Application_ID INT PRIMARY KEY,
    Year INT,
    Gender VARCHAR(20),
    Age_Group VARCHAR(10),
    Income DECIMAL(12,2),
    Credit_Score INT,
    Credit_Type VARCHAR(10),
    Co_Applicant_Credit_Type VARCHAR(10)
);

-- Table 2: loan_details

CREATE TABLE loan_details (
    Application_ID INT PRIMARY KEY,
    Loan_Limit VARCHAR(20),
    Approved_In_Advance VARCHAR(10),
    Loan_Type VARCHAR(20),
    Loan_Purpose VARCHAR(20),
    Credit_Worthiness VARCHAR(10),
    Open_Credit VARCHAR(10),
    Business_Or_Commercial VARCHAR(20),
    Loan_Amount DECIMAL(12,2),
    Interest_Rate DECIMAL(6,3),
    Interest_Rate_Spread DECIMAL(6,3),
    Upfront_Charges DECIMAL(12,2),
    Term INT,
    Negative_Amortization VARCHAR(10),
    Interest_Only VARCHAR(10),
    Lump_Sum_Payment VARCHAR(10),
    Submission_Type VARCHAR(20),
    Security_Type VARCHAR(20),
    FOREIGN KEY (Application_ID) REFERENCES applicants(Application_ID)
);

-- Table 3: Property Details

CREATE TABLE property_details (
    Application_ID INT PRIMARY KEY,
    Property_Value DECIMAL(12,2),
    Construction_Type VARCHAR(10),
    Occupancy_Type VARCHAR(10),
    Secured_By VARCHAR(20),
    Total_Units VARCHAR(10),
    FOREIGN KEY (Application_ID) REFERENCES applicants(Application_ID)
);

-- Table 4: loan_risk

CREATE TABLE loan_risk (
    Application_ID INT PRIMARY KEY,
    Region VARCHAR(20),
    LTV DECIMAL(8,4),
    DTIR DECIMAL(6,2),
    Default_Status TINYINT,
    FOREIGN KEY (Application_ID) REFERENCES applicants(Application_ID)
);

-- Imported Data

LOAD DATA LOCAL INFILE 'C:/Users/syedm/OneDrive/Desktop/Loan_Default_Analysis/Loan_Default.csv'
INTO TABLE staging_loans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SHOW tables;


-- ==============================================

-- Step 0: Create Our Working Table

CREATE DATABASE IF NOT EXISTS loan_default_db;
USE loan_default_db;

CREATE TABLE loans_cleaned (
    ID INT PRIMARY KEY,
    year INT,
    loan_limit VARCHAR(10),
    Gender VARCHAR(20),
    approv_in_adv VARCHAR(10),
    loan_type VARCHAR(10),
    loan_purpose VARCHAR(10),
    Credit_Worthiness VARCHAR(10),
    open_credit VARCHAR(10),
    business_or_commercial VARCHAR(10),
    loan_amount DECIMAL(12,2),
    rate_of_interest DECIMAL(6,3),
    Interest_rate_spread DECIMAL(6,4),
    Upfront_charges DECIMAL(12,2),
    term INT,
    Neg_ammortization VARCHAR(10),
    interest_only VARCHAR(10),
    lump_sum_payment VARCHAR(10),
    property_value DECIMAL(12,2),
    construction_type VARCHAR(10),
    occupancy_type VARCHAR(10),
    Secured_by VARCHAR(20),
    total_units VARCHAR(10),
    income DECIMAL(12,2),
    credit_type VARCHAR(10),
    Credit_Score INT,
    co_applicant_credit_type VARCHAR(10),
    age VARCHAR(10),
    submission_of_application VARCHAR(20),
    LTV DECIMAL(8,4),
    Region VARCHAR(20),
    Security_Type VARCHAR(20),
    Status TINYINT,
    dtir1 DECIMAL(6,2),
    Age_Estimate INT,
    Default_Status VARCHAR(5),
    Interest_Rate_Monthly DECIMAL(10,8),
    EMI DECIMAL(12,2),
    Branch VARCHAR(10),
    Loss_Amount DECIMAL(12,2),
    Recovery_Amount DECIMAL(12,2)
);

-- Step 1: Import the Data via sql query or use table data import wizard

LOAD DATA LOCAL INFILE 'C:/Users/syedm/OneDrive/Desktop/Loan_Default_Analysis/Dataset/Cleaned_data/loan_data_cleaned.csv'
INTO TABLE loans_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check data 
select * from loans_cleaned limit 10;

-- Step 2: A Small Lookup Table (For JOIN Practice)

CREATE TABLE branch_info (
    Branch VARCHAR(10) PRIMARY KEY,
    Branch_Manager VARCHAR(50),
    Branch_City VARCHAR(50)
);

INSERT INTO branch_info VALUES
('BR001', 'Ravi Kumar', 'Bengaluru'),
('BR002', 'Anita Sharma', 'Chennai'),
('BR003', 'Suresh Reddy', 'Hyderabad'),
('BR004', 'Priya Nair', 'Mumbai'),
('BR005', 'Vikram Singh', 'Delhi'),
('BR006', 'Divya Menon', 'Kolkata'),
('BR007', 'Arjun Rao', 'Pune'),
('BR008', 'Kavya Iyer', 'Ahmedabad'),
('BR009', 'Rohit Verma', 'Jaipur'),
('BR010', 'Sneha Pillai', 'Lucknow');

-- Now let's write our 50+ business queries, grouped by category.

-- GROUP A: Basic SELECT, WHERE, ORDER BY (Queries 1-8)

-- Query 1: Show all defaulted loans

SELECT ID, loan_amount, Credit_Score, Default_Status
FROM loans_cleaned
WHERE Default_Status = 'Yes';

-- Query 2: Show loans with high loan amount (above 5,00,000)

SELECT ID, loan_amount, Region
FROM loans_cleaned
WHERE loan_amount > 500000
ORDER BY loan_amount DESC;

-- Query 3: Show customers with low credit score (below 600)

SELECT ID, Credit_Score, Default_Status
FROM loans_cleaned
WHERE Credit_Score < 600
ORDER BY Credit_Score ASC;

-- Query 4: Show loans from the South region only

SELECT ID, Region, loan_amount, Default_Status
FROM loans_cleaned
WHERE Region = 'south';

-- Query 5: Show loans between 2,00,000 and 4,00,000

SELECT ID, loan_amount
FROM loans_cleaned
WHERE loan_amount BETWEEN 200000 AND 400000;

-- Query 6: Show Joint applicants only

SELECT ID, Credit_Score, Default_Status
FROM loans_cleaned
WHERE Credit_Score < 600
ORDER BY Credit_Score ASC;

-- Query 4: Show loans from the South region only

SELECT ID, Region, loan_amount, Default_Status
FROM loans_cleaned
WHERE Region = 'south';

-- Query 5: Show loans between 2,00,000 and 4,00,000

SELECT ID, loan_amount
FROM loans_cleaned
WHERE loan_amount BETWEEN 200000 AND 400000;

-- Query 6: Show Joint applicants only

SELECT ID, Gender, loan_amount
FROM loans_cleaned
WHERE Gender = 'Joint';

-- Query 7: Show loans where LTV is very high (above 90%)

SELECT ID, LTV, loan_amount, Default_Status
FROM loans_cleaned
WHERE LTV > 90
ORDER BY LTV DESC;

-- Query 8: Show top 10 largest loans

SELECT ID, loan_amount, Region, Default_Status
FROM loans_cleaned
ORDER BY loan_amount DESC
LIMIT 10;

-- GROUP B: GROUP BY and Aggregates (Queries 9-18)

-- Query 9: Count total loans

SELECT COUNT(*) AS Total_Loans
FROM loans_cleaned;


 
 -- Query 10
-- Question: Which region has the most loans?

SELECT Region, COUNT(*) AS Total_Loans
FROM loans_cleaned
GROUP BY Region
ORDER BY Total_Loans DESC;


-- Query 11
-- Question: Which branch handles the most loans?

SELECT Branch, COUNT(*) AS Total_Loans
FROM loans_cleaned
GROUP BY Branch
ORDER BY Total_Loans DESC;


-- Query 12
-- Question: Which region gives out bigger loans on average?

SELECT Region, AVG(loan_amount) AS Avg_Loan_Amount
FROM loans_cleaned
GROUP BY Region
ORDER BY Avg_Loan_Amount DESC;


-- Query 13
-- Question: Which branch has given out the most total money in loans?

SELECT Branch, SUM(loan_amount) AS Total_Loan_Value
FROM loans_cleaned
GROUP BY Branch
ORDER BY Total_Loan_Value DESC;


-- Query 14
-- Question: How many defaults happened in each region?

SELECT Region, 
       SUM(CASE WHEN Default_Status = 'Yes' THEN 1 ELSE 0 END) AS Default_Count
FROM loans_cleaned
GROUP BY Region
ORDER BY Default_Count DESC;


-- Query 15
-- Question: Which loan purpose attracts the riskiest (lowest credit score) customers?

SELECT loan_purpose, AVG(Credit_Score) AS Avg_Credit_Score
FROM loans_cleaned
GROUP BY loan_purpose
ORDER BY Avg_Credit_Score ASC;


-- Query 16
-- Question: Which branch has lost the most money from defaults?

SELECT Branch, SUM(Loss_Amount) AS Total_Loss
FROM loans_cleaned
GROUP BY Branch
ORDER BY Total_Loss DESC;


-- Query 17
-- Question: For each loan type, how many defaulted vs did not?

SELECT loan_type, Default_Status, COUNT(*) AS Total
FROM loans_cleaned
GROUP BY loan_type, Default_Status
ORDER BY loan_type;


-- Query 18
-- Question: What is our smallest and largest loan given?

SELECT MIN(loan_amount) AS Min_Loan,
       MAX(loan_amount) AS Max_Loan
FROM loans_cleaned;


-- Query 19
-- Question: How can we group loans into simple size categories for reporting?

SELECT ID, loan_amount,
       CASE 
           WHEN loan_amount < 200000 THEN 'Small'
           WHEN loan_amount BETWEEN 200000 AND 500000 THEN 'Medium'
           ELSE 'Large'
       END AS Loan_Size_Category
FROM loans_cleaned;


-- Query 20
-- Question: How risky is each customer, in simple labels a manager can understand?

SELECT ID, Credit_Score,
       CASE 
           WHEN Credit_Score < 580 THEN 'High Risk'
           WHEN Credit_Score BETWEEN 580 AND 700 THEN 'Medium Risk'
           ELSE 'Low Risk'
       END AS Risk_Band
FROM loans_cleaned;


-- Query 21
-- Question: How many customers fall into each risk category?

SELECT 
    CASE 
        WHEN Credit_Score < 580 THEN 'High Risk'
        WHEN Credit_Score BETWEEN 580 AND 700 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Band,
    COUNT(*) AS Total_Loans
FROM loans_cleaned
GROUP BY Risk_Band;


-- Query 22
-- Question: Which loans have TWO risk factors at once (both high LTV and low credit score)?

SELECT ID, LTV, Credit_Score,
       CASE 
           WHEN LTV > 90 AND Credit_Score < 600 THEN 'Very Risky'
           ELSE 'Normal'
       END AS Risk_Flag
FROM loans_cleaned;


-- Query 23
-- Question: How financially stressed is each customer, based on their debt-to-income ratio?

SELECT ID, dtir1,
       CASE 
           WHEN dtir1 < 30 THEN 'Healthy'
           WHEN dtir1 BETWEEN 30 AND 45 THEN 'Moderate'
           ELSE 'Stressed'
       END AS DTI_Category
FROM loans_cleaned;


-- Query 24
-- Question: How can we group detailed age ranges into simpler categories for a dashboard?

SELECT ID, age,
       CASE 
           WHEN age IN ('<25','25-34') THEN 'Young'
           WHEN age IN ('35-44','45-54') THEN 'Middle-aged'
           ELSE 'Senior'
       END AS Age_Category
FROM loans_cleaned;


-- Query 25
-- Question: Who manages the branch handling each loan?

SELECT l.ID,
       l.loan_amount,
       l.Default_Status,
       b.Branch_Manager,
       b.Branch_City
FROM loans_cleaned l
JOIN branch_info b 
    ON l.Branch = b.Branch;


-- Query 26
-- Question: Which branch manager is responsible for the highest total loan value?

SELECT b.Branch_Manager,
       SUM(l.loan_amount) AS Total_Loan_Value
FROM loans_cleaned l
JOIN branch_info b 
    ON l.Branch = b.Branch
GROUP BY b.Branch_Manager
ORDER BY Total_Loan_Value DESC;


-- Query 27
-- Question: Which city (branch location) has the most defaults?

SELECT b.Branch_City, 
       SUM(CASE WHEN l.Default_Status = 'Yes' THEN 1 ELSE 0 END) AS Default_Count
FROM loans_cleaned l
JOIN branch_info b 
    ON l.Branch = b.Branch
GROUP BY b.Branch_City
ORDER BY Default_Count DESC;


-- Query 28
-- Question: Are there any branches with no loan activity at all?

SELECT b.Branch,
       b.Branch_City,
       COUNT(l.ID) AS Total_Loans
FROM branch_info b
LEFT JOIN loans_cleaned l 
    ON b.Branch = l.Branch
GROUP BY b.Branch, b.Branch_City;


-- Query 29
-- Question: Which branch city tends to serve riskier (lower credit score) customers?

SELECT b.Branch_City,
       AVG(l.Credit_Score) AS Avg_Credit_Score
FROM loans_cleaned l
JOIN branch_info b 
    ON l.Branch = b.Branch
GROUP BY b.Branch_City
ORDER BY Avg_Credit_Score ASC;


-- Query 30
-- Question: Which branch manager's team is best at recovering money from defaults?

SELECT b.Branch_Manager,
       SUM(l.Recovery_Amount) AS Total_Recovered
FROM loans_cleaned l
JOIN branch_info b 
    ON l.Branch = b.Branch
GROUP BY b.Branch_Manager
ORDER BY Total_Recovered DESC;


-- Query 31
-- Question: Which loans are bigger than our typical (average) loan?

SELECT ID, loan_amount
FROM loans_cleaned
WHERE loan_amount > (
    SELECT AVG(loan_amount)
    FROM loans_cleaned
);


-- Query 32
-- Question: Which single branch has given out the most total loan money?

SELECT Branch,
       SUM(loan_amount) AS Total_Value
FROM loans_cleaned
GROUP BY Branch
HAVING SUM(loan_amount) = (
    SELECT MAX(branch_total)
    FROM (
        SELECT SUM(loan_amount) AS branch_total
        FROM loans_cleaned
        GROUP BY Branch
    ) AS branch_totals
);


-- Query 33
-- Question: Which customers have below-average creditworthiness?

SELECT ID, Credit_Score
FROM loans_cleaned
WHERE Credit_Score < (
    SELECT AVG(Credit_Score)
    FROM loans_cleaned
);


-- Query 34
-- Question: Which loans have a riskier LTV than our "typical" defaulted loan?

SELECT ID, LTV, Default_Status
FROM loans_cleaned
WHERE LTV > (
    SELECT AVG(LTV)
    FROM loans_cleaned
    WHERE Default_Status = 'Yes'
);


-- Query 35
-- Question: Which regions have a default rate above the company-wide average?

-- No SQL code was provided in the source.
-- The source says this is solved using Query 40.


-- Query 36
-- Question: What was our single biggest loss from one loan?

SELECT ID, Branch, Loss_Amount
FROM loans_cleaned
WHERE Loss_Amount = (
    SELECT MAX(Loss_Amount)
    FROM loans_cleaned
);


-- Query 37
-- Question: What is the default rate (%) for each region?

WITH region_summary AS (
    SELECT Region,
           COUNT(*) AS Total_Loans,
           SUM(CASE WHEN Default_Status = 'Yes' THEN 1 ELSE 0 END) AS Total_Defaults
    FROM loans_cleaned
    GROUP BY Region
)
SELECT Region,
       Total_Loans,
       Total_Defaults,
       ROUND((Total_Defaults / Total_Loans) * 100, 2) AS Default_Rate_Percent
FROM region_summary
ORDER BY Default_Rate_Percent DESC;


-- Query 38
-- Question: Which branch has the worst (highest) default rate?

WITH branch_summary AS (
    SELECT Branch,
           COUNT(*) AS Total_Loans,
           SUM(CASE WHEN Default_Status = 'Yes' THEN 1 ELSE 0 END) AS Total_Defaults
    FROM loans_cleaned
    GROUP BY Branch
)
SELECT Branch,
       Total_Loans,
       Total_Defaults,
       ROUND((Total_Defaults / Total_Loans) * 100, 2) AS Default_Rate_Percent
FROM branch_summary
ORDER BY Default_Rate_Percent DESC;


-- Query 39
-- Question: Which loan purpose has the riskiest default rate?

WITH purpose_summary AS (
    SELECT loan_purpose,
           COUNT(*) AS Total_Loans,
           SUM(CASE WHEN Default_Status = 'Yes' THEN 1 ELSE 0 END) AS Total_Defaults
    FROM loans_cleaned
    GROUP BY loan_purpose
)
SELECT loan_purpose,
       Total_Loans,
       Total_Defaults,
       ROUND((Total_Defaults / Total_Loans) * 100, 2) AS Default_Rate_Percent
FROM purpose_summary
ORDER BY Default_Rate_Percent DESC;


-- Query 40
-- Question: Which regions perform worse than our company-wide average default rate?

WITH region_summary AS (
    SELECT Region,
           COUNT(*) AS Total_Loans,
           SUM(CASE WHEN Default_Status = 'Yes' THEN 1 ELSE 0 END) AS Total_Defaults
    FROM loans_cleaned
    GROUP BY Region
),
region_rate AS (
    SELECT Region,
           ROUND((Total_Defaults / Total_Loans) * 100, 2) AS Default_Rate
    FROM region_summary
)
SELECT Region,
       Default_Rate
FROM region_rate
WHERE Default_Rate > (
    SELECT AVG(Default_Rate)
    FROM region_rate
)
ORDER BY Default_Rate DESC;


-- Query 41
-- Question: Among loans that defaulted, does credit score risk band affect how much money we lose?

WITH risk_band AS (
    SELECT ID,
           Loss_Amount,
           CASE 
               WHEN Credit_Score < 580 THEN 'High Risk'
               WHEN Credit_Score BETWEEN 580 AND 700 THEN 'Medium Risk'
               ELSE 'Low Risk'
           END AS Risk_Band
    FROM loans_cleaned
    WHERE Default_Status = 'Yes'
)
SELECT Risk_Band,
       AVG(Loss_Amount) AS Avg_Loss
FROM risk_band
GROUP BY Risk_Band
ORDER BY Avg_Loss DESC;


-- Query 42
-- Question: Which 3 branches are best at recovering money after defaults?

WITH branch_recovery AS (
    SELECT Branch,
           SUM(Recovery_Amount) AS Total_Recovery
    FROM loans_cleaned
    GROUP BY Branch
)
SELECT Branch,
       Total_Recovery
FROM branch_recovery
ORDER BY Total_Recovery DESC
LIMIT 3;


-- Query 43
-- Question: What is each loan's rank, from biggest to smallest?

SELECT ID,
       Branch,
       loan_amount,
       RANK() OVER (ORDER BY loan_amount DESC) AS Loan_Rank
FROM loans_cleaned;


-- Query 44
-- Question: Within each branch, which is the biggest loan, 2nd biggest, and so on?

SELECT ID,
       Branch,
       loan_amount,
       RANK() OVER (
           PARTITION BY Branch 
           ORDER BY loan_amount DESC
       ) AS Rank_In_Branch
FROM loans_cleaned;


-- Query 45
-- Question: Give every loan a unique sequence number, from biggest to smallest.

SELECT ID,
       loan_amount,
       ROW_NUMBER() OVER (
           ORDER BY loan_amount DESC
       ) AS Row_Num
FROM loans_cleaned;


-- Query 46
-- Question: What is the single biggest loan given by each branch?

WITH ranked_loans AS (
    SELECT ID,
           Branch,
           loan_amount,
           ROW_NUMBER() OVER (
               PARTITION BY Branch 
               ORDER BY loan_amount DESC
           ) AS rn
    FROM loans_cleaned
)
SELECT ID,
       Branch,
       loan_amount
FROM ranked_loans
WHERE rn = 1;


-- Query 47
-- Question: As loans come in one after another, what is the cumulative total loan money given out so far?

SELECT ID,
       loan_amount,
       SUM(loan_amount) OVER (
           ORDER BY ID
       ) AS Running_Total
FROM loans_cleaned
LIMIT 20;


-- Query 48
-- Question: Is this particular loan bigger or smaller than its branch's typical loan size?

SELECT ID,
       Branch,
       loan_amount,
       AVG(loan_amount) OVER (
           PARTITION BY Branch
       ) AS Branch_Avg_Loan,
       loan_amount - AVG(loan_amount) OVER (
           PARTITION BY Branch
       ) AS Difference_From_Avg
FROM loans_cleaned;


-- Query 49
-- Question: How many loans were issued each year?

SELECT year,
       COUNT(*) AS Total_Loans
FROM loans_cleaned
GROUP BY year;


-- Query 50
-- Question: How has our total lending changed year by year?

SELECT year,
       SUM(loan_amount) AS Total_Loan_Value
FROM loans_cleaned
GROUP BY year
ORDER BY year;


-- Query 51
-- Question: What is the default rate for each year?

SELECT year,
       COUNT(*) AS Total_Loans,
       SUM(CASE WHEN Default_Status = 'Yes' THEN 1 ELSE 0 END) AS Total_Defaults,
       ROUND(
           SUM(CASE WHEN Default_Status = 'Yes' THEN 1 ELSE 0 END) 
           / COUNT(*) * 100,
           2
       ) AS Default_Rate_Percent
FROM loans_cleaned
GROUP BY year;