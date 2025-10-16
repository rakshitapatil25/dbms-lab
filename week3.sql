create database if not exists bank_2;
use bank_2;
create table branch1(
    branch_name varchar(20), 
    branch_city varchar(20), 
    assests int,
    primary key(branch_name)
);
create table bankaccount(
    accno int, 
    branch_name varchar(20),
    balance int,
    primary key(accno),
    foreign key(branch_name) 
    references branch1(branch_name)
);
create table bankcustomer(
    customer_name varchar(20),
    customer_street varchar(20),
    customer_city varchar(20),
    primary key(customer_name)
);
create table depositer(
    customer_name varchar(20),
    accno int,
    primary key(customer_name,accno),
    foreign key(customer_name) 
    references bankcustomer(customer_name),
    foreign key(accno) 
    references bankaccount(accno)
);
create table loan(
    loan_number int,
    branch_name varchar(20),
    amount int,
    primary key(loan_number),
    foreign key(branch_name) 
    references branch1(branch_name)
);
insert into branch1 values('SBI_Chamrajpet','Bangalore',50000);
insert into branch1 values('SBI_Residency','Bangalore',10000);
insert into branch1 values('SBI_Shivajiroad','Bombay',20000);
insert into branch1 values('SBI_Parliamentroad','Delhi',10000);
insert into branch1 values('SBI_Jantarmantar','Delhi',20000);
select * from branch1;
insert into bankaccount values(1,'SBI_Chamrajpet',2000);
insert into bankaccount values(2,'SBI_Residency',5000);
insert into bankaccount values(3,'SBI_Shivajiroad',6000);
insert into bankaccount values(4,'SBI_Parliamentroad',9000);
insert into bankaccount values(5,'SBI_Jantarmantar',8000);
insert into bankaccount values(6,'SBI_Shivajiroad',4000);
insert into bankaccount values(8,'SBI_Residency',4000);
insert into bankaccount values(9,'SBI_Parliamentroad',3000);
insert into bankaccount values(10,'SBI_Residency',5000);
insert into bankaccount values(11,'SBI_Jantarmantar',2000);
select * from bankaccount;
insert into bankcustomer values('Avinash','Bulltempleroad','bangalore');
insert into bankcustomer values('Dinesh','Bannergatta','bangalore');
insert into bankcustomer values('Mohan','Natioanlcollege','bangalore');
insert into bankcustomer values('Nikhil','Akbarroad','Delhi');
select * from bankcustomer;
insert into bankcustomer values('ravi','Prithvirajroad','Delhi');
insert into depositer values('Avinash',1);
insert into depositer values('Dinesh',2);
insert into depositer values('Mohan',3);
insert into depositer values('Nikhil',4);
insert into depositer values('Ravi',5);
insert into depositer values('Avinash',6);
insert into depositer values('Dinesh',8);
insert into depositer values('Mohan',9);
insert into depositer values('Nikhil',10);
insert into depositer values('Ravi',11);
select * from depositer;
insert into loan values(1,'SBI_Chamrajpet',1000);
insert into loan values(2,'SBI_Residency',2000);
insert into loan values(3,'SBI_Shivajiroad',3000);
insert into loan values(4,'SBI_Parliamentroad',4000);
insert into loan values(5,'SBI_Jantarmantar',5000);
select * from loan;


SELECT 
    branch_name, 
    assests / 100000 AS `Assets in Lakhs`
FROM 
    branch1;
    

CREATE VIEW bangalore_branches AS
SELECT branch_name, assests
FROM branch1
WHERE branch_city = 'Bangalore';

SELECT * FROM bangalore_branches;

CREATE VIEW branch_loans AS
SELECT branch_name, SUM(amount) AS total_loan
FROM loan
GROUP BY branch_name;
SELECT * FROM branch_loans;

SELECT customer_name
FROM depositer, bankaccount, branch1
WHERE depositer.accno = bankaccount.accno
  AND bankaccount.branch_name = branch1.branch_name
  AND branch1.branch_city = 'Delhi'
GROUP BY customer_name
HAVING COUNT(DISTINCT branch1.branch_name) = 
       (SELECT COUNT(*) FROM branch1 WHERE branch_city = 'Delhi');
       
SELECT DISTINCT l.loan_number, l.branch_name
FROM loan l
WHERE l.branch_name NOT IN (
    SELECT b.branch_name
    FROM bankaccount b
    JOIN depositer d ON b.accno = d.accno
);

SELECT DISTINCT d.customer_name
FROM depositer d, bankaccount b, branch1 br, loan l
WHERE d.accno = b.accno
  AND b.branch_name = br.branch_name
  AND br.branch_name = l.branch_name
  AND br.branch_city = 'Bangalore';
  
SELECT branch_name
FROM branch1
WHERE assests > ALL (
    SELECT assests
    FROM branch1
    WHERE branch_city = 'Bangalore'
);

DELETE FROM bankaccount
WHERE branch_name IN (
    SELECT branch_name
    FROM branch1
    WHERE branch_city = 'Bombay'
);


UPDATE bankaccount
SET balance = balance + (balance * 5 / 100)
WHERE accno > 0;
SELECT * FROM bankaccount;

















