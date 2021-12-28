use finalsubmission

go
-- 1a) Registering a student --

CREATE PROC StudentRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@faculty varchar(20),
@Gucian bit,
@email varchar(50),
@address varchar(50)

AS

DECLARE @ID int

INSERT INTO PostGradUser VALUES (@email, @password)

select @ID = max(P.id)
from PostGradUser P 

IF @Gucian = 1
INSERT INTO GUCianStudent (id, firstname, lastname, faculty, addresss) VALUES (@ID, @first_name, @last_name, @faculty, @address)

ELSE
INSERT INTO NonGUCianStudent (id, firstname, lastname, faculty, addresss) VALUES (@ID, @first_name, @last_name, @faculty, @address);


GO

-- 1a) Register a Supervisor--

CREATE PROC SupervisorRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@faculty varchar(20),
@email varchar(50)

AS

Declare @ID int
Declare @name varchar(50)
SET @name = @first_name + ' ' + @last_name

INSERT into PostGradUser VALUES (@email, @password)

select @ID = max(P.id)
from PostGradUser P 

INSERT into supervisor (id, namee, faculty) VALUES (@ID, @name, @faculty)


GO

-- 2a) Login as a user--

CREATE PROC userLogin
@ID int,
@password varchar(20),
@Success bit OUTPUT

AS

DECLARE @email varchar(50)

Select @email = P.email
From PostGradUser P where P.id = @ID

IF EXISTS (select email, passwordd from PostGradUser where email = @email AND passwordd = @password)
		BEGIN
			SET @Success = 1
		END
ELSE
SET @success = 0


GO

-- 2b Add mobile number--

CREATE PROC addMobile
@ID int,
@mobile_number varchar(20)
AS 
IF exists (SELECT G.id from GUCianstudent G where G.id = @ID)
		INSERT INTO GUCStudentPhoneNumber VALUES (@ID, @mobile_number)
ELSE 
	INSERT INTO nonGUCStudentPhoneNumber (id, phone) VALUES (@ID, @mobile_number);

GO

-- 3a List all supervisors in the system--

CREATE PROC AdminListSup
AS
Select *
from supervisor

GO

-- 3b view the profile of any supervisor that contains all his/her information.--

CREATE PROC AdminViewSupervisorProfile
@supId int
AS
SELECT *
from supervisor S 
where S.id = @supId

GO

--  3c List all Theses in the system--

CREATE PROC AdminViewAllTheses
AS
SELECT * from Thesis 

GO

--  3d List the number of on going theses --

CREATE PROC AdminViewOnGoingThesis
AS
Select count(*) AS 'Number of ongoing theses' from Thesis T where T.endDate > GETDATE() OR T.endDate is NULL

GO

-- 3e List all supervisors’ names currently supervising students, theses title, student name. --

CREATE PROC AdminViewStudentThesisBySupervisor
AS

select S.namee AS 'Supervisor', T.title AS 'Thesis Title', GS.firstName + ' ' + GS.lastname AS 'Student Name'
From supervisor S inner join GUCianStudentRegisterThesis GSRT
ON S.id = GSRT.sup_id
inner join GUCianstudent GS
ON GS.id = GSRT.s_id
inner join Thesis T
ON T.SerialNumber = GSRT.serialno

UNION

select S.namee AS 'Supervisor', T.title AS 'Thesis Title', NGS.firstName + ' ' + NGS.lastname AS 'Student Name'
From supervisor S inner join NonGUCianStudentRegisterThesis NGSRT
ON S.id = NGSRT.sup_id
inner join NONGUCIANstudent NGS
ON NGS.id = NGSRT.s_id
inner join Thesis T
ON T.SerialNumber = NGSRT.serialno


GO

-- 3f List nonGucians names, course code, and respective grade.

CREATE PROC AdminListNonGucianCourse
@courseID int
AS
Select NGS.firstName, NGS.lastname, C.code, NGSTC.grade
From NONGUCIANstudent NGS inner join NonGucianStudentTakeCourse NGSTC
ON NGS.id = NGSTC.s_id
inner join course C
ON C.id = NGSTC.c_id
where c.id = @courseID

