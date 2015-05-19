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
	
/********************************************************************************************************/

/********* Approved Orders with Media Detail lines not either Order Approved or Order Verified ******/

select m.* from txn_data.tbl_media_order o
    cross apply (select item from dbo.split(o.order_data,',')) a
       join txn_data.tbl_media_detail m on a.item = m.media_detail_id and m.media_detail_status not in (7,8)
where o.order_status = 'approved' and m.is_active = 1
order by m.campaign_id, m.media_detail_id

/****************************** Island Problem *****************************************************/

SELECT MIN(Col1) As Start, 
		MAx(Col1) As End FROM
		(SELECT Col1, Col1 - ROW_NUMBER() OVER(Order By Col1) As grp)
		FROM T1
	GROUP BY grp;	
/********************************************************************************************************/

set identity_insert master_data.media_detail_master_data_opco_mapping on

DECLARE @i int = 0

WHILE @i < 14 --PSI
BEGIN
    SET @i = @i + 1

	insert into master_data.media_detail_master_data_opco_mapping
	(media_mapping_id,media_id,operating_company_id,created_date)
	values
	((select top 1 media_mapping_id 
		from master_data.media_detail_master_data_opco_mapping 
		order by media_mapping_id desc) + @i 
	, (select top 1 media_id from master_data.media_detail_master_data order by media_id desc) + @i 
	,4 
	,CURRENT_TIMESTAMP) 
END
set identity_insert master_data.media_detail_master_data_opco_mapping off
