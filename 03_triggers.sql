USE automated_sales_reporting;

#1. The manager wants to keep a record whenever a new sale is added.Create an audit table that stores: sale ID ,salesperson ,
# amount ,action ,date/time of the action .Then create a trigger that automatically inserts a record into the audit table whenever a new sale is inserted

#create a audit table
CREATE TABLE audit
(   
    sale_id  INT,
	salesperson VARCHAR(50),
	amount DECIMAL(10,2),
	action  VARCHAR(50),
	action_time DATETIME
);

#creating Trigger
DELIMITER $$
CREATE TRIGGER new_sale
AFTER INSERT ON sales
FOR EACH ROW 
BEGIN
INSERT INTO  audit 
( sale_id  ,salesperson ,amount , action  ,action_time)
VALUES(NEW.sale_id , NEW.salesperson , NEW.amount,"INSERT" , current_timestamp());
END $$
DELIMITER ;

INSERT INTO sales
VALUES(26,"Jane","Gauteng","Laptop","Electronics",1,5500,now());

#check if the sales details where stored
SELECT*
FROM  sales;

# check if trigger worked 
SELECT*
FROM audit;




#2. Create a trigger that automatically records when a sale is deleted.The audit record should contain:
# sale ID ,salesperson ,amount ,action ,date/time of the action .Test it by deleting one sale.

drop TRIGGER  deleted_sale;
DELIMITER $$
CREATE TRIGGER  deleted_sale
AFTER  DELETE ON sales
FOR EACH ROW
BEGIN
INSERT INTO audit
( sale_id  ,salesperson ,amount , action  ,action_time)
VALUES(OLD.sale_id , OLD.salesperson , OLD.amount,"DELETE" , current_timestamp());
END $$
DELIMITER ;

#delete record
DELETE
FROM sales
WHERE salesperson ="Jane";

#  check if record has been deleted
SELECT*
FROM sales;
# check if records have been stored 
SELECT *
FROM audit;




#3. The manager wants to track changes to sales amounts.Create an audit table and a trigger that records whenever the amount of an existing sale is changed.
# Store:sale ID ,old amount, new amount , action ,date/time of the change


CREATE TABLE audit_sales_changes
(
 sale_id INT
 ,old_amount DECIMAL(10,2)
 , new_amount DECIMAL(10,2)
 , action VARCHAR(20),
 action_time TIMESTAMP
);

DROP TRIGGER amount_update;
DELIMITER $$
CREATE TRIGGER amount_update
AFTER UPDATE ON sales
FOR EACH ROW
BEGIN
INSERT INTO audit_sales_changes
VALUES( OLD.sale_id ,OLD.amount , NEW.amount , "UPDATE",current_timestamp());

END $$
DELIMITER ;

UPDATE sales
SET amount =5000
WHERE sale_id = 25;

# check if the amount has changed
SELECT*
FROM sales
WHERE sale_id = 25;
#check if the trigger has stored the record 
SELECT*
FROM audit_sales_changes;

#4. Create a trigger that prevents a sale from being inserted when the amount is zero or negative.Test the trigger with an invalid sale.

DROP TRIGGER prevents_sale; 

DELIMITER $$
CREATE TRIGGER prevents_sale
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
IF NEW.amount <=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='Sales amount should be greater than zero';
END IF;
END $$
DELIMITER ;

# testing
INSERT INTO sales
VALUES(26,"Jane","Gauteng","Laptop","Electronics",1,-4500,current_date());
INSERT INTO sales
VALUES(27,"Lebogang","Gauteng","Laptop","Electronics",2,0,current_date());


#5. Create a trigger that prevents a sale from being inserted when the quantity is zero or negative.
# Test the trigger with an invalid quantity

DELIMITER $$
CREATE TRIGGER quantityLessThanZero
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
IF NEW.quantity <=0 THEN 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='Invalid quantity: The quantity should be greater than zero';
END IF;

END $$
DELIMITER ;


#Testing
INSERT INTO sales
VALUES(26,"Jane","Gauteng","Laptop","Electronics",-1,4500,current_date());

#6. The company wants every new sale to automatically record the time it was created.Create an audit table containing:
#sale ID, salesperson ,created date/time. Create a trigger that automatically inserts this information whenever a new sale is added.


