

CREATE TABLE dbo.Employee(
	EmployeeID INT NOT NULL PRIMARY KEY
	,FirstName VARCHAR(128) NOT NULL
	,LastName VARCHAR(128) NOT NULL
	,HireDate DATETIME NOT NULL
	,IsActive BIT NOT NULL
	)