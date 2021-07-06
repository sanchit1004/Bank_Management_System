CREATE database mydb;
#drop database mydb;
USE mydb;

CREATE TABLE Branch (
    BranchID INT(10) PRIMARY KEY,
    Branchloc VARCHAR(15) NOT NULL
);
CREATE TABLE Customer (
    CustID INT(10) PRIMARY KEY,
    custTypeCode VARCHAR(2) CHECK (custTypeCode IN ('I' , 'SC', 'M', 'O')),
    custPhone VARCHAR(10) NOT NULL,
    custEmail VARCHAR(30) NOT NULL,
    firstName VARCHAR(15) NOT NULL,
    middleName VARCHAR(15) NOT NULL,
    lastName VARCHAR(15) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    StreetName VARCHAR(25) NOT NULL,
    building VARCHAR(25) NOT NULL,
    city VARCHAR(20) NOT NULL,
    state VARCHAR(15) NOT NULL,
    pincode INT(6) NOT NULL,
    birthDate DATE NOT NULL,
    EmpID INT(10) REFERENCES Employee,
    age INT NOT NULL,
    custType VARCHAR(15) NOT NULL
);
CREATE TABLE Employee (
    EmpID INT(10) PRIMARY KEY,
    joiningDate DATE NOT NULL,
    emp_firstname VARCHAR(15) NOT NULL,
    emp_middlename VARCHAR(15) NOT NULL,
    emp_lastname VARCHAR(15) NOT NULL,
    empPhone VARCHAR(10) NOT NULL,
    empEmail VARCHAR(30) NOT NULL,
    posTypeCode VARCHAR(2) CHECK (posTypeCode IN ('AC' , 'CA', 'M', 'CO', 'L')),
    gender VARCHAR(1) NOT NULL,
    StreetName VARCHAR(25) NOT NULL,
    building VARCHAR(25) NOT NULL,
    city VARCHAR(20) NOT NULL,
    state VARCHAR(15) NOT NULL,
    pincode INT(6) NOT NULL,
    workedYears INT NOT NULL,
    branchID INT(10) REFERENCES branch,
    position VARCHAR(15) NOT NULL
);

CREATE TABLE Loan (
    LoanID INT(10) PRIMARY KEY,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    Loan_Amount FLOAT(8 , 1 ) NOT NULL,
    EMI_Amount FLOAT(8 , 1 ) NOT NULL,
    ROI FLOAT(2 , 1 ) NOT NULL,
    LoanTypesCode VARCHAR(2) CHECK (LoanTypesCode IN ('C' , 'H', 'E', 'B')),
    AccID INT(10) REFERENCES Accounts,
    CustID INT(10) REFERENCES Customer,
    LoanType VARCHAR(15)
);


CREATE TABLE Accounts (
    AccID INT(10) PRIMARY KEY,
    AccName VARCHAR(30) NOT NULL,
    AccBalance FLOAT(8 , 1 ) NOT NULL,
    AccCreDate DATE NOT NULL,
    CustID INT(10) REFERENCES Customer,
    AccTypesCode VARCHAR(2) CHECK (AccTypesCode IN ('S' , 'Sl', 'C', 'M')),
    AccTypes VARCHAR(15)
);

CREATE TABLE CustPurchase (
    PurchaseID INT(15) PRIMARY KEY,
    Date DATE,
    CustID INT(10) REFERENCES Customer,
    ServiceCode VARCHAR(3) NOT NULL,
    CHECK (ServiceCode IN ('CRC' , 'DEC', 'ATC', 'INS')),
    service VARCHAR(15)
);
  
CREATE TABLE Transactions (
    TransID INT(15) PRIMARY KEY,
    Date DATE,
    Amount FLOAT(8 , 1 ) NOT NULL,
    TransTypeCode VARCHAR(3) NOT NULL,
    Transmode VARCHAR(3) NOT NULL,
    AccID INT(10) REFERENCES Accounts,
    PurchaseID INT(10) REFERENCES CustPurchase,
    CHECK (TransTypeCode IN ('WD' , 'DEP')),
    CHECK (Transmode IN ('EMI' , 'RD', 'FD', 'OL', 'CH')),
    TransactionMode VARCHAR(15)
);
  
 
 
#Triggers  

