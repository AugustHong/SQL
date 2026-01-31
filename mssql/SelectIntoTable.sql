-- Select Into 可以像 Oracle 的 Create 建立不存在的Table
-- Test2.dbo.TableA 原本不存在 
Select * into Test2.dbo.TableA  from  Test.dbo.TableA

-- 也可以建成 Tmp Table
Select * into #Tmp from TableA;