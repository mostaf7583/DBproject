create database mo130
create table users(
id int primary key identity,
email varchar(20),
password1 varchar(20))
create table Admins(
id int primary key identity,
email varchar(20),
password1 varchar(20))

create table student(
id int primary key Identity,
firstName varchar(20),
lastname varchar(20),
email varchar(35),
type1 varchar(20),
faculty varchar(20),
address1 varchar(35),
Gpa int 
)
 create table GUCianstudent(
id int primary key Identity,
firstName varchar(20),
lastname varchar(20),
email varchar(35),
type1 varchar(20),
faculty varchar(20),
address1 varchar(35),
Gpa int ,
undergradID int
)

create table NONGUCIANstudent(
id int primary key Identity,
firstName varchar(20),
lastname varchar(20),
email varchar(35),
type1 varchar(20),
faculty varchar(20),
address1 varchar(35),
Gpa int )

create table GUCStudentPhoneNumber(
 id int  ,
 phone int   ,
 primary key (id, phone),
  foreign key (id) references GUCianstudent(id) on delete cascade on update cascade
 )
 create table nonGUCStudentPhoneNumber(
 id int  ,
 phone int ,
 primary key(id, phone),
  foreign key (id) references NONGUCIANstudent(id) on delete cascade on update cascade
 )
  create table course( 
  id int primary key,
  fees int ,
  credithours int ,
  code int )
create table supervisor 
(id int primary key identity,
email varchar(20),
password1 varchar(20),
faculty varchar (20))

create table Payment(
id int primary key,
amount int,
no_installments int,
fundPercentage int
);

create table Thesis (
SerialNumber int primary key,
field varchar(20),
type1 varchar(20),
title varchar(30),
startDate date ,
endDate date,
defenseDate date,
years as (YEAR(endDate)-YEAR(startDate)),
grade int ,
payment_id int, 
noExtenstion bit,
foreign key (payment_id) references Payment(id)  on update cascade on delete cascade
)

create table Publication(
id int primary key,
title varchar(20),
dateP date,
place varchar(20),
accepted bit,
host varchar(20)
);



create table Examiner(
id int ,
namee varchar(20),
email varchar(30),
Passwordd varchar(30),
FieldOfWork varchar (20),
isNational bit,
primary key(id)
);

create table Defense(
SerialNumber int,
datee date,
locationn varchar(20),
grade varchar,
primary key (SerialNumber, datee),
Foreign key (SerialNumber) references Thesis(serialNumber) on  delete cascade on update cascade

);


create table GUCianProgessReport(
sidd int,
noo int,
datee date,
eval varchar(20),
statee int,
thesisSerialNumber int,
supid int,
primary key (sidd, noo),
Foreign key (sidd) references GucianStudent(id) on  delete cascade on update cascade,
Foreign key (thesisSerialNumber) references Thesis(serialNumber) on  delete cascade on update cascade,
Foreign key (supid) references Supervisor(id) on  delete cascade on update cascade
);

create table NonGUCianProgressReport(
sidd int,
noo int,
datee date,
eval varchar(20),
statee int,
thesisSerialNumber int,
supid int,
Primary Key (sidd, noo),
Foreign Key (sidd) references NonGUCianStudent(id) on  delete cascade on update cascade,
Foreign Key (thesisSerialNumber) references Thesis(serialNumber)on  delete cascade on update cascade,
Foreign Key (supid) references Supervisor(id) on  delete cascade on update cascade
);

create table Installment(
datee date,
paymentID int,
amount int,
done bit,
Primary Key(datee, paymentID),
Foreign Key (paymentID) references payment(id) on  delete cascade on update cascade
);
create table NonGucianStudentPayForCourse (
 s_id int ,
 paymentNo int,
 c_id int,
primary key(s_id,paymentNo,c_id),
Foreign Key (s_id) references NonGucianStudent(id)on  delete cascade on update cascade,
Foreign Key (paymentNo) references Payment(id)  on  delete cascade on update cascade,
Foreign Key (c_id) references  Course(id)  on  delete cascade on update cascade
)
--NonGucianStudentTakeCourse (sid, cid, grade) _ _ _ _
create table NonGucianStudentTakeCourse (
 s_id int,
 c_id int,
 grade int,
primary key (s_id,c_id),
Foreign Key (s_id) references NonGucianStudent(id)on  delete cascade on update cascade,
Foreign Key (c_id) references  Course(id)  on  delete cascade on update cascade
)
--GUCianStudentRegisterThesis (sid, sup_id, serial_no)
create table GUCianStudentRegisterThesis(
 s_id     int,
 sup_id   int,
 serialno int,
primary key (s_id,sup_id,serialno),

Foreign Key (s_id) references GucianStudent(id)on  delete cascade on update cascade,
Foreign Key (sup_id) references Supervisor(id)on  delete cascade on update cascade,
Foreign Key (serialno) references Thesis(SerialNumber)on  delete cascade on update cascade
)

create table NonGUCianStudentRegisterThesis(
 s_id     int,
 sup_id   int,
 serialno int,
primary key (s_id,sup_id,serialno),

Foreign Key (s_id) references NonGucianStudent(id)on  delete cascade on update cascade,
Foreign Key (sup_id) references Supervisor(id)on  delete cascade on update cascade,
Foreign Key (serialno) references Thesis(SerialNumber)on  delete cascade on update cascade
);



create table ExaminerEvaluateDefense(
datee date,
serialNo int,
ExaminerID int,
comment varchar(100),
Primary Key (datee, serialNo, ExaminerID),
Foreign Key (datee) references Defense(datee),
Foreign Key (serialNo) references Defense(SerialNumber),
Foreign Key (ExaminerID) references Examiner(id)
);

create table ThesisHasPublication(
serialNo int,
pubid int,
Primary Key(serialNo, pubid),
Foreign Key (serialNo) references Thesis(serialNumber)on  delete cascade on update cascade,
Foreign Key (pubid) references Publication(id)on  delete cascade on update cascade
)