DECLARE @id INT
DECLARE @fname NVARCHAR(20)
DECLARE @sname NVARCHAR(20)

DECLARE @mcursor CURSOR

SET @mcursor = CURSOR FOR SELECT EmpID, FirstName, LAstName FROM dbo.Employee

OPEN @mcursor
FETCH NEXT FROM @mcursor INTO @id, @fname, @sname

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT cast(@id as VARCHAR(10)) + ' ' + @fname + ' ' + @sname
	FETCH NEXT FROM @mcursor INTO @id, @fname, @sname
END

CLOSE @mcursor
DEALLOCATE @mcursor