delimiter // 
CREATE TRIGGER emp_trigger BEFORE INSERT ON Employee
       FOR EACH ROW
       BEGIN
           IF NEW.posTypeCode = 'AC' THEN SET NEW.position = 'Accountant';
           ELSEIF NEW.posTypeCode = 'CA' THEN SET NEW.position = 'Cashier';
           ELSEIF NEW.posTypeCode = 'M' THEN SET NEW.position = 'Manager';
           ELSEIF NEW.posTypeCode = 'CO' THEN SET NEW.position = 'Consultant';
           ELSEIF NEW.posTypeCode = 'L' THEN SET NEW.position = 'Loan Officer';
           END IF;
           Set new.workedYears = TIMESTAMPDIFF(year,NEW.joiningDate,Current_Date());
       END;//
 delimiter ;
#drop trigger emp_trigger;

delimiter // 
CREATE TRIGGER emp_trigger_before_upd BEFORE UPDATE ON Employee
       FOR EACH ROW
       BEGIN
           IF NEW.posTypeCode = 'AC' THEN SET NEW.position = 'Accountant';
           ELSEIF NEW.posTypeCode = 'CA' THEN SET NEW.position = 'Cashier';
           ELSEIF NEW.posTypeCode = 'M' THEN SET NEW.position = 'Manager';
           ELSEIF NEW.posTypeCode = 'CO' THEN SET NEW.position = 'Consultant';
           ELSEIF NEW.posTypeCode = 'L' THEN SET NEW.position = 'Loan Officer';
           END IF;
           Set new.workedYears = TIMESTAMPDIFF(year,NEW.joiningDate,Current_Date());
       END;//
 delimiter ;
#drop trigger emp_trigger_before_upd;


delimiter //
CREATE TRIGGER cust_type_trigger BEFORE INSERT ON Customer
       FOR EACH ROW
       BEGIN
           IF NEW.custTypeCode = 'I' THEN SET NEW.custType = 'Individual';
           ELSEIF NEW.custTypeCode = 'SC' THEN SET NEW.custType = 'Senior Citizen';
           ELSEIF NEW.custTypeCode = 'M' THEN SET NEW.custType = 'Minor';
           ELSEIF NEW.custTypeCode = 'O' THEN SET NEW.custType = 'Organization';
           END IF;
           Set new.age = TIMESTAMPDIFF(year,new.birthDate,Current_Date());

       END;//
 delimiter ;
#drop trigger cust_type_trigger;

delimiter //
CREATE TRIGGER cust_type_trigger_before_upd BEFORE UPDATE ON Customer
       FOR EACH ROW
       BEGIN
           IF NEW.custTypeCode = 'I' THEN SET NEW.custType = 'Individual';
           ELSEIF NEW.custTypeCode = 'SC' THEN SET NEW.custType = 'Senior Citizen';
           ELSEIF NEW.custTypeCode = 'M' THEN SET NEW.custType = 'Minor';
           ELSEIF NEW.custTypeCode = 'O' THEN SET NEW.custType = 'Organization';
           END IF;
           Set new.age = TIMESTAMPDIFF(year,new.birthDate,Current_Date());
       END;//
 delimiter ;
#drop trigger cust_type_trigger_before_upd;


delimiter //
CREATE TRIGGER loan_type_trigger BEFORE INSERT ON Loan
       FOR EACH ROW
       BEGIN
           IF NEW.LoanTypesCode = 'C' THEN SET NEW.LoanType = 'Car';
           ELSEIF NEW.LoanTypesCode = 'H' THEN SET NEW.LoanType = 'Home';
           ELSEIF NEW.LoanTypesCode = 'E' THEN SET NEW.LoanType = 'Education';
           ELSEIF NEW.LoanTypesCode = 'B' THEN SET NEW.LoanType = 'Business';
           END IF;
           Set new.EMI_Amount = new.Loan_Amount * (new.ROI/100) * (POWER((1 + (new.ROI/100)),TIMESTAMPDIFF(month,NEW.startDate,NEW.endDate)) / (POWER((1 + (new.ROI/100)),(TIMESTAMPDIFF(month,NEW.startDate,NEW.endDate) - 1))));
       END;//
 delimiter ;
#drop trigger loan_type_trigger;

