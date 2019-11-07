select user(), database();

use mysql_study;

-- 8
select connection_id();

select * from tbl;

insert into tbl(col) values(20);

-- read lock 걸림(mysql에서)
select * from tbl; -- 가능

insert into tbl(col) values(21); -- 대기
-- my_sql에서 unlock 하는 순간 insert 됨


-- write lock 걸림(mysql에서)
select * from tbl; -- 대기
-- my_sql에서 unlock 하는 순간 select 됨

insert into tbl(col) values(41);
-- my_sql에서 unlock 하는 순간 insert 됨