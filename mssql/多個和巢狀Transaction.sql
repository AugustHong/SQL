/* 多個 Transaction 和 巢狀的Transaction*/

-- 裡面有多個Transaction (但各自獨立，不用1個掛了全Rollback)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ManyTransaction]
AS
BEGIN
	BEGIN TRY

		-- 1個 BEGIN TRANSACTION 包住1個 COMMIT TRANSACTION
		-- 這樣就算 下1個死掉了，這邊也會成功寫入
		BEGIN TRANSACTION
		INSERT INTO TableE (ID) VALUES (1);
		COMMIT TRANSACTION

		-- 會死掉，但不影響上面的成功
		BEGIN TRANSACTION
		INSERT INTO TableE (ID) VALUES (1);
		COMMIT TRANSACTION
           
		RETURN 0;
    END TRY   
    BEGIN CATCH
        IF @@TRANCOUNT > 0
		BEGIN
		ROLLBACK TRANSACTION  --ROLLBACK
		END   
		
		RETURN -1;
    END CATCH
END

-- 由上面得知，通常會這樣寫的都是在寫SP 裡面的Log (不然每次Log 都和 1個動作一起 COMMIT，這樣也有點問題。只想要Log寫入成功而己其他的要退回)
-- 所以我建了1個 LogTable 和 1個專門來寫Log 的 SP
-- 這樣就可以模擬真實用 1個 Transaction (有多個步驟，1個錯全部返回，但Log 都還是有寫)
-- 最後實測辦不到(他的最外層Transaction就包全部，裡面的先COMMIT也沒用。沒有像Oracle的可以跳脫原有的Transaction之功能)
-- 要硬做也是可以， 寫Log 的 改成Function 然後裡面是組SQL字串。最後在 COMMIT 和 ROLLBACK 的下一行 執行組出來的SQL字串，強制讓他不在Transaction中
-- 或者第2種比較難維護的，就是把所有要寫的Log 都放在最上面然後每1個設1個 SAVE TRANSACTION 然後，下面就跳回指定的位置。(也是蠻爛的寫法，而且還不能帶參數呈現Log) 下面範例呈現
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ManyTransaction2]
AS
BEGIN
    DECLARE @TEXT VARCHAR(500);  --寫入的Log訊息
	DECLARE @STEP INT;    --當前執行的步驟

	BEGIN TRY

		BEGIN TRANSACTION

		-- 一開始先指定寫好所有的Log (再依據哪邊死掉去返回指定點)
		SAVE TRANSACTION W1
		SET @TEXT = '開始執行SP';
		INSERT INTO LogTable (LogText) VALUES (@TEXT);
		
		SAVE TRANSACTION W2
		SET @TEXT = '處理第1個作業，寫入3(預計要成功的)';
		INSERT INTO LogTable (LogText) VALUES (@TEXT);
		
		SAVE TRANSACTION W3
		SET @TEXT = '處理第2個作業，寫入3(預計要失敗的)';
		INSERT INTO LogTable (LogText) VALUES (@TEXT);
		
		SAVE TRANSACTION W4
		SET @TEXT = '結束執行SP';
		INSERT INTO LogTable (LogText) VALUES (@TEXT);
		
		-- 實際要實作的動作		
		-- 第2步會成功的
		SET @STEP = 2;
		INSERT INTO TableE (ID) VALUES (3);

		-- 第3步會失敗的
		SET @STEP = 3;
		INSERT INTO TableE (ID) VALUES (3);	

    END TRY   
    BEGIN CATCH
		IF @STEP = 2
		BEGIN
			ROLLBACK TRANSACTION W2
			COMMIT  --要COMMIT其他的 (就是 Log的)
		END
		IF @STEP = 3
		BEGIN
			ROLLBACK TRANSACTION W3
			COMMIT  --要COMMIT其他的 (就是 Log的)
		END

		SET @TEXT = '[失敗]' + ERROR_MESSAGE();
		INSERT INTO LogTable (LogText) VALUES (@TEXT);
    END CATCH
END

--================================用組SQL的方式來寫，優點可帶參數，缺點 長度怕過長============================================
-- 先寫出 組 SQL 字串 的 函式
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[WriteLogSql] 
(
	@I_TEXT VARCHAR(500)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	
	RETURN 'INSERT INTO LogTable (LogText) VALUES (''' + @I_TEXT + ''');';
END

-- 主邏輯
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ManyTransaction3]
AS
BEGIN
    DECLARE @TEXT VARCHAR(500), @SQL VARCHAR(MAX);

	BEGIN TRY

		BEGIN TRANSACTION

		SET @TEXT = '開始執行SP';
		SET @SQL = dbo.WriteLogSql(@TEXT);
		
		SET @TEXT = '處理第1個作業，寫入5(預計要成功的)';
		INSERT INTO TableE (ID) VALUES (5);
		SET @SQL = @SQL + dbo.WriteLogSql(@TEXT);
		
		SET @TEXT = '處理第2個作業，寫入5(預計要失敗的)';
		INSERT INTO TableE (ID) VALUES (5);
		SET @SQL = @SQL + dbo.WriteLogSql(@TEXT);
		
		SET @TEXT = '結束執行SP';
		SET @SQL = @SQL + dbo.WriteLogSql(@TEXT);	

		COMMIT TRANSACTION;

		-- 執行寫Log 的 SP
		EXECUTE(@SQL);
    END TRY   
    BEGIN CATCH
		ROLLBACK TRANSACTION;

		SET @TEXT = '[失敗]' + REPLACE(ERROR_MESSAGE(), '''', '''''');
		SET @SQL = @SQL + dbo.WriteLogSql(@TEXT);

		-- 執行寫Log 的 SP
		EXECUTE(@SQL);
    END CATCH
END




-- 巢狀Transaction(但就直接用1個 BEGIN TRANSACTION 包起來就行了，而且有人說盡量不要用，所以這邊就看看用就行)
-- 參考網址： https://littlehorseboy.github.io/2020/07/05/202007-t-sql-save-tran/#%E5%B7%A2%E7%8B%80%E4%BA%A4%E6%98%93%EF%BC%8C%E6%AD%A3%E7%A2%BA%E7%9A%84%E5%AF%AB%E6%B3%95
-- SAVE TRANSACTION 就當作記錄點的概念，當 ROLLBACK後會返回到 記錄點之前的位置繼續執行
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[NetTransaction]
AS
BEGIN
	BEGIN TRY
      BEGIN TRANSACTION outterTran;

      BEGIN TRY
            -- @@TRANCOUNT > 0 代表目前已經是在交易內，改用 SAVE TRAN
            IF (@@TRANCOUNT > 0) SAVE TRANSACTION innerTran;
            ELSE BEGIN TRAN innerTran;

            INSERT INTO TableE (ID) VALUES (2);

			INSERT INTO TableE (ID) VALUES (2);

            -- SAVE TRANSACTION 不做 COMMIT
            IF (@@TRANCOUNT = 0) COMMIT TRANSACTION innerTran;
      END TRY
      BEGIN CATCH
            -- SAVE TRAN 局部交易回復
            ROLLBACK TRANSACTION innerTran;

            THROW;
      END CATCH
      -- end innerTran

      COMMIT TRAN outterTran;
	END TRY
	BEGIN CATCH
      ROLLBACK TRAN outterTran;

      THROW;
	END CATCH
END