GO

-- 3g Update the number of thesis extension by 1

CREATE PROC AdminUpdateExtension
@ThesisSerialNo int
AS
DECLARE @Extension int
select @Extension = T.noExtension
from Thesis T where T.SerialNumber = @ThesisSerialNo
SET @Extension = @Extension + 1
Update Thesis 
SET noExtension = @Extension
where SerialNumber = @ThesisSerialNo


GO

-- 3h Issue a thesis payment.

CREATE PROC AdminIssueThesisPayment
@ThesisSerialNo int,
@amount decimal,
@noOfInstallments int,
@fundPercentage decimal,
@Success bit output
AS
Declare @ID int
		INSERT INTO Payment (amount, no_installments, fundPercentage) VALUES (@amount, @noOfInstallments, @fundPercentage)
        
        Select @ID=max(P.id)
        from Payment P
        
        update Thesis set payment_id=@ID where SerialNumber=@ThesisSerialNo
		
        SET @Success = 1


--3i view the profile of any student that contains all his/her information.--

GO
CREATE PROC  AdminViewStudentProfile
@sid int 
AS
if(@sid  in(select id from GUCianstudent))
	
    Select PGU.email,GS.*,GSPN.phone
	from PostGradUser PGU
                inner join GUCianstudent GS on PGU.id=GS.id
                inner join GUCStudentPhoneNumber GSPN  on GS.id=GSPN.id
	where PGU.id=@sid 

else if(@sid  in(select id from NONGUCIANstudent))
    
    Select PGU.email,NGS.*,NGSPN.phone
	from PostGradUser PGU
                inner join NONGUCIANstudent NGS on PGU.id=NGS.id
                inner join nonGUCStudentPhoneNumber NGSPN  on NGS.id=NGSPN.id
	where PGU.id=@sid 

else
	print('wrong student id')

--3j Issue installments as per the number of installments for a certain payment every six months starting from the entered date. --
GO
CREATE PROC AdminIssueInstallPayment 
@paymentID int, 
@InstallStartDate date
AS
declare @i int
declare @newdate date
declare @paymentamount decimal
declare @insamount decimal

select @i= P.no_installments
from Payment p
where p.id=@paymentID

select @paymentamount= P.amount
from Payment p
where p.id=@paymentID

set @insamount=@paymentamount/@i

while (@i>0)
    begin
         set @newdate = DATEADD(month, (@i*6), @InstallStartDate)   
        INSERT into installment (amount,datee,paymentID) VALUES(@insamount,@newdate,@paymentID);
       Set @i=@i -1
       
    end
--3k List the title(s) of accepted publication(s) per thesis--
GO
CREATE PROC AdminListAcceptPublication
AS
SELECT p.title,THP.serialNo
FROM Publication P 
		inner join ThesisHasPublication THP on THP.pubid=P.id
WHERE accepted ='1' 


--3L Add courses and link courses to students.--
GO
CREATE PROC AddCourse
 
@courseCode varchar(10), 
@creditHrs int, 
@fees decimal
AS
INSERT INTO Course VALUES(@fees,@creditHrs,@courseCode);
--3l Add courses and link courses to students.--
GO
CREATE PROC linkCourseStudent
@courseID int, 
@studentID int
AS 
INSERT INTO NonGucianStudentTakeCourse(c_id,s_id) VALUES(@courseID,@studentID);
--3l Add courses and link courses to students.--
GO
CREATE PROC addStudentCourseGrade
@courseID int, 
@studentID int, 
@grade decimal
AS
UPDATE NonGucianStudentTakeCourse SET grade =@grade WHERE @courseID=c_id and @studentID=s_id;