delimiter //
CREATE TRIGGER loan_trigger_before_upd BEFORE UPDATE ON Loan
FOR EACH ROW
BEGIN
           IF NEW.LoanTypesCode = 'C' THEN SET NEW.LoanType = 'Car';
           ELSEIF NEW.LoanTypesCode = 'H' THEN SET NEW.LoanType = 'Home';
           ELSEIF NEW.LoanTypesCode = 'E' THEN SET NEW.LoanType = 'Education';
           ELSEIF NEW.LoanTypesCode = 'B' THEN SET NEW.LoanType = 'Business';
           END IF;
           Set new.EMI_Amount = 
		   new.Loan_Amount * (new.ROI/100) * 
		   (POWER((1 + (new.ROI/100)),TIMESTAMPDIFF(month,NEW.startDate,NEW.endDate)) / 
           (POWER((1 + (new.ROI/100)),(TIMESTAMPDIFF(month,NEW.startDate,NEW.endDate)))- 1));
           END;//
 delimiter ;
#drop trigger loan_trigger_before_upd;

delimiter //
CREATE TRIGGER account_type_trigger BEFORE INSERT ON Accounts
       FOR EACH ROW
       BEGIN
           IF NEW.AccTypesCode = 'S' THEN SET NEW.AccTypes = 'Savings';
           ELSEIF NEW.AccTypesCode = 'Sl' THEN SET NEW.AccTypes = 'Salary';
           ELSEIF NEW.AccTypesCode = 'C' THEN SET NEW.AccTypes = 'Current';
           ELSEIF NEW.AccTypesCode = 'M' THEN SET NEW.AccTypes = 'Minor';
           END IF;
       END;//
 delimiter ;
#drop trigger account_type_trigger;

delimiter //
CREATE TRIGGER account_type_trigger_before_upd BEFORE UPDATE ON Accounts
       FOR EACH ROW
       BEGIN
           IF NEW.AccTypesCode = 'S' THEN SET NEW.AccTypes = 'Savings';
           ELSEIF NEW.AccTypesCode = 'Sl' THEN SET NEW.AccTypes = 'Salary';
           ELSEIF NEW.AccTypesCode = 'C' THEN SET NEW.AccTypes = 'Current';
           ELSEIF NEW.AccTypesCode = 'M' THEN SET NEW.AccTypes = 'Minor';
           END IF;
       END;//
 delimiter ;
#drop trigger account_type_trigger_before_upd;


delimiter // 
CREATE TRIGGER service_trigger BEFORE INSERT ON CustPurchase
       FOR EACH ROW
       BEGIN
           IF NEW.ServiceCode  = 'CRC' THEN SET NEW.service = 'Credit Card';
           ELSEIF NEW.ServiceCode  = 'DEC' THEN SET NEW.service = 'Debit Card';
           ELSEIF NEW.ServiceCode  = 'ATC' THEN SET NEW.service = 'ATM Card';
           ELSEIF NEW.ServiceCode  = 'INS' THEN SET NEW.service = 'Insurance';
           END IF;
       END;//
 delimiter ;
#drop trigger service_trigger;

delimiter // 
CREATE TRIGGER service_trigger_before_upd BEFORE UPDATE ON CustPurchase
       FOR EACH ROW
       BEGIN
           IF NEW.ServiceCode  = 'CRC' THEN SET NEW.service = 'Credit Card';
           ELSEIF NEW.ServiceCode  = 'DEC' THEN SET NEW.service = 'Debit Card';
           ELSEIF NEW.ServiceCode  = 'ATC' THEN SET NEW.service = 'ATM Card';
           ELSEIF NEW.ServiceCode  = 'INS' THEN SET NEW.service = 'Insurance';
           END IF;
       END;//
 delimiter ;
#drop trigger service_trigger_before_upd;


