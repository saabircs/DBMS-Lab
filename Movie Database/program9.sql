create database movie;
use movie;

create table actor(
act_id int,
act_name varchar(20),
act_gender char(1),
primary key(act_id));
desc actor;

create table director(
dir_id int,
dir_name varchar(20),
dir_phone int(10),
primary key(dir_id));
desc director;

alter table director
modify column dir_phone bigint;
desc director;

create table movies(
mov_id int,
mov_title varchar(25),
mov_year int,
mov_lang varchar(12),
dir_id int,
primary key(mov_id),
foreign key(dir_id) references director(dir_id));
desc movies;

create table movie_cast(
act_id int,
mov_id int,
role varchar(10),
primary key(act_id,mov_id),
foreign key(act_id) references actor(act_id),
foreign key(mov_id) references movies(mov_id));
desc movie_cast;


create table rating(
mov_id int,
rev_stars varchar(25),
primary key(mov_id),
foreign key(mov_id) references movies(mov_id));
desc rating;

insert into actor values(301,'ANUSHKA','F'); 
insert into actor values (302,'PRABHAS','M'); 
insert into actor values(303,'PUNITH','M'); 
insert into actor values(304,'JERMY','M'); 
commit;
select * from actor;

insert into director values(60,'RAJAMOULI', 8751611001); 
insert into director values(61,'HITCHCOCK', 7766138911); 
insert into director values(62,'FARAN', 9986776531); 
insert into director values(63,'STEVEN SPIELBERG', 8989776530); 
commit;
select * from director;

insert into movies values(1001,'BAHUBALI-2', 2017, 'TELAGU', 60); 
insert into movies values(1002,'BAHUBALI-1', 2015, 'TELAGU', 60); 
insert into movies values(1003,'AKASH', 2008, 'KANNADA', 61); 
insert into movies values(1004,'WAR HORSE', 2011, 'ENGLISH', 63); 
commit;
select * from movies;

insert into movie_cast values(301, 1002, 'HEROINE'); 
insert into movie_cast values(301, 1001, 'HEROINE'); 
insert into movie_cast values(303, 1003, 'HERO');
insert into movie_cast values(303, 1002, 'GUEST'); 
insert into movie_cast values(304, 1004, 'HERO'); 
commit;
select * from movie_cast;

insert into rating values(1001, 4); 
insert into rating values(1002, 2);
insert into rating values(1003, 5); 
insert into rating values(1004, 4);
commit;
select * from rating;



-- Query 1

select mov_title from movies m where dir_id=(select dir_id from director where dir_name='Hitchcock');

select mov_title from movies m,director d where m.dir_id=d.dir_id and d.dir_name='Hitchcock';

-- Query 2

select m.mov_title
from movies m, movie_cast mc
where m.mov_id=mc.mov_id
and mc.act_id in( select act_id from movie_cast group by act_id having count(act_id)>1)
group by mov_title
having count(*)>1;

select m.mov_title from movies m,movie_cast mc where m.mov_id=mc.mov_id
and mc.act_id in(select act_id from movie_cast group by act_id having count(act_id)>1)
group by mov_title having count(*)>1;

-- Query 3

select act_name,mov_title,mov_year from actor a join movie_cast mc on a.act_id=mc.act_id join movies m on m.mov_id
=mc.mov_id where m.mov_year not between 2005 and 2015;

-- Query 4

select mov_title,max(rev_stars)
from movies 
inner join rating using(mov_id)
group by mov_id
having max(rev_stars)>0
order by mov_title;

select mov_title,max(rev_stars) from movies m,rating r
where m.mov_id=r.mov_id group by r.mov_id having max(rev_stars)>0 order by mov_title;

-- Query 5

update rating set rev_stars=5 
where mov_id in(select mov_id from movies where dir_id in(select dir_id from director where dir_name='Steven Spielberg'));
select *from rating;

