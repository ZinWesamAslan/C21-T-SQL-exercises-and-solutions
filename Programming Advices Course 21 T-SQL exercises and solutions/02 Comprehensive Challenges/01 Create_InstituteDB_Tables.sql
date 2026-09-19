
-- 1. إنشاء قاعدة البيانات واستخدامها
CREATE DATABASE InstituteDB;
GO

USE InstituteDB;
GO 

-- 2. جدول الأشخاص الرئيسي (People Supertype)
CREATE TABLE People (
    PersonID INT IDENTITY(1,1) CONSTRAINT PK_People PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
	SecondName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL CONSTRAINT UQ_People_Email UNIQUE,
    Phone NVARCHAR(20) NOT NULL CONSTRAINT UQ_People_Phone UNIQUE,
    Gender CHAR(1) NOT NULL CONSTRAINT CHK_People_Gender CHECK (Gender IN ('M', 'F')),
    DateOfBirth DATE NOT NULL,
    Address NVARCHAR(200) NULL,
    CreatedDate DATETIME NOT NULL CONSTRAINT DF_People_CreatedDate DEFAULT GETDATE()
);
GO

-- 3. جدول الأدوار (Roles)
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) CONSTRAINT PK_Roles PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL CONSTRAINT UQ_Roles_RoleName UNIQUE,
    Description NVARCHAR(250) NULL
);
GO

-- 4. جدول الصلاحيات (Permissions)
CREATE TABLE Permissions (
    PermissionID INT IDENTITY(1,1) CONSTRAINT PK_Permissions PRIMARY KEY,
    PermissionName NVARCHAR(100) NOT NULL CONSTRAINT UQ_Permissions_Name UNIQUE, -- e.g. 'MANAGE_USERS', 'ADD_PAYMENT'
    Description NVARCHAR(250) NULL
);
GO

