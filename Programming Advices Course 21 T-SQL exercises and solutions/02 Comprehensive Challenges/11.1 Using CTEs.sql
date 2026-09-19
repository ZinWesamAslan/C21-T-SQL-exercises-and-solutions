

CREATE VIEW vw_StudentAttendanceAlerts2
AS
WITH AttendanceTotals AS (
    -- 1. تجميع البيانات وحساب الأعداد فقط
    SELECT 
        E.StudentID,
        P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS StudentName,
        CB.BatchCode,
        COUNT(A.AttendanceID) AS TotalSessions,
        SUM(CASE WHEN A.Status = 'Absent' THEN 1 ELSE 0 END) AS TotalAbsences
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
),
AttendanceCalculations AS (
    -- 2. حساب النسبة المئوية بناءً على الأعداد السابقة
    SELECT 
        StudentID,
        StudentName,
        BatchCode,
        TotalSessions,
        TotalAbsences,
        CAST((TotalAbsences * 100.0) / NULLIF(TotalSessions, 0) AS DECIMAL(5,2)) AS AbsencePercentage
    FROM 
        AttendanceTotals
)
-- 3. الاستعلام النهائي الصريح والأنظف
SELECT 
    StudentID,
    StudentName,
    BatchCode,
    TotalSessions,
    TotalAbsences,
    AbsencePercentage
FROM 
    AttendanceCalculations
WHERE 
    AbsencePercentage >= 20.00;
GO