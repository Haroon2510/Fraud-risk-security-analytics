CREATE database FraudRiskMonitor

use FraudRiskMonitor


SELECT TOP 10 * FROM fraud_transactions

SELECT * FROM fraud_transactions







SELECT DISTINCT transaction_date, SUM(amount) AS frauds FROM fraud_transactions GROUP BY transaction_date ORDER BY SUM(amount) DESC





-- Fraud vs Genuine Transactions

SELECT is_fraud, COUNT(*) AS transaction_count
FROM fraud_transactions
GROUP BY is_fraud;




-- Total Fraud Amount

SELECT SUM(amount) AS total_fraud_amount
FROM fraud_transactions
WHERE is_fraud = 1;





-- Top 5 High - Risk States

SELECT TOP 5  state, COUNT(*) AS fraud_count
FROM fraud_transactions
WHERE is_fraud = 1
GROUP BY state
ORDER BY fraud_count DESC;







--  Top High-Risk Merchants

WITH MerchantFraud AS (
    SELECT  merchant,
        COUNT(*) AS fraud_count
    FROM fraud_transactions
    WHERE is_fraud = 1
    GROUP BY merchant
)
SELECT  merchant, fraud_count,
    RANK() OVER (ORDER BY fraud_count DESC) AS merchant_rank
FROM MerchantFraud
where fraud_count >= 15;






-- Fraud by Transaction Hour

SELECT transaction_hour, COUNT(*) AS fraud_count
FROM fraud_transactions
WHERE is_fraud = 1
GROUP BY transaction_hour
Having COUNT(*) >100
ORDER BY fraud_count DESC;








-- Top Fraudulent Merchant Categories

SELECT TOP 10 category, COUNT(*) AS fraud_cases
FROM fraud_transactions
WHERE is_fraud = 1
GROUP BY category
ORDER BY fraud_cases DESC;


-- Repeat Fraud Customers

SELECT TOP 20 full_name, COUNT(*) AS fraud_attempts
FROM fraud_transactions
WHERE is_fraud = 1
GROUP BY full_name
HAVING COUNT(*) >= 3
ORDER BY fraud_attempts DESC;


-- Compliance Threshold Violations

SELECT COUNT(*) AS review_required_transactions
FROM fraud_transactions
WHERE amount >= 10000;





-- Fraud Risk Level Distributions

SELECT fraud_risk_level, COUNT(*) AS total_transactions
FROM fraud_transactions
GROUP BY fraud_risk_level
ORDER BY total_transactions DESC;







-- Daily Fraud Trend

SELECT  transaction_date,
    COUNT(*) AS fraud_cases,
    SUM(amount) AS fraud_amount
FROM fraud_transactions
WHERE is_fraud = 1
GROUP BY transaction_date
ORDER BY transaction_date;

SELECT fraud_score FROM fraud_transactions WHERE fraud_score > 50






--MONTHLY FRAUD TREND

SELECT    MONTH(trans_date_trans_time) AS transaction_month,
    COUNT(*) AS fraud_transactions,
    SUM(COUNT(*)) OVER (ORDER BY MONTH(trans_date_trans_time)) AS cumulative_fraud_transactions
FROM fraud_transactions
WHERE is_fraud = 1
GROUP BY MONTH(trans_date_trans_time)
ORDER BY transaction_month;

SELECT TOP 10 * FROM fraud_transactions

select distinct fraud_score from fraud_transactions order by fraud_score





--FRAUD PERCENTAGE CONTRIBUTION BY CATEGORY

WITH CategoryFraud AS (
    SELECT    category, COUNT(*) AS fraud_count
    FROM fraud_transactions
    WHERE is_fraud = 1
    GROUP BY category
)
SELECT category, fraud_count,
    ROUND((fraud_count * 100.0 /SUM(fraud_count) OVER ()), 2) AS fraud_percentage
FROM CategoryFraud
ORDER BY fraud_percentage DESC;


--fraud risk severity distribution

SELECT  fraud_risk_level,
    COUNT(*) AS total_transactions,
    ROUND(COUNT(*) * 100.0 /SUM(COUNT(*)) OVER (), 2) AS percentage_distribution
FROM fraud_transactions
GROUP BY fraud_risk_level
ORDER BY total_transactions DESC;

