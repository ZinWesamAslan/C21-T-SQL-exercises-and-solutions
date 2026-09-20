/*
16. Advanced Department Performance Report
Scenario: The management requires a high-level performance overview for all departments.
Question: Write a Stored Procedure `sp_DepartmentPerformanceReport` that returns: DepartmentName, Total Active Courses, Total Batches Created (all time), Total Unique Students Enrolled (all time), and Total Revenue Generated (sum of all payments for batches belonging to this department).
*/

CREATE PROCEDURE sp_DepartmentPerformanceReport
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        D.DepartmentName,
        COUNT(DISTINCT CASE WHEN C.IsActive = 1 THEN C.CourseID END) AS TotalActiveCourses,
        COUNT(DISTINCT CB.BatchID) AS TotalBatches,
        COUNT(DISTINCT E.StudentID) AS TotalUniqueStudents,
        ISNULL(SUM(P.AmountPaid), 0) AS TotalRevenue
    FROM Departments D
    LEFT JOIN Courses C ON D.DepartmentID = C.DepartmentID
    LEFT JOIN CourseBatches CB ON C.CourseID = CB.CourseID
    LEFT JOIN Enrollments E ON CB.BatchID = E.BatchID
    LEFT JOIN Payments P ON E.EnrollmentID = P.EnrollmentID
    GROUP BY D.DepartmentName
    ORDER BY TotalRevenue DESC;
END;
GO