--3m View examiners and supervisor(s) names attending a thesis defense taking place on a certain date.--
GO 
CREATE PROC ViewExamSupDefense
@defenseDate datetime
AS
select E.namee As examinername,S.namee as supervisorname
from Examiner E 
       left outer join ExaminerEvaluateDefense EED ON E.id = EED.examinerId
       left outer join GUCianStudentRegisterThesis GSRT on EED.serialNo=GSRT.serialno
       left outer join NonGUCianStudentRegisterThesis NGSRT on EED.serialNo=NGSRT.serialno
       left outer join supervisor S on (S.id=GSRT.sup_id or S.id=NGSRT.sup_id)
WHERE EED.datee=@defenseDate;

--4(a) Evaluate a student’s progress report, and give evaluation value 0 to 3.--
GO
CREATE PROC EvaluateProgressReport
@supervisorID int, 
@thesisSerialNo int, 
@progressReportNo int, 
@evaluation int 
AS
if(exists(select thesisSerialNumber,noo,supid from GUCianProgressReport where @thesisSerialNo =thesisSerialNumber and @progressReportNo=noo and @supervisorID=supid ))
    UPDATE GUCianProgressReport  set eval=@evaluation 
    where @supervisorID=GUCianProgressReport.supid 
      and @thesisSerialNo =GUCianProgressReport.thesisSerialNumber 
      and @progressReportNo=GUCianProgressReport.noo
else if(exists(select thesisSerialNumber,noo from NonGUCianProgressReport where @thesisSerialNo =thesisSerialNumber and @progressReportNo=noo and @supervisorID=supid   ))
    UPDATE NonGUCianProgressReport  set eval=@evaluation 
    where @supervisorID=NonGUCianProgressReport.supid 
      and @thesisSerialNo =NonGUCianProgressReport.thesisSerialNumber
      and @progressReportNo=NonGUCianProgressReport.noo
else
    print('progress report doesnt exist')
--4(B) View all my students’s names and years spent in the thesis.--
GO
CREATE PROC ViewSupStudentsYears
@supervisorID int
AS 

SELECT GS.firstName,GS.lastname,T.years
FROM GUCianstudent GS 
        inner JOIN GUCianStudentRegisterThesis GSRT ON GS.id=GSRT.s_id
        inner JOIN Thesis T                         ON T.SerialNumber=GSRT.serialno
WHERE GSRT.sup_id=@supervisorID

union

SELECT NGS.firstName,NGS.lastname,T.years
FROM NONGUCIANstudent NGS 
        inner JOIN NonGUCianStudentRegisterThesis NGSRT ON NGS.id=NGSRT.s_id
        inner JOIN Thesis T                         ON T.SerialNumber=NGSRT.serialno
WHERE NGSRT.sup_id=@supervisorID 

--4(C) View my profile and update my personal information.--

GO 

CREATE PROC SupViewProfile
@supervisorID int
AS
SELECT * FROM Supervisor WHERE Supervisor.id = @supervisorID
--4(C) View my profile and update my personal information.--
GO
CREATE PROC UpdateSupProfile
@supervisorID int,
@name varchar(20), 
@faculty varchar(20)
AS
UPDATE  supervisor set namee=@name ,faculty=@faculty  where supervisor.id =@supervisorID


go

--4D View all publications of a student.--
create proc ViewAStudentPublications
@StudentID int
As 
if(exists(select id from GUCianstudent where id=@StudentID))
	Select P.* 
	from ThesisHasPublication THP
            inner join Publication P on THP.pubid=P.id
            inner join GUCianStudentRegisterThesis GSRT on THP.serialNo=GSRT.serialno
	where GSRT.s_id=@StudentID

else if(exists(select id from NONGUCIANstudent where id=@StudentID))
	Select P.* 
	from ThesisHasPublication THP
            inner join Publication P on THP.pubid=P.id
            inner join NonGUCianStudentRegisterThesis NGSRT on THP.serialNo=NGSRT.serialno
	where NGSRT.s_id=@StudentID
else 
	print('wrong student id') 

go
--4E Add defense for a thesis, for nonGucian students all courses’ grades should be greater than 50 percent.--
create proc AddDefenseGucian
@ThesisSerialNo int ,
@DefenseDate Datetime , 
@DefenseLocation varchar(15)
As
if(@ThesisSerialNo in(select serialno from GUCianStudentRegisterThesis))
	INSERT INTO Defense(SerialNumber,datee,locationn) VALUES (@ThesisSerialNo,@DefenseDate,@DefenseLocation)
