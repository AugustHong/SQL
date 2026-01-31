/*
    參考網址： https://www.cnblogs.com/ljhdo/p/4549152.html
*/

--------------------------------------------基本應用------------------------------------------------------------
declare @json nvarchar(max);
set @json = 
N'{
    "info":{  
      "type":1,
      "address":{  
        "town":"bristol",
        "county":"avon",
        "country":"england"
      },
      "tags":["sport", "water polo"],
      "others":[{
        "other1" : "ABC",
        "other2" : "DEF"
      },{
        "other1" : "ABC123",
        "other2" : "DEF456"
      }]
   },
   "type":"basic"
}';
--建議先轉大寫or小寫(因為他會認為找不到喔！)，但相對的裡面的值也會被大小寫影響到。所以只能說要確保好名稱是對的
--set @json = LOWER(@json);  

select isjson(@json);  -- 是否是JSON格式

/*
$：代表整個JSON內容；
句号 . ：表示 JSON 的各個Key值；
中括號 [] ：表示陣列中的元素，元素的起始位置是0；

注意：最大回傳Nvarchar(4000)；如果回傳會超過，使用OpenJson函式
*/
select
  json_value(@json, '$.type') as type,  -- basic
  json_value(@json, '$.info.type') as info_type,  -- 1
  json_value(@json, '$.info.address.town') as town, -- bristol
  json_value(@json, '$.info.tags[0]') as tag, -- sport
  json_value(@json, '$.info.others[0].other1') as other -- ABC
;

-- 上面是基本的，但有時候不一定有傳入這個參數。而直接下會爆錯
SELECT JSON_VALUE(@json, '$.ggggggggg');   -- 這樣會直接爆錯(但有時候又會回NULL，下次要用時執行一下自已的JSON資料)
-- 所以建議 改成 下面的語法 (CHARINDEX 函是 是找這個字串在 指定字串下的位置，若 = 0 就是找不到)
SELECT IIF(CHARINDEX('"ggggggggg"', @json) > 0, JSON_VALUE(@json, '$.ggggggggg'), '');


-- JSON_QUERY 是會回傳 JSON 資料
select
	json_query(@json, '$.type') as type,  -- 會回傳 NULL (因為沒有子項JSON)
    json_query(@json, '$') as json_context,  -- 整個JSON字串
    json_query(@json, '$.info') as info,
    json_query(@json, '$.info.address') as info_address,
    json_query(@json, '$.info.tags') as info_tags;


-- JSON_MODIFY (增/刪/修) 元素
set @json = JSON_MODIFY(@json, '$.type', 'This is basic');  -- 修改值
set @json = JSON_MODIFY(@json, '$.ggggggggg', 'ggggg'); -- 沒有項目，會直接用新增的
SELECT @json;
set @json = JSON_MODIFY(@json, '$.ggggggggg', null);  -- 最後1個參數是 NULL，代表是刪除
set @json = JSON_MODIFY(@json, 'append $.info.tags', 'play');  -- 在陣列中加入元素
SELECT @json;

-------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------進階應用-------------------------------------------------------

-- 將 JSON 轉成 Table  (裡面的 lax $ 可以想成 foreach 的 當前row物件)
SELECT info_type, info_address, tags, others
FROM OPENJSON(@json, '$.info') 
with 
(
info_type tinyint 'lax $.type',
info_address nvarchar(max) 'lax $.address' as json,
tags nvarchar(max) 'lax $.tags' as json,
others nvarchar(max) 'lax $.others' as json
);

-- 訪問物件陣列
SELECT t.*
FROM OPENJSON(@json, '$.info.others')
WITH(
	other1 varchar(100) 'lax $.other1',
	other2 varchar(100) 'lax $.other2'
) AS t;

-- 訪問 陣列
SELECT t.*
FROM OPENJSON(@json, '$.info.tags')
WITH(
	tag varchar(100) 'lax $'
) AS t;

-------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------用Table產生JSON字串---------------------------------------------------

Declare @dt Table (id int, name varchar(20), birthday date);
INSERT INTO @dt(id, name, birthday) VALUES (1, '王小明', '2024-05-24');
INSERT INTO @dt(id, name, birthday) VALUES (2, '林中明', '2024-08-30');
INSERT INTO @dt(id, name, birthday) VALUES (3, '陳大明', '2024-12-01');
SELECT * FROM @dt;

-- 自動生成
-- {"json":[{"id":1,"name":"王小明","birthday":"2024-05-24"},{"id":2,"name":"林中明","birthday":"2024-08-30"},{"id":3,"name":"陳大明","birthday":"2024-12-01"}]}
select id,
    name,
    birthday
from @dt
for json auto,root('json');

-- 拿掉 root 的話就會長這樣
-- [{"id":1,"name":"王小明","birthday":"2024-05-24"},{"id":2,"name":"林中明","birthday":"2024-08-30"},{"id":3,"name":"陳大明","birthday":"2024-12-01"}]
select id,
    name,
    birthday
from @dt
for json auto;

-- 以Path 模式生成
-- {"data":[{"inx":1,"player":{"name":"王小明","birthday":"2024-05-24"}},{"inx":2,"player":{"name":"林中明","birthday":"2024-08-30"}},{"inx":3,"player":{"name":"陳大明","birthday":"2024-12-01"}}]}
select id as 'inx',
    name as 'player.name',
    birthday as 'player.birthday'
from @dt
for json path,root('data');

-- 如果只想組成陣列的話 (但這個出來的還是物件型態)
-- {"seq":[{"id":1},{"id":2},{"id":3}]}
SELECT id
FROM @dt
FOR JSON AUTO,ROOT('seq');

-- 所以如果要組成陣列 (參考 案例二 + 案例四 的組合的話)，還是會有 id 這個值出來
-- [{"id":1},{"id":2},{"id":3}]
SELECT id
FROM @dt
FOR JSON AUTO;

-- 目前沒找到好方法，感覺也只能用Replace強制換字串了 (拿上面的再加工)
Declare @outputJson varchar(300) = (SELECT id
FROM @dt
FOR JSON AUTO);
SELECT @outputJson;

-- 先把頭尾2層 + 中間 弄掉
SET @outputJson = REPLACE(@outputJson, '[{', '[');
SET @outputJson = REPLACE(@outputJson, '}]', ']');
SET @outputJson = REPLACE(@outputJson, '},{', ',');
SELECT @outputJson;
-- 去掉關鍵字 (中間的 id 就是上面命名的關鍵字)
SET @outputJson = REPLACE(@outputJson, '"' + 'id' + '":', '');
SELECT @outputJson;

-------------------------------------------------------------------------------------------------------------------------------