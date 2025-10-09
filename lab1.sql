create database IF NOT exists insurance_info;
use insurance_info;

create table person(
driver_id varchar(4),
name varchar(20),
address varchar(20),
primary key(driver_id)
);
create table car(
reg_num varchar(19),
model_num varchar(15),
year int,
primary key(reg_num)
);
create table owns(
driver_id varchar(4),
reg_num varchar(10),
primary key(driver_id, reg_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num)
);
create table accident(
report_num int,
accident_date date,
location varchar(20),
primary key(report_num)
);
create table participated(
driver_id varchar(4),
reg_num varchar(10),
report_num int,
damage_amount int,
primary key(driver_id, reg_num, report_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num),
foreign key(report_num) references accident(report_num)
);
insert into person values('A01', 'Richard', 'Srinivas nagar');
insert into person values('A02','Pradeep', 'Rajaji nagar');
insert into person values('A03', 'Smith', 'Ashok nagar');
insert into person values('A04', 'Venu', 'Srinivas nagar');
insert into person values('A05', 'Jhon', 'Hanumanth nagar');

insert into car values('KA052250', 'Indica', 1990);
insert into car values('KA031181','Lancer', 1957);
insert into car values('KA095477','Toyota',1998);
insert into car values('KA053408','Honda', 2008);
insert into car values('KA041702','Audi', 2005);

insert accident values(11, '2003-01-01', 'Mysore road');
insert accident values(12, '2004-02-02', 'Southend circle');
insert accident values(13, '2003-01-21','Bull temple road');
insert accident values(14, '2017-02-17', 'Mysore road');
insert accident values(15, '2004-03-05', 'Kanakpura road');

insert into owns values('A01', 'KA052250');
insert into owns values('A02','KA031181');
insert into owns values('A03', 'KA095477');
insert into owns values('A04', 'KA053408');
insert into owns values('A05', 'KA041702');

insert into participated values('A01', 'KA052250', 11, 10000);
insert into participated values('A02', 'KA031181', 12,50000);
insert into participated values('A03', 'KA095477', 13,25000);
insert into participated values('A04', 'KA053408', 14, 3000);
insert into participated values('A05', 'KA041702', 15, 5000);

SELECT * from car order by year ASC;

SELECT COUNT(*)
FROM participated, car
WHERE participated.reg_num = car.reg_num
AND car.model = 'Lancer';

USE insurance_data;

SELECT COUNT(*)
FROM participated, owns, accident
WHERE owns.reg_num = participated.reg_num
AND participated.report_num = accident.report_num
AND YEAR (accident.accident_date) = 2008;

SELECT * from participated order by damage_amount desc;

SELECT AVG (damage_amount)
FROM participated;

DELETE from participated
WHERE damage_amount < (SELECT AVG(damage_amount) FROM participated);

SELECT name from person, participated
WHERE participated.driver_id = person.driver_id
AND damage_amount < (SELECT AVG (damage_amount) FROM participated);

SELECT MAX (damage_amount)AS max_damage 
FROM participated;
