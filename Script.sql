select user(), database();

show databases;

drop database if exists coffee2;

create database if not exists coffee2;

use coffee2;

drop table if exists sale;
drop table if exists product;

create table if not exists product(
	code char(4) not null,
	name varchar(20),
	primary key(code)
);


create table if not EXISTS sale(
	no int AUTO_INCREMENT,
	code char(4) not null,
	price int not null,
	saleCnt int not null,
	marginRate int not null,
	primary key (no),
	foreign key (code) REFERENCES product(code)
);


-- 삽입 불가능 참조 무결성 제약조건 위배
insert into sale(no, code, price, saleCnt, marginRate) VALUES(1, 'A001', 4500, 20, 10);

insert into product values('A001', '아메리카노');
insert into product VALUES
('A002', '카푸치노'),
('A003', '헤이즐넛'),
('A004', '에스프레소'),
('B001', '딸기쉐이크'),
('B002', '후르츠와인'),
('B003', '팥빙수'),
('B004', '아이스초코');


select * 
	from product;

-- 삽입 가능(product 테이블에 'A001' 항목이 존재하기 때문에)
insert into sale(no, code, price, saleCnt, marginRate) VALUES(1, 'A001', 4500, 20, 10);
insert into sale(code, price, saleCnt, marginRate) 
	VALUES('A002', 3800, 140, 15), ('B001', 5200, 250, 12), ('B002', 4300, 110, 11);

select *
	from sale;

update sale
	set saleCnt=150
 where no = 1;

SELECT *
	from product join sale; -- 카티션 프로덕트
	
select *
	from product join sale on product.code = sale.code;
	
select *
	from product p, sale s
	where p.code=s.code;