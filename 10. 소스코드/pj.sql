set serveroutput on;
drop sequence seqsub;
create sequence seqsub minvalue 42;
-- B.01 - 1. 과목명 관리(과목명을 등록 수정 조회 삭제)
--등록 전 조회
select * from subject; --42개
--등록
insert into Subject values (seqSub.nextVal, 'ComputerStudy');
--조회
select * from Subject; --43개


-- B.02
-- 새로운 과목(42)를 위해 교사 정보 등록(교사번호, 이름, 주민번호 뒷자리, 전화번호을 입력하여 교사정보를 등록)
select * from teacher; -- 교사 10명
insert into teacher values (12, '이동재', '1011111', '010-2222-4244');
-- 선생님이 강의 가능한 과목 배정
insert into teaching_subject values (12, 1);
insert into teaching_subject values (12, 2);
insert into teaching_subject values (12, 3);
insert into teaching_subject values (12, 4);
insert into teaching_subject values (12, 5);
insert into teaching_subject values (12, 43);

-- 선생님의 정보 출력
select 
    t.name as "이름",
    t.ssn as "주민번호뒷자리",
    t.tel as "전화번호",
    s.subject_name as "강의가능과목"
from teacher t
    inner join teaching_subject ts
        on t.teacher_seq = ts.teacher_seq
            inner join subject s
                on ts.subject_seq = s.subject_seq
                    where t.teacher_seq = 12;
/
select * from student;
                    
-- 교육생 정보 출력(VIEW)
SELECT * FROM student_scores_view;

-- B.05 교육생 검색해서 정보 출력
-- 호출
begin
student_select_p(5);
end;
/

-- B.06 시험 관리 특정 교육생 조회
--호출
BEGIN
  print_personal_score;
END;

-- B.07 기간별 출결

-- 1. 개설 과정 선택 시 모든 교육생의 출결을 조회할 수 있다.
-- 호출
BEGIN
    get_attendance_info(1);
END;

-- 2 기간별 출석 조회
-- 개설과정번호, 조회를 원하는 시작날짜,종료날짜 선택시 해당 기간 출석 내역을 조회 할 수 있다.
-- 호출
BEGIN
    get_attendance_date_info(4,'2023-03-30', '2023-03-31');
END;
/

-- D.02 출석 기록 (트리거)
--출석
--insert into attendance_detail(attendance_detail_seq, attendance_seq, check_in, check_out) 
--values (attendance_detatil_seq.nextVal, p_attendance_seq, p_check_in, p_check_out);

--호출
-- 결석시 벌점 점수 증가
begin
    attendance_detail_insert_p(52083, null, null);
end;
/
select * from student;


-- B.8 면접
select * from member;
-- 지원생 등록
-- insert into Member(member_seq,name,ssn,tel) values(p_member_seq, p_name, p_ssn, p_tel);
--insert into Interview(interview_seq,member_seq,motive,enroll_subject) values(p_interview_seq, p_member_seq, p_motive, p_enroll_subject);
-- 호출
begin
    MemberInterview_insert_p(1001,'학동현',7777777,'010-7777-7777',1001,'취업','메타버스 플랫폼 개발자 양성 과정');
end;
/

select count(*) from member;
select * from interview where interview_Seq = 1001;

-- 지원생 선발
--insert into Student(student_seq,curriculum_list_seq,enroll_date,drop_out,drop_out_date,member_seq) values(p_seq, p_curriculum_list_seq, p_enroll_date, p_drop_out, p_drop_out_date, p_member_seq);
begin
    Student_insert_p(501,7,'2023-04-11','수강예정',null,1001);
end;
/
select * from student;


-- B.09 선택과정 상담 조회
-- 개설과정 번호 선택시 해당 과정 상담목록을 출력한다
-- open_curs_seq 받아야함

--호출
BEGIN
  counsel_select_p(4);
END;

-- B.10 교재 관리 교재 조회 교재 등록
select * from book;
select * from subject_book;

-- 교재등록
insert into book values (42,'진짜 수학 공부법', '류승재', '경향BP','2023');
select * from book;

-- 개설과목에 교재등록시 전체 교재 목록에서 선택해서 추가
-- insert into Subject_Book(subject_seq,book_seq) values (p_subject_seq, p_book_seq); 
-- 호출
begin
    Subject_Book_insert_p(42,42);