delimiter // 
CREATE TRIGGER transmode_trigger BEFORE INSERT ON Transactions
       FOR EACH ROW
       BEGIN
           IF NEW.Transmode  = 'EMI' THEN SET NEW.TransactionMode = 'EMI';
           ELSEIF NEW.Transmode  = 'RD' THEN SET NEW.TransactionMode = 'Rate Deposit';
           ELSEIF NEW.Transmode  = 'FD' THEN SET NEW.TransactionMode = 'Fixed Deposit';
           ELSEIF NEW.Transmode  = 'OL' THEN SET NEW.TransactionMode = 'Online';
           ELSEIF NEW.Transmode  = 'CH' THEN SET NEW.TransactionMode = 'Cheque';
           END IF;
           #Select AccBalance from Accounts as AccBalance;
           IF new.TransTypeCode = 'WD' Then update Accounts set AccBalance = CASE 
           WHEN (Accounts.AccBalance - new.Amount) > 0 THEN AccBalance - new.Amount ELSE AccBalance END WHERE Accounts.AccID=NEW.AccID ;
		   ELSEIF new.TransTypeCode = 'DEP' then update Accounts set AccBalance = AccBalance + new.Amount WHERE Accounts.AccID=NEW.AccID;
           END IF;
       END;//
 delimiter ;
#drop trigger transmode_trigger;

delimiter // 
CREATE TRIGGER transmode_trigger_before_upd BEFORE UPDATE ON Transactions
       FOR EACH ROW
       BEGIN
           IF NEW.Transmode  = 'EMI' THEN SET NEW.TransactionMode = 'EMI';
           ELSEIF NEW.Transmode  = 'RD' THEN SET NEW.TransactionMode = 'Rate Deposit';
           ELSEIF NEW.Transmode  = 'FD' THEN SET NEW.TransactionMode = 'Fixed Deposit';
           ELSEIF NEW.Transmode  = 'OL' THEN SET NEW.TransactionMode = 'Online';
           ELSEIF NEW.Transmode  = 'CH' THEN SET NEW.TransactionMode = 'Cheque';
           END IF;
           #Select AccBalance from Accounts as AccBalance;
           IF new.TransTypeCode = 'WD' Then update Accounts set AccBalance = CASE 
           WHEN (Accounts.AccBalance - new.Amount) > 0 THEN AccBalance - new.Amount ELSE AccBalance END WHERE Accounts.AccID=NEW.AccID ;
		   ELSEIF new.TransTypeCode = 'DEP' then update Accounts set AccBalance = AccBalance + new.Amount WHERE Accounts.AccID=NEW.AccID;
           END IF;
       END;//
 delimiter ;
#drop trigger transmode_trigger_before_upd;


insert into Customer(CustID, custTypeCode, custPhone, custEmail, firstName, middleName, lastName, gender, StreetName, building, city, state, pincode, birthDate, EmpID ) values(2015110011, 'I','9834659278','adityatarade@gmail.com', 'Aditya', 'Manoj', 'Tarade', 'M', 'M.G Road', '301 / st Floor', 'Mumbai', 'Maharashtra', 400028, '1980-03-02', 2015220011);
insert into Customer(CustID, custTypeCode, custPhone, custEmail, firstName, middleName, lastName, gender, StreetName, building, city, state, pincode, birthDate, EmpID ) values(2016110012, 'SC','9089946598','pranavaher@gmail.com', 'Pranav', 'Atharva', 'Aher',  'M', 'Shanivaar Peth', '175 / Hakimwadi','Pune', 'Maharashtra', 400064, '1957-01-02', 2016220012);
insert into Customer(CustID, custTypeCode, custPhone, custEmail, firstName, middleName, lastName, gender, StreetName, building, city, state, pincode, birthDate, EmpID ) values(2017110013, 'M','9875465980', 'kuldeepvaishnav@gmail.com', 'Sunita', 'Vijay', 'Patil', 'F', 'Peth Naka', '443, Laxmi Plaza','Kolhapur', 'Maharashtra', 415208, '2004-01-02', 2017220013);
insert into Customer(CustID, custTypeCode, custPhone, custEmail, firstName, middleName, lastName, gender, StreetName, building, city, state, pincode, birthDate, EmpID ) values(2018110014, 'O','9487568750', 'virajwasnik@gmail.com', 'Viraj', 'Mohan', 'Wasnik',  'M',  'Datta Chowk', ' B 29/b, Aditya heights','Satara', 'Maharashtra', 410432, '1990-12-12', 2018220014);
insert into Customer(CustID, custTypeCode, custPhone, custEmail, firstName, middleName, lastName, gender, StreetName, building, city, state, pincode, birthDate, EmpID ) values(2019110015, 'SC','9089946598','mohinisarvankar@gmail.com', 'Mohini', 'Pravin', 'Sarvankar',  'F', 'Karad Square', ' 29, Bhatia Bldg','Karad', 'Maharashtra', 402811, '1952-11-10', 2019220015);


