create database IF NOT EXISTS supplier_database;
use supplier_database;


CREATE TABLE Supplier (
  sid INT,
  sname VARCHAR(50),
  city VARCHAR(50),
  PRIMARY KEY (sid)
);

CREATE TABLE Parts (
  pid INT,
  pname VARCHAR(50),
  color VARCHAR(30),
  PRIMARY KEY (pid)
);

CREATE TABLE Catalog (
  sid INT,
  pid INT,
  cost DECIMAL(10,2),
  PRIMARY KEY (sid, pid),
  FOREIGN KEY (sid) REFERENCES Supplier(sid),
  FOREIGN KEY (pid) REFERENCES Parts(pid)
);

-- Supplier table
INSERT INTO Supplier VALUES (1, 'Ravi Traders', 'Delhi');
INSERT INTO Supplier VALUES (2, 'Kumar Supplies', 'Mumbai');
INSERT INTO Supplier VALUES (3, 'Acme Widget Suppliers', 'Chennai');

-- Parts table
INSERT INTO Parts VALUES (101, 'Bolt', 'Red');
INSERT INTO Parts VALUES (102, 'Nut', 'Red');
INSERT INTO Parts VALUES (103, 'Screw', 'Silver');
INSERT INTO Parts VALUES (104, 'Washer', 'Black');

-- Catalog table (who supplies what and at what cost)
INSERT INTO Catalog VALUES (1, 101, 5.00);
INSERT INTO Catalog VALUES (1, 102, 4.50);
INSERT INTO Catalog VALUES (1, 103, 6.00);
INSERT INTO Catalog VALUES (2, 101, 5.50);
INSERT INTO Catalog VALUES (2, 104, 4.00);
INSERT INTO Catalog VALUES (3, 101, 5.75);
INSERT INTO Catalog VALUES (3, 102, 4.25);
INSERT INTO Catalog VALUES (3, 103, 6.50);
INSERT INTO Catalog VALUES (3, 104, 4.10);


SELECT pname
FROM Parts
WHERE pid IN (SELECT pid FROM Catalog);


SELECT sname
FROM Supplier
WHERE sid IN (
  SELECT sid
  FROM Catalog
  GROUP BY sid
  HAVING COUNT(pid) = (SELECT COUNT(*) FROM Parts)
);


SELECT sname
FROM Supplier
WHERE sid IN (
  SELECT sid
  FROM Catalog
  WHERE pid IN (SELECT pid FROM Parts WHERE color = 'Red')
  GROUP BY sid
  HAVING COUNT(pid) = (SELECT COUNT(*) FROM Parts WHERE color = 'Red')
);


SELECT pname
FROM Parts
WHERE pid IN (
  SELECT pid
  FROM Catalog
  WHERE sid = (SELECT sid FROM Supplier WHERE sname = 'Acme Widget Suppliers')
  AND pid NOT IN (
    SELECT pid
    FROM Catalog
    WHERE sid <> (SELECT sid FROM Supplier WHERE sname = 'Acme Widget Suppliers')
  )
);



SELECT DISTINCT sid
FROM Catalog c1
WHERE cost > (
  SELECT AVG(cost)
  FROM Catalog c2
  WHERE c1.pid = c2.pid
);


SELECT p.pname, s.sname
FROM Parts p, Supplier s, Catalog c
WHERE p.pid = c.pid AND s.sid = c.sid
AND cost = (
  SELECT MAX(cost)
  FROM Catalog
  WHERE pid = p.pid
);                                                                                        



