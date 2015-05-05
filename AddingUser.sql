----------READ ME - START -----------
/*
The script allows adding a user to ECOS Production system.

Please make sure to enter the required information (marked as INPUT REQUIRED below) before executing the script.

The user executing the script must have write permissions to the database in use.

ECOS PRODUCTION DATABASE SERVER IS EMDC1SQM15V04\AMOSAPPP03

*/
----------READ ME - END  -----------



USE [ECOS_PSI_GOLIVE]									--- INPUT OPTIONAL: Change target database if required

DECLARE @user_name VARCHAR(50)
DECLARE @user_id INT
DECLARE @user_full_name VARCHAR(50)

DECLARE @portal_application_id INT
DECLARE @planner_application_id INT
DECLARE @project_application_id INT
DECLARE @maps_application_id INT
DECLARE @reports_application_id INT

DECLARE @portal_application_role INT
DECLARE @planner_application_role INT
DECLARE @project_application_role INT
DECLARE @maps_application_role INT
DECLARE @reports_application_role INT
DECLARE @user_culture VARCHAR(10)
DECLARE @report_access_required bit


----------USER INPUT SECTION - START -----------

SET @user_name = 'domain\username'						-- INPUT REQUIRED: Replace domain\username with target users values
SET @user_full_name = 'First_Name Last_Name'			-- INPUT REQUIRED: Replace First_Name Last_Name with target users values
SET @report_access_required = 0							-- INPUT REQUIRED: Change to 1 if report access is required, other 0
SET @user_culture = 'en-GB'								-- INPUT REQUIRED: Default is en-GB. Change if required. See https://msdn.microsoft.com/en-gb/library/ee825488(v=cs.20).aspx for help

----------- SET USER ROLES BELOW ----------------
/*
role_id		role_name
	1	Administrator
	2	Client
	3	Planner
	4	Business Director
	5	Trader
	6	Media Owner
	7	Finance
	8	Contributor
	9	Delivery
	10	Super User
	11	Media Owner Admin
	12	Media Owner Trader

Default role is Planner - Change below if required
*/

SET @maps_application_role = 3
SET @portal_application_role = 3
SET @project_application_role = 3
SET @planner_application_role = 3
SET @reports_application_role = 3

----------USER INPUT SECTION - END -----------


IF @user_name = 'domain\username'
BEGIN 
	PRINT 'Please enter the user details in USER INPUT SECTION' 
	Goto FINISH
END


Select @portal_application_id = application_id from master_data.electric_application where application_name = 'Portal'
Select @planner_application_id = application_id from master_data.electric_application where application_name = 'Planner'
Select @project_application_id = application_id from master_data.electric_application where application_name = 'Project'
Select @maps_application_id = application_id from master_data.electric_application where application_name = 'Maps'
Select @reports_application_id = application_id from master_data.electric_application where application_name = 'Reports'

----------------------------------------------------------
PRINT 'Checking for user ' + @user_name
----------------------------------------------------------

IF exists(SELECT user_id FROM [master_data].[app_user] WHERE user_name = @user_name)
BEGIN
	PRINT @user_name + ' exists'	
	SELECT @user_id = user_id FROM [master_data].[app_user] WHERE user_name = @user_name
END
ELSE
BEGIN
	PRINT 'Adding '+ @user_name + ' to ECOS'
	
	IF @user_full_name <> ''
		BEGIN
			INSERT INTO [master_data].[app_user] VALUES (@user_name,CURRENT_USER,CURRENT_TIMESTAMP,CURRENT_USER,CURRENT_TIMESTAMP,@user_full_name,1,0)

			SELECT @user_id = user_id FROM [master_data].[app_user] WHERE user_name = @user_name
		END
	PRINT 'Added '+ @user_name + ' to ECOS'
END

----------------------------------------------------------
PRINT 'Checking access to Portal for user ' + @user_name
----------------------------------------------------------

IF exists(SELECT application_id FROM [master_data].[user_role_application] WHERE user_id = @user_id and application_id = @portal_application_id)
BEGIN
	PRINT @user_name + ' has access to Portal application'
END
ELSE
BEGIN
	PRINT 'Adding '+ @user_name + ' to Portal'
	
	INSERT INTO [master_data].[user_role_application] VALUES (@portal_application_role,@user_id,@portal_application_id,CURRENT_USER,CURRENT_TIMESTAMP,CURRENT_USER,CURRENT_TIMESTAMP)
	
	PRINT 'Added '+ @user_name + ' to Portal'
