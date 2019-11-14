select user(), database();

-- procedure
-- 내용이 변경되면 프로시져를 삭제 후 재생성 해야 적용됨.
DROP PROCEDURE IF EXISTS sel_dept;
DELIMITER $$
	CREATE PROCEDURE sel_dept ()
		BEGIN
			SELECT DEPTNO, DEPTNAME, FLOOR FROM department;
		END $$
DELIMITER ;
		
CALL sel_dept();

-- out 매개변수
DROP PROCEDURE IF EXISTS simpleproc;
DELIMITER $$
	CREATE PROCEDURE simpleproc (OUT paraml INT)
		BEGIN
			SELECT COUNT(*) INTO paraml FROM department;
		END $$
DELIMITER ;

call simpleproc(@a);

select @a;


-- in 매개변수
DROP PROCEDURE IF EXISTS in_proc;
DELIMITER $$
	CREATE PROCEDURE in_proc (in dno INT)
		BEGIN
			select deptno, deptname, floor
				from department where deptno = dno;
		END $$
DELIMITER ;


call in_proc(3);


-- 오류 처리

-- continue
select * from noTable;

DROP PROCEDURE IF EXISTS error_continue_proc;
delimiter $$
create procedure error_continue_proc ()
begin
		declare i int;
	
		declare continue handler for 1146 set i = 1;
		select * from noTable;
		select i;
end $$
delimiter ;

call error_continue_proc();



-- exit
DROP PROCEDURE IF EXISTS error_exit_proc;
delimiter $$
create procedure error_exit_proc()
BEGIN
	declare i int;
	
	declare exit handler for 1146 set i = 1;
	select * from noTable;
	select i;
END

call error_exit_proc();


-- 1146 사용, 오류메시지
DROP PROCEDURE IF EXISTS error_condition_value_proc;
delimiter $$
create procedure error_condition_value_proc()
BEGIN
	declare continue handler for 1146 select '테이블이 없어요ㅠㅠ' as '메시지';
	select * from noTable;	
END $$
delimiter ;

call error_condition_value_proc();



-- table_not_exist 사용, 오류메시지
DROP PROCEDURE IF EXISTS error_condition_name_proc;
delimiter $$
create procedure error_condition_name_proc()
BEGIN
	declare table_not_exit condition for 1146;
	declare continue handler for 1146 select '테이블이 없어요ㅠㅠ' as '메시지';
	select * from noTable;	
END $$
delimiter ;

call error_condition_name_proc();



-- dbeaver 내의 기능 사용해서 만듬, 결과창 2개
DROP PROCEDURE IF EXISTS mysql_study.error_sqlexception_proc;

DELIMITER $$
$$
CREATE PROCEDURE mysql_study.error_sqlexception_proc()
BEGIN
	declare continue handler for SQLEXCEPTION
	begin
		show errors;
		select '오류가 발생했습니다. 작업은 취소시켰습니다.' as '메시지';
		rollback;
	end;
	insert into departments values('d007', 'ceo');
END$$
DELIMITER ;

call error_sqlexception_proc();



-- 오류 발생 및 오류 처리
create table employee_hire(
	empno int(11) not null,
	empname varchar(20),
	hiredate date
);

insert into employee_hire values
(1, '홍길동', '2000-11-11'),
(2, '도깨비', '2015-12-12'),
(3, '김사부', '2013-12-12');

select * from employee_hire;


drop PROCEDURE if EXISTS ifproc_error;
delimiter $$
create procedure ifproc_error(in eno int)
BEGIN
	declare hire_date date; -- 입사일
	declare cur_date date; -- 현재날짜
	declare dif_days int; -- 현재날짜 - 입사일
	declare cnt int;
	
	declare exit handler for sqlexception
	BEGIN
		select '해당하는 사원이 존재하지 않음' as '메시지';
	END;

	select hiredate, count(*) into hire_date, cnt
		from employee_hire
	where empno = eno
		group by hiredate;

	if (cnt is null) THEN
		signal SQLSTATE '45000';
	end if; -- 예외 발생
	
	set cur_date = current_date();
	set dif_days = datediff(cur_date, hire_date);

	if (dif_days/365) >= 5 THEN
		select concat('입사한지 ', dif_days,'일이나 지났습니다. 축하합니다.');
	ELSE
		select concat('입사한지 ', dif_days,'일밖에 안되었네요. 분발하세요.');
	end if;
END $$
delimiter ;

call ifproc_error(1);
call ifproc_error(4);


	select hiredate, count(*)
		from employee_hire
		where empno = 4
		group by hiredate;
	
select * from employee_hire;

