use finalsubmission

--1a--

--select * from PostGradUser
--select * from GUCianstudent
EXEC StudentRegister 'Ahmed' , 'Hossam' , 'Hossam7856' , ' Engineering' , 1, 'AhmedHossam@gmail.com', 'Street 273 building 7'
--select * from PostGradUser
--select * from GUCianstudent

--select * from supervisor
EXEC SupervisorRegister 'Mohammed', 'fathy', 'Fathy321', 'engineering', 'mohammed.fathy@gmail.com'
--select * from PostGradUser
--select * from supervisor

--2a--
DECLARE @success bit
EXEC userLogin 1, 'qwer0123', @success OUTPUT
PRINT @success

--2b--

--select * from nonGUCStudentPhoneNumber where id=9
EXEC addMobile 9, '0101234568'
--select * from nonGUCStudentPhoneNumber where id=9

--3a--
EXEC AdminListSup

--3b--
EXEC AdminViewSupervisorProfile 12

--3c--
EXEC AdminViewAllTheses

--3d--
EXEC AdminViewOnGoingThesis

--3e--
EXEC AdminViewStudentThesisBySupervisor

--3f--
exec AdminListNonGucianCourse 5

--3g--
EXEC AdminUpdateExtension 6

--3h--

--select * from Payment
--select * from thesis
DECLARE @successbit int
EXEC AdminIssueThesisPayment 30,120000,1,5,@successbit OUTPUT
Print @successbit
--select * from Payment
--select * from thesis

--3i--
exec AdminViewStudentProfile 8

--3j--

--select * from Payment
--select * from Installment I where i.paymentID=29
exec AdminIssueInstallPayment 29,'2022/1/1'
--select * from Installment I where i.paymentID=29

--3k--
exec AdminListAcceptPublication

--3l--

--select * from course
exec AddCourse 'cs2',4,10000
--select * from course

--select * from NonGucianStudentTakeCourse
exec addStudentCourseGrade  1,8,90
--select * from NonGucianStudentTakeCourse

--3m--
exec ViewExamSupDefense '2020/6/8'

--4a--

--select * from GUCianProgressReport
exec EvaluateProgressReport 11,17,2,0
--select * from GUCianProgressReport

--4b--
exec ViewSupStudentsYears 11

--4c--
exec SupViewProfile 11

exec UpdateSupProfile 11,'slim nader','pharmacy'
--exec SupViewProfile 11

--4d--
exec ViewAStudentPublications 7
exec ViewAStudentPublications 8

--4e--
exec AddDefenseGucian 1 , '2021/1/1' , 'hall 3'

--select * from NonGucianStudentTakeCourse where s_id=9
--select * from NonGUCianStudentRegisterThesis where s_id=9
exec AddDefenseNonGucian 5,'2021/1/2' , 'hall 3'
exec AddDefenseNonGucian 6,'2021/1/2' , 'hall 3'

--4f--

exec AddExaminer 1,'2021/1/1' , 'Charles' ,0, 'engineerng'
exec AddExaminer 5,'2021/1/2' , 'Charles' ,0, 'engineerng'
exec AddExaminer 6,'2021/1/2' , 'slim' ,0, 'engineerng'

--4g--

--select * from Thesis
exec CancelThesis 1
exec CancelThesis 2
--select * from Thesis

--4h--

--select grade from Thesis where SerialNumber=2
exec AddGrade 2,90
--select grade from Thesis where SerialNumber=2

--5a--

--select grade from Defense where datee='2021/1/2' and SerialNumber=6
exec AddDefenseGrade 6,'2021/1/2',90.43
--select grade from Defense where datee='2021/1/2' and SerialNumber=6

--5b--

--select comment from Defense where datee='2021/1/2' and SerialNumber=6
exec AddCommentsGrade 6,'2021/1/2','nice work'
--select comment from Defense where datee='2021/1/2' and SerialNumber=6

--6a--

exec viewMyProfile 7
exec viewMyProfile 8

--6b--

exec editMyProfile 7,'david','samy','anypass','testmail','manial','phd'
--exec viewMyProfile 7

--6c--

exec addUndergradID 7,'15918'
--exec viewMyProfile 7

--6d--
exec ViewCoursesGrades 9
exec ViewCoursesGrades 8

--6e--
exec ViewCoursePaymentsInstall 8

exec ViewThesisPaymentsInstall 8
exec ViewThesisPaymentsInstall 5

exec ViewUpcomingInstallments 8
exec ViewUpcomingInstallments 5

exec ViewMissedInstallments 8 --one missed installement of course and one missed installement of a thesis--


--6f--

--select * from NonGUCianProgressReport
exec AddProgressReport 6, '2020/6/30'
--select * from NonGUCianProgressReport

exec FillProgressReport 6,2,3,'test'
--select * from NonGUCianProgressReport

--6g--

exec ViewEvalProgressReport 6,1

--6h--

exec addPublication 'test','2021/12/1','ieee','guc',1
--select * from Publication

--6i--

--select * from ThesisHasPublication
exec linkPubThesis 12,6
--select * from ThesisHasPublication

