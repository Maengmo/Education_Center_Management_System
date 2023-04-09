select * from holiday

commit;

select count(*) from attendance;

select * from attendance;

-- 강의 스케줄
--1. 강의 예정
select 
    *
from Curriculum_list c
        where c.curriculum_list_Seq between 7 and 12;
--2. 강의 중
select 
    *
from Curriculum_list c
    inner join open_curs o
        on c.curriculum_list_seq = o.curriculum_list_seq;
--3. 강의 종료
select 
   c.curriculum_list_seq,
   c.curs_name
from Curriculum_list c
    left outer join open_curs o
        on c.curriculum_list_seq = o.curriculum_list_seq
            where open_curs_seq is null;
            
-- 강의실 상세 정보 출력
select 
   c.curriculum_list_seq as "과정번호",
   o.curs_name as "과정명",
   p.subject_seq as "과목번호",
   t.subject_name as "과목이름",
   p.begin_date as "과정기간(시작)",
   p.end_date as "과정기간(끝)",
   o.room_seq as "강의실",
   b.subject as "과목명",
   o.student_limit as "수강정원"
from curriculum_list c
    inner join open_curs o
        on c.curriculum_list_seq = o.curriculum_list_seq
            inner join student s
                on s.curriculum_list_seq = c.curriculum_list_seq
                    inner join open_subject p
                        on o.open_curs_seq = p.open_curs_seq
                            inner join subject t
                                on t.subject_seq = p.subject_seq
                                    inner join subject_book k
                                        on k.subject_seq = t.subject_seq
                                            inner join book b
                                                on k.book_seq = b.book_seq;
                                             
select 
    b.name as "교육생 이름",
    b.tel as  "전화번호",
    s.enroll_date as "등록일",
    drop_out as "현재상태"
from student s
         inner join member b
            on s.member_seq = b.member_seq;
            
select
    s.subject_seq as "강의 번호",
    j.subject_name as "강의 이름",
    s.score_attend as "출석 점수",
    s.score_writeTest as "필기 시험",
    s.score_realTest as "실기 시험"
from score s
    inner join subject j
        on s.subject_Seq = j.subject_seq;

select * from score;
insert into test values (83, 41, '필기 시험', 'firebase 필기 시험');

-- 과목번호, 과정명, 과정기간(시작 연월일, 끝 연월일), 강의실, 과목명, 과목기간(시작 연월일, 끝 연월일), 교재명, 출결, 필기, 실기 배점
select 
    o.subject_seq as "과목번호",
    c.curs_name as "과정명",
    c.begin_date as "과정기간(시작)",
    c.end_date as "과정기간(종료)",
    room_seq as "강의실",
    s.subject_name as "과목이름",
    o.begin_date as "과목시작일",
    o.end_date as "과목종료일",
    b.subject as "교재",
    e.score_attend as "출석점수",
    e.score_writeTest as "필기점수",
    e.score_realTest as "실기점수"
from subject s
    inner join open_subject o
        on s.subject_seq = o.subject_seq
            inner join open_curs c
                on c.open_curs_seq = o.open_curs_seq
                    inner join subject_book t
                        on t.subject_seq = s.subject_seq
                            inner join book b
                                on t.book_seq = b.book_seq
                                    inner join score e
                                        on e.subject_seq =s.subject_seq;
-- 강의를 마친 과정 -> 과목번호
select 
    subject_seq
from curriculum_subject
    where curriculum_list_seq = ( select
                                                s.curriculum_list_seq
                                            from student s
                                                where s.drop_out_date < sysdate
                                                    group by s.curriculum_list_seq
                                                        having s.curriculum_list_seq = 7) and subject_seq = 3;

select 
    s.subject_seq,
    t.teacher_seq,
    t.name,
    d.student_seq,
    m.name
from subject s
    inner join teaching_subject e
        on s.subject_seq = e.subject_seq
            inner join teacher t
                on t.teacher_seq = e.teacher_seq
                    inner join subject_score r
                        on r.subject_seq = s.subject_seq
                            inner join student d
                                on d.student_seq = r.student_seq
                                    inner join member m
                                        on d.member_seq = m.member_seq
                                            where s.subject_seq = 3/*과목번호*/ 
                                            and t.teacher_seq = 6/*선생번호*/ and d.student_seq = 5/*학생번호*/;