insert into employee (empID, joiningDate, emp_firstname, emp_middlename, emp_lastname, empPhone, empEmail, posTypeCode, gender, StreetName, building, city, state, pincode, branchid) values (2015220011, '2005-03-09', 'John', 'David', 'Smith', '9967439902', 'John@gmail.com', 'AC' ,'M' ,'M.G.Road', 'Om Sai Sadan', 'Nashik', 'Maharashtra', 421206, 0000000001);
insert into employee (empID, joiningDate, emp_firstname, emp_middlename, emp_lastname, empPhone, empEmail, posTypeCode, gender, StreetName, building, city, state, pincode, branchid) values (2016220012, '2008-02-05', 'Emily', 'David', 'Warner', '9987455902', 'Emily@gmail.com', 'CO' ,'F' ,'Nehru road', 'Sweet arcade', 'Pune', 'Maharashtra', 421246, 0000000002);
insert into employee (empID, joiningDate, emp_firstname, emp_middlename, emp_lastname, empPhone, empEmail, posTypeCode, gender, StreetName, building, city, state, pincode, branchid) values (2017220013, '2000-10-12', 'Shreya', 'Prakas', 'Gupto', '8655439902', 'Shreya@gmail.com', 'M' ,'F' ,'hill Road', 'Seattle arcades', 'Mumbai', 'Maharashtra', 400002, 0000000003);
insert into employee (empID, joiningDate, emp_firstname, emp_middlename, emp_lastname, empPhone, empEmail, posTypeCode, gender, StreetName, building, city, state, pincode, branchid) values (2018220014, '2009-05-04', 'Adarsh', 'Aryan', 'Shah', '8867439945', 'Adarsh@gmail.com', 'CA' ,'M' ,'Link Road', 'Millenial', 'Dadar', 'Maharashtra', 400206, 0000000004);
insert into employee (empID, joiningDate, emp_firstname, emp_middlename, emp_lastname, empPhone, empEmail, posTypeCode, gender, StreetName, building, city, state, pincode, branchid) values (2019220015, '2008-04-01', 'Rohan', 'Ramesh', 'Katkar', '8454439902', 'rohan@gmail.com', 'L' ,'M' ,'Savarkar Road', 'Green heights', 'Thane', 'Maharashtra', 421150, 0000000005);

Insert into Accounts(AccID,AccName,AccCreDate,AccBalance,CustID,AccTypesCode) values(2015440011,'Aditya','2019-01-01',1000000 , '2015110011','Sl');
Insert into Accounts(AccID,AccName,AccCreDate,AccBalance,CustID,AccTypesCode) values(2016440012,'Pranav','2018-02-02',3000000, '2015110012','C');
Insert into Accounts(AccID,AccName,AccCreDate,AccBalance,CustID,AccTypesCode) values(2017440013,'Sunita','2017-03-03',50000, '2015110013','M');
Insert into Accounts(AccID,AccName,AccCreDate,AccBalance,CustID,AccTypesCode) values(2018440014,'Wasnik_Enterprises','2017-04-04', 2000000, '2015110014','C');
Insert into Accounts(AccID,AccName,AccCreDate,AccBalance,CustID,AccTypesCode) values(2019440015,'MohiniSarvankar','2016-06-06', 500000, '2015110015','S');

