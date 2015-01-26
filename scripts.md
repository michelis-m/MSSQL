/****** Script for downloading frames  ******/

SELECT A.frame_id, F.order_id, A.start_date, A.end_date

FROM ECOS_PSI_GOLIVE.txn_data.media_detail_frame A

INNER JOIN ECOS_PSI_GOLIVE.master_data.frame C ON A.frame_id = C.frame_id

INNER JOIN ECOS_PSI_GOLIVE.txn_data.tbl_media_order F ON A.campaign_id = F.campaign_id


WHERE F.order_id = 9074;



****************************************************************************************************

/****** Script for finding columns  ******/

USE ECOS_PSI_GOLIVE

SELECT
    object_schema_name(t.object_id) + '.' + t.name as table_name,
    c.name as column_name
FROM sys.tables t
INNER JOIN sys.columns c
ON t.object_id = c.object_id
WHERE c.name like '%line%';


****************************************************************************************************

/***** Script for reports since date *****/

SELECT media_detail_id, campaign_id, no_of_frames, media_cost, total_media_cost, media_cost_margin, total_media_cost_margin  

FROM txn_data.media_detail

WHERE start_date > '2015-01-14';


*****************************************************************************************************

/***** MOs *****/

SELECT [media_owner_id]
      ,[media_owner_name]
  FROM [ECOS_PSI_GOLIVE].[master_data].[media_owner]


*****************************************************************************************************

/***** Format Types *****/

SELECT [format_type_id]
      ,[format_type_name]
      ,[format_type_name_mov]
  FROM [ECOS_PSI_GOLIVE].[master_data].[format_type]


*****************************************************************************************************


