select user(), database();



-- cast
create table if not exists items (
	id int auto_increment PRIMARY key,
	item_no varchar(255) not null
);

insert into items(item_no)
	VALUES
	('1'), ('1c'),  ('11z'), ('10z'),
	('2a'), ('2'), ('3c'), ('20d');

select item_no
	from items
order by item_no;

select item_no
from items
order by cast(item_no as unsigned int), item_no;
-- order by cast(item_no as unsigned), item_no;

select * from items;

truncate table items;

insert into items(item_no)
	values	('A-2'),
			('A-1'),
			('A-3'),
			('A-4'),
			('A-5'),
			('A-10'),
			('A-11'),
			('A-20'),
			('A-30');
			
select item_no, id
	from items
order by id;

select item_no
	from items
order by item_no;

select item_no
	from items
order by length(item_no), item_no;

select item_no,cast(item_no as UNSIGNED int)
	from items
order by cast(item_no as UNSIGNED int);


select cast('ADF123' as UNSIGNED);

Select cast('123asd' as UNSIGNED);