#Loan values Done
insert into Loan(LoanID, startDate, endDate, Loan_Amount, ROI, AccID, CustID, LoanTypesCode) values(2015330011, '2020-01-02','2022-01-02', 2000000, 9, 2015440011, 2015110011, 'H');
insert into Loan(LoanID, startDate, endDate, Loan_Amount, ROI, AccID, CustID, LoanTypesCode) values(2016330012, '2020-11-11','2030-11-02', 2500000, 9.5 ,2016440012, 2016110012, 'C');
insert into Loan(LoanID, startDate, endDate, Loan_Amount, ROI, AccID, CustID, LoanTypesCode) values(2017330013, '2020-03-30','2025-01-02', 400000, 8.7, 2017440013, 2017110013, 'E');
insert into Loan(LoanID, startDate, endDate, Loan_Amount, ROI, AccID, CustID, LoanTypesCode) values(2018330014, '2020-08-21','2027-12-02', 350000, 7.9 , 2018440014,  2018110014, 'B');
insert into Loan(LoanID, startDate, endDate, Loan_Amount, ROI, AccID, CustID, LoanTypesCode) values(2019330015, '2020-09-17','2029-01-02', 100000, 9.9, 2019440015, 2019110015, 'H');
insert into Loan(LoanID, startDate, endDate, Loan_Amount, ROI, AccID, CustID, LoanTypesCode) values(2019330016, '2020-09-17','2029-01-02', 10000, 9.9, 2019440015, 2019110015, 'H');


#CustPurchase values Done
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2015550011, '2020-01-02', 2015110011, 'CRC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2016550012, '2020-01-11', 2016110012, 'DEC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2017550013, '2020-02-15', 2017110013, 'ATC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2018550014, '2020-02-21', 2018110014, 'DEC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2019550015, '2020-03-17', 2019110015, 'INS');

insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2015550016, '2020-03-13', 2015110011, 'INS');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2016550017, '2020-04-11', 2016110012, 'CRC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2017550018, '2020-04-30', 2017110013, 'DEC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2018550019, '2020-05-17', 2018110014, 'ATC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2019550020, '2020-05-18', 2019110015, 'DEC');

insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2015550021, '2020-06-09', 2015110011, 'ATC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2016550022, '2020-07-08', 2016110012, 'INS');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2017550023, '2020-08-20', 2017110013, 'CRC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2018550024, '2020-08-21', 2018110014, 'ATC');
insert into CustPurchase(PurchaseID, Date,CustID, ServiceCode) values(2019550025, '2020-09-17', 2019110015, 'DEC');
SELECT 
    *
FROM
    Loan;

#Transactions values Done
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2015660011, '2020-01-02', 10000.0, 'DEP', 2015440011, 'EMI');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2016660012, '2020-02-02', 1500.0, 'DEP', 2016440012, 'RD');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2017660013, '2020-07-22', 120000.0, 'DEP', 2017440013, 'FD');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2018660014, '2020-09-09', 30000.0, 'WD', 2018440014, 'OL');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2019660015, '2020-11-14', 23000.0, 'WD', 2019440015, 'CH');

insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2015660016, '2020-12-02', 12400.0, 'DEP', 2015440011, 'CH');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2016660017, '2020-04-22', 15000.0, 'WD', 2016440012, 'OL');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2017660018, '2020-08-19', 19000.0, 'DEP', 2017440013, 'EMI');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2018660019, '2020-07-17', 305000.0, 'DEP', 2018440014, 'FD');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2019660020, '2020-03-15', 2000.0, 'DEP', 2019440015, 'RD');

insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2015660021, '2020-02-11', 1000.0, 'DEP', 2015440011, 'RD');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2016660022, '2020-05-17', 1500000.0, 'DEP', 2016440012, 'FD');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2017660023, '2020-09-13', 120000.0, 'WD', 2017440013, 'OL');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2018660024, '2020-07-23', 38000.0, 'WD', 2018440014, 'CH');
insert into Transactions(TransID , Date, Amount, TransTypeCode, AccID, Transmode) values(2019660025, '2020-02-29', 23000.0, 'DEP', 2019440015, 'EMI');
SELECT 
    *
FROM
    Transactions;
SELECT 
    *
FROM
    Accounts;

#Branch values Done
insert into Branch values( 0000000001, 'Karad'); 
insert into Branch values( 0000000004, 'Pune');
insert into Branch values( 0000000002, 'Mumbai'); 
insert into Branch values( 0000000003, 'Pune');
insert into Branch values( 0000000005, 'Kolhapur');

Select * from Customer;
Select * from Loan;
SHOW tables;
DESCRIBE Customer;

#Joins
SELECT a.custID, a.firstname, a.lastname , a.gender, a.city, a.age, a.custtype, b.empID, b.emp_firstname, b.emp_lastname
FROM customer a 
INNER JOIN employee b
ON a.empID=b.empID;