else
	print('wrong thesis no') 

go
--4E Add defense for a thesis, for nonGucian students all courses’ grades should be greater than 50 percent.--
create proc AddDefenseNonGucian
@ThesisSerialNo int ,
@DefenseDate Datetime , 
@DefenseLocation varchar(15)
As
if (@ThesisSerialNo in(select serialno from NonGUCianStudentRegisterThesis))  
	if(
    50<All(SELECT NGSTC.grade 
           FROM NonGucianStudentTakeCourse NGSTC
                    inner join NonGUCianStudentRegisterThesis NGSRT on NGSTC.s_id=NGSRT.s_id
	       where NGSRT.serialno=@ThesisSerialNo))
		INSERT INTO Defense(SerialNumber,datee,locationn) VALUES (@ThesisSerialNo,@DefenseDate,@DefenseLocation)
	else 
		print('student doesnt meet the requirments as he scored less than 50 in one or more courses')
else
	print('wrong thesis no')

--4f Add examiner(s) for a defense.--
go

create proc AddExaminer
@ThesisSerialNo int ,
@DefenseDate Datetime ,
@ExaminerName varchar(20),
@National bit, 
@fieldOfWork varchar(20)
As
declare @ID int
declare @ID2 int
        insert into PostGradUser values (null,null)
       
        Select @ID=max(PGU.id)
        from PostGradUser PGU
        
        INSERT INTO Examiner VALUES (@ID,@ExaminerName,@fieldOfWork,@National)
        
        Select @ID2=max(E.id)
        from Examiner E
if(exists(select SerialNumber,datee from defense where SerialNumber=@ThesisSerialNo and datee=@DefenseDate))
	BEGIN
        INSERT INTO ExaminerEvaluateDefense(datee,serialNo,ExaminerID) values (@DefenseDate,@ThesisSerialNo,@ID) 
    END
else 
	print('defense doesnt exist')

--4g Cancel a Thesis if the evaluation of the last progress report is zero.--
go

create proc CancelThesis	
@ThesisSerialNo int 
As
declare @eval int
declare @noo int
if(@ThesisSerialNo in(select serialno from GUCianStudentRegisterThesis))
	begin
        select  @noo=max(GPR.noo)
        from GucianProgressReport GPR 
        where GPR.thesisSerialNumber=@ThesisSerialNo 
        
        select  @eval=GPR.eval
        from GucianProgressReport GPR 
        where GPR.thesisSerialNumber=@ThesisSerialNo and GPR.noo=@noo

        if(@eval=0)
            delete from Thesis where SerialNumber=@ThesisSerialNo
        else
            print('last progress report eval not 0 so thesis not cancelled ')
    end
else if(@ThesisSerialNo in(select serialno from NonGUCianStudentRegisterThesis))
    begin
        select  @noo=max(NGPR.noo)
        from NonGucianProgressReport NGPR 
        where NGPR.thesisSerialNumber=@ThesisSerialNo 
        
        select  @eval=NGPR.eval
        from NonGucianProgressReport NGPR 
        where NGPR.thesisSerialNumber=@ThesisSerialNo and NGPR.noo=@noo

        if(@eval=0)
            delete from Thesis where SerialNumber=@ThesisSerialNo
        else
            print('last progress report eval not 0 so thesis not cancelled ')
    end
else
	print('wrong thesis no')


--4h Add a grade for a thesis.--
go

create proc AddGrade	
@ThesisSerialNo int,
@grade decimal(4,2)
As 
if(exists(select SerialNumber from Thesis where SerialNumber=@ThesisSerialNo))
	Update Thesis SET grade=@grade where SerialNumber=@ThesisSerialNo
else
	print('wrong thesis')


