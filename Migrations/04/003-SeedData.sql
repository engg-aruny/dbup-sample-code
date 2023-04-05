IF OBJECT_ID('Teacher', 'U') IS NOT NULL
BEGIN
    INSERT INTO Teacher (ID, FirstName, LastName, Email, PhoneNumber, Gender)
    VALUES (1, 'Ramesh', 'Kumar', 'testramesh@gmail.com', '1234567890', 'M'),
           (2, 'Amit', 'Sharma', 'testamitsharma@gmail.com', '1234517890', 'M')
END


IF OBJECT_ID('Student', 'U') IS NOT NULL
BEGIN
    INSERT INTO Student (ID, FirstName, LastName, Email, DateOfBirth)
    VALUES (1, 'Mohit', 'Yadav', 'testmohit@gmail.com', GETDATE()),
           (2, 'Ankit', 'Sharma', 'testankitsharma@gmail.com', GETDATE())
END
