
/*
5. Instructor Commission Calculation
Scenario: The accounting department requires a report showing
the amount due to an instructor for a specific batch based on 
their commission rate and actual collected payments.
Question: Write a Stored Procedure `sp_CalculateInstructorCommission`
accepting @BatchID that outputs:
BatchCode, Instructor Name (FullName including SecondName), CommissionRate,
TotalCollectedAmount, and InstructorDueAmount.
*/

CREATE PROCEDURE sp_CalculateInstructorCommission
    @BatchID INT
AS
BEGIN
    SET NOCOUNT ON;


    SELECT 
        CB.BatchID, 
        CB.BatchCode,
        P.FirstName + ' ' + P.SecondName + ' ' + P.LastName AS InstructorName,
        I.CommissionRate,
        ISNULL(SUM(Pay.AmountPaid), 0) AS TotalCollectedAmount, 
        (ISNULL(SUM(Pay.AmountPaid), 0) * (I.CommissionRate / 100)) AS InstructorDueAmount
    FROM 
        CourseBatches CB
    INNER JOIN 
        Instructors I ON CB.InstructorID = I.InstructorID
    INNER JOIN 
        People P ON I.InstructorID = P.PersonID
    INNER JOIN 
        Enrollments E ON CB.BatchID = E.BatchID
    LEFT JOIN 
        Payments Pay ON E.EnrollmentID = Pay.EnrollmentID
    WHERE 
        CB.BatchID = @BatchID
    GROUP BY 
        CB.BatchID, CB.BatchCode, P.FirstName, P.SecondName, P.LastName, I.CommissionRate;
END;
GO