--5a Add grade for a defense.--
go
create proc AddDefenseGrade	
@ThesisSerialNo int ,
@DefenseDate Datetime ,
@grade decimal (4,2) 
As
if(exists(select SerialNumber,datee from defense where SerialNumber=@ThesisSerialNo and datee=@DefenseDate))
	Update Defense set grade=@grade where SerialNumber=@ThesisSerialNo and datee=@DefenseDate 
else
	print('defense doesnt exist')

--5b Add comments for a defense.--
go
create proc AddCommentsGrade
@ThesisSerialNo int ,
@DefenseDate Datetime ,
@comments varchar(300)
As
if(exists(select SerialNumber,datee from defense where SerialNumber=@ThesisSerialNo and datee=@DefenseDate))
	Update ExaminerEvaluateDefense set comment=@comments where serialNo=@ThesisSerialNo and datee=@DefenseDate 
else 
	print('defense doesnt exist')
--6a View my profile that contains all my information.--
go
create proc viewMyProfile
@studentId int
As
if(@studentId  in(select id from GUCianstudent))
	
    Select *
	from PostGradUser PGU
                inner join GUCianstudent GS on PGU.id=GS.id
                inner join GUCStudentPhoneNumber GSPN  on GS.id=GSPN.id
	where PGU.id=@studentId 

else if(@studentId  in(select id from NONGUCIANstudent))
    
    Select *
	from PostGradUser PGU
                inner join NONGUCIANstudent NGS on PGU.id=NGS.id
                inner join nonGUCStudentPhoneNumber NGSPN  on NGS.id=NGSPN.id
	where PGU.id=@studentId 

else
	print('wrong student id')
--6b Edit my profile--
go
create proc editMyProfile 
@studentID int, 
@firstName varchar(10), 
@lastName varchar(10), 
@password varchar(10), 
@email varchar(10), 
@address varchar(10), 
@type varchar(10) 
As
if(@studentId in(select id from GUCianstudent))
	begin
		update PostGradUser  set email=@email,passwordd=@password where id=@studentId 
		update GUCianstudent set firstname=@firstName,lastname=@lastName,typee=@type,addresss=@address where id=@studentId
	end
else if(@studentId  in(select id from NONGUCIANstudent))
	begin
		update PostGradUser  set email=@email,passwordd=@password where id=@studentId 
		update NONGUCIANstudent set firstname=@firstName,lastname=@lastName,typee=@type,addresss=@address where id=@studentId
	end
else 
	print('wrong student id')

GO
-- Question 6 (c) As a Gucian graduate, add my undergarduate ID.--
CREATE PROC addUndergradID
@studentID int,
@undergradID varchar(10)
AS
if @studentID is null or @undergradID IS NULL
    PRINT 'one  or more inputs is null'
ELSE
BEGIN
    IF @studentID in (SELECT id from GUCianstudent)
    BEGIN
        UPDATE GUCianstudent
        SET undergradID = @undergradID
        where id = @studentID
    END
    ELSE
        PRINT 'ID Does Not Exist'
END

GO
-- Question 6 (d) As a nonGucian student, view my courses’ grades--
CREATE PROC ViewCoursesGrades
@studentID int
AS
if @studentID is null
PRINT 'The Given Input Is Null'
ELSE
BEGIN
    IF @studentID in (select s_id from NonGucianStudentTakeCourse)
    BEGIN
        SELECT c_id,grade from NonGucianStudentTakeCourse
        WHERE s_id = @studentID
    END
    ELSE
        PRINT 'Student ID Does Not Exist'
END

GO
--Question 6 (e) View all my payments and installments.--

CREATE PROC ViewCoursePaymentsInstall
@studentID int
AS
if @studentID is NULL
    PRINT 'The Given Input Is Null'
ELSE
BEGIN
    IF @studentID in (select s_id from NonGucianStudentPayForCourse)
        SELECT p.*,i.*
        FROM NonGucianStudentPayForCourse n inner JOIN Payment p on n.paymentNo = p.id INNER JOIN Installment i on i.paymentID = p.id
        where n.s_id=@studentID
        ELSE
            print 'ID Does Not Exist'
