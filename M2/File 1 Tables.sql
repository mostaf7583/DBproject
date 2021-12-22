create database finalsubmission;

go
use finalsubmission

create table PostGradUser(
id int identity,
email varchar(50) ,
passwordd varchar(20),
primary key(id)
)

create table Admin(
id int,
primary key (id),
foreign key (id) references PostGradUser(id) on delete cascade on update cascade

)

create table GUCianstudent(
id int,
firstName varchar(20),
lastname varchar(20),
typee varchar(20),
faculty varchar(20),
addresss varchar(35),
GPA decimal(2,1) ,
undergradID int,
Primary key(id),
foreign key (id) references PostGradUser(id) on delete cascade on update cascade,
Check (GPA between 0.7 and 5.0)
)

create table NONGUCIANstudent(
id int,
firstName varchar(20),
lastname varchar(20),
typee varchar(20),
faculty varchar(20),
addresss varchar(35),
GPA decimal (2,1) ,
primary key (id),
Foreign Key (id) references PostGradUser(id) on delete cascade on update cascade,
Check (GPA between 0.0 and 4.0)
)

create table GUCStudentPhoneNumber(
id int  ,
phone varchar(20)   ,
primary key (id, phone),
foreign key (id) references GUCianstudent(id) on delete cascade on update cascade
 )

create table nonGUCStudentPhoneNumber(
id int  ,
phone varchar (20) ,
primary key(id, phone),
foreign key (id) references NONGUCIANstudent(id) on delete cascade on update cascade
 )

create table course( 
id int primary key identity,
fees decimal ,
credithours int ,
code varchar(10) )

create table supervisor (
id int,
namee varchar(20),
faculty varchar (20),
primary key (id),
Foreign Key (id) references PostGradUser(id) on delete cascade on update cascade
)

create table Payment(
id int primary key identity,
amount decimal(12,2),
no_installments int,
fundPercentage decimal(2,1)
);

create table Thesis (
SerialNumber int primary key identity,
field varchar(20),
type1 varchar(20),
title varchar(70),
startDate date ,
endDate date,
defenseDate date,
years as (YEAR(endDate)-YEAR(startDate)),
grade decimal(4,2) ,
payment_id int, 
noExtension int,
foreign key (payment_id) references Payment(id) on update cascade on delete cascade

)

create table Publication(
id int primary key identity,
title varchar(70),
dateP date,
place varchar(20),
accepted bit,
host varchar(50)
);

create table Examiner(
id int,
namee varchar(20),
FieldOfWork varchar (20),
isNational bit,
primary key(id),
Foreign key (id) references PostGradUser(id)on  delete cascade on update cascade
);

create table Defense(
SerialNumber int,
datee datetime,
locationn varchar(20),
grade decimal(4,2) ,
primary key (SerialNumber, datee),
Foreign key (SerialNumber) references Thesis(serialNumber) on  delete cascade on update cascade
);

create table GUCianProgressReport(
sidd int,
noo int,
datee date,
eval int,
statee int,
thesisSerialNumber int,
supid int,
descriptionn varchar(500), 
primary key (sidd, noo),
Foreign key (sidd) references GucianStudent(id) ,
Foreign key (thesisSerialNumber) references Thesis(serialNumber)on  delete cascade on update cascade ,
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
descriptionn varchar(500), 
Primary Key (sidd, noo),
Foreign Key (sidd) references NonGUCianStudent(id) ,
Foreign Key (thesisSerialNumber) references Thesis(serialNumber)on  delete cascade on update cascade,
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

create table NonGucianStudentTakeCourse (
s_id int,
c_id int,
grade decimal(4,2),
primary key (s_id,c_id),
Foreign Key (s_id) references NonGucianStudent(id)on  delete cascade on update cascade,
Foreign Key (c_id) references  Course(id)  on  delete cascade on update cascade
)

create table GUCianStudentRegisterThesis(
s_id     int,
sup_id   int,
serialno int,
primary key (s_id,sup_id,serialno),
Foreign Key (s_id) references GucianStudent(id),
Foreign Key (sup_id) references Supervisor(id),
Foreign Key (serialno) references Thesis(SerialNumber)on  delete cascade on update cascade
)

create table NonGUCianStudentRegisterThesis(
s_id     int,
sup_id   int,
serialno int,
primary key (s_id,sup_id,serialno),
Foreign Key (s_id) references NonGucianStudent(id),
Foreign Key (sup_id) references Supervisor(id) ,
Foreign Key (serialno) references Thesis(SerialNumber) on  delete cascade on update cascade
);

create table ExaminerEvaluateDefense(
datee datetime,
serialNo int,
ExaminerID int,
comment varchar(300),
Primary Key (datee, serialNo, ExaminerID),
Foreign Key (serialNo,datee) references Defense on  delete cascade on update cascade,
Foreign Key (ExaminerID) references Examiner(id)on  delete cascade on update cascade
)

create table ThesisHasPublication(
serialNo int,
pubid int,
Primary Key(serialNo, pubid),
Foreign Key (serialNo) references Thesis(serialNumber)on  delete cascade on update cascade,
Foreign Key (pubid) references Publication(id)on  delete cascade on update cascade
)



