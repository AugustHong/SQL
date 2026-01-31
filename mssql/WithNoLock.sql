-- WITH (nolock)，因為在寫入Table時這時去Select會被卡住，但加上這個就不會，建議是大量一直頻繁寫入的表再加
SELECT * FROM TableA with(nolock);

-- 若是 SP裡面的話可以加上  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-- 例：
CREATE PROCEDURE ABC (
    @A VARCHAR(10)
)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
    -- 做事
END