END

GO
--Question 6 (e) View all my payments and installments.--
CREATE PROC ViewThesisPaymentsInstall
@studentID int
AS
if @studentID is NULL
    PRINT 'The Given Input Is Null'
ELSE
    BEGIN 
    IF @studentID in (select s_id from GUCianStudentRegisterThesis)
    BEGIN
        select i.*,p.*
        from Installment i INNER JOIN Payment p on i.paymentID = p.id INNER JOIN Thesis t on t.payment_id = p.id
            INNER JOIN GUCianStudentRegisterThesis g on g.serialno = t.SerialNumber  
        WHERE @studentID=g.s_id
    END
    ELSE
    BEGIN
        IF @studentID in (select s_id from NonGUCianStudentRegisterThesis)
        BEGIN
            select i.*,p.*
            from Installment i INNER JOIN Payment p on i.paymentID = p.id INNER JOIN Thesis t on t.payment_id = p.id
                INNER JOIN NonGUCianStudentRegisterThesis g on g.serialno = t.SerialNumber  
            WHERE @studentID=g.s_id
        END
        ELSE
        PRINT ' ID Does Not Exist'
    END
END

GO
--Question 6 (e) View all my payments and installments.--
CREATE PROC ViewUpcomingInstallments
@studentID int
AS
if @studentID is NULL
    PRINT 'The Given Input Is Null'
ELSE
BEGIN 
    IF @studentID in (select s_id from GUCianStudentRegisterThesis)
    BEGIN
        select i.datee, i.paymentID, i.amount
        from Installment i LEFT OUTER JOIN Payment p on i.paymentID = p.id LEFT OUTER JOIN Thesis t on t.payment_id = p.id
            LEFT OUTER JOIN GUCianStudentRegisterThesis g on g.serialno = t.SerialNumber  
        WHERE @studentID=g.s_id and GETDATE() < i.datee and i.done = '0' 
    END
    ELSE
    BEGIN
        IF ((@studentID in (select s_id from NonGUCianStudentRegisterThesis)) or (@studentID in  (select s_id from NonGucianStudentPayForCourse )))
        BEGIN
            select i.datee, i.paymentID, i.amount
            from Installment i LEFT OUTER JOIN Payment p on i.paymentID = p.id LEFT OUTER JOIN Thesis t on t.payment_id = p.id
                               LEFT OUTER JOIN NonGUCianStudentRegisterThesis g on g.serialno = t.SerialNumber  
            WHERE @studentID=g.s_id and GETDATE() < i.datee and i.done = '0'
        UNION
            select i.datee, i.paymentID, i.amount
            from Installment i LEFT OUTER JOIN Payment p on i.paymentID = p.id 
                               LEFT OUTER JOIN NonGucianStudentPayForCourse NGSPFC on NGSPFC.paymentNo = p.id
            WHERE @studentID=NGSPFC.s_id and GETDATE() < i.datee and i.done = '0'
        END
    END
END
GO
--Question 6 (e) View all my payments and installments.--
CREATE PROC ViewMissedInstallments
@studentID int
AS
if @studentID is NULL
    PRINT 'The Given Input Is Null'
ELSE
BEGIN 
    IF @studentID in (select s_id from GUCianStudentRegisterThesis)
    BEGIN
        select i.datee, i.paymentID, i.amount
        from Installment i LEFT OUTER JOIN Payment p on i.paymentID = p.id LEFT OUTER JOIN Thesis t on t.payment_id = p.id
            LEFT OUTER JOIN GUCianStudentRegisterThesis g on g.serialno = t.SerialNumber  
        WHERE @studentID=g.s_id and GETDATE() > i.datee and i.done = '0'
    END
    ELSE
    BEGIN
        IF ((@studentID in (select s_id from NonGUCianStudentRegisterThesis)) or (@studentID in  (select s_id from NonGucianStudentPayForCourse )))
        BEGIN
            select i.datee, i.paymentID, i.amount
            from Installment i LEFT OUTER JOIN Payment p on i.paymentID = p.id LEFT OUTER JOIN Thesis t on t.payment_id = p.id
                LEFT OUTER JOIN NonGUCianStudentRegisterThesis g on g.serialno = t.SerialNumber  
            WHERE @studentID=g.s_id and GETDATE() > i.datee and i.done = '0'
           UNION
            select i.datee, i.paymentID, i.amount
            from Installment i LEFT OUTER JOIN Payment p on i.paymentID = p.id 
                               LEFT OUTER JOIN NonGucianStudentPayForCourse NGSPFC on NGSPFC.paymentNo = p.id
            WHERE @studentID=NGSPFC.s_id and GETDATE() > i.datee and i.done = '0'
        END
        ELSE
        PRINT 'Student ID Does Not Exist'
    END
