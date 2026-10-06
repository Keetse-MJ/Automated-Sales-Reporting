/* #1. The sales manager wants a monthly sales summary. Create a summary table containing the month and total sales, 
     then create an Event that automatically inserts the current month's total sales.
*/

CREATE TABLE monthly_sales_summary
(
	sales_month INT,
    total_sales DECIMAL(10,2)
);

  DROP EVENT  monthly_sales_event;
  DELIMITER $$
  CREATE EVENT monthly_sales_event
  ON SCHEDULE EVERY 1 month
  DO
		INSERT INTO monthly_sales_summary
		SELECT DISTINCT MONTH(sale_date) AS sales_month,SUM(amount)AS total_sales
		FROM sales
		WHERE MONTH(sale_date) = MONTH(NOW()) AND YEAR(sale_date)= YEAR(now())
		GROUP BY sales_month;
		  
  $$
  DELIMITER ;
  
  /*CHECK IF THE EVENT HAS TAKEN PLACE*/
  SELECT*
  FROM monthly_sales_summary;
  
 
 /*
   #2. Create a one-time Event that inserts a record into an audit table showing that the Event ran. 
   The record should contain a message and the date/time when the Event ran.
*/
  

CREATE TABLE audit_record
(
 message VARCHAR(50),
 message_datetime TIMESTAMP
);


DELIMITER $$
CREATE EVENT one_time_event
ON SCHEDULE AT current_timestamp()
DO
INSERT INTO audit_record
VALUES('The message has been recorded',current_timestamp());
$$
DELIMITER ;

SELECT*
FROM audit_record;


/* #3. The sales manager wants a daily sales summary. Create a summary table containing the date and total sales, 
     then create an Event that automatically inserts the current day's total sales.*/


CREATE TABLE daily_sales
(
  sales_date DATE,
  total_sales DECIMAL(10,2)
);


DELIMITER $$
CREATE EVENT daily_sales_event
ON SCHEDULE EVERY 1 DAY
DO
INSERT INTO daily_sales
SELECT DATE(NOW()) AS sales_date, SUM(amount) AS total_sales
FROM sales
WHERE sale_date =DATE(NOW())
GROUP BY sales_date;
$$
DELIMITER ;

SELECT*
FROM daily_sales;

/* #4.  The sales manager wants to know how many sales transactions are made each month. 
Create a summary table containing the month and the total number of sales. Then create 
an Event that automatically inserts the number of sales for the current month.
*/

CREATE TABLE sales_number_summary
(
sales_month INT,
sales_total_number INT
);


DELIMITER $$
CREATE EVENT sales_number_event
ON SCHEDULE EVERY 1 MONTH
DO
INSERT INTO sales_number_summary
SELECT MONTH(sale_date) sales_month,COUNT(*)number_of_sales
FROM sales
WHERE MONTH(sale_date) = MONTH(NOW()) AND
     YEAR(sale_date) = YEAR(NOW())
GROUP BY sales_month;
$$
DELIMITER ;

SELECT* FROM sales_number_summary;

/* #5. The sales manager wants an automated report showing the highest individual sale
 made each day.Create a summary table containing the date and highest sale amount. 
 Then create an Event that automatically inserts the highest sale for the current day.
*/
CREATE TABLE highest_sale
(
sale_date DATE,
highest_sale  DECIMAL(10,2)
);

DELIMITER $$
CREATE EVENT highest_sale_event
ON SCHEDULE EVERY 1 day
DO
INSERT INTO highest_sale
SELECT sale_date,MAX(amount) highest_sale
FROM sales
WHERE sale_date =DATE(NOW())
GROUP BY sale_date
;
$$
DELIMITER ;

SELECT* FROM highest_sale;


/* #6. The sales manager wants an automated report showing the average sale amount for each month.
	   Create a summary table containing the month and average sale amount.
       Then create an Event that automatically inserts the average sale for the current month.
*/

DROP TABLE average_sale_table;
CREATE TABLE average_sale_table
(
   sales_month INT,
   average_sales_amount DECIMAL(10,2)
);

