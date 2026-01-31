/*
    自已寫的產生行事曆
*/

-- 回傳的結果
DECLARE @ResultTable TABLE(     [Day] DATE,   -- 日期
                                [DayText] VARCHAR(10), -- 日期文字 yyyyMMdd
                                [YYYY] VARCHAR(4),  -- 西元年yyyy
                                [EEE] VARCHAR(3),   -- 民國年 EEE
                                [MM] VARCHAR(2),    -- 月 MM
                                [DD] VARCHAR(2),    -- 日 dd
                                [Week] INT,  -- 第幾周 (日-六 為1週)
                                [DayOfWeek] INT  -- 星期幾 (星期日 = 7)
                        );

-- 開始年、結束年
DECLARE @StartYear INT = 2024, @EndYear INT = 2024;

-- 跑迴圈
WHILE(@StartYear <= @EndYear)
BEGIN

    -- 產生起迄日期
	DECLARE @StartDate DATE = CAST(CAST(@StartYear AS VARCHAR) + '0101' AS DATE);
	DECLARE @EndDate DATE = CAST(CAST(@StartYear AS VARCHAR) + '1231' AS DATE);
	-- 計算週次使用
	DECLARE @CurrMonth VARCHAR(2) = '', @Week INT = 0;
	-- 相關變數
	DECLARE @DayText VARCHAR(10), @YYYY VARCHAR(4), @MM VARCHAR(2), @DD VARCHAR(2), @DayOfWeek INT, @EEE VARCHAR(3);

    WHILE (@StartDate <= @EndDate)
	BEGIN
				
		-- 取得相關值
		SET @DayText = CONVERT(VARCHAR, @StartDate, 112);
		SET @YYYY = SUBSTRING(@DayText, 1, 4);
        SET @EEE = CAST(@YYYY AS INT) - 1911;
		SET @MM = SUBSTRING(@DayText, 5, 2);
		SET @DD = SUBSTRING(@DayText, 7, 2);
		-- 這邊得到的要減1是因為 星期日回傳 1；星期一 回傳 2；星期五 回傳 6
		SET @DayOfWeek = DATEPART(WEEKDAY, @StartDate) - 1;

		-- 若 = 0 的代表是星期日，要轉回 7
		IF @DayOfWeek = 0
		BEGIN
			SET @DayOfWeek = 7;
		END

		-- 如果月份相同，但是星期日 要加1週
		IF @CurrMonth = @MM AND @DayOfWeek = 7
		BEGIN
			SET @Week = @Week + 1;
		END

		-- 如果月分不同，變成 第1週
		IF @CurrMonth <> @MM
		BEGIN
			SET @Week = 1;
			SET @CurrMonth = @MM;
		END

		-- 寫入資料
		INSERT INTO @ResultTable([Day], [DayText], [YYYY], [EEE], [MM], [DD], [Week], [DayOfWeek]) VALUES
		(@StartDate, @DayText, @YYYY, @EEE, @MM, @DD, @Week, @DayOfWeek);

		-- 更新日期 + 1
		SET @StartDate = DATEADD(DAY, 1, @StartDate);
	END

    -- 更新年度 + 1
    SET @StartYear = @StartYear + 1;

END

-- 查看結果
SELECT * FROM @ResultTable;