end;
/
select * from Subject_Book where book_seq = 42;



-- D.04 취업활동 등록 (교육생)
--update job_current 
  --  set 
    --    JOB_FIELD_SEQ = pjob_field_seq, 
      --  company= pcompany, 
       -- hire_date=phire_date
    --where student_seq = pstudent_seq;

-- 호출
select * from job_current;

begin
    job_current_update(5,82,'요기요',sysdate);
end;

select * from job_current;

-- B.11
--  관리자는 취업현황에 대한 재취업 지원 시스템을 제공하기 위해 미취업 교육생 목록을 열람할 수 있다(수료후 12월 이내의 교육생들에 한해서)
-- 호출
BEGIN
    job_needed_select_p;
END;




-- B.12 
-- 협력기업 등록
-- INSERT into job_announce VALUES (jobannounceSeq.nextVal, pcity, pjob_field, pcontract_type, pcompany, ppeople, pbegindate, penddate);
drop sequence jobannounceSeq;
create sequence jobannounceSeq minvalue 23;
-- 호출
begin
    job_announce_insert_p(4,2,1,'요기요',9,'2023-03-30','2023-11-29');
end;

-- 협력기업 조회
-- 호출
BEGIN
    job_announce_select_p;
END;
/

-- C.01 교육생 정보
-- 강의 스케줄 조회
--1. 강의 예정
begin
     curriculum_info;
end;
--2. 강의 중
begin
     open_curs_info;     
end;
--3. 강의 종료
begin
     no_open_curs; 
end;


select * from score;
select * from test;
-- C.02 배점 입력 (트리거와같이)
-- 교사는 특정 과목을 선택하고 해당 과목의 배점 정보를 출결, 필기, 실기로 구분해 등록할 수 있어야 한다 
-- (출결은 최소 20점 이상이어야 하고, 출결, 필기, 실기의 합은 100점이 되도록 한다)
-- INSERT INTO score VALUES (score_seq.nextVal, psubject, pattend, pwritetest, prealtest);

-- 호출
-- 실패
BEGIN
    score_insert_p(42, 31, 31, 31);
END;

--성공
BEGIN
    score_insert_p(42, 33, 33, 34);
END;

-- D.01 성적조회 (로그인한학생주민번호입력)
--호출            

begin
    student_private_score(1088989);
end;


-- C.05 상담일지등록 (트리거)
-- insert into counsel values (cnsl_seq.nextVal, pteacher_seq, pstudent_seq, pcounsel_topic_seq, pcounsel_date, pcounsel_text);

--호출
--실패
begin
    counsel_insert(1,31,7,sysdate,'취업에 대한 상담 진행');
end;

--성공
begin
    counsel_insert(1,29,7,sysdate,'취업에 대한 상담 진행');
end;

select * from counsel;

-- D.03 교육생 상담일지 조회(학생번호입력)

-- 호출
begin
    counsel_info_p(2);
end;



-- C.07 추천 도서 등록
--insert into comment_book(comment_book_seq, subject_seq, teacher_seq, book_name) 
--values (cbook_seq.nextVal, p_subject_seq, p_teacher_seq, p_book_name);

-- 호출
begin
    comment_book_insert_p(11,2,'C언어의 정석');
end;

select * from comment_book;

-- D.05 교사 추천도서 조회 (과목번호입력)

-- 호출    
begin
    recommend_book(5);
end;  





-- D.06 만남의 광장 게시판
-- 게시판 등록
-- insert into Board(Board_seq, student_seq, Board_title, Board_content) 
-- values (board_seq.nextVal, p_student_seq, p_board_title, p_board_content);

--호출
begin
    Board_insert_p(13,'어떤 언어로 시작해야 될까요?', '어떤 언어가 가장 인기가 많은가요?');
end;

select * from Board;

-- 게시판 답글등록
-- insert into Board_Reply (reply_seq, Board_seq, student_seq, reply_content) values (boardreplyseq.nextVal, pBoard_seq, pstudent_seq, preply_content);

--호출
begin
    Board_Reply_insert(13,13,'자바를 공부하는게 좋을 것 같습니다!');
end;

select * from Board_Reply;

-- D.07 달란트 시장 (트리거)
-- 상품구매
select * from prize;

select * from point;

select * from student_prize_list;


--실패
insert into student_prize_list values (2,3);
--성공
insert into student_prize_list values (4,5);



