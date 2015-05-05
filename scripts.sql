/****** Script for finding columns  ******/

USE ECOS_PSI_GOLIVE

SELECT
    object_schema_name(t.object_id) + '.' + t.name as table_name,
    c.name as column_name
FROM sys.tables t
INNER JOIN sys.columns c
ON t.object_id = c.object_id
WHERE c.name like '%line%';

/*****************************************************************************************************/

CREATE TRIGGER instead_delete
ON master_data.frame
INSTEAD OF DELETE
AS
BEGIN
	UPDATE master_data.frame
	SET is_active=0
	WHERE frame_id IN (SELECT frame_id FROM deleted)
END
/********************************************************************************************************/

;WITH table1 as  
	(
		select user_id, min(business_unit_id) as n from master_data.user_profile
		group by user_id
	)
UPDATE txn_data.tbl_blueprint
set business_id = table1.n
FROM table1
	INNER JOIN txn_data.tbl_blueprint tb ON (tb.created_by= table1.user_id)
