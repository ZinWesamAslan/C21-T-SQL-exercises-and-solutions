-- 1. CONCAT & CONCAT_WS
-- Function: Merges two or more strings. CONCAT_WS merges with a separator and ignores NULL values.
SELECT TOP 5 
    Make,
    ModelName,
    CONCAT(Make, ' ', ModelName) AS FullModel_Concat,
    CONCAT_WS(' - ', Make, ModelName, 'Edition') AS FullModel_ConcatWS
FROM Makes m
JOIN MakeModels mm ON m.MakeID = mm.MakeID;

-- 2. UPPER & LOWER
-- Function: Converts text case to uppercase (UPPER) or lowercase (LOWER). Very useful in standardizing data before comparison.
SELECT TOP 5 
    Make,
    UPPER(Make) AS Make_UpperCase,
    LOWER(Make) AS Make_LowerCase
FROM Makes;

-- 3. LEN
-- Function: Returns the length of the string (number of characters), ignoring trailing spaces.
SELECT TOP 5 
    Vehicle_Display_Name,
    LEN(Vehicle_Display_Name) AS NameLength
FROM VehicleDetails
ORDER BY NameLength DESC; -- To find the longest vehicle names

-- 4. LEFT & RIGHT
-- Function: Extracts a specific number of characters from the left or right of a string.
SELECT TOP 5 
    Vehicle_Display_Name,
    LEFT(Vehicle_Display_Name, 5) AS First5Chars,
    RIGHT(Vehicle_Display_Name, 4) AS Last4Chars -- Useful for extracting the year if it is always in the last 4 characters
FROM VehicleDetails;

-- 5. SUBSTRING
-- Function: Extracts a substring based on a starting point and the required length.
SELECT TOP 5 
    Vehicle_Display_Name,
    SUBSTRING(Vehicle_Display_Name, 1, 10) AS First10Chars -- Starts from the first character and takes 10 characters
FROM VehicleDetails;

-- 6. REPLACE
-- Function: Searches for a specific text within a string and replaces it with another. (Commonly used in data cleaning).
SELECT TOP 5 
    Vehicle_Display_Name,
    REPLACE(Vehicle_Display_Name, 'Base', 'Standard Edition') AS ReplacedName
FROM VehicleDetails
WHERE Vehicle_Display_Name LIKE '%Base%';

-- 7. TRIM, LTRIM, RTRIM
-- Function: Removes spaces from a string. LTRIM from the left, RTRIM from the right, TRIM from both sides.
-- Here we artificially create spaces and then remove them for illustration.
SELECT 
    '   Test Data   ' AS OriginalData,
    LTRIM('   Test Data   ') AS LeftTrimmed,
    RTRIM('   Test Data   ') AS RightTrimmed,
    TRIM('   Test Data   ') AS FullyTrimmed;

-- 8. CHARINDEX
-- Function: Searches for the index of a specific character or word within a string. Returns an integer.
SELECT TOP 5 
    Vehicle_Display_Name,
    CHARINDEX(' ', Vehicle_Display_Name) AS FirstSpacePosition -- To find out where the first word ends
FROM VehicleDetails;

-- 9. PATINDEX (Pattern Index)
-- Function: Similar to CHARINDEX but supports wildcards like % to search for a specific pattern (e.g., the first number appearing in the text).
SELECT TOP 5 
    Vehicle_Display_Name,
    PATINDEX('%[0-9]%', Vehicle_Display_Name) AS FirstNumberPosition -- Locates the first number in the vehicle's name
FROM VehicleDetails
WHERE PATINDEX('%[0-9]%', Vehicle_Display_Name) > 0;

-- 10. STUFF
-- Function: Deletes a part of a string based on a specific length and position, then "stuffs" new text in its place.
SELECT TOP 5 
    Vehicle_Display_Name,
    -- Start from the second character, delete 3 characters, and insert '***' in their place
    STUFF(Vehicle_Display_Name, 2, 3, '***') AS StuffedName 
FROM VehicleDetails;