CREATE TABLE salesperson_details
(
 sale_id INT,
 salesperson  VARCHAR(50),
 created_datetime datetime
);

DROP TRIGGER new_sale_record;
DELIMITER $$
CREATE TRIGGER new_sale_record
AFTER INSERT ON sales
FOR EACH ROW 
BEGIN
INSERT INTO salesperson_details
(sale_id,salesperson,created_datetime)
VALUES(NEW.sale_id,NEW.salesperson,current_timestamp());
END  $$
DELIMITER ;

INSERT INTO sales
VALUES(26,"Jane","Gauteng","Phone","Electronics",1,4500,NOW());

SELECT*
FROM sales;
# check if trigger worked 
SELECT*
FROM salesperson_details;



#7. The manager wants to track which salesperson made every newly inserted sale. Create an audit table containing: sale ID , salesperson , action
# Create a trigger that automatically records the salesperson whenever a new sale is inserted.

CREATE TABLE track_sales_table
(
 sale_id INT,
 salesperson VARCHAR(50),
 action VARCHAR(50)
);

DELIMITER $$
CREATE TRIGGER track_sales_trigger
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
INSERT INTO track_sales_table
(sale_id , salesperson ,action)
VALUES(NEW.sale_id,NEW.salesperson,"INSERT");
END $$
DELIMITER ;

INSERT INTO sales
VALUES(27,"Lethabo","Gauteng","Laptop","Electronics",1,8500,NOW());

#check if trigger worked 
SELECT*
FROM track_sales_table;


#8. Create a trigger that automatically changes a newly inserted salesperson's name to uppercase.For example:thabo → THABO ,sarah → SARAH
# Test the trigger by inserting a sale with a lowercase salesperson name.

DROP TRIGGER name_to_upper;
DELIMITER $$
CREATE TRIGGER name_to_upper
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
SET new.salesperson = UPPER(new.salesperson);
END $$
DELIMITER ;

INSERT INTO sales
VALUES(28,"Katlego","Gauteng","Phone","Electronics",3,13500,NOW());

#check if trigger workes
SELECT*
FROM sales
WHERE sale_id =28;


#9. The manager wants to track changes to the quantity of a sale.Create an audit table and a trigger that records: sale ID ,old quantity ,
# new quantity ,action, date/time of the change .Test it by updating the quantity of an existing sale.

# TABLE TO STORE THE DETAILS
CREATE  TABLE updated_quantity_table
(
  sale_id INT,
  old_quantity INT,
 new_quantity INT,
 action VARCHAR(50),
 action_change DATETIME
);

DELIMITER $$
CREATE TRIGGER updated_quantity_trigger
AFTER UPDATE ON sales
FOR EACH ROW
BEGIN
INSERT INTO updated_quantity_table
(sale_id,old_quantity,new_quantity,action,action_change)
VALUES(OLD.sale_id,OLD.quantity,NEW.quantity,"UPDATE",current_timestamp());
END $$
DELIMITER ;

UPDATE sales
SET quantity= 2
WHERE sale_id =26;


SELECT*
FROM sales
WHERE sale_id=26;

SELECT*
FROM updated_quantity_table;



#10 .Create a trigger that automatically records both the old and new amount whenever a sale's amount is updated.The audit table should contain:
# sale ID ,salesperson ,old amount , new amount ,date/time of the change.Test the trigger by updating an existing sale.


# TABLE TO STORE THE DETAILS
CREATE  TABLE updated_amount_table
(
  sale_id INT,
  salesperson VARCHAR(50),
  old_amount DECIMAL(10,2),
 new_amount DECIMAL(10,2),
 action_change DATETIME
);

DROP TRIGGER updated_amount_trigger;
DELIMITER $$
CREATE TRIGGER updated_amount_trigger
AFTER UPDATE ON sales
FOR EACH ROW
BEGIN
INSERT INTO  updated_amount_table
(sale_id,salesperson,old_amount,new_amount,action_change)
VALUES(OLD.sale_id,OLD.salesperson,OLD.amount,NEW.amount,current_timestamp());
END $$
DELIMITER ;

UPDATE sales
SET amount= 2000
WHERE sale_id =27;


SELECT*
FROM sales
WHERE sale_id=27;

SELECT*
FROM updated_amount_table;

