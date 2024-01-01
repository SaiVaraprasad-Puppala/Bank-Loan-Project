USE bank_loan;

-- To check the data types of the columns in the loans table
DESCRIBE loans;

SELECT * FROM loans;

-- To change different formats of dates into a specific format for analysis 

UPDATE loans
SET issue_date = 
CASE 
    WHEN issue_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(issue_date, '%d-%m-%Y')
    WHEN issue_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(issue_date, '%d/%m/%Y')
END;

UPDATE loans
SET last_credit_pull_date = 
CASE 
    WHEN last_credit_pull_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y')
    WHEN last_credit_pull_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(last_credit_pull_date, '%d/%m/%Y')
END;

UPDATE loans
SET last_payment_date = 
CASE 
    WHEN last_payment_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(last_payment_date, '%d-%m-%Y')
    WHEN last_payment_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(last_payment_date, '%d/%m/%Y')
END;

UPDATE loans
SET next_payment_date = 
CASE 
    WHEN next_payment_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(next_payment_date, '%d-%m-%Y')
    WHEN next_payment_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(next_payment_date, '%d/%m/%Y')
END;

-- Total Loan Applications
SELECT COUNT(*) AS total_loan_applications FROM loans;

-- Monthly Loan Applications
SELECT MONTHNAME(issue_date), COUNT(*) AS no_of_loan_applications_issued
FROM loans
GROUP BY MONTHNAME(issue_date) 
ORDER BY COUNT(*) DESC;

-- Total Funded Amount
SELECT SUM(loan_amount) AS total_funded_amount FROM loans;

-- MTD Total Funded Amount
SELECT MONTHNAME(issue_date) AS month_names, SUM(loan_amount) AS issued_amount
FROM loans
GROUP BY MONTHNAME(issue_date)
ORDER BY issued_amount DESC;

-- Total Amount Received
SELECT SUM(total_payment) AS total_amount_received
FROM loans;

-- Monthly Amount Received 
SELECT MONTHNAME(issue_date) AS months, SUM(total_payment) AS total_amount_received 
FROM loans
GROUP BY MONTHNAME(issue_date)
ORDER BY total_amount_received DESC;

-- Average Interest Rate
SELECT AVG(int_rate)*100 AS average_interest_rate FROM loans;

-- Minimum, Maximum, Average Interest Rate for Different Loan Terms
SELECT term AS term_period, MIN(int_rate)*100 AS minimum_interest_rate, MAX(int_rate)*100 AS maximum_interest_rate, AVG(int_rate)*100 AS avg_interest_rate
FROM loans
GROUP BY term;

-- Minimum, Maximum, Average Debt-to-Income Ratio According to Their Credit Rating Grade 
SELECT grade AS based_on_credit_score, MIN(dti)*100 AS min_debt_to_income, MAX(dti)*100 AS max_debt_to_income, AVG(dti)*100 AS avg_debt_to_income
FROM loans
GROUP BY grade
ORDER BY based_on_credit_score ASC;

-- Good Loans Applications
SELECT COUNT(CASE WHEN loan_status = 'fully paid' OR loan_status = 'current' THEN id END) AS good_loans_issued FROM loans;

-- Good Loan Applications Percentage
SELECT COUNT(CASE WHEN loan_status = 'fully paid' OR loan_status = 'current' THEN id END)*100/COUNT(id)  AS good_loans_issued_percentage 
FROM loans;

-- Good Loans Funded Amount
SELECT SUM(CASE WHEN loan_status = 'fully paid' OR loan_status = 'current' THEN loan_amount END) AS good_loans_funded_amount
FROM loans;

-- Good Loans Amount Received
SELECT SUM(total_payment) AS good_loans_amount_received
FROM loans
WHERE loan_status = 'fully paid' OR loan_status = 'current';

-- Bad Loans Applications
SELECT COUNT(id) AS no_of_bad_loan_applications
FROM loans 
WHERE loan_status = 'charged off';

-- Bad Loan Applications Percentage
SELECT COUNT(CASE WHEN loan_status = 'charged off' THEN id END)*100/COUNT(id)  AS bad_loan_applications_percentage
FROM loans;

-- Amount Issued for Bad Loans
SELECT SUM(loan_amount) AS amount_issued 
FROM loans 
WHERE loan_status = 'charged off';

-- Amount Received from Bad Loans
SELECT SUM(total_payment) AS amount_received 
FROM loans 
WHERE loan_status = 'charged off';

-- Based on Loan Status 
SELECT 
    loan_status,
    COUNT(id) AS no_of_applications,
    SUM(loan_amount) AS total_amt_funded,
    SUM(total_payment) AS total_payment_received,
    AVG(int_rate)*100 AS avg_interest_rate
FROM loans
GROUP BY loan_status
ORDER BY 2 DESC;

-- Bank Loan Overview
-- Monthly Wise Applications, Amount Funded, Amount Received
SELECT
    MONTHNAME(issue_date) AS month_name,
    COUNT(id) AS no_of_applications,
    SUM(loan_amount) AS total_amt_funded,
    SUM(total_payment) AS total_amt_received
FROM loans
GROUP BY MONTHNAME(issue_date)
ORDER BY 2;

-- State Wise Applications, Amount Funded, Amount Received
SELECT
    address_state AS state,
    COUNT(id) AS no_of_applications,
    SUM(loan_amount) AS total_amt_funded,
    SUM(total_payment) AS total_amt_received
FROM loans
GROUP BY address_state
ORDER BY 2 DESC;

-- Employee Length Wise Applications, Amount Funded, Amount Received
SELECT
    emp_length AS work_experience,
    COUNT(id) AS no_of_applications,
    SUM(loan_amount) AS total_amt_funded,
    SUM(total_payment) AS total_amt_received,
    AVG(int_rate)*100 AS average_int_rate
FROM loans
GROUP BY emp_length
ORDER BY 1;

-- Purpose Wise Applications, Amount Funded, Amount Received
SELECT
    purpose ,
    COUNT(id) AS no_of_applications,
    SUM(loan_amount) AS total_amt_funded,
    SUM(total_payment) AS total_amt_received,
    AVG(int_rate)*100 AS average_int_rate
FROM loans
GROUP BY purpose
ORDER BY 1;

-- Home Ownership
SELECT
    home_ownership ,
    COUNT(id) AS no_of_applications,
    SUM(loan_amount) AS total_amt_funded,
    SUM(total_payment) AS total_amt_received
FROM loans
GROUP BY home_ownership
ORDER BY 2 DESC;