-- 11. REPLICATE
-- Function: Repeats a string a specified number of times. (Useful for creating simple text charts or padding).
SELECT TOP 5 
    Vehicle_Display_Name,
    NumDoors,
    REPLICATE('|', NumDoors) AS DoorCountVisualBar -- A bar chart representing the number of doors
FROM VehicleDetails;

-- 12. REVERSE
-- Function: Reverses the order of characters in a string.
SELECT TOP 5 
    Make,
    REVERSE(Make) AS ReversedMake
FROM Makes;

-- 13. SOUNDEX & DIFFERENCE (Less common functions)
-- Function: SOUNDEX converts text to a phonetic code (how it sounds), DIFFERENCE compares two phonetic codes and returns a value from 0 to 4 (4 means exact phonetic match).
-- Useful for searching misspelled data that sounds the same.
SELECT 
    SOUNDEX('Honda') AS HondaSound,
    SOUNDEX('Hunda') AS HundaSound,
    DIFFERENCE('Honda', 'Hunda') AS SimilarityScore; -- Will return 4 because the pronunciation is very similar

-- 1. GETDATE() & SYSDATETIME()
-- Function: Returns the current system date and time. SYSDATETIME provides higher precision in fractional seconds.
SELECT 
    GETDATE() AS CurrentDateTime,
    SYSDATETIME() AS CurrentSysDateTime;

-- 2. YEAR(), MONTH(), DAY()
-- Function: Extracts the year, month, or day as integers from a specific date.
SELECT 
    GETDATE() AS Today,
    YEAR(GETDATE()) AS CurrentYear,
    MONTH(GETDATE()) AS CurrentMonth,
    DAY(GETDATE()) AS CurrentDay;

-- 3. DATETIMEFROMPARTS (Practical use on your database)
-- Function: Builds a real date from separate numbers (year, month, day). 
-- Since your database only has a Year field, we will convert it to a real date (e.g., January 1st of that year).
SELECT TOP 5 
    Vehicle_Display_Name,
    Year AS ProductionYearInt,
    DATETIMEFROMPARTS(Year, 1, 1, 0, 0, 0,0) AS SimulatedProductionDate
FROM VehicleDetails;

-- 4. DATEDIFF
-- Function: Calculates the difference between two dates based on a specific unit (years, months, days).
-- Here we calculate the car's age in years based on the current year compared to the production year.
SELECT TOP 5 
    Vehicle_Display_Name,
    Year AS ProductionYear,
    YEAR(GETDATE()) AS CurrentYear,
    -- Calculates the difference in years between the simulated production date and today's date
    DATEDIFF(YEAR, DATETIMEFROMPARTS(Year, 1, 1, 0, 0, 0, 0), GETDATE()) AS VehicleAgeInYears
FROM VehicleDetails;

-- 5. DATEADD
-- Function: Adds (or subtracts) a specific time interval to an existing date.
-- Scenario: Suppose the car warranty is 5 years from the production date, and we want to find out the warranty expiration date.
SELECT TOP 5 
    Vehicle_Display_Name,
    DATETIMEFROMPARTS(Year, 1, 1, 0, 0, 0, 0) AS ProductionDate,
    DATEADD(YEAR, 5, DATETIMEFROMPARTS(Year, 1, 1, 0, 0, 0, 0)) AS WarrantyExpiryDate
FROM VehicleDetails;

-- 6. DATENAME & DATEPART
-- Function: Extracts a specific part of a date. DATENAME returns it as a string (e.g., 'January'), while DATEPART returns it as a number.
SELECT 
    GETDATE() AS Today,
    DATENAME(MONTH, GETDATE()) AS MonthNameStr,   -- Example: 'September'
    DATEPART(MONTH, GETDATE()) AS MonthNumberInt, -- Example: 9
    DATENAME(WEEKDAY, GETDATE()) AS DayOfWeekStr, -- Example: 'Friday'
    DATEPART(QUARTER, GETDATE()) AS QuarterOfYear;-- Current quarter of the year (1, 2, 3, 4)