drop PROCEDURE if EXISTS ifproc_error1;
delimiter $$
create procedure ifproc_error1(in eno int)
BEGIN
	declare hire_date date; -- 입사일
	declare cur_date date; -- 현재날짜
	declare dif_days int; -- 현재날짜 - 입사일
	declare cnt int;
	
	declare employee_not_exist condition for sqlstate '45000';
	declare exit handler for employee_not_exist
	BEGIN
		show errors;
	END;

	select hiredate, count(*) into hire_date, cnt
		from employee_hire
	where empno = eno
		group by hiredate;

	if cnt is null THEN
		signal SQLSTATE '45000'
 		set MESSAGE_TEXT = '해당하는 사원이 존재하지 않음';
	end if; -- 예외 발생
	
	set cur_date = current_date();
	set dif_days = datediff(cur_date, hire_date);

	if (dif_days/365) >= 5 THEN
		select concat('입사한지 ', dif_days,'일이나 지났습니다. 축하합니다.');
	ELSE
		select concat('입사한지 ', dif_days,'일밖에 안되었네요. 분발하세요.');
	end if;
END $$
delimiter ;

call ifproc_error1(1);
call ifproc_error1(4);


drop PROCEDURE if EXISTS ifproc_error2;
delimiter $$
create procedure ifproc_error2(in eno int)
BEGIN
	declare hire_date date; -- 입사일
	declare cur_date date; -- 현재날짜
	declare dif_days int; -- 현재날짜 - 입사일
	declare cnt int;
	
	declare employee_not_exist condition for sqlstate '45000';
	declare exit handler for employee_not_exist
	RESIGNAL SET MESSAGE_TEXT = 'The employee does not exist';
	
	select hiredate, count(*) into hire_date, cnt
		from employee_hire
	where empno = eno
		group by hiredate;

	if cnt is null THEN
		signal SQLSTATE '45000'
 		set MESSAGE_TEXT = '해당하는 사원이 존재하지 않음';
	end if; -- 예외 발생
	
	set cur_date = current_date();
	set dif_days = datediff(cur_date, hire_date);

	if (dif_days/365) >= 5 THEN
		select concat('입사한지 ', dif_days,'일이나 지났습니다. 축하합니다.');
	ELSE
		select concat('입사한지 ', dif_days,'일밖에 안되었네요. 분발하세요.');
	end if;
END $$
delimiter ;

call ifproc_error2(1);
call ifproc_error2(4);



drop PROCEDURE if EXISTS ifproc_error4;
delimiter $$
create procedure ifproc_error4(in eno int)
BEGIN
	declare hire_date date; -- 입사일
	declare cur_date date; -- 현재날짜
	declare dif_days int; -- 현재날짜 - 입사일
	declare cnt int;
	declare MESSAGE_TEXT varchar(50);
	
	declare exit handler for 45000 show errors;

	select hiredate, count(*) into hire_date, cnt
		from employee_hire
	where empno = eno
	group by hiredate;

	if cnt is null THEN
		signal SQLSTATE '45000'
 		set MESSAGE_TEXT = '해당하는 사원이 존재하지 않음';
	end if; -- 예외 발생
	
	set cur_date = current_date();
	set dif_days = datediff(cur_date, hire_date);

	if (dif_days/365) >= 5 THEN
		select concat('입사한지 ', dif_days,'일이나 지났습니다. 축하합니다.');
	ELSE
		select concat('입사한지 ', dif_days,'일밖에 안되었네요. 분발하세요.');
	end if;
END $$
delimiter ;

call ifproc_error4(1);
call ifproc_error4(4);





-- if 명령문
drop procedure if EXISTS ifproc3;
delimiter $$
create PROCEDURE ifproc3(in in_point int)
BEGIN
	declare point int;
	declare credit char(1);
	set point = in_point;

	if point >= 90 then
		set credit = 'A';
	elseif point >= 80 THEN
		set credit = 'B';
	elseif point >= 70 THEN
		set credit = 'C';
	elseif point >= 60 THEN
		set credit = 'D';
	else
		set credit = 'F';
	end if;

	select concat('취득 점수 ==> ', point), concat('학점 ==> ', credit);
END $$
delimiter ;

call ifproc3(75);



drop procedure if exists ifproc_grade;
delimiter $$
create procedure ifproc_grade(in eno int)
BEGIN
	declare sal int;
	declare grade int;
	declare ename varchar(20);
	select empname, salary into ename, sal
	from employee
	where empno = eno;
	if sal < 1500001 THEN
		set grade = 1;
	elseif sal < 3000001 THEN
		set grade = 3;
	elseif sal < 4000001 THEN
		set grade = 4;
	else
		set grade = 5;
	end if;
	select concat(eno, '(', ename,')의 급여는 ',sal,'이며 등급은 ',grade,'입니다.');
end $$
delimiter ;

