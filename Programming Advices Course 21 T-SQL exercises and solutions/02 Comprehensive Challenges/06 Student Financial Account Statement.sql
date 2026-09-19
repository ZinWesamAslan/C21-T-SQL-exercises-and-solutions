/*
4. Student Financial Account Statement
Scenario: In the student profile view, the system needs to display a financial summary showing total course fees, total paid amount, and remaining balance.
Question: Write a database object named `fn_GetStudentFinancialStatus` that takes @StudentID and returns a table containing TotalFees, TotalPaid, and RemainingBalance.
*/

CREATE FUNCTION fn_GetStudentFinancialStatus (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        @StudentID AS StudentID,
        ISNULL(Fees.TotalFees, 0) AS TotalFees,
        ISNULL(Paid.TotalPaid, 0) AS TotalPaid,
        ISNULL(Fees.TotalFees, 0) - ISNULL(Paid.TotalPaid, 0) AS RemainingBalance
    FROM 
    -- 1. حساب إجمالي رسوم الكورسات التي سجل فيها الطالب
    (
        SELECT SUM(C.Price) AS TotalFees
        FROM Enrollments E
        INNER JOIN CourseBatches CB ON E.BatchID = CB.BatchID
        INNER JOIN Courses C ON CB.CourseID = C.CourseID
        WHERE E.StudentID = @StudentID
    ) AS Fees
    CROSS JOIN
    -- 2. حساب إجمالي المبالغ المدفوعة بشكل مستقل تماماً
    (
        SELECT SUM(P.AmountPaid) AS TotalPaid
        FROM Payments P
        INNER JOIN Enrollments E ON P.EnrollmentID = E.EnrollmentID
        WHERE E.StudentID = @StudentID
    ) AS Paid
);
GO