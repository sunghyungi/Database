select user(), database();


-- 1개의 입력변수
drop procedure if exists userproc1;
delimiter $$
$$
create procedure userproc1(in userName varchar(10))
BEGIN
	select * from employee where empname = userName;
END $$
delimiter ;

call userproc1('조민희');


-- 2개의 입력변수
drop procedure if exists userproc2;
delimiter $$
$$
create procedure userproc2(
	in userSalary int,
	in userDno int
)
BEGIN
	select *
	from employee
	where salary >= userSalary and dno = userDno;
END $$
DELIMITER ;



-- 입력변수, 출력변수
drop procedure if exists userproc3;

delimiter $$
$$
create procedure userproc3(
	in idx integer,
	in name varchar(20),
	in floor integer,
	out outValue int
)
BEGIN
	insert into department values(idx, name, floor);
	select max(deptno) into outValue
		from department;
END $$
delimiter ;

call userproc3(6, '행정', 7, @myValue);

select * from department;

select @myValue;


drop procedure if exists userproc4;
delimiter $$
$$
create procedure userproc4 (
	in in_dno int(11),
	out out_empno int(11), out out_empname varchar(20), out out_title varchar(10))
BEGIN
	declare err int default 0;
	declare continue handler for SQLEXCEPTION
	BEGIN
		show errors;
		set err = -1;
	END;

	start transaction; -- 트랜잭션 사용 여부
	-- 트랜잭션에 사용 될 쿼리 작성
	select empno, empname, title into out_empno, out_empname, out_title
		from employee
	where dno=in_dno;

	-- 예외처리 변수가 에러라면 롤백 아니라면 커밋
	if err < 0 then
		select 'rollback';
		rollback;
	else
		select 'commit';
		commit;
	end if;
end $$
delimiter ;

call userproc4(3,@a,@b,@c);
select @a, @b, @c;
select * from employee;



-- mysql에서는 테이블 이름을 파라미터로 사용할 수 없음.
drop procedure if exists userproc9;
delimiter $$
create procedure userproc9(
	in tblName varchar(20)
)
BEGIN
	select tblName;
	select * from tblName;
END $$
delimiter ;

call userproc9('employee');


-- 동적 SQL
drop procedure if exists proc_dynamic;
delimiter $$
create procedure mysql_study.proc_dynamic(
	in tblName varchar(20)
)
BEGIN
	set @sqlQuery = concat('select * from ', tblName);
	prepare myQuery from @sqlQuery;
	execute myQuery;
	deallocate prepare myQuery;
END $$
delimiter ;

call proc_dynamic('employee');



-- Stored Procedure 관리
select routine_name, routine_definition from information_schema.ROUTINES
where ROUTINE_TYPE = 'procedure' and routine_schema ='mysql_study';


select param_list, body from mysql.proc
	where db = 'mysql_study' and type = 'procedure' and name = 'userproc3';


show procedure status;
show procedure status where db = 'mysql_study';

show procedure status like '%if%';
show procedure status where name like '%if%';

show create procedure ifproc_error;






