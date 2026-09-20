/*
19. Instructor Handover / Reassignment
Scenario: An instructor leaves the institute, and all their active classes 
must be immediately transferred to a new instructor.

Question: Write a Stored Procedure `sp_ReassignInstructorBatches`
taking @OldInstructorID and @NewInstructorID.
Requirements:
1. Validate that both IDs exist in the Instructors table.
2. Validate that the New Instructor IsActive = 1.
3. Update the InstructorID in CourseBatches ONLY for batches that are 'Upcoming' or 'Ongoing'.
4. Return the number of reassigned batches.
*/

CREATE PROCEDURE sp_ReassignInstructorBatches
    @OldInstructorID INT,
    @NewInstructorID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @OldExists BIT;
        DECLARE @NewActive BIT;

        -- Validate Old Instructor
        SELECT @OldExists = 1 FROM Instructors WHERE InstructorID = @OldInstructorID;
        IF (@OldExists IS NULL)
            THROW 50050, 'The original instructor does not exist.', 1;

        -- Validate New Instructor
        SELECT @NewActive = IsActive FROM Instructors WHERE InstructorID = @NewInstructorID;
        IF (@NewActive IS NULL)
            THROW 50051, 'The new instructor does not exist.', 1;
        IF (@NewActive = 0)
            THROW 50052, 'Cannot assign batches to an inactive instructor.', 1;

        -- Update Assignment
        UPDATE CourseBatches
        SET InstructorID = @NewInstructorID,
            UpdatedDate = GETDATE()
        WHERE InstructorID = @OldInstructorID 
          AND Status IN ('Upcoming', 'Ongoing');

        SELECT @@ROWCOUNT AS ReassignedBatchesCount;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO