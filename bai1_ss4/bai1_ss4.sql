drop database if exists quan_ly_sinh_vien_a;
create database if not exists quan_ly_sinh_vien_a;
use quan_ly_sinh_vien_a;

create table classes(
class_id int not null auto_increment primary key,
class_name varchar(60) not null,
start_date date not null,
status bit

);

create table student(
student_id int not null auto_increment primary key,
student_name varchar(30) not null,
address varchar(50),
phone varchar(20),
status_s bit,
class_id int not null,
foreign key (class_id) references classes (class_id)

);
create table subject_s(
sub_id int not null auto_increment primary key,
sub_name varchar (30) not null,
credit tinyint not null default 1 check (credit >=1 ),
status bit default 1
);
create table mark(
mark_id int not null auto_increment primary key,
sub_id int not null ,
student_id int not null,
mark_s float default 0 check (mark_s between 0 and 100),
exam_times tinyint default 1,
foreign key (sub_id) references subject_s (sub_id),
foreign key (student_id) references student(student_id)
);
insert into classes
values(1,'A1', '2008-12-20',1);
insert into classes
values (2,'A2','2008-12-22',1);
insert into classes
values (3,'B3', current_date(),0);
insert into student (student_name,address,phone,status_s,class_id)
values ('Hung','Ha Noi',0123456789,1,1);
insert into student (student_name,address,status_s,class_id)
values ('Hoa','Sai Gon',1,1);
insert into student (student_name,address,phone,status_s,class_id)
values ('Manh','Hue',0147258369,0,2);
insert into student (student_name,address,phone,status_s,class_id)
values ('Hai','Ha Noi',0227258369,0,1);
insert into subject_s
values (1,'CF',5,1),
(2,'C',6,1),
(3,'HDJ',5,1),
(4,'RDBMS',5,1);
insert into mark (sub_id,student_id,mark_s,exam_times)
values (1,1,15,1),
(1,2,10,2),
(2,1,20,1);


-- Hiển thị số lượng sinh viên ở từng nơi
select count(student.student_id) as so_luong_sv, address
from student
group by address;
-- Tính điểm trung bình các môn học của mỗi học viên
select avg(mark.mark_s) as diem_trung_binh, student.student_name
from mark
join student on mark.student_id = student.student_id
group by student.student_name;
-- Hiển thị những bạn học viên co điểm trung bình các môn học lớn hơn 15
select avg(mark.mark_s) as diem_trung_binh, student.student_name
from mark
join student on mark.student_id = student.student_id
group by student.student_name
having diem_trung_binh > 15;
-- Hiển thị thông tin các học viên có điểm trung bình lớn nhất.
select avg(mark.mark_s) as diem_tb, student.student_name
from mark
join student on mark.student_id = student.student_id
group by student.student_name
having diem_tb > all(select avg(mark.mark_s) as diem_tb
from mark
join student on mark.student_id = student.student_id);
-- Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
SELECT  * FROM subject_s
WHERE credit = (SELECT 
            MAX(credit)
        FROM subject_s);

-- Hiển thị các thông tin môn học có điểm thi lớn nhất.
SELECT 
    subject_s.*
FROM subject_s
	JOIN mark ON subject_s.sub_id = mark.sub_id
WHERE mark_s IN (SELECT 
            MAX(mark_s)
        FROM mark);

-- Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, 
-- xếp hạng theo thứ tự điểm giảm dần
SELECT student.*, AVG(mark_s) AS avg_mark
FROM student JOIN
    mark ON student.student_id = mark.student_id
GROUP BY student.student_id , student.student_name
ORDER BY avg_mark DESC;