-- 7. EOMONTH (End Of Month)
-- Function: Returns the last day of the month for a specific date. (Relatively modern function and very important in financial reports).
-- Scenario: Finding the last day of the month the car was produced (assuming it was produced in month 1).
SELECT TOP 5 
    Vehicle_Display_Name,
    DATETIMEFROMPARTS(Year, 1, 1, 0, 0, 0, 0) AS ProductionDate,
    EOMONTH(DATETIMEFROMPARTS(Year, 1, 1, 0, 0, 0, 0)) AS LastDayOfProductionMonth
FROM VehicleDetails;

-- 8. ISDATE
-- Function: Checks if the input text represents a valid date or not. (Returns 1 if valid and 0 if invalid).
-- Very useful during Data Migration to ensure there are no errors before conversion.
SELECT 
    ISDATE('2026-09-11') AS IsValidDate_1, -- Valid (1)
    ISDATE('2026-15-30') AS IsValidDate_2, -- Invalid (0) because month 15 does not exist
    ISDATE(CAST(Year AS VARCHAR) + '-01-01') AS IsValidVehicleDate -- Check vehicle dates
FROM VehicleDetails
WHERE ID = 1;

-- 9. FORMAT (Works with Dates and Numbers)
-- Function: Formats a date or number to fit specific languages or display formats (uses the .NET engine and is relatively slow on large tables).
SELECT 
    GETDATE() AS Today,
    FORMAT(GETDATE(), 'dd/MM/yyyy') AS BritishFormat,
    FORMAT(GETDATE(), 'MM-dd-yyyy') AS USFormat,
    FORMAT(GETDATE(), 'dddd, MMMM dd, yyyy') AS FullTextFormat,
    FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') AS StandardDBFormat;

--------------------------------------------------------------------------------------------------
-- ===============================================================================================
-- Advanced Combining Scenario
-- Combining string and date functions to produce a formatted final report
-- ===============================================================================================
--------------------------------------------------------------------------------------------------
SELECT TOP 10
    -- Concatenate a string containing a vehicle code extracted from its name, converting it to uppercase
    CONCAT_WS(' | ',UPPER(LEFT(m.Make, 3)),SUBSTRING(vd.Vehicle_Display_Name, CHARINDEX(' ', vd.Vehicle_Display_Name) + 1, 5)) AS GeneratedVehicleCode,
    
    -- Calculate the vehicle age and use strings to append the word 'Years'
    CONCAT(DATEDIFF(YEAR, DATETIMEFROMPARTS(vd.Year, 1, 1, 0, 0, 0, 0), GETDATE()), ' Years') AS AgeText,
    
    -- Replace missing values or process with cleaning strings
    TRIM(REPLACE(vd.Vehicle_Display_Name, m.Make, '')) AS CleanedModelName,
    
    -- Calculate a hypothetical maintenance date (last day of the month, 6 months from today)
    EOMONTH(DATEADD(MONTH, 6, GETDATE())) AS NextScheduledMaintenance
FROM VehicleDetails vd
JOIN Makes m ON vd.MakeID = m.MakeID
ORDER BY vd.Year DESC;


-- 1. STRING_AGG (Available from SQL Server 2017 onwards)
-- Function: Aggregates values from multiple rows into a single string separated by a specific delimiter (similar to GROUP_CONCAT in MySQL).
-- Scenario: We want to display each manufacturer (Make) alongside a list of all its models in a single text field.
SELECT TOP 10
    m.Make,
    STRING_AGG(mm.ModelName, '   |   ') WITHIN GROUP (ORDER BY mm.ModelName ASC) AS AllModelsList
FROM Makes m
JOIN MakeModels mm ON m.MakeID = mm.MakeID
GROUP BY m.Make;

-- 2. STRING_SPLIT
-- Function: The reverse of STRING_AGG, takes a string and splits it into rows based on a specific delimiter.
-- Scenario: We have a car name consisting of multiple words, and we want to separate each word into a distinct row for analysis.
DECLARE @SampleVehicleName VARCHAR(100) = 'Acura MDX Advance 2026';
SELECT 
    value AS WordPart
