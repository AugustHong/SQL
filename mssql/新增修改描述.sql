-- 新增/修改描述

-- 新增(欄位描述)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'欄位描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TableName', @level2type=N'COLUMN',@level2name=N'ColumnName'
-- 新增(Table描述)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TableName'

-- 修改(欄位描述)
EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'欄位描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TableName', @level2type=N'COLUMN',@level2name=N'ColumnName'
-- 修改(Table描述)
EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Table描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TableName'
