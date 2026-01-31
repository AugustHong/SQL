ALTER PROCEDURE [dbo].[TRY_CATCH] (
					 @I_TEST VARCHAR(120),
					 @O_TEST    VARCHAR(20) OUTPUT)
AS BEGIN 

    SET NOCOUNT ON 
    SET ANSI_WARNINGS ON

    BEGIN TRY
        BEGIN TRANSACTION    
        DECLARE @V_ERROR_SEVERITY INT,               --RAISERROR變數:ERROR_SEVERITY()
                @V_ERROR_STATE    INT,               --RAISERROR變數:ERROR_STATE()
                @V_ERROR_MESSAGE  NVARCHAR(4000),    --RAISERROR變數:ERROR_MESSAGE()    
                @V_ERROR_NUMBER   INT,
                @V_ERROR_LINE     INT,
                @V_ERROR_PROCEDURE VARCHAR2(2000)
        
        -- 中間做處理

        -- 處理完要 COMMIT
        COMMIT TRANSACTION
        --========== SP  END  ==========              
    END TRY   
    BEGIN CATCH
        -- Rollback
        ROLLBACK TRANSACTION  
        -- 取到錯誤資訊     
        SELECT @V_ERROR_SEVERITY = ERROR_SEVERITY(), 
                @V_ERROR_STATE = ERROR_STATE(), 
                @V_ERROR_MESSAGE = ERROR_MESSAGE(), 
                @V_ERROR_NUMBER = ERROR_NUMBER(), 
                @V_ERROR_LINE = ERROR_LINE(), 
                @V_ERROR_PROCEDURE = ERROR_PROCEDURE()
        RAISERROR(50001,@V_ERROR_SEVERITY,@V_ERROR_STATE,@V_ERROR_STATE,@V_ERROR_MESSAGE)        
    END CATCH  
END