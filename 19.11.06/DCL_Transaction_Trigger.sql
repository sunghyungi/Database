select user(), database();

-- 격리 수준 확인
select @@global.transaction_isolation, @@transaction_isolation;

-- 격리 수준 변경 ( session, global )
set session transaction isolation level serializable;
set session transaction isolation level REPEATABLE READ;

-- root만 가능
set global transaction isolation level serializable;

create table tbl(
	id INT NOT NULL AUTO_INCREMENT,
	col int not null,
	PRIMARY KEY (id)
) Engine = InnoDB;

-- 4
select connection_id();

select * from tbl;

insert into tbl(col) values(10);

-- read lock
lock table tbl read;

insert into tbl(col) values(11);

unlock tables;


-- write lock
lock table tbl write;

select * from tbl;
insert tbl(col) values(31);

unlock tables;


-- commit/rollback

select @@autocommit;

set autocommit = 0;
set autocommit = 1;

-- autocommit = 0 인 상태 (rollback 가능)
select * from employee;

update employee
	set title = '대리'
where empno = 1003;

select * from employee;

-- commit 없이 rollback (돌아감)
rollback;

update employee
	set title = '과장'
where empno = 1004;

commit;
select * from employee;
-- commit 후 rollback (돌아가지 않음)
rollback;

-- procedure

select * from employee;
select * from department;

drop procedure if exists proc_transaction;
delimiter $$
create procedure proc_transaction()
BEGIN
	declare err int default 0;
	declare continue handler for SQLEXCEPTION
	begin
		show errors;
		set err = -1;
	end;
	
	set autocommit = 0;	
-- 	select @@autocommit;
	start transaction;

	insert into department values(5, '마케팅', 10);
	insert into employee values(1010, '천사', '부장', 4377, 4000000, 3, 1);
	select err;
	
	if err < 0 THEN
		select 'rollback';
		rollback;
	else
		select 'commit';
		commit;
	end if;
	set autocommit = 1;
-- 	select @@autocommit;
END $$
delimiter ;

call proc_transaction();

select * from department;
delete from department where deptno = 5;

select * from employee where empno = 1010;
delete from employee where empno = 1010;

insert into department values(5, '마케팅', 10);
insert into employee values(1010, '천사', '부장', 4377, 4000000, 3, 1);



-- savepoint

set autocommit = false;
savepoint aa;

insert into employee values(1011, '악마', '대리', 4377, 3500000, 3, 1);
savepoint bb;

update employee
set salary = 4000000
	where empno = 1011;
savepoint cc;

delete
	from employee
where empno = 1011;
savepoint dd;

rollback to dd;
select * from employee;

rollback to cc;
select * from employee;

rollback to bb;
select * from employee;

rollback to aa;
select * from employee;

set autocommit = true;



-- trigger
drop table employee_audit;
create table employee_audit (
	id int auto_increment primary key,
	empno varchar(40) not null,
	empname varchar(40) not null,
	changedate datetime default null,
	action varchar(40) default null
);

show triggers from mysql_study;


-- insert trigger

delimiter $$
create trigger tri_after_employee_insert
	after insert on employee
	for each row
begin
		insert into employee_audit values
		(null, new.empno, new.empname, now(), 'insert');  -- 로그 형성
end $$
delimiter ;

select  * from employee;

insert into employee values(1012, '천사2', '사원', 3011, 1500000, 3, 2);

select * from employee where empno = 1012;

select * from employee_audit;


-- update trigger

drop trigger tri_before_employee_update;

delimiter $$
create trigger tri_before_employee_update
	before update on employee
	for each row
begin
	insert into employee_audit values
	(null, concat(old.empno, '->', new.empno), concat(old.empname, '->', new.empname), now(), concat('update from ',user()));
end $$
delimiter ;

select * from employee;

update employee set empname = '아이유', empno = 1111
	where empno = 1012;

select * from employee where empno = 1111;

select * from employee_audit;


show triggers;


-- delete trigger

delimiter $$
create trigger tri_before_employee_delete 
	before delete on employee
	for each row
begin
	insert into employee_audit values
	(null, old.empno, old.empname, now(), concat('delete from ', substring_index(user(),'@',1)));
end $$
delimiter ;


delete from employee where empno = 1111;

select * from employee where empno = 1111;

select * from employee_audit;

show triggers;




























