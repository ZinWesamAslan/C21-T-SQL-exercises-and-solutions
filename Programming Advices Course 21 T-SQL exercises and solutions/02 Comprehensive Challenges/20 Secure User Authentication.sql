/*
18. Secure User Authentication
Scenario: The backend needs to authenticate users trying to log into the application. Passwords in the DB are hashed (PasswordHash) using SHA2_256 and salted (PasswordSalt).
Question: Write a Stored Procedure `sp_AuthenticateUser` that accepts @Username and @PlainPassword. Implement the hashing logic to verify the password. Validate that the user exists and IsActive = 1. If successful, return UserID, RoleName, and associated Person FullName (with SecondName). If unsuccessful, throw an appropriate error.
*/

CREATE PROCEDURE sp_AuthenticateUser
    @Username NVARCHAR(50),
    @PlainPassword NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserID INT;
    DECLARE @IsActive BIT;
    DECLARE @StoredHash NVARCHAR(256);
    DECLARE @StoredSalt NVARCHAR(128);
    DECLARE @ComputedHash NVARCHAR(256);

    -- Get user credentials
    SELECT 
        @UserID = UserID, 
        @IsActive = IsActive, 
        @StoredHash = PasswordHash, 
        @StoredSalt = PasswordSalt
    FROM Users 
    WHERE Username = @Username;

    -- Validation: User Exists
    IF (@UserID IS NULL)
        THROW 50040, 'Invalid username or password.', 1;

    -- Validation: User is Active
    IF (@IsActive = 0)
        THROW 50041, 'This account is deactivated. Please contact administration.', 1;

    -- Verify Password (Simulating SHA2_256 hash using HASHBYTES)
    -- Note: CONVERT is used to change varbinary to string for comparison
    SET @ComputedHash = LOWER(CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', @PlainPassword + @StoredSalt), 2));

    IF (@ComputedHash <> LOWER(@StoredHash))
        THROW 50042, 'Invalid username or password.', 1;

    -- Authentication Successful, Return Details
    SELECT 
        U.UserID,
        U.Username,
        R.RoleName,
        P.FirstName + ' ' + P.SecondName + ' ' + P.LastName AS FullName
    FROM Users U
    INNER JOIN Roles R ON U.RoleID = R.RoleID
    LEFT JOIN People P ON U.PersonID = P.PersonID
    WHERE U.UserID = @UserID;
END;
GO