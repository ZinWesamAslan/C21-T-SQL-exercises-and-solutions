/*
11. Soft Delete & Hard Delete Strategy 
Scenario: System administrators sometimes delete student records.
However, if a student has any active enrollment (Status = 'Enrolled'),
their record MUST NOT be deleted from the database. Instead, 
their account should be deactivated (IsActive = 0). If the student has no active enrollments, 
the deletion should proceed normally.

Question: Write a database object on the `Students` table that intercepts any DELETE operation.
Implement the logic to soft-delete students with active enrollments and hard-delete the rest,
handling multiple rows simultaneously.
*/

-- هذا التريغر لن يتم انشاؤه ولكن ينبغي الاطلاع عليه
-- وذلك بسبب عدم قدرتنا على حذف سطر من جدول الطلاب بسبب القيود و المفاتيح

CREATE TRIGGER trg_PreventActiveStudentDelete
ON Students
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Soft Delete: Update IsActive = 0 for students who have active enrollments
    UPDATE S
    SET S.IsActive = 0
    FROM Students S
    INNER JOIN deleted d ON S.StudentID = d.StudentID
    WHERE EXISTS (
        SELECT 1 
        FROM Enrollments E 
        WHERE E.StudentID = S.StudentID AND E.Status = 'Enrolled'
    );


	
    -- 2. Hard Delete: Actually delete students who DO NOT have any active enrollments
    DELETE S
    FROM Students S
    INNER JOIN deleted d ON S.StudentID = d.StudentID
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Enrollments E 
        WHERE E.StudentID = S.StudentID AND E.Status = 'Enrolled'
    );
END;
GO