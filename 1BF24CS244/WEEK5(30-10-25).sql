Create database if not exists employee_database;
use employee_database;


CREATE TABLE DEPT (
    DEPTNO INT PRIMARY KEY,
    DNAME VARCHAR(50),
    DLOC VARCHAR(50)
);

CREATE TABLE EMPLOYEE (
    EMPNO INT PRIMARY KEY,
    ENAME VARCHAR(50),
    MGR_NO INT,
    HIREDATE DATE,
    SAL DECIMAL(10,2),
    DEPTNO INT,
    FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO)
);

CREATE TABLE PROJECT (
    PNO INT PRIMARY KEY,
    PLOC VARCHAR(50),
    PNAME VARCHAR(50)
);

CREATE TABLE ASSIGNED_TO (
    EMPNO INT,
    PNO INT,
    JOB_ROLE VARCHAR(50),
    PRIMARY KEY (EMPNO, PNO),
    FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO),
    FOREIGN KEY (PNO) REFERENCES PROJECT(PNO)
);

CREATE TABLE INCENTIVES (
    EMPNO INT,
    INCENTIVE_DATE DATE,
    INCENTIVE_AMOUNT DECIMAL(10,2),
    FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO)
);


-- DEPT
INSERT INTO DEPT VALUES
(10, 'IT', 'Bengaluru'),
(20, 'HR', 'Hyderabad'),
(30, 'Finance', 'Mysuru'),
(40, 'Marketing', 'Chennai'),
(50, 'Sales', 'Pune');

-- EMPLOYEE
INSERT INTO EMPLOYEE VALUES
(101, 'Ravi', NULL, '2020-05-10', 60000, 10),
(102, 'Anita', 101, '2019-03-15', 55000, 20),
(103, 'Kiran', 101, '2021-01-12', 50000, 30),
(104, 'Meena', 102, '2018-07-25', 65000, 40),
(105, 'Suresh', 103, '2022-02-14', 48000, 10),
(106, 'Priya', 103, '2023-06-18', 52000, 20);

-- PROJECT
INSERT INTO PROJECT VALUES
(1, 'Bengaluru', 'SmartApp'),
(2, 'Hyderabad', 'DataSecure'),
(3, 'Mysuru', 'PaySys'),
(4, 'Pune', 'AdBoost'),
(5, 'Chennai', 'CloudX');

-- ASSIGNED_TO
INSERT INTO ASSIGNED_TO VALUES
(101, 1, 'Manager'),
(102, 2, 'HR Specialist'),
(103, 3, 'Analyst'),
(104, 5, 'Marketing Lead'),
(105, 1, 'Developer'),
(106, 2, 'Coordinator');

-- INCENTIVES
INSERT INTO INCENTIVES VALUES
(101, '2024-03-01', 5000),
(103, '2024-05-20', 3000),
(104, '2024-06-15', 2500);



/*Retrieve Employee Numbers of All Employees Working on Projects Located in Bengaluru, Hyderabad, or Mysuru*/
SELECT DISTINCT A.EMPNO
FROM ASSIGNED_TO A
JOIN PROJECT P ON A.PNO = P.PNO
WHERE P.PLOC IN ('Bengaluru', 'Hyderabad', 'Mysuru');



/*Get Employee IDs of Those Employees Who Didn’t Receive Incentives*/
SELECT E.EMPNO
FROM EMPLOYEE E
WHERE E.EMPNO NOT IN (SELECT EMPNO FROM INCENTIVES);


/*Find Employee Name, Number, Dept, Job Role, Department Location, and Project Location for Employees Working in Projects Located Same as Their Department Location*/
SELECT E.ENAME, E.EMPNO, D.DNAME, A.JOB_ROLE, D.DLOC AS DEPT_LOCATION, P.PLOC AS PROJECT_LOCATION
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
JOIN ASSIGNED_TO A ON E.EMPNO = A.EMPNO
JOIN PROJECT P ON A.PNO = P.PNO
WHERE D.DLOC = P.PLOC;