select user(), database();

-- p 77

create user 'ceo'@'localhost';
create user 'ceo'@'192.168.10.160';
create user 'ceo'@'%';



alter user 'ceo'@'localhost' identified by 'rootroot';
alter user 'ceo'@'%' identified by 'rootroot';

drop user 'ceo'@'192.168.10.160';

create user 'ceo1'@'localhost' identified by 'rootroot';
create user 'ceo1'@'%' identified by 'rootroot';

-- 권한 확인
show grants for 'ceo'@'localhost';
show grants for 'ceo'@'%';

show grants for 'ceo1'@'localhost';
show grants for 'ceo1'@'%';

-- 권한 부여
grant select on coffee2.* to 'ceo'@'localhost';

-- 테이블 컬럼단위로 권한 부여 가능
grant update(empname) on mysql_study.employee to 'ceo'@'localhost';
grant select(empname) on mysql_study.employee to 'ceo'@'localhost';


grant insert, select, delete, update on mysql_study.* to 'ceo'@'localhost';

-- 권한 해제
revoke select(empname), update(empname) on mysql_study.employee from 'ceo'@'localhost';


-- 계정 삭제
drop user 'ceo1'@'localhost';
drop user 'ceo1'@'%';

drop user 'ceo'@'localhost';
drop user 'ceo'@'%';


-- 계정, 비밀번호, 권한을 동시에 추가 및 제거
grant select, insert, create, update, delete
 on mysql_study.* to 'ceo'@'localhost' identified by 'rootroot';
 
show grants for 'ceo'@'localhost';

revoke create on mysql_study.* from 'ceo'@'localhost';


