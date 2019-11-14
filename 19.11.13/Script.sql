select user(), database();


-- cursor 계속
drop procedure if exists proc_cursor3;
delimiter $$
create procedure proc_cursor3(
	in req_deptname varchar(20)
)
BEGIN
	declare emp_no int(11);
	declare req_deptno int;
	declare emp_name varchar(20);
	declare emp_title varchar(10);
	declare emp_dno int(11);
	declare no_more_rows boolean default false;

	-- 커서 선언
	declare employee_cur cursor for
		select empno, empname, title, dno from employee where dno = req_deptno;
	
	declare continue handler for not found set no_more_rows = true;

	select deptno into req_deptno
		from department
	where deptname = req_deptname;

	open employee_cur;
	select_loop:LOOP
		fetch employee_cur into emp_no, emp_name, emp_title, emp_dno;
		if no_more_rows THEN
			close employee_cur; -- 커서 닫기
		leave select_loop;
		end if;
		select emp_no as '사원번호', emp_name as '사원명', emp_title as '직책', emp_dno as '부서번호';
	end loop;
END $$
delimiter ;

call proc_cursor3('영업');







drop procedure if exists proc_cursor4;
delimiter $$
create procedure proc_cursor4(
	in req_deptname varchar(20)
)
BEGIN
	declare emp_no int(11);
	declare req_deptno int;
	declare emp_name varchar(20);
	declare emp_title varchar(10);
	declare emp_dno int(11);

	-- 커서 선언
	declare employee_cur cursor for
		select empno, empname, title, dno from employee where dno = req_deptno;
	
	declare exit handler for not found
	begin
			close employee_cur;
	end;
	
	select deptno into req_deptno
		from department
	where deptname = req_deptname;

	open employee_cur;
	select_loop:LOOP
		fetch employee_cur into emp_no, emp_name, emp_title, emp_dno;
		select emp_no as '사원번호', emp_name as '사원명', emp_title as '직책', emp_dno as '부서번호';
	end loop;
END $$
delimiter ;

call proc_cursor4('영업');






desc employee;
desc department;













drop procedure if exists ins_dep_emp;
delimiter $$
create procedure ins_dep_emp (
	in in_empno int(11),
	in in_empname varchar(20),
	in in_title varchar(13),
	in in_managername varchar(20),
	in in_salary int(11),
	in in_deptname char(10),
	in in_floor int(11)
)
BEGIN
	declare err int default 0;




	declare continue handler For SQLEXCEPTION
	BEGIN
		show errors;
		set err = -1;
	END;
	
	declare continue handler for 1062
	BEGIN
		select concat('해당하는 사원이 존재 ', (select empname from employee where empno = in_empno), '(', in_empno, ')') as '메시지';
		set err = -1;
	END;

	start transaction;
	


	if (select count(*) from department where deptname = in_deptname) = 0 then
	insert into department(deptname, floor) values(in_deptname, in_floor);
	end if;
	
	insert into employee values(in_empno, in_empname, in_title, (select m.empno from employee m where m.empname = in_managername),
									in_salary, (select deptno from department where deptname = in_deptname), NULL);
	
	if (select manager from employee where empno = in_empno) is null then signal SQLSTATE '45000' set MESSAGE_TEXT = '해당하는 직속상사가 존재하지 않음' ;
	end if;
	


	-- 예외처리 변수가 에러라면 롤백 아니라면 커밋
	if err < 0 then
		select 'rollback';
		rollback;
	else
		select empno, empname, title, manager, salary, dno, deptno, deptname, floor
			from employee e, department d
		where e.dno = d.deptno and e.empno = in_empno;
	
		select 'commit';
		commit;
	end if;
end $$
delimiter ;






set autocommit = false;
call ins_dep_emp(2000, '문근영', '사원', '이성래2', 1600000, '개발', 8);
set autocommit = true;


delete from employee where empno = 2000;
delete from department where deptname = '개발2';

select * from employee where empno = 2000;
select * from department;
select * from employee;




-- 	declare endOfRow boolean default false;
-- 	declare check1 int default 0; 
-- 	declare dname varchar(20);
-- 
-- 
-- 
-- 	declare dnameCursor cursor for
-- 		select deptname from department;
-- 	
-- 	declare continue handler 
-- 		for not found
-- 		begin
-- 			set endOfRow = true;
-- 		end;
-- 		
-- 
-- 
-- 	open dnameCursor;
-- 
-- 	cursor_loop: loop
-- 	fetch dnameCursor into dname;
-- 		if endOfRow then
-- 			leave cursor_loop;
-- 		end if;
-- 	
-- 		if in_deptname = dname then set check1 = 1;
-- 		end if;
-- 	end loop cursor_loop;
-- 
-- 	close dnameCursor;

	