-- 5. الجدول الوسيط بين الأدوار والصلاحيات (RolePermissions)
CREATE TABLE RolePermissions (
    RoleID INT NOT NULL,
    PermissionID INT NOT NULL,
    CONSTRAINT PK_RolePermissions PRIMARY KEY (RoleID, PermissionID),
    CONSTRAINT FK_RolePermissions_Roles FOREIGN KEY (RoleID) 
        REFERENCES Roles(RoleID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_RolePermissions_Permissions FOREIGN KEY (PermissionID) 
        REFERENCES Permissions(PermissionID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 6. جدول مستخدمي النظام والتطبيق (Users & Authentication)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    PersonID INT NULL, -- رابط اختياري مع جدول الأشخاص
    RoleID INT NOT NULL, -- رابط مع جدول الأدوار بدلاً من النصوص
    Username NVARCHAR(50) NOT NULL CONSTRAINT UQ_Users_Username UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    PasswordSalt NVARCHAR(128) NOT NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT 1,
    CreatedDate DATETIME NOT NULL CONSTRAINT DF_Users_CreatedDate DEFAULT GETDATE(),
    CONSTRAINT FK_Users_People FOREIGN KEY (PersonID) 
        REFERENCES People(PersonID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) 
        REFERENCES Roles(RoleID) ON DELETE NO ACTION ON UPDATE CASCADE
);
GO

-- 7. جدول الطلاب (Students Subtype)
CREATE TABLE Students (
    StudentID INT CONSTRAINT PK_Students PRIMARY KEY, -- PersonID & StudentID identical
    RegistrationDate DATE NOT NULL CONSTRAINT DF_Students_RegistrationDate DEFAULT GETDATE(),
    IsActive BIT NOT NULL CONSTRAINT DF_Students_IsActive DEFAULT 1,
    CreatedByUserID INT NULL,
    UpdatedByUserID INT NULL,
    UpdatedDate DATETIME NULL,
    CONSTRAINT FK_Students_People FOREIGN KEY (StudentID) 
        REFERENCES People(PersonID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Students_Users_Created FOREIGN KEY (CreatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Students_Users_Updated FOREIGN KEY (UpdatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 8. جدول المدرسين (Instructors Subtype)
CREATE TABLE Instructors (
    InstructorID INT CONSTRAINT PK_Instructors PRIMARY KEY, -- PersonID & InstructorID identical
    HireDate DATE NOT NULL CONSTRAINT DF_Instructors_HireDate DEFAULT GETDATE(),
    CommissionRate DECIMAL(5, 2) NOT NULL CONSTRAINT DF_Instructors_Commission DEFAULT 50.00 
        CONSTRAINT CHK_Instructors_Commission CHECK (CommissionRate BETWEEN 0 AND 100),
	IsActive BIT NOT NULL CONSTRAINT DF_Instructors_IsActive DEFAULT 1,
    CreatedByUserID INT NULL,
    UpdatedByUserID INT NULL,
    UpdatedDate DATETIME NULL,
    CONSTRAINT FK_Instructors_People FOREIGN KEY (InstructorID) 
        REFERENCES People(PersonID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Instructors_Users_Created FOREIGN KEY (CreatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Instructors_Users_Updated FOREIGN KEY (UpdatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 9. جدول الفروع / التخصصات (Departments)
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) CONSTRAINT PK_Departments PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL CONSTRAINT UQ_Departments_Name UNIQUE,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_Departments_IsActive DEFAULT 1
);
GO

-- 10. جدول الدورات التدريبية (Courses)
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) CONSTRAINT PK_Courses PRIMARY KEY,
    DepartmentID INT NOT NULL,
    CourseCode NVARCHAR(20) NOT NULL CONSTRAINT UQ_Courses_Code UNIQUE,
    CourseTitle NVARCHAR(150) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    DurationHours INT NOT NULL CONSTRAINT CHK_Courses_Duration CHECK (DurationHours > 0),
    Price DECIMAL(10, 2) NOT NULL CONSTRAINT CHK_Courses_Price CHECK (Price >= 0),
    IsActive BIT NOT NULL CONSTRAINT DF_Courses_IsActive DEFAULT 1,
    CONSTRAINT FK_Courses_Departments FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID) ON DELETE NO ACTION ON UPDATE CASCADE
);
GO

-- 11. جدول القاعات / الغرف الدراسية (Classrooms)
CREATE TABLE Classrooms (
    ClassroomID INT IDENTITY(1,1) CONSTRAINT PK_Classrooms PRIMARY KEY,
    RoomName NVARCHAR(50) NOT NULL CONSTRAINT UQ_Classrooms_RoomName UNIQUE,
    Capacity INT NOT NULL CONSTRAINT CHK_Classrooms_Capacity CHECK (Capacity > 0),
    Building NVARCHAR(50) NULL
);
GO

-- 12. جدول الشعب الدراسية المفتوحة (CourseBatches)
CREATE TABLE CourseBatches (
    BatchID INT IDENTITY(1,1) CONSTRAINT PK_CourseBatches PRIMARY KEY,
    CourseID INT NOT NULL,
    InstructorID INT NOT NULL,
    ClassroomID INT NULL,
    BatchCode NVARCHAR(30) NOT NULL CONSTRAINT UQ_CourseBatches_BatchCode UNIQUE,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    MaxStudents INT NOT NULL CONSTRAINT CHK_CourseBatches_MaxStudents CHECK (MaxStudents > 0),
    Status NVARCHAR(20) NOT NULL CONSTRAINT DF_CourseBatches_Status DEFAULT 'Upcoming' 
        CONSTRAINT CHK_CourseBatches_Status CHECK (Status IN ('Upcoming', 'Ongoing', 'Completed', 'Cancelled')),
    CreatedByUserID INT NULL,
    UpdatedByUserID INT NULL,
    UpdatedDate DATETIME NULL,
    CONSTRAINT CHK_CourseBatches_Dates CHECK (EndDate >= StartDate),
    CONSTRAINT FK_CourseBatches_Courses FOREIGN KEY (CourseID) 
        REFERENCES Courses(CourseID) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_CourseBatches_Instructors FOREIGN KEY (InstructorID) 
        REFERENCES Instructors(InstructorID) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_CourseBatches_Classrooms FOREIGN KEY (ClassroomID) 
        REFERENCES Classrooms(ClassroomID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_CourseBatches_Users_Created FOREIGN KEY (CreatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_CourseBatches_Users_Updated FOREIGN KEY (UpdatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 13. جدول تسجيل الطلاب في الشعب (Enrollments)
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) CONSTRAINT PK_Enrollments PRIMARY KEY,
    StudentID INT NOT NULL,
    BatchID INT NOT NULL,
    EnrollmentDate DATE NOT NULL CONSTRAINT DF_Enrollments_Date DEFAULT GETDATE(),
    FinalGrade DECIMAL(5, 2) NULL CONSTRAINT CHK_Enrollments_FinalGrade CHECK (FinalGrade BETWEEN 0 AND 100),
    Status NVARCHAR(20) NOT NULL CONSTRAINT DF_Enrollments_Status DEFAULT 'Enrolled' 
        CONSTRAINT CHK_Enrollments_Status CHECK (Status IN ('Enrolled', 'Completed', 'Dropped', 'Failed')),
    CreatedByUserID INT NULL,
    UpdatedByUserID INT NULL,
    UpdatedDate DATETIME NULL,
    CONSTRAINT UQ_Student_Batch UNIQUE (StudentID, BatchID),
    CONSTRAINT FK_Enrollments_Students FOREIGN KEY (StudentID) 
        REFERENCES Students(StudentID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Enrollments_CourseBatches FOREIGN KEY (BatchID) 
        REFERENCES CourseBatches(BatchID) ON DELETE NO ACTION ON UPDATE NO ACTION, -- تم التعديل هنا
    CONSTRAINT FK_Enrollments_Users_Created FOREIGN KEY (CreatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Enrollments_Users_Updated FOREIGN KEY (UpdatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 14. جدول المدفوعات والرسوم (Payments)
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) CONSTRAINT PK_Payments PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    AmountPaid DECIMAL(10, 2) NOT NULL CONSTRAINT CHK_Payments_Amount CHECK (AmountPaid > 0),
    PaymentDate DATETIME NOT NULL CONSTRAINT DF_Payments_Date DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(30) NOT NULL CONSTRAINT CHK_Payments_Method CHECK (PaymentMethod IN ('Cash', 'Credit Card', 'Bank Transfer')),
    Notes NVARCHAR(250) NULL,
    CreatedByUserID INT NOT NULL,
    UpdatedByUserID INT NULL,
    UpdatedDate DATETIME NULL,
    CONSTRAINT FK_Payments_Enrollments FOREIGN KEY (EnrollmentID) 
        REFERENCES Enrollments(EnrollmentID) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_Payments_Users_Created FOREIGN KEY (CreatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Payments_Users_Updated FOREIGN KEY (UpdatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 15. جدول الحضور والغياب (Attendance)
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) CONSTRAINT PK_Attendance PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    SessionDate DATE NOT NULL,
    Status NVARCHAR(10) NOT NULL CONSTRAINT CHK_Attendance_Status CHECK (Status IN ('Present', 'Absent', 'Late', 'Excused')),
    Remarks NVARCHAR(200) NULL,
    CreatedByUserID INT NULL,
    UpdatedByUserID INT NULL,
    UpdatedDate DATETIME NULL,
    CONSTRAINT UQ_Enrollment_SessionDate UNIQUE (EnrollmentID, SessionDate),
    CONSTRAINT FK_Attendance_Enrollments FOREIGN KEY (EnrollmentID) 
        REFERENCES Enrollments(EnrollmentID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Attendance_Users_Created FOREIGN KEY (CreatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Attendance_Users_Updated FOREIGN KEY (UpdatedByUserID) 
        REFERENCES Users(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 16. جدول أوقات المحاضرات الأسبوعية للشعب (BatchSchedules)
CREATE TABLE BatchSchedules (
    ScheduleID INT IDENTITY(1,1) CONSTRAINT PK_BatchSchedules PRIMARY KEY,
    BatchID INT NOT NULL,
    DayOfWeek TINYINT NOT NULL CONSTRAINT CHK_BatchSchedules_Day CHECK (DayOfWeek BETWEEN 1 AND 7), -- 1: Sun, 2: Mon ... 7: Sat
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    CONSTRAINT CHK_BatchSchedules_Time CHECK (EndTime > StartTime),
    CONSTRAINT FK_BatchSchedules_CourseBatches FOREIGN KEY (BatchID) 
        REFERENCES CourseBatches(BatchID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO