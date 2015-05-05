/****** Adding Nmc Supplier ******/

DECLARE @nmcsupplier_name VARCHAR(50)
DECLARE @nmcsupplier_id INT
DECLARE @nmcsupplier_email VARCHAR(50)
DECLARE @nmcaxcode VARCHAR(10)
DECLARE @nmccurrency INT
DECLARE @nmcproduction_type INT

----------------------------------------- INPUT ----------------------------------------------------

SET @nmcsupplier_name = 'Testing nmc Supplier' 
SET @nmcsupplier_email = 'nmc-email@test.com'
SET @nmcaxcode = 'AX0000'
SET @nmccurrency = 1                           -- 1 GBP / 2 EUR check masteR_data.currency for more

SET @nmcproduction_type = 1

/*
1	Net Production Traditional
2	Net Production Digital
3	Gross Production Traditional
4	Gross Production Digital
6	Despatch
7	Inspection
8	Photography
9	Other
10	Supplier
11	Electricity
12	Installation
13	ASBOF
14	EE mData
15	Hyperspace Production
16	Liveposter
17	Media Owner Testing
18	Cancellation Fee
19	Experiential
20	Research
21	Posting Charge
22	Production 
23	Installation
24	Electricity 
25	Maintenance
26	Removal
27	OAG
28	Competitive
29	Photography
30	Office Fee
31	Consultancy
*/
-------------------------------------------------------------------------------------------------------------

IF @nmcsupplier_name = 'nmc supplier name'
BEGIN 
	PRINT 'Please enter the nmc supplier details in USER INPUT SECTION' 
	Goto FINISH
END

------------------------------------- Checking if nmc supplier exists and adding if not ----------------------
DECLARE @nmcsupid INT

SET @nmcsupid = (select top 1 nmc_supplier_id from master_data.nmc_supplier order by nmc_supplier_id desc) + 1


IF exists(SELECT nmc_supplier_name FROM master_data.nmc_supplier WHERE nmc_supplier_name = @nmcsupplier_name)
BEGIN
	PRINT @nmcsupplier_name + ' exists'	
	SELECT nmc_supplier_name FROM master_data.nmc_supplier WHERE nmc_supplier_name = @nmcsupplier_name
	Goto FINISH
END
ELSE
BEGIN
	PRINT 'Adding ' + @nmcsupplier_name + ' to ECOS'

	set identity_insert master_Data.nmc_supplier on 
	
	insert into master_data.nmc_supplier
	(nmc_supplier_id, nmc_supplier_name)
	values (@nmcsupid,@nmcsupplier_name)

	PRINT 'Added ' + @nmcsupplier_name + ' to ECOS'

	set identity_insert master_Data.nmc_supplier off
END

SET @nmcsupplier_id = (SELECT nmc_supplier_id from master_Data.nmc_supplier where @nmcsupplier_name = nmc_supplier_name)

------------------------------------------------- Adding Currency -----------------------------------------
DECLARE @nmccurid INT

SET @nmccurid = (select top 1 nmc_currency_supplier_id from master_data.nmc_supplier_currency_mapping order by nmc_currency_supplier_id desc) + 1

set identity_insert master_data.nmc_supplier_currency_mapping on

PRINT 'Adding ' + @nmcsupplier_name + ' currency'

insert into master_data.nmc_supplier_currency_mapping
(nmc_currency_supplier_id,nmc_supplier_id,currency_id)
values 
(@nmccurid,@nmcsupplier_id,@nmccurrency)

PRINT 'Added ' + @nmcsupplier_name + ' currency'

set identity_insert master_data.nmc_supplier_currency_mapping off

------------------------------------------------- Adding e-mail ------------------------------------------
DECLARE @nmcemailid INT

SET @nmcemailid = (select top 1 nmc_supplier_email_id from master_data.nmc_supplier_email order by nmc_supplier_email_id desc) + 1

set identity_insert master_data.nmc_supplier_email on

PRINT 'Adding ' + @nmcsupplier_name + ' e-mail'

insert into master_data.nmc_supplier_email
(nmc_supplier_email_id,nmc_supplier_id, email)
values (@nmcemailid,@nmcsupplier_id, @nmcsupplier_email)

PRINT 'Added ' + @nmcsupplier_name + ' e-mail'

set identity_insert master_data.nmc_supplier_email off

------------------------------------------------- Adding AX Code ------------------------------------------
DECLARE @nmcaxid INT

SET @nmcaxid = (select top 1 mapping_id from master_Data.nmc_supplier_mapping order by mapping_id desc ) + 1

set identity_insert master_Data.nmc_supplier_mapping on

PRINT 'Adding ' + @nmcsupplier_name + ' AX Code'

insert into master_Data.nmc_supplier_mapping
(mapping_id,nmc_supplier_id, external_nmc_supplier_id, type_name)
values
(@nmcaxid,@nmcsupplier_id, @nmcaxcode, 'Ax')

PRINT 'Added ' + @nmcsupplier_name + ' AX Code'

set identity_insert master_Data.nmc_supplier_mapping off

----------------------------------- Mapping to Production Type ----------------------------------------------
DECLARE @nmctypeid INT

SET @nmctypeid = (select top 1 nmc_type_supplier_map_id from master_data.nmc_type_supplier_mapping order by nmc_type_supplier_map_id desc ) + 1

set identity_insert master_data.nmc_type_supplier_mapping on

PRINT 'Inserting ' + @nmcsupplier_name + 'production cost'

insert into master_data.nmc_type_supplier_mapping
(nmc_type_supplier_map_id,nmc_supplier_id,nmc_production_cost_type_id)
values(@nmctypeid, @nmcsupplier_id, @nmcproduction_type)

PRINT 'Inserted ' + @nmcsupplier_name + 'production cost'

set identity_insert master_data.nmc_type_supplier_mapping off

FINISH:

------------------------------------------------------------------------------------------------------

--select * from master_data.nmc_supplier
--select * from master_Data.nmc_supplier_mapping
--select * from master_data.nmc_supplier_currency_mapping
--select * from master_data.nmc_type_supplier_mapping
--select * from master_data.nmc_supplier_email
-----------------------------------------------------------