DELIMITER $$
CREATE EVENT average_sale_event
ON SCHEDULE EVERY 1 MONTH
DO
INSERT INTO average_sale_table
SELECT MONTH(sale_date) AS sales_month,AVG(amount) AS average_sale_amount
FROM sales
WHERE MONTH(sale_date) = MONTH(NOW())  
GROUP BY sales_month;
 $$
 DELIMITER ;
 
 
 SELECT* FROM average_sale_table;
 
 
 /* #7. The sales manager wants an automated monthly report showing how much each salesperson sold. 
Create a summary table containing the month, salesperson and total sales. 
Then create an Event that automatically inserts the current month's total sales for each salesperson.
*/

CREATE TABLE monthly_report
(
sale_month INT,
salesperson VARCHAR(50),
total_sales DECIMAL(10,2)
);

DELIMITER $$
CREATE EVENT monthly_report_event
ON SCHEDULE EVERY 1 MONTH
DO
INSERT INTO monthly_report
SELECT MONTH(sale_date) AS sale_month,salesperson,SUM(amount) AS total_sales
FROM sales
WHERE MONTH(sale_date)  = MONTH(NOW())  AND
	  YEAR(sale_date) = YEAR(NOW())
GROUP BY sale_month,salesperson;
$$
DELIMITER ;

SELECT* FROM monthly_report;


/* # 8.
 The sales manager wants an automated daily report showing how many sales transactions were made each day.
 Create a summary table containing the date and number of sales.
 Then create an Event that automatically inserts the number of sales for the current day.
*/
CREATE TABLE daily_report
(
	sale_date DATE,
	number_of_sales INT
);

DELIMITER $$
CREATE EVENT daily_report_event
ON SCHEDULE EVERY 1 DAY
DO
INSERT INTO daily_report
SELECT sale_date,COUNT(*) AS number_of_sales
FROM sales
WHERE sale_date = DATE(NOW())
GROUP BY sale_date;

$$
DELIMITER ;

SELECT* FROM daily_report;


/* #9.
 The sales manager wants an automated monthly report showing the salesperson with the highest total
 sales for the current month. Create a summary table containing the month, salesperson and total sales. 
 Then create an Event that automatically inserts the salesperson with the highest total sales for the current month.
*/


CREATE TABLE highest_monthly_sales
(
sales_month INT,
salesperson VARCHAR(50),
total_sales DECIMAL(10,2)
);

DELIMITER $$
CREATE EVENT highest_monthly_event
ON SCHEDULE EVERY 1 MONTH
DO
 INSERT INTO highest_monthly_sales
 SELECT MONTH(sale_date) sales_month,salesperson,SUM(amount) total_sales
 FROM sales
 WHERE MONTH(sale_date)=MONTH(now()) 
 GROUP BY sales_month,salesperson
 HAVING  SUM(amount) = (
                         SELECT MAX(total_sales)
                         FROM 
                         (
                          SELECT MONTH(sale_date) sales_month,salesperson,SUM(amount) total_sales
						 FROM sales
						 WHERE MONTH(sale_date)=MONTH(now()) 
						 GROUP BY sales_month,salesperson
                         ) as agg_table
                        );

$$
DELIMITER  ;

SELECT*
FROM highest_monthly_sales;


/* #10. The sales manager wants a complete monthly sales report. Create a summary table 
       containing the month, total sales, number of sales, average sale amount and highest individual sale. 
       Then create an Event that automatically inserts all of these values for the current month.
*/

CREATE TABLE monthly_sales_report
(
sales_month          INT,
total_sale           DECIMAL(10,2),
number_of_sales      DECIMAL(10,2),
average_sale_amount  DECIMAL(10,2),
highest_sale_amount  DECIMAL(10,2)
)
;
DELIMITER $$
CREATE EVENT monthly_sales_report_event
ON SCHEDULE EVERY 1 MONTH
DO
INSERT INTO monthly_sales_report
SELECT month(sale_date) AS sales_month,SUM(amount) total_sales,
COUNT(*) number_of_sales,AVG(amount) average_sale_amount,MAX(amount) AS highest_sale_amount
FROM sales
WHERE month(sale_date) = MONTH(NOW()) 
GROUP BY sales_month 

$$
DELIMITER ;

SELECT*
FROM monthly_sales_report;