SELECT a.empID, a.emp_firstname , a.emp_lastname, a.gender, a.position, a.workedYears, b.branchID, b.branchloc
FROM employee a 
INNER JOIN branch b
ON a.branchID=b.branchid
Order by empID;

SELECT  b.LoanID, a.AccID, a.Accname,a.accbalance,a.accTypes, b.Loan_Amount, b.startDate, b.endDate, b.EMI_amount, b.LoanType
FROM Accounts a , Loan b
WHERE a.AccID=b.AccID
Order by loanID;

SELECT a.custID, a.firstname, a.lastname, b.purchaseID, b.service, b.date
FROM customer a 
INNER JOIN custPurchase b
ON a.custID=b.custID
ORDER BY CustID,date;

SELECT a.AccID, b.TransID,  a.Accname,a.accbalance, a.accTypes, b.date, b.amount, b.transactionmode, b.TransTypeCode
FROM Accounts a 
INNER JOIN transactions b
ON a.AccID=b.AccID
Order by AccID, transID;

SELECT a.AccID, a.Accname,a.accbalance, a.accTypes, COUNT(b.TransID) As Number_of_transactions
FROM Accounts a 
INNER JOIN transactions b
ON a.AccID=b.AccID
GROUP BY AccID
Order by AccID;

#Views
CREATE VIEW cust
AS SELECT a.custID, a.firstname, a.lastname , a.gender, a.city, a.age, a.custtype, b.empID, b.emp_firstname, b.emp_lastname
FROM customer a, employee b
WHERE a.empID=b.empID;
select * from cust order by custID;

CREATE VIEW emp
AS SELECT a.empID, a.emp_firstname , a.emp_lastname, a.gender, a.position, a.workedYears, b.branchID, b.branchloc
FROM employee a, branch b
WHERE a.branchID=b.branchid;
select * from emp order by empID;

CREATE VIEW loanacc
AS SELECT b.LoanID, a.AccID, a.Accname,a.accbalance,a.accTypes, b.Loan_Amount, b.startDate, b.endDate, b.EMI_amount, b.LoanType
FROM Accounts a, Loan b
WHERE a.AccID=b.AccID;
select * from loanacc order by loanID;

CREATE VIEW custcustpurchase
AS SELECT a.custID, a.firstname, a.lastname, b.purchaseID, b.service, b.date
FROM customer a, custPurchase b
WHERE a.custID=b.custID;
select * from custcustpurchase order by date;

select * from custcustpurchase where custID = '2019110015' order by date;

CREATE VIEW transacc
AS SELECT b.TransID, a.AccID, a.Accname,a.accbalance, a.accTypes, b.date, b.amount, b.transactionmode, b.TransTypeCode
FROM Accounts a, transactions b
WHERE a.AccID=b.AccID;
select * from transacc order by transID;

select * from transacc where transactionmode = 'Rate Deposit' order by transID;

CREATE VIEW transaccno
AS SELECT a.AccID, a.Accname,a.accbalance, a.accTypes, b.TransID, b.date, b.amount, b.transactionmode, b.TransTypeCode
FROM Accounts a, transactions b
WHERE a.AccID=b.AccID AND A.AccID=2018440014;
select * from transaccno order by date;


#aggregate
select sum(accbalance) as bank_capital from accounts;
select sum(loan_amount) as total_loan_from_bank from loan;
select sum(amount) as total_deposit from transactions WHERE transtypecode='DEP';
select sum(amount) as total_withdrawal from transactions WHERE transtypecode='WD';

select avg(amount) as average_yearly_deposit, year(date) from transactions WHERE transtypecode='DEP' AND year(date)='2020';
select avg(amount) as average_yearly_withdrawal, year(date) from transactions WHERE transtypecode='WD' AND year(date)='2020';

select count(empID) as total_employee from employee;
select count(custID) as total_customers from customer;
select count(accID) as total_accounts from accounts;
select count(transID)as total_no_transactions from transactions;

select min(accBalance) as minimum_account_balance from accounts;
select max(accBalance) as maximum_account_balance from accounts;
select min(Loan_amount) as minimum_loan_amount from loan;
select max(Loan_amount) as maximum_loan_amount from loan;
select min(amount) as minimum_transaction_amount from transactions;
select max(amount) as maximum_transaction_amount from transactions;

select * from transactions;