END

----------------------------------------------------------
PRINT 'Checking access to Planner for user ' + @user_name
----------------------------------------------------------

IF exists(SELECT application_id FROM [master_data].[user_role_application] WHERE user_id = @user_id and application_id = @planner_application_id)
BEGIN
	PRINT @user_name + ' has access to Planner application'
END
ELSE
BEGIN
	PRINT 'Adding '+ @user_name + ' to Planner'
	
	INSERT INTO [master_data].[user_role_application] VALUES (@planner_application_role,@user_id,@planner_application_id,CURRENT_USER,CURRENT_TIMESTAMP,CURRENT_USER,CURRENT_TIMESTAMP)
	
	PRINT 'Added '+ @user_name + ' to Planner'
END

----------------------------------------------------------
PRINT 'Checking access to Project for user ' + @user_name
----------------------------------------------------------

IF exists(SELECT application_id FROM [master_data].[user_role_application] WHERE user_id = @user_id and application_id = @project_application_id)
BEGIN
	PRINT @user_name + ' has access to Project application'
END
ELSE
BEGIN
	PRINT 'Adding '+ @user_name + ' to Project'
	
	INSERT INTO [master_data].[user_role_application] VALUES (@project_application_role,@user_id,@project_application_id,CURRENT_USER,CURRENT_TIMESTAMP,CURRENT_USER,CURRENT_TIMESTAMP)
	
	PRINT 'Added '+ @user_name + ' to Project'
END

----------------------------------------------------------
PRINT 'Checking access to Maps for user ' + @user_name
----------------------------------------------------------

IF exists(SELECT application_id FROM [master_data].[user_role_application] WHERE user_id = @user_id and application_id = @maps_application_id)
BEGIN
	PRINT @user_name + ' has access to maps application'
END
ELSE
BEGIN
	PRINT 'Adding '+ @user_name + ' to Maps'
	
	INSERT INTO [master_data].[user_role_application] VALUES (@maps_application_role,@user_id,@maps_application_id,CURRENT_USER,CURRENT_TIMESTAMP,CURRENT_USER,CURRENT_TIMESTAMP)
	
	PRINT 'Added '+ @user_name + ' to Maps'
END

IF @report_access_required = 1
BEGIN
------------------------------------------------------------
--PRINT 'Checking access to Reports for user ' + @user_name
------------------------------------------------------------

IF exists(SELECT application_id FROM [master_data].[user_role_application] WHERE user_id = @user_id and application_id = @reports_application_id)
BEGIN
	PRINT @user_name + ' has access to Reports application'
END
ELSE
BEGIN
	PRINT 'Adding '+ @user_name + ' to Reports'
	
	INSERT INTO [master_data].[user_role_application] VALUES (@reports_application_role,@user_id,@reports_application_id,CURRENT_USER,CURRENT_TIMESTAMP,CURRENT_USER,CURRENT_TIMESTAMP)
	
	PRINT 'Added '+ @user_name + ' to Reports'
END

END

----------------------------------------------------------
PRINT 'Checking for ' + @user_name + ' country culture.'
----------------------------------------------------------

IF exists(SELECT [culture_code]  FROM [master_data].[user_country_culture] WHERE user_id = @user_id and [culture_code] = @user_culture)
BEGIN
	PRINT @user_name + ' has culture ' + @user_culture
END
ELSE
BEGIN
	PRINT 'Adding '+ @user_name + ' country culture ' + @user_culture
	
	INSERT INTO [master_data].[user_country_culture] VALUES (@user_id,1,1,@user_culture)
	
	PRINT 'Added '+ @user_name + ' country culture ' + @user_culture
END

FINISH:

------------------------------------------------------------------------------------------------------------
/****** Adding more business units *****/
------------------------------------------------------------------------------------------------------------
insert
  into master_data.user_profile
       (user_id, country_id, operating_company_id, office_id, operation_group_id, business_unit_id, created_by, created_date)
select 417, country_id, operating_company_id, office_id, operation_group_id, business_unit_id, created_by, getdate()
  from master_data.user_profile           --User Id here
 where user_id = 54                       --User with same access
