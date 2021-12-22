CREATE DATABASE gost;
create table Employee(
id int primary key Identity,
first_name char(25) Default 'Slim',
middle_name varchar(25),
last_name varchar(20) ,
country varchar(15),
fax_number varchar(15),
birth_date datetime not null,
age as year(current_timestamp)-year(birth_date)
)
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Slim','Abdennadher','Tunisia','12345','11-11-1967')
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Slim','Abdennadher','Tunisia','12345','11-11-1972')
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Alan','Turner','USA','12356','11/11/1967')
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Jack','Nickolson','USA','128912','11/11/1970')
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Fred','Melan','USA','171241','11/11/1973')
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Fred','Melan','USA','171241','11/11/1970')
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Albert','Einestein','Germany','172124','11/11/1975')
INSERT INTO Employee(first_name,last_name,country,fax_number,birth_date)
VALUES ('Mahmoud','Sakr','Egypt','124124','11/11/1980')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Taher','Galal','Egypt','11/11/1982')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Hassan','Shehata','Egypt','11/11/1987')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Baba','Arko','Cameron','11/11/1987')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Yaya','Toure','Cameron','11/11/1990')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Bob','Bradley','USA','11/11/1992')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Haitham','Ismail','Egypt','11/11/1967')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Soad','Hosny','Egypt','11/11/1993')
INSERT INTO Employee(first_name,middle_name,last_name,country,birth_date)
VALUES ('Elham','Hosny','Shaheen','Egypt','11/11/1995')
INSERT INTO Employee(first_name,middle_name,last_name,country,birth_date)
VALUES ('Haifa','Aslan','Wahby','Egypt','11/11/1995')
INSERT INTO Employee(first_name,middle_name,last_name,country,birth_date)
VALUES ('Akram','Farouk','Hosny','Egypt','11/11/1998')
INSERT INTO Employee(first_name,middle_name,last_name,country,birth_date)
VALUES ('Hend','Hamdy','Sabry','Tunisia','11/11/2002')
INSERT INTO Employee(first_name,last_name,country,birth_date)
VALUES ('Samuel','Etoo','Cameron','11/11/2004')
select * from Employee
