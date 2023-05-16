--create user(database)

Create user test identified by 1234;

--Give Grant--
Grant dba to test;

--change password--
alter user test identified by 12345 replace 1234;

--connect again--

connect test/12345;

--create table--

create table Student(id number(10),
                     sname varchar2(20),
                     age number(2),
                     constraint student_pk primary key(id));

--insert row--

insert into Student values (101, 'Tom', 21);

--update record--

update Student set age=22 where sname = 'Tom';

--Delete record--

delete from Student where id = 101;

--clear table data--

truncate table Student;

--show table--

select * from Student;

--show table structure--

desc Student;

--add column in a table--

ALTER TABLE Student ADD department number;

--add primary key in existing table--

update Student add primary key(id);

-- drop column of a table--

alter table Student drop column department;

--rename column of a table--

alter table Student rename column sname to Student_name;