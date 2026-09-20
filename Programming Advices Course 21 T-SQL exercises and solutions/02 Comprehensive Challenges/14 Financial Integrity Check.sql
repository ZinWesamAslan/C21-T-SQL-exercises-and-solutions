/*
12. Financial Integrity Check 
Scenario: Receptionists add payments for students. 
A critical business rule states that a student's total payments 
for a specific enrollment cannot exceed the actual price of the course. 

Question: Write a database object on the `Payments` table that runs automatically
when new payments are added. It must calculate the new total paid amount for the enrollment.
If the total exceeds the course price, 
the operation must be rejected entirely with a clear error message.
*/

CREATE TRIGGER trg_PreventOverpayment
ON Payments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT i.EnrollmentID
        FROM inserted i
        INNER JOIN Payments P ON i.EnrollmentID = P.EnrollmentID
        INNER JOIN Enrollments E ON i.EnrollmentID = E.EnrollmentID
        INNER JOIN CourseBatches CB ON E.BatchID = CB.BatchID
        INNER JOIN Courses C ON CB.CourseID = C.CourseID
        GROUP BY i.EnrollmentID, C.Price
        HAVING SUM(P.AmountPaid) > C.Price
    )
    BEGIN
        RAISERROR ('Payment rejected: The total paid amount cannot exceed the course price.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO