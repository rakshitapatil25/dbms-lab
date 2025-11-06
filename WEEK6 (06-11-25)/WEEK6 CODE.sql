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


-- DEPT Table (No Changes Needed)
-- Insert Departments if not already added (from original code)
INSERT INTO DEPT (DEPTNO, DNAME, DLOC) VALUES
(10, 'IT', 'Bengaluru'),
(20, 'HR', 'Hyderabad'),
(30, 'Finance', 'Mysuru'),
(40, 'Marketing', 'Chennai'),
(50, 'Sales', 'Pune');

-- EMPLOYEE Table (Top-level and Second-level Managers + Employees in Same Department)
INSERT INTO EMPLOYEE (EMPNO, ENAME, MGR_NO, HIREDATE, SAL, DEPTNO) VALUES
(101, 'Ravi', NULL, '2020-05-10', 60000, 10),  -- IT
(102, 'Anita', NULL, '2019-03-15', 55000, 20),  -- HR
(103, 'Kiran', NULL, '2021-01-12', 50000, 30),  -- Finance
(104, 'Meena', NULL, '2018-07-25', 65000, 40),  -- Marketing
(106, 'Priya', NULL, '2023-06-18', 52000, 50);  -- Sales

-- Second-level managers (MGR_NO points to the EMPNO of a top-level manager)
INSERT INTO EMPLOYEE (EMPNO, ENAME, MGR_NO, HIREDATE, SAL, DEPTNO) VALUES
(107, 'Anjali', 101, '2018-05-15', 70000, 10),  -- IT
(108, 'Ravi Kumar', 102, '2019-07-20', 58000, 20),  -- HR
(109, 'Suresh', 103, '2021-03-15', 54000, 30),  -- Finance
(110, 'Suman', 104, '2020-10-10', 62000, 40),  -- Marketing
(111, 'Ajay', 106, '2023-02-10', 50000, 50);  -- Sales

-- Employees working in the same department as their manager
INSERT INTO EMPLOYEE (EMPNO, ENAME, MGR_NO, HIREDATE, SAL, DEPTNO) VALUES
(112, 'Ravi Kumar Jr.', 101, '2022-03-10', 70000, 10),  -- Same department as Ravi
(113, 'Meenal', 102, '2022-06-15', 55000, 20),  -- Same department as Anita
(114, 'Kiran Kumar', 103, '2021-11-25', 60000, 30),  -- Same department as Kiran
(115, 'Suman R', 104, '2022-02-05', 62000, 40),  -- Same department as Meena
(116, 'Anjali', 106, '2023-04-10', 52000, 50);  -- Same department as Priya

-- INCENTIVES Table (January 2019 Incentives)
INSERT INTO INCENTIVES (EMPNO, INCENTIVE_DATE, INCENTIVE_AMOUNT) VALUES
(101, '2019-01-15', 12000),  -- Ravi gets the highest incentive
(102, '2019-01-10', 10000),  -- Anita gets the second-highest incentive
(103, '2019-01-20', 8000),   -- Kiran gets a lesser incentive
(104, '2019-01-25', 7000),   -- Meena gets a lower incentive
(106, '2019-01-30', 5000);   -- Priya gets the lowest incentive




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


-- First, we get the count of employees reporting to each manager.
SELECT MGR_NO, COUNT(*) AS NUM_EMPLOYEES
FROM EMPLOYEE
GROUP BY MGR_NO;

-- Second, we need to check the manager(s) with the maximum number of employees.
SELECT E.ENAME AS MANAGER_NAME
FROM EMPLOYEE E
WHERE E.EMPNO IN (
    SELECT MGR_NO
    FROM EMPLOYEE
    GROUP BY MGR_NO
    HAVING COUNT(*) = (
        SELECT MAX(EmployeeCount)
        FROM (
            SELECT COUNT(*) AS EmployeeCount
            FROM EMPLOYEE
            GROUP BY MGR_NO
        ) AS SubQuery
    )
);


SELECT E.ENAME AS MANAGER_NAME
FROM EMPLOYEE E
WHERE E.SAL > (
    SELECT AVG(S.SAL)
    FROM EMPLOYEE S
    WHERE S.MGR_NO = E.EMPNO
);


SELECT E.ENAME AS SECOND_TOP_MANAGER_NAME, E.DEPTNO
FROM EMPLOYEE E
WHERE E.MGR_NO IN (
    SELECT E1.EMPNO
    FROM EMPLOYEE E1
    WHERE E1.MGR_NO IS NULL
      AND E1.DEPTNO = E.DEPTNO
)
AND E.MGR_NO IS NOT NULL;


SELECT E.EMPNO, E.ENAME, E.SAL, E.HIREDATE, I.INCENTIVE_DATE, I.INCENTIVE_AMOUNT
FROM EMPLOYEE E
JOIN INCENTIVES I ON E.EMPNO = I.EMPNO
WHERE I.INCENTIVE_DATE BETWEEN '2019-01-01' AND '2019-01-31'
AND I.INCENTIVE_AMOUNT = (
    SELECT MAX(INCENTIVE_AMOUNT)
    FROM INCENTIVES
    WHERE INCENTIVE_DATE BETWEEN '2019-01-01' AND '2019-01-31'
    AND INCENTIVE_AMOUNT < (
        SELECT MAX(INCENTIVE_AMOUNT)
        FROM INCENTIVES
        WHERE INCENTIVE_DATE BETWEEN '2019-01-01' AND '2019-01-31'
    )
);


SELECT E.EMPNO, E.ENAME, E.SAL, E.HIREDATE, D.DNAME AS DEPARTMENT_NAME
FROM EMPLOYEE E
JOIN EMPLOYEE M ON E.MGR_NO = M.EMPNO
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE E.DEPTNO = M.DEPTNO;









