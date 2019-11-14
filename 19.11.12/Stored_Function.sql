select user(), database();


-- Function

drop function if exists userfunc2;
delimiter $$
$$
create function userfunc2(bYear INT)
returns INT
begin
	declare age INT;
	set age = year(curdate())-bYear;
	return age;
end $$
delimiter ;

select userfunc2(1990);
select userfunc2(1979) into @age1979;
select userfunc2(1997) into @age1997;
select @age1979, @age1997;

select concat('1997년생과 1979년생의 나이차 ==> ', (@age1979-@age1997));





drop function if exists getdeptnamefunc;
delimiter $$
$$
create function getdeptnamefunc(
	_dno int(11)
)
returns varchar(10)
BEGIN
	declare return_deptName varchar(10);

	select deptname into return_deptName
	from department
	where deptno = _dno;

	return return_deptName;
END $$
delimiter ;

select getdeptnamefunc(3);


-- 함수는 실제 테이블을 조회할 때 활용
select empno, empname, title, manager, salary, getdeptnamefunc(dno)
	from employee;


drop function if exists get_manager_info;
delimiter $$
$$
create function get_manager_info( in_empno int )
returns varchar(30)
BEGIN
	declare return_manager_info varchar(30);

	select concat(empname, '(', empno, ')') into return_manager_info
		from employee
	where empno = in_empno;

	return return_manager_info;
END $$
DELIMITER ;

select empno,
		empname,
		title,
		get_manager_info(manager) as manager,
		salary,
		getdeptnamefunc(dno)
	from employee;


delimiter $$
drop function if exists EmployeeLevel $$
CREATE FUNCTION EmployeeLevel(p_empno int(11))
returns varchar(10)
BEGIN
	declare salarylim integer;
	declare p_empLevel varchar(10);

	select salary into salarylim
		from employee
	where empno = p_empno;

	if salarylim > 4000000 THEN
		set p_empLevel = 'PLATINUM';
	ELSEIF (salarylim <= 4000000 and salarylim >= 2000000) THEN
		set p_empLevel = 'GOLD';
	ELSEIF (salarylim < 2000000) THEN
		set p_empLevel = 'SILVER';
	END IF;
	RETURN (p_empLevel);
END $$
DELIMITER ;

select empno, empname, EmployeeLevel(empno)
	from employee;


drop procedure if exists GetCustomerLevel2;
delimiter $$
create procedure GetCustomerLevel2(
	in p_empno int(11),
	out p_empLevel varchar(10)
)
BEGIN
	select employeeLevel(p_empno) into p_empLevel
		from employee
	where empno = p_empno;
END $$
delimiter ;

call GetCustomerLevel2(4377, @level);

select @level;


drop procedure if exists proc_cursor;
delimiter $$
CREATE PROCEDURE proc_cursor()
BEGIN
	declare userSalary int;
	declare cnt int default 0;
	declare totalSalary int default 0;
	declare endOfRow boolean default false;
	
	declare userCursor cursor for
		select salary from employee;
	
	declare continue handler
		for not found
		begin
			show errors;
			set endOfRow = true;
		end;
	
	open userCursor;

	cursor_loop: LOOP
		fetch userCursor into userSalary;
		if endOfRow then
			leave cursor_loop;
		end if;
		set cnt = cnt + 1;
		set totalSalary = totalSalary + userSalary;
	end loop cursor_loop;

	select cnt, concat('사원의 급여 평균 ==>', (totalSalary/cnt));

	close userCursor;
END $$
delimiter ;


call proc_cursor();
select * from employee;





drop procedure if exists cursor_avg_sal_while;
delimiter $$
CREATE PROCEDURE cursor_avg_sal_while()
BEGIN
	declare user_Salary int default 0;
	declare emp_cnt int default -1;
	declare total_Salary int default 0;
	declare endOfRow boolean default false;
	
	declare userCursor cursor for
		select salary from employee;
	
	declare continue handler
		for not found set endOfRow = true;

	open userCursor;

	while(!endOfRow) do
		set emp_cnt = emp_cnt + 1;
		set total_salary = total_salary + user_salary;
		fetch userCursor into user_salary;	
	end while;
 	set emp_cnt = emp_cnt;
	select emp_cnt, concat('사원의 급여 평균 ==>', (total_Salary/emp_cnt));

	close userCursor;
END $$
delimiter ;

call cursor_avg_sal_while();

select * from employee;



drop procedure if exists cursor_proc02;
delimiter $$
create procedure cursor_proc02()
BEGIN
	declare userSalary int;
	declare cnt int default 0;
	declare totalSalary int default 0;
	
	declare endOfRow boolean default false;

	declare userCursor cursor for
		select salary from employee;
	
	declare exit handler
		for not FOUND
		begin
			select concat('사원의 급여 평균 ==>', (totalSalary/cnt));
			close userCursor;
		end;
	
	open userCursor;

	cursor_loop: loop
		fetch userCursor into userSalary;
	
		set cnt = cnt + 1;
		set totalSalary = totalSalary + userSalary;
	end loop cursor_loop;
END $$
delimiter ;

call cursor_proc02();













