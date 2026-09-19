/*
9. High Risk Student Absence Report
Scenario: The system needs to automatically
flag students who have missed a critical percentage of their classes.

Question: Create a View `vw_StudentAttendanceAlerts` 
calculating TotalSessions, TotalAbsences, and AbsencePercentage per student per batch.
Include StudentName (FullName with SecondName).
Filter to show only students with an absence rate >= 20%.
*/

CREATE VIEW vw_StudentAttendanceAlerts
AS
SELECT 
    E.StudentID,
    P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS StudentName,
    CB.BatchCode,
    COUNT(A.AttendanceID) AS TotalSessions,
    SUM(CASE WHEN A.Status = 'Absent' THEN 1 ELSE 0 END) AS TotalAbsences,
    CAST(SUM(CASE WHEN A.Status = 'Absent' THEN 1 ELSE 0 END) AS DECIMAL(5,2)) / COUNT(A.AttendanceID) * 100 AS AbsencePercentage
FROM 
    Enrollments E
INNER JOIN 
    CourseBatches CB ON E.BatchID = CB.BatchID
INNER JOIN 
    People P ON E.StudentID = P.PersonID
INNER JOIN 
    Attendance A ON E.EnrollmentID = A.EnrollmentID
GROUP BY 
    E.StudentID, P.FirstName, P.SecondName, P.LastName, CB.BatchCode
HAVING 
    (CAST(SUM(CASE WHEN A.Status = 'Absent' THEN 1 ELSE 0 END) AS DECIMAL(5,2)) / COUNT(A.AttendanceID) * 100) >= 20.00;
GO