select 
    s.student_seq as "교육생 번호",
    m.name as "교육생 이름",
    s.drop_out as "현재 상태",
    c.attend_score as "출석 점수",
    c.test_writescore as "필기 점수",
    c.test_realscore as "실기 점수"
from student s
    inner join member m
        on s.member_seq = m.member_seq
            inner join subject_score c
                on s.student_seq = c.student_seq
                    where subject_seq = 3/*특정과목번호*/;

select 
    c.curriculum_list_seq as "과정번호",
    c.subject_seq as "과목번호",
    d.student_seq as "학생번호",
    a.attendance_date as "출석날짜"
from teaching_subject s
    inner join teacher t
        on s.teacher_seq = t.teacher_seq
            inner join curriculum_subject c
                on c.subject_seq = s.subject_seq
                    inner join subject_score e
                        on s.subject_seq = e.subject_seq
                            inner join student d
                                on e.student_seq = d.student_seq
                                    inner join attendance a
                                        on a.student_seq = d.student_seq
                                            where t.teacher_seq = 6 and a.attendance_date between '0223-01-01' and '2023-04-07';
    
select 
    c.curriculum_list_seq as "과정번호",
    d.student_seq as "학생번호",
    a.attendance_date as "출석날짜"
from teaching_subject s
    inner join teacher t
        on s.teacher_seq = t.teacher_seq
            inner join curriculum_subject c
                on c.subject_seq = s.subject_seq
                    inner join subject_score e
                        on s.subject_seq = e.subject_seq
                            inner join student d
                                on e.student_seq = d.student_seq
                                    inner join attendance a
                                        on a.student_seq = d.student_seq
                                            where t.teacher_seq = 6 and a.attendance_date between '0223-01-01' and '2023-04-07'
                                                and c.curriculum_list_seq =3 /*특정과정*/
                                                    and d.student_seq = 1; /* 특정인원 */ 
  
select *
from job_current;
select 
    s.student_seq as "학생번호",
    m.name as "이름",
    m.tel as "전화번호",
    j.job_field_seq as "분야 번호",
    f.field_name as "분야",
    j.company as "회사",
    j.hire_date as "고용날짜"
from job_current j
    inner join student s
        on j.student_seq = s.student_seq
            inner join member m
                on m.member_seq = s.member_seq
                    inner join job_field f
                        on f.job_field_seq = j.job_field_seq
                             where m.name = '학현정';

select 
    c.curriculum_list_seq as "과정번호",
    d.student_seq as "학생번호",
    a.attendance_date as "출석날짜"
from teaching_subject s
    inner join teacher t
        on s.teacher_seq = t.teacher_seq
            inner join curriculum_subject c
                on c.subject_seq = s.subject_seq
                    inner join subject_score e
                        on s.subject_seq = e.subject_seq
                            inner join student d
                                on e.student_seq = d.student_seq
                                    inner join attendance a
                                        on a.student_seq = d.student_seq
                                            inner join member m
                                                on m.member_seq = d.member_seq
                                                    and d.student_seq = 1; /* 특정인원 */ 
                                                    
CREATE TABLE Test_date(
    test_date_seq NUMBER PRIMARY KEY, /* 시험날짜번호 */
    open_curs_seq REFERENCES OPEN_CURS(open_curs_seq), /* 개설과정번호 */
    subject_seq REFERENCES SUBJECT(subject_seq) NOT NULL, /* 과목번호 */
    test_date DATE NOT NULL,/* 시험날짜 */
    quiz_seq NUMBER references QUIZ(quiz_seq) NOT NULL /* 퀴즈번호 */    
);                    
ALTER TABLE attendacne MODIFY attendance_date null;

commit;
insert into attendance values (5, 1, '2022-11-04');
update attendance set attendance_date = null where attendance_seq = 5;
select * from attendance;

select* from attendance_detail;

select 
    *
from attendance
    where student_seq = 31;
    
select
    *
from attendance_detail
    where check_in is null;