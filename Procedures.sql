CREATE PROCEDURE [dbo].[FormatChange]
	 @NewFormat INT --Insert Format id here
	 ,@NewDiC INT   --Insert Dimension Code id here
	 ,@Frame FLOAT  --Insert Frame Id here
AS
BEGIN
	DECLARE @error VARCHAR(1024)
	DECLARE @msg VARCHAR(1024)
	
	BEGIN TRY
	UPDATE master_data.frame
	set dimension_code_id= @NewDiC, format_type_id = @newFormat
	where frame_id = @frame
	END TRY
	BEGIN CATCH
		SELECT @error = ERROR_MESSAGE()
		RAISERROR(@error,16,2)
	END CATCH
END