FROM STRING_SPLIT(@SampleVehicleName, ' ');

-- 3. TRANSLATE (Available from SQL Server 2017)
-- Function: Replaces a set of characters with another set all at once (stronger and faster than chaining REPLACE functions).
-- Scenario: Cleaning car names by converting spaces, parentheses, and dashes to an underscore (_).
SELECT TOP 5 
    Vehicle_Display_Name,
    TRANSLATE(Vehicle_Display_Name, ' -()', '____') AS Translated_Name
FROM VehicleDetails;

-- 4. QUOTENAME
-- Function: Adds square brackets [] (or quotes) around text to make it safe as a SQL object name (very useful in Dynamic SQL).
SELECT TOP 5 
    Make,
    QUOTENAME(Make) AS SafeObjectName,          -- Result: [Acura]
    QUOTENAME(Make, '''') AS QuotedStringValue  -- Result: 'Acura'
FROM Makes;

-- 5. SPACE
-- Function: Generates a specific number of spaces. Used to format text output.
SELECT TOP 5 
    Make + SPACE(10) + ModelName AS SpacedOutput
FROM Makes m
JOIN MakeModels mm ON m.MakeID = mm.MakeID;

-- 6. ASCII & CHAR
-- Function: ASCII returns the numeric code of the first character in the text. CHAR takes the numeric code and returns it as a character.
SELECT TOP 5 
    Make,
    ASCII(Make) AS FirstLetterAsciiCode,
    CHAR(ASCII(Make)) AS ReconstructedLetter
FROM Makes;

-- 7. UNICODE & NCHAR
-- Function: Same concept as ASCII and CHAR, but handles extended characters and other languages (like Arabic) using the NCHAR system.
SELECT 
    UNICODE(N'?') AS ArabicLetterCode,
    NCHAR(1587) AS ReconstructedArabicLetter;

-- 8. CURRENT_TIMESTAMP
-- Function: The same as GETDATE() but follows the ANSI SQL Standard. It is better to use it to ensure code compatibility with other database engines.
SELECT CURRENT_TIMESTAMP AS AnsiStandardCurrentTime;

-- 9. GETUTCDATE & SYSUTCDATETIME
-- Function: Returns Coordinated Universal Time (UTC) instead of the local server time. Essential for applications serving users in different countries.
SELECT 
    CURRENT_TIMESTAMP AS LocalServerTime,
    GETUTCDATE() AS UniversalTime_UTC,
    SYSUTCDATETIME() AS UniversalTime_HighPrecision;

-- 10. DATEFROMPARTS
-- Function: Builds a date (DATE type only, no time) from year, month, and day. (Lighter and faster than DATETIMEFROMPARTS if you don't need time).
SELECT TOP 5 
    Year,
    DATEFROMPARTS(Year, 7, 1) AS MidYearProductionDate
FROM VehicleDetails;

-- 11. TODATETIMEOFFSET
-- Function: Converts a local date to a date containing a Timezone Offset.
SELECT 
    TODATETIMEOFFSET(CURRENT_TIMESTAMP, '+03:00') AS SyriaTimeWithOffset;

-- 12. SWITCHOFFSET
-- Function: Changes the time offset for an existing datetime to see the time in another country.
DECLARE @MyLocalTime DATETIMEOFFSET = TODATETIMEOFFSET(CURRENT_TIMESTAMP, '+03:00');
SELECT 
    @MyLocalTime AS TimeInSyria,
    SWITCHOFFSET(@MyLocalTime, '-04:00') AS TimeInNewYork;


-- 13. IIF (Inline IF)
-- Function: A quick conditional function that returns one value if the condition is true, and another if it's false (a short alternative to CASE WHEN).
-- Scenario: Classifying cars into (Coupe) if they have 2 doors, and (Family) if they have 4 or more doors.
SELECT TOP 10 
    Vehicle_Display_Name,
    NumDoors,
    IIF(NumDoors <= 2, 'Sport/Coupe', 'Family/SUV') AS VehicleCategory
FROM VehicleDetails;

-- 14. CHOOSE
-- Function: Returns an item from a list based on the passed Index number. (Index starts at 1).
-- Scenario: Suppose BodyID numbers from 1 to 4 represent specific types, we use CHOOSE to translate them quickly.
SELECT TOP 10 
    Vehicle_Display_Name,
    BodyID,
    CHOOSE(BodyID, 'Sedan', 'SUV', 'Truck', 'Coupe', 'Hatchback') AS QuickBodyTypeGuess
FROM VehicleDetails
WHERE BodyID <= 5;

-- 15. ISNULL
-- Function: Checks if the value is NULL, and if so, replaces it with a default value you specify.
-- Scenario: Some cars might not have a registered fuel type (NULL).
SELECT TOP 100
    vd.Vehicle_Display_Name,
    ft.FuelTypeName,
    ISNULL(ft.FuelTypeName, 'Fuel Type Not Specified') AS SafeFuelType
FROM VehicleDetails vd
LEFT JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID;

-- 16. COALESCE
-- Function: Similar to ISNULL but can take a long list of columns and returns the *first non-null value* it finds in the list.
-- Scenario: We try to fetch the car description from a specific field, and if it's empty, we take it from another, and if that's empty, we output a default message.
SELECT TOP 10
    MakeID,
    ModelID,
    SubModelID,
    -- COALESCE returns the first non-null argument
    COALESCE(CAST(SubModelID AS VARCHAR), CAST(ModelID AS VARCHAR), 'No SubModel or Model') AS FirstAvailableID
FROM VehicleDetails;

-- 17. NULLIF
-- Function: Compares two values. If they are equal, it returns NULL. If they differ, it returns the first value.
-- Scenario: Often used to avoid a "Divide by Zero" error by converting zero to NULL.
DECLARE @TotalVehicles INT = 100;
DECLARE @FailedVehicles INT = 0;
-- Here, NULLIF will convert @FailedVehicles to NULL if it's 0, so the result will be NULL and the code won't crash with a Divide by Zero error
SELECT @TotalVehicles / NULLIF(@FailedVehicles, 0) AS SuccessRatio;

-- 18. CAST
-- Function: Converts data from one type to another (based on the standard ANSI SQL standard).
SELECT TOP 5 
    Vehicle_Display_Name,
    Year,
    'Model Year is: ' + CAST(Year AS VARCHAR(4)) AS YearString -- Convert the number to text to concatenate it
FROM VehicleDetails;

-- 19. CONVERT
-- Function: Does the same as CAST but is specific to SQL Server, and is distinguished by its ability to specify a "Style/Format" (especially when converting dates to strings).
SELECT 
    CURRENT_TIMESTAMP AS OriginalTime,
    CONVERT(VARCHAR(20), CURRENT_TIMESTAMP, 120) AS ODBC_Canonical_Format, -- YYYY-MM-DD HH:MI:SS
    CONVERT(VARCHAR(10), CURRENT_TIMESTAMP, 103) AS British_French_Format; -- DD/MM/YYYY

-- 20. ISNUMERIC
-- Function: Checks if the text contains an integer/decimal number or not (returns 1 if it is a number, 0 if not).
-- Scenario: Checking a text field to ensure whether the user has entered a valid year.
SELECT 
    ISNUMERIC('2026') AS IsNumberValid,       -- Result: 1
    ISNUMERIC('Sedan') AS IsTextValid,        -- Result: 0
    ISNUMERIC('2026.5') AS IsDecimalValid;    -- Result: 1 (accepts decimal points)

-- 21. TRY_CAST & TRY_CONVERT
-- Function: Safe conversion. If the conversion fails (e.g., converting a word to a number), instead of the query crashing and throwing an error, it returns NULL.
SELECT 
    TRY_CAST('2026' AS INT) AS SuccessfulCast,    -- Will return 2026
    TRY_CAST('Acura' AS INT) AS FailedCast;       -- Will return NULL and won't stop code execution