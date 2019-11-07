select user(), database();

create table product(
	code char(4) not null comment '코드',
	name varchar(20) not null comment '제품명',
	price int(11) not null comment '제품단가',
	primary key (code)
);

insert into product(code, name, price) values
('a001', '아메리카노', 5000),('a002', '카푸치노',3800),
('a003', '헤이즐넛', 5000),('a004', '에스프레소', 5000),
('b001', '딸기쉐이크', 5200),('b002', '후르츠와인', 4300),
('b003', '팥빙수', 8000),('b004', '아이스초코', 7000);

create table price_logs(
	id int(11) not null AUTO_INCREMENT,
	code char(4) not null,
	price int(11) not null,
	updated_at timestamp not null default CURRENT_TIMESTAMP on update current_timestamp,
	primary key (id),
	key code (code),
	constraint fk_price_logs foreign key(code) references product (code) on delete cascade on update cascade
);

delimiter $$
create trigger before_product_update
before update on product
for each row
begin
	insert into price_logs(code, price)
	values(old.code, old.price);
end $$
delimiter ;

update product
set price = 4500
where code = 'A001';

select * from product;
select * from price_logs;


create table user_change_logs (
	id int(11) not null auto_increment,
	code char(4) default null,
	updated_at timestamp not null default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	updated_by varchar(30) not null,
	primary key(id),
	key code (code),
	constraint fk_user_change_logs
		foreign key (code) references product(code)
		on delete cascade
		on update cascade
);


delimiter $$
create trigger before_product_update_2
	before update on product
	for each row follows before_product_update
BEGIN
	insert into user_change_logs(code, updated_by)
	values(old.code,user());
END $$
delimiter ;


update product
set price = 6000
where code = 'A002';

select * from product;

select * from price_logs;

select * from user_change_logs;

show triggers from mysql_study where `table` = 'product';

show triggers from mysql_study;

select TRIGGER_NAME, ACTION_ORDER, EVENT_OBJECT_TABLE, ACTION_TIMING, EVENT_MANIPULATION
	from information_schema.TRIGGERS
where trigger_schema = 'mysql_study'
order by EVENT_OBJECT_TABLE, ACTION_TIMING, EVENT_MANIPULATION;

-- 새로운 사원이 입사할 때마다, 사원의 급여가 1500000 미만인 경우에는 급여를 10% 인상하는 트리거를 작성하라.
-- 여기서 이벤트는 새로운 사원 투플이 삽입될 때, 조건은 급여<150000, 동작은 급여를 10% 인상하는 것입니다.

delimiter $$
create trigger tri_raise_salary
	before insert on employee
	for each row
BEGIN
	if(new.salary<1500000) THEN
 		set new.salary = new.salary * 1.1;
	end if;
END $$
delimiter ;

drop trigger tri_raise_salary;

show triggers;

select * from employee;

insert into employee values(4000, '김태희', '사원', 3011, 1400000, 2, 2);
delete from employee where empno = 4000;


create table high_salary as
	select empname, salary, title
	from employee
	where salary > 3000000;

select * from high_salary;


-- 새로운 사원이 입사할 때마다, 사원의 급여가 3000000 초과할 경우 high_salary에 empname, salary, title 정보를 추가하는 trigger를 작성하시오.

delimiter $$
create trigger tri_high_salary
	before insert on employee
	for each row
BEGIN
	if(new.salary>3000000) THEN
 		insert into high_salary values(new.empname, new.salary, new.title);
	end if;
END $$
delimiter ;

insert into employee values(1008, '에일리', '과장', 3011, 3100000, 3, 2);
select * from employee;
select * from high_salary;


-- 사원이 수정될 경우 high_salary 정보를 수정되거나, 삭제하는 trigger를 작성하시오.

delimiter $$
create trigger tri_employee_after_update_high_salary
	after update on employee
	for each row
BEGIN
	if(new.salary>3000000) THEN
 		update high_salary
 		set title = new.title, salary = new.salary
 		where empname = new.empname;
 	else
 		delete
 			from high_salary
 		where empname = new.empname;
	end if;
END $$
delimiter ;


-- 사원이 수정될 경우 hight_salary 정보를 수정되어 조건을 만족하는 경우, 추가하는 trigger를 작성하시오.
delimiter $$
create trigger tri_employee_before_update_high_salary
	before update on employee
	for each row
BEGIN
	if(new.salary>3000000) THEN
 		insert into high_salary values (new.empname, new.salary, new.title);
	end if;
END $$
delimiter ;


-- 사원이 수정될 경우 high_salary 정보를 조건에 따라 수정되거나, 삭제, 추가하는 trigger를 작성하시오
delimiter $$
create trigger tri_employee_after_update_high_salary
	before update on employee
	for each row
BEGIN
	if(old.salary>3000000) THEN
		if(new.salary>3000000) then 	
			update high_salary set salary = new.salary, title = new.title where empname = new.empname;
 		else
 			delete from high_salary where empname = new.empname;
 		end if;
 	else
 		if(new.salary>3000000) then
 			insert into high_salary values(new.empname, new.salary, new.title);
		end if;
	end if;
END $$
delimiter ;

drop trigger tri_employee_after_update_high_salary;


update employee set salary = 2900000 where empno = 1008;

select * from employee;
select * from high_salary;

update employee set salary =3900000, title = '과장' where empno = 1008;


-- 특정 데이터베이스의 모든 트리거를 검색
select *
	from information_schema.triggers
where TRIGGER_SCHEMA = 'mysql_study';

select *
	from information_schema.TRIGGERS
where trigger_schema = 'mysql_study'
and trigger_name = 'tri_before_employee_update';

select *
	from information_schema.triggers
where trigger_schema = 'mysql_study'
	and EVENT_OBJECT_TABLE = 'employee';




	