call ifproc_grade(1003);
select * from employee;


drop procedure if exists ifproc_grade2;
delimiter $$
create procedure ifproc_grade2(in eno int)
BEGIN
	select e.empno, e.empname, e.salary, g.grade
		from employee e, sal_grade g
	where e.salary between g.losal and g.hisal and empno = eno;
END $$
delimiter ;

select * from sal_grade;

call ifproc_grade2(1003);


drop PROCEDURE if EXISTS GetEmployeeLevel;
delimiter $$
create procedure GetEmployeeLevel(
	in p_empno int(11),
	out p_empLevel varchar(10))
BEGIN
	declare salarylim integer;
	
	select salary into salarylim
		from employee
	where empno = p_empno;

	if salarylim > 4000000 then
		set p_empLevel = 'PLATINUM';
	ELSEIF (salarylim <= 4000000 and salarylim >= 2000000) THEN
		set p_empLevel = 'GOLD';
	ELSEIF (salarylim < 2000000) THEN
		set p_empLevel = 'SILVER';
	END IF;

	SELECT salarylim, p_empLevel;
END $$
delimiter ;

call GetEmployeeLevel(1003, @a);

select @a;




-- case 명령문
drop procedure if exists GetEmployeeVacation;
delimiter $$
create procedure GetEmployeeVacation(
	in p_empno int(11),
	out p_vacation varchar(50))
BEGIN
	declare emp_title varchar(50);

	select title into emp_title
		from employee
	where empno = p_empno;
	
	case emp_title
		when '사장' THEN
			set p_vacation = '2-day Vacation';
		when '부장' THEN
			set p_vacation = '3-day Vacation';
		when '과장' THEN
			set p_vacation = '4-day Vacation';
		when '대리' THEN
			set p_vacation = '5-day Vacation';
		else
			set p_vacation = '6-day Vacation';
	end case;
	select emp_title, p_vacation;
END $$
delimiter ;

call GetEmployeeVacation(4377, @vacation);

select @vacation;





drop procedure if exists caseproc;
delimiter $$
create procedure caseproc(in point int)
BEGIN
	declare credit char(1);
	
	CASE
		when point >= 90 then set credit = 'A';
		when point >= 80 then set credit = 'B';
		when point >= 70 then set credit = 'C';
		when point >= 60 then set credit = 'D';
		else set credit = 'F';
	end case;
	select concat('취득 점수 ==> ', point), concat('학점 ==> ', credit);
END $$
delimiter ;

call caseproc(77);





create table credit(
	grade char(1),
	low int,
	high int
)

insert into credit values
('A', 90, 100),
('B', 80, 89),
('C', 70, 79),
('D', 60, 69),
('F', 0, 59);


drop procedure if exists ifproc_grade3;
delimiter $$
create procedure ifproc_grade3(in point int)
begin
	select point '취득 점수', grade '학점'
		from credit
	where point between low and high;
end $$
delimiter ;

call ifproc_grade3(99);



-- while 명령문
drop procedure if exists whileproc;

delimiter $$
$$
create procedure whileproc()
BEGIN
	declare i int;
	declare hap int;
	set i = 1;
	set hap = 0;
	
	while(i < 101) do
		set hap = hap + i;
		set i = i + 1;
	end while;

select hap;
END $$
delimiter ;

call whileproc();




delimiter $$
drop PROCEDURE if exists test_mysql_while_loop$$
create procedure test_mysql_while_loop()
BEGIN
	declare x int;
	declare str varchar(255);

	set x = 1;
	set str = '';

	while x <= 5 do
		set str = concat(str,x,',');
		set x = x + 1;
	end while;

	select str;
END $$
delimiter ;

call test_mysql_while_loop();


-- ITERATE / LEAVE

drop procedure if exists whileproc2;
delimiter $$
$$
create procedure whileproc2()
BEGIN
	declare i int;
	declare hap int;
	set i = 1;
	set hap = 0;

	myWhile:while (i < 101) do
		if (i%7=0) then
			set i = i + 1;
			iterate myWhile;
		end if;

		set hap = hap + i;

		if(hap > 1000) THEN
			leave myWhile;
		end if;

		set i = i + 1;
	end while;

	select hap;
END $$
delimiter ;

call whileproc2();



-- repeat

delimiter $$
drop procedure if exists mysql_test_repeat_loop$$
create procedure mysql_test_repeat_loop(in cnt int)
BEGIN
	declare x int;
	declare str varchar(255);

	set x = 1;
	set str = '';

	repeat
		set str = concat(str,x,',');
		set x = x + 1;
		until x > cnt
	end repeat;

	select left(str, length(str)-1) as 'str';
end $$
delimiter ;

call mysql_test_repeat_loop(5);



