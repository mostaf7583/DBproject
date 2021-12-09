

create table PostGradUser(
id int identity,
email varchar(20),
passwordd varchar(20),
primary key(id)
)


create table Admin(
id int,
foreign key (id) references PostGradUser(id) on delete cascade on update cascade,
primary key (id)
)


 create table GUCianstudent(
id int,
firstName varchar(20),
lastname varchar(20),
typee varchar(20),
faculty varchar(20),
addresss varchar(35),
GPA int ,
undergradID int,
Primary key(id),
foreign key (id) references PostGradUser(id) on delete cascade on update cascade
)

create table NONGUCIANstudent(
id int,
firstName varchar(20),
lastname varchar(20),
typee varchar(20),
faculty varchar(20),
addresss varchar(35),
GPA int,
primary key (id),
Foreign Key (id) references PostGradUser(id) on delete cascade on update cascade
)

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
  code int)


create table supervisor 
(id int,
namee varchar(20),
faculty varchar (20),
primary key (id),
Foreign Key (id) references PostGradUser(id) on delete cascade on update cascade
)

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
id int,
namee varchar(20),
FieldOfWork varchar (20),
isNational bit,
primary key(id),
Foreign key (id) references PostGradUser(id)
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
Foreign key (sidd) references GucianStudent(id) ,
Foreign key (thesisSerialNumber) references Thesis(serialNumber) ,
Foreign key (supid) references Supervisor(id)
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
Foreign Key (sidd) references NonGUCianStudent(id) ,
Foreign Key (thesisSerialNumber) references Thesis(serialNumber),
Foreign Key (supid) references Supervisor(id)
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
Foreign Key (s_id) references GucianStudent(id),
Foreign Key (sup_id) references Supervisor(id),
Foreign Key (serialno) references Thesis(SerialNumber)
)

create table NonGUCianStudentRegisterThesis(
 s_id     int,
 sup_id   int,
 serialno int,
primary key (s_id,sup_id,serialno),

Foreign Key (s_id) references NonGucianStudent(id),
Foreign Key (sup_id) references Supervisor(id),
Foreign Key (serialno) references Thesis(SerialNumber)
);


create table ExaminerEvaluateDefense(
datee date,
serialNo int,
ExaminerID int,
comment varchar(100),
Primary Key (datee, serialNo, ExaminerID),
Foreign Key (datee,serialNo) references Defense,
Foreign Key (ExaminerID) references Examiner(id)
)

create table ThesisHasPublication(
serialNo int,
pubid int,
Primary Key(serialNo, pubid),
Foreign Key (serialNo) references Thesis(serialNumber)on  delete cascade on update cascade,
Foreign Key (pubid) references Publication(id)on  delete cascade on update cascade
)