END
GO

-- Question 6 (f) Add and fill my progress report(s).--
CREATE PROC AddProgressReport
@thesisSerialNo int,
@progressReportDate date
AS

DECLARE @supid INT
DECLARE @sid INT
DECLARE @progressreportnoo INT


IF @thesisSerialNo is null or @progressReportDate is null
    PRINT 'ONE OF THE INPUTS IS NULL'
else 
BEGIN
    if @thesisSerialNo in (select serialno from GUCianStudentRegisterThesis)
    BEGIN
    
        SELECT @supid = g.sup_id FROM GUCianStudentRegisterThesis g WHERE g.serialno = @thesisSerialNo
        SELECT @sid = g.s_id FROM GUCianStudentRegisterThesis g WHERE g.serialno = @thesisSerialNo
        SELECT @progressreportnoo = g.noo FROM GUCianProgressReport g WHERE g.sidd = @sid

        set @progressreportnoo=@progressreportnoo +1
        
        INSERT into GUCianProgessReport (noo,thesisSerialNumber, datee, sidd, supid)
        VALUES(@progressreportnoo,@thesisSerialNo, @progressReportDate, @sid, @supid)
    END
    ELSE
    BEGIN
        if @thesisSerialNo in (select serialno from NonGUCianStudentRegisterThesis)
        BEGIN  
            SELECT @supid = g.sup_id FROM NonGUCianStudentRegisterThesis g WHERE g.serialno = @thesisSerialNo
            SELECT @sid = g.s_id FROM NonGUCianStudentRegisterThesis g WHERE g.serialno = @thesisSerialNo
            SELECT @progressreportnoo =g.noo FROM NonGUCianProgressReport g WHERE g.sidd = @sid
            
            set @progressreportnoo=@progressreportnoo +1

            INSERT into NonGUCianProgressReport (noo, thesisSerialNumber, datee, sidd, supid)
            VALUES(@progressreportnoo,@thesisSerialNo, @progressReportDate, @sid, @supid)
        END
        ELSE 
            PRINT ' Wrong Thesis Serial Number'
    END
END

-- Question 6 (f) Add and fill my progress report(s).--
GO
CREATE PROC FillProgressReport
@thesisSerialNo int, 
@progressReportNo int, 
@state int, 
@description varchar(200)
AS 
 if @thesisSerialNo is null or @progressReportNo is null or @state is null or @description is null
 BEGIN
    PRINT 'One of the inputs is null'
END
ELSE 
BEGIN
    if @thesisSerialNo in (select serialno from GUCianStudentRegisterThesis)
    BEGIN
        UPDATE GUCianProgessReport 
        SET statee = @state , descriptionn = @description 
        where @progressReportNo = noo and @thesisSerialNo = thesisSerialNumber
    END
    else
    BEGIN
        if @thesisSerialNo in (select serialno from NonGUCianStudentRegisterThesis)
        BEGIN
            UPDATE NonGUCianProgressReport 
            SET statee = @state , descriptionn = @description 
            where @progressReportNo = noo and @thesisSerialNo = thesisSerialNumber
        END
        ELSE
            PRINT 'Wrong Thesis Serial Number'
    END
END

-- Question 6 (g) View my progress report(s) evaluations.--

GO
CREATE PROC ViewEvalProgressReport
@thesisSerialNo int,
@progressReportNo int
AS

if EXISTS(SELECT * FROM Thesis t WHERE t.SerialNumber = @thesisSerialNo)
BEGIN
    if exists(SELECT * FROM GUCianProgressReport g WHERE g.noo = @progressReportNo and g.thesisSerialNumber = @thesisSerialNo)
    BEGIN
        SELECT p.eval 
        FROM GUCianProgressReport p INNER JOIN Thesis t on  p.thesisSerialNumber = t.SerialNumber
        where p.thesisSerialNumber = @thesisSerialNo and p.noo = @progressReportNo
    END
    ELSE
        if exists(SELECT * FROM NonGUCianProgressReport g WHERE g.noo = @progressReportNo and g.thesisSerialNumber = @thesisSerialNo )
        BEGIN
            SELECT n.eval 
            FROM NonGUCianProgressReport n INNER JOIN Thesis t on  n.thesisSerialNumber = t.SerialNumber
            where n.thesisSerialNumber = @thesisSerialNo and n.noo = @progressReportNo
        END
        ELSE
            PRINT 'Progress Report Number Does Not Exist'
    END
    ELSE
        PRINT 'Serial Number Does not Exist'


-- Question 6 (h) Add publication.--

GO
CREATE PROC addPublication
@title varchar(50),
@pubDate datetime,
@host varchar(50),
@place varchar(50), 
@accepted bit
AS
if @title IS NULL   or  @pubDate  IS NULL or  @host IS NULL or  @place IS NULL or  @accepted IS NULL
    PRINT 'One of the inputs is null'
ELSE
BEGIN
    INSERT INTO Publication (title, dateP, place, accepted, host)
    VALUES (@title,@pubDate, @place, @accepted, @host)
END



go
-- Question 6 (i) Link publication to my thesis.--
CREATE PROC linkPubThesis
@PubID int,
@thesisSerialNo int
AS
if (exists(select * from Thesis t where @thesisSerialNo = t.SerialNumber))
BEGIN
    if (exists(select * from Publication p where @PubID = p.id))
    BEGIN
        INSERT Into ThesisHasPublication 
        VALUES(@thesisSerialNo,@PubID)
    END
    ELSE
        PRINT 'Publication ID Does not Exist '
END
ELSE
        PRINT 'Thesis Serial Number Does not Exist '

go
CREATE PROC StudentRegister2
@password varchar(20),
@Gucian bit,
@email varchar(50)

AS

DECLARE @ID int

INSERT INTO PostGradUser VALUES (@email, @password)

select @ID = max(P.id)
from PostGradUser P 

IF @Gucian = 1
INSERT INTO GUCianStudent (id ) VALUES (@ID)

ELSE
INSERT INTO NonGUCianStudent (id) VALUES (@ID);

go

CREATE PROC examinerRegister 
@password varchar(20),
@email varchar(50)

AS

DECLARE @ID int

INSERT INTO PostGradUser VALUES (@email, @password)

select @ID = max(P.id)
from PostGradUser P 

INSERT INTO examiner (id ) VALUES (@ID)

go

CREATE PROC SupervisorRegister2
@password varchar(20),
@email varchar(50)

AS

Declare @ID int
INSERT into PostGradUser VALUES (@email, @password)

select @ID = max(P.id)
from PostGradUser P 

INSERT into supervisor (id) VALUES (@ID)

go
Create proc userLogin
@id int,
@password varchar(20),
@success bit output,
@type int output
as
begin
if exists(
select ID,password
from PostGradUser
where id=@id and password=@password)
begin
set @success =1
-- check user type 0-->Student,1-->Admin,2-->Supervisor ,3-->Examiner
if exists(select id from GucianStudent where id=@id union select id from
NonGucianStudent where id=@id )
set @type=0
if exists(select id from Admin where id=@id)
set @type=1
if exists(select id from Supervisor where id=@id)
set @type=2
if exists(select id from Examiner where id=@id)
set @type=3
end
else
set @success=0
end