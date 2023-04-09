create or replace procedure curriculum_list_delete_p(p_seq in curriculum_list.seq%type)
is
begin
   delete from curriculum_list
   where p_seq = seq;
   commit;
end c_delete_p;

create or replace procedure subject_delete_p(p_seq in subject.seq%type)
is
begin
   delete from subject
   where p_seq = seq;
   commit;
end subject_delete_p;

create or replace procedure room_delete_p(p_seq in room_seq%type)
is
begin
   delete from room
   where p_seq = seq;
   commit;
end l_delete_p;

create or replace procedure book_delete_p(p_seq in book.book_seq%type)
is
begin
   delete from book
   where p_seq = seq;
   commit;
end book_delete_p;

create or replace procedure teacher_delete_p(p_seq in teacher.teacher_seq%type)
is
begin
   delete from teacher
   where p_seq = seq;
   commit;
end teacher_delete_p;

create or replace procedure curriculum_list_delete_p(p_seq in curriculum_list.curriculum_list_seq%type)
is
begin
   delete from curriculum_list
   where p_seq = seq;
   commit;
end teacher_delete_p;

create or replace procedure student_update_p(p_seq in sutdent.student_student_seq%type)
is
begin
   update student set drop_out = '수료완료', drop_out_date = sysdate
   where p_seq = seq;
   commit;
end teacher_delete_p;

CREATE OR REPLACE PROCEDURE curriculum_subject_delete_p (
   p_seq IN NUMBER
)
IS
BEGIN
   DELETE FROM curriculum_subject
   WHERE sequence_number = p_seq;
   COMMIT;
END curriculum_subject_delete_p;

CREATE OR REPLACE PROCEDURE student_find_p(p_seq IN student.student_seq%type)
IS
    v_curs_name  open_curs.curs_name%type;
    v_begin_date open_curs.begin_date%type;
    v_end_date   open_curs.end_date%type;
    v_room_name  room.room_name%type;
    v_drop_out   student.drop_out%type;
    v_drop_out_date student.drop_out_date%type;
BEGIN
    SELECT oc.curs_name, oc.begin_date, oc.end_date, r.room_name, st.drop_out, st.drop_out_date
    INTO v_curs_name, v_begin_date, v_end_date, v_room_name, v_drop_out, v_drop_out_date
    FROM member mb
    INNER JOIN student st ON mb.member_seq = st.member_seq
    INNER JOIN enrollment en ON mb.member_seq = en.member_seq
    INNER JOIN open_curs oc ON en.open_curs_seq = oc.open_curs_seq
    INNER JOIN room r ON oc.room_seq = r.room_seq
    WHERE st.student_seq = p_seq;
    
    DBMS_OUTPUT.PUT_LINE('과정명: ' || v_curs_name);
    DBMS_OUTPUT.PUT_LINE('과정기간(시작): ' || v_begin_date);
    DBMS_OUTPUT.PUT_LINE('과정기간(끝): ' || v_end_date);
    DBMS_OUTPUT.PUT_LINE('강의실: ' || v_room_name);
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || v_drop_out);
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 날짜: ' || v_drop_out_date);
END student_find_p;

DECLARE
    p_seq student.student_seq%TYPE := 5;
BEGIN
    student_find_p(p_seq);
END;
/


CREATE OR REPLACE PROCEDURE student_list_by_curriculum_p (
    p_curriculum_list_seq IN curriculum_list.curriculum_list_seq%TYPE,
    p_name OUT member.name%TYPE,
    p_ssn OUT member.ssn%TYPE,
    p_tel OUT member.tel%TYPE,
    p_drop_out OUT student.drop_out%TYPE
)
IS
BEGIN
    SELECT mb.name, mb.ssn, mb.tel, st.drop_out
    INTO p_name, p_ssn, p_tel, p_drop_out
    FROM curriculum_list cl
    INNER JOIN student st ON cl.curriculum_list_seq = st.curriculum_list_seq
    INNER JOIN member mb ON st.member_seq = mb.member_seq
    WHERE cl.curriculum_list_seq = p_curriculum_list_seq
    AND ROWNUM = 1;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('해당 과정 번호에 해당하는 교육생이 존재하지 않습니다.');
END student_list_by_curriculum_p;

DECLARE
    v_name member.name%TYPE;
    v_ssn member.ssn%TYPE;
    v_tel member.tel%TYPE;
    v_drop_out student.drop_out%TYPE;
BEGIN
    student_list_by_curriculum_p(p_curriculum_list_seq => 1,
                                 p_name => v_name,
                                 p_ssn => v_ssn,
                                 p_tel => v_tel,
                                 p_drop_out => v_drop_out);
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || v_ssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || v_tel);
    DBMS_OUTPUT.PUT_LINE('교육이수여부: ' || v_drop_out);
END;

CREATE OR REPLACE PROCEDURE student_list_by_curriculum_p(
    p_curriculum_list_seq IN curriculum_list.curriculum_list_seq%TYPE,
    p_names OUT SYS.ODCIVARCHAR2LIST,
    p_ssns OUT SYS.ODCIVARCHAR2LIST,
    p_tels OUT SYS.ODCIVARCHAR2LIST,
    p_drop_outs OUT SYS.ODCIVARCHAR2LIST
)
IS
BEGIN
    SELECT mb.name, mb.ssn, mb.tel, st.drop_out
    BULK COLLECT INTO p_names, p_ssns, p_tels, p_drop_outs
    FROM curriculum_list cl
    INNER JOIN student st ON cl.curriculum_list_seq = st.curriculum_list_seq
    INNER JOIN member mb ON st.member_seq = mb.member_seq
    WHERE cl.curriculum_list_seq = p_curriculum_list_seq;
END student_list_by_curriculum_p;

DECLARE
    names SYS.ODCIVARCHAR2LIST;
    ssns SYS.ODCIVARCHAR2LIST;
    tels SYS.ODCIVARCHAR2LIST;
    drop_outs SYS.ODCIVARCHAR2LIST;
BEGIN
    student_list_by_curriculum_p(1, names, ssns, tels, drop_outs);
    
    FOR i IN 1..names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || names(i));
        DBMS_OUTPUT.PUT_LINE('SSN: ' || ssns(i));
        DBMS_OUTPUT.PUT_LINE('Tel: ' || tels(i));
        DBMS_OUTPUT.PUT_LINE('Drop Out: ' || drop_outs(i));
    END LOOP;
END;

create or replace procedure comment_book_insert_p (
    p_subject_seq in comment_book.subject_seq%type,
    p_teacher_seq in comment_book.teacher_seq%type,
    p_book_name in comment_book.book_name%type
)
is

begin
    
    insert into comment_book(comment_book_seq, subject_seq, teacher_seq, book_name) 
        values (cbook_seq.nextVal, p_subject_seq, p_teacher_seq, p_book_name);
        
        commit;
        
        dbms_output.put_line('insert success');

end comment_book_insert_p;
DECLARE
  v_subject_seq comment_book.subject_seq%TYPE := 123;
  v_teacher_seq comment_book.teacher_seq%TYPE := 456;
  v_book_name comment_book.book_name%TYPE := 'My Book';
BEGIN
  comment_book_insert_p(
    p_subject_seq => v_subject_seq,
    p_teacher_seq => v_teacher_seq,
    p_book_name => v_book_name
  );
END;

CREATE OR REPLACE PROCEDURE comment_book_update_p(
  p_comment_book_seq comment_book.comment_book_seq%TYPE,
  p_book_name comment_book.book_name%TYPE
) IS
BEGIN
  UPDATE comment_book
  SET book_name = p_book_name
  WHERE comment_book_seq = p_comment_book_seq;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Update success');
END comment_book_update_p;

BEGIN
  comment_book_update_p(p_comment_book_seq => 121, p_book_name => '자바 개론');
END;

CREATE OR REPLACE PROCEDURE comment_book_delete_p(
     p_comment_book_seq comment_book.comment_book_seq%TYPE
)
IS
BEGIN
    delete from comment_book where comment_book_seq = p_comment_book_seq;
    commit;
END comment_book_delete_p;

DECLARE
   v_comment_book_seq comment_book.comment_book_seq%TYPE := 10;
BEGIN
  comment_book_delete_p(
    p_comment_book_seq => v_comment_book_seq
  );
END;

CREATE OR REPLACE PROCEDURE comment_book_select_p
IS
BEGIN
  FOR c IN (
    SELECT subject_seq, teacher_seq, book_name
    FROM comment_book
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('과목번호: ' || c.subject_seq || ', 교사번호: ' || c.teacher_seq || ', 책제목: ' || c.book_name);
  END LOOP;
END comment_book_select_p;
    
BEGIN
  comment_book_select_p;
END;

CREATE OR REPLACE PROCEDURE board_select_p
IS
BEGIN
    FOR c IN (
    SELECT b.board_seq, b.student_seq, b.board_title, b.board_content, br.reply_seq, br.student_seq AS reply_student_seq, br.reply_content
    from board b
        inner join board_reply br on b.board_seq = br.board_seq
  )
  LOOP
  DBMS_OUTPUT.PUT_LINE('게시물번호: ' || c.board_seq || ', 교육생번호: ' || c.student_seq || ', 게시글 제목: ' || c.board_title || ', 게시글 본문: ' || c.board_content  || ', 댓글번호: ' || c.reply_seq  || ', 교육생번호(댓글): ' || c.reply_student_seq  || ', 댓글내용: ' || c.reply_content);
  END LOOP;
END board_select_p;

begin
    board_select_p;
end;

set serveroutput on;

CREATE OR REPLACE PROCEDURE board_update_p (
    p_board_seq board.board_seq%type,
    p_board_title board.board_title%type
)
IS
BEGIN
    update board
    set board_title = p_board_title
    where board_seq = p_board_seq;
    
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('Update success');
END board_update_p;

BEGIN
  board_update_p(p_board_seq => 13, p_board_title => '수정할 제목');
END;

CREATE OR REPLACE PROCEDURE board_delete_p (
    p_board_seq board.board_seq%type
)
IS
BEGIN
    delete from board where board_seq = p_board_seq;
    commit;
END board_delete_p;
DECLARE
   v_board_seq board.board_seq%TYPE := 10;
BEGIN
  board_delete_p(
    p_board_seq => v_board_seq
  );
END;

CREATE OR REPLACE PROCEDURE curriculum_list_delete_p(
    p_seq IN curriculum_list.curriculum_list_seq%TYPE
)
IS
BEGIN
   DELETE FROM curriculum_list
   WHERE curriculum_list_seq = p_seq;
   COMMIT;
END curriculum_list_delete_p;

create or replace procedure subject_delete_p(p_seq in subject.subject_seq%type)
is
begin
   delete from subject
   where subject_seq = p_seq;
   commit;
end subject_delete_p;

create or replace procedure room_delete_p(p_seq in room.room_seq%type)
is
begin
   delete from room
   where room_seq = p_seq;
   commit;
end room_delete_p;

CREATE OR REPLACE PROCEDURE book_delete_p (
    p_seq in book.book_seq%type
)
is
begin
   delete from book
   where book_seq = p_seq;
   commit;
end book_delete_p;

create or replace procedure teacher_delete_p(
    p_teacher_seq in teacher.teacher_seq%type)
is
begin
   delete from teacher
   where teacher_seq = p_teacher_seq;
   commit;
end teacher_delete_p;

CREATE OR REPLACE PROCEDURE open_curs_delete_p(p_seq in open_curs.open_curs_seq%type)
is
begin
   delete from open_curs
   where open_curs_seq = p_seq;
   commit;
end open_curs_delete_p;

create or replace procedure curriculum_subject_delete_p(
    p_curriculum_list_seq in curriculum_subject.curriculum_list_seq%type
)
is
begin
   delete from curriculum_subject
   where curriculum_list_seq = p_curriculum_list_seq;
   commit;
end curriculum_subject_delete_p;
/
commit;
CREATE SEQUENCE attendance_seq
minvalue 52078;

select count(*) from attendance;

CREATE OR REPLACE PROCEDURE attendance_insert_p (
    p_student_seq attendance.student_seq%type
)
IS
BEGIN
   insert into attendance(attendance_seq, student_seq, attendance_date) 
        values (attendance_seq.nextVal, p_student_seq, sysdate);
        
        commit;
        
        dbms_output.put_line('insert success');

END attendance_insert_p;

DECLARE
    v_student_seq attendance.student_seq%type := 1234; -- 예시로 학생 번호 1234를 사용합니다.
BEGIN
    attendance_insert_p(p_student_seq => v_student_seq);
END;

select * from attendance_detail;
create sequence attendance_detatil_seq
minvalue 52023;

CREATE OR REPLACE PROCEDURE attendance_detail_insert_p (
    p_attendance_seq attendance_detail.attendance_seq%type,
    p_check_in attendance_detail.check_in%type,
    p_check_out attendance_detail.check_out%type
)
IS
BEGIN
   insert into attendance_detail(attendance_detail_seq, attendance_seq, check_in, check_out) 
        values (attendance_detatil_seq.nextVal, p_attendance_seq, p_check_in, p_check_out);
        
        commit;
        
        dbms_output.put_line('insert success');

END attendance_detail_insert_p;

declare
    l_attendance_seq attendance_detail.attendance_seq%type := 1001;
    l_check_in attendance_detail.check_in%type := to_date('09:00:52');
    l_check_out attendance_detail.check_out%type := to_date(null);
begin
    attendance_detail_insert_p(l_attendance_seq, l_check_in, l_check_out);
end;

CREATE OR REPLACE PROCEDURE attendance_detail_update_p (
    p_attendance_seq attendance_detail.attendance_seq%type,
    p_check_out attendance_detail.check_out%type
)
IS
BEGIN
     update attendance_detail
     set check_out = p_check_out
     where attendance_seq = p_attendance_seq;
        
        commit;
        
        dbms_output.put_line('update success');

END attendance_detail_update_p;

select count(*) from attendance_detail;
declare
    v_attendance_seq attendance_detail.attendance_seq%type := 52023;
    v_check_out attendance_detail.check_out%type := to_date('18:00:00');
begin
    attendance_detail_update_p(v_attendance_seq, v_check_out);
end;

CREATE OR REPLACE PROCEDURE get_attendance_date_p (
    p_student_seq IN attendance.student_seq%TYPE
)
IS
    CURSOR c_attendance_dates IS
        SELECT attendance_date
        FROM attendance
        WHERE student_seq = p_student_seq;
    l_attendance_date attendance.attendance_date%TYPE;
BEGIN
    FOR r_attendance_date IN c_attendance_dates LOOP
        l_attendance_date := r_attendance_date.attendance_date;
        DBMS_OUTPUT.PUT_LINE('Attendance Date: ' || TO_CHAR(l_attendance_date, 'YYYY-MM-DD'));
    END LOOP;
END;

DECLARE
    v_student_seq attendance.student_seq%TYPE := 123; -- 조회하고자 하는 학생 번호를 지정
BEGIN
    get_attendance_date_p(p_student_seq => v_student_seq);
END;

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE get_attendance_date2_p (
    p_student_seq IN attendance.student_seq%TYPE,
    p_year IN NUMBER,
    p_month IN NUMBER
)
IS
BEGIN
    FOR c IN (
        SELECT attendance_date
        FROM attendance
        WHERE student_seq = p_student_seq 
        AND attendance_date LIKE ('%' || p_year || '/' || LPAD(p_month, 2, '0') || '%')
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Attendance Date: ' || TO_CHAR(c.attendance_date, 'YY-MM-DD'));
    END LOOP;
END get_attendance_date2_p;

/
DECLARE
    v_student_seq attendance.student_seq%TYPE := 3;
    v_year NUMBER := 23;
    v_month NUMBER := 04;
BEGIN
    get_attendance_date2_p(p_student_seq => v_student_seq, p_year => v_year, p_month => v_month);
END;
/

CREATE OR REPLACE PROCEDURE get_attendance_date2_p (
    p_student_seq IN attendance.student_seq%TYPE,
    p_year IN NUMBER,
    p_month IN NUMBER
)
IS
BEGIN
    FOR c IN (
        SELECT attendance_date
        FROM attendance
        WHERE student_seq = p_student_seq 
        AND attendance_date LIKE ('%' || p_year || '/' || LPAD(p_month, 2, '0') || '%')
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Attendance Date: ' || TO_CHAR(c.attendance_date, 'YY-MM-DD'));
    END LOOP;
END get_attendance_date2_p;
/
select attendance_date from attendance where student_seq = 3  and to_char(attendance_date, 'yy') = 22 and to_char(attendance_date, 'mm') = '10' and to_char(attendance_date, 'dd') = 31;

CREATE OR REPLACE PROCEDURE get_attendance_date2_p (
    p_student_seq IN attendance.student_seq%TYPE,
    p_year IN NUMBER,
    p_month IN NUMBER,
    p_day IN NUMBER,
    p_result OUT VARCHAR2
)
IS
  v_attendance_date DATE;
BEGIN
  SELECT attendance_date INTO v_attendance_date
  FROM attendance
  WHERE student_seq = p_student_seq
  AND TO_CHAR(attendance_date, 'YYYY/MM/DD') = TO_CHAR(TO_DATE(p_year || '/' || p_month || '/' || p_day, 'YYYY/MM/DD'), 'YYYY/MM/DD');
    
  p_result := '출석' ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_result := '결석';
END;

DECLARE
  v_result VARCHAR2(10);
BEGIN
  get_attendance_date2_p(3, 2022, 10, 31, v_result);
  DBMS_OUTPUT.PUT_LINE(v_result);
END;

select count(*) from Board;
Create sequence board_seq
minvalue 13;

CREATE OR REPLACE PROCEDURE Board_insert_p(
    p_student_seq board.student_seq%type, 
    p_board_title board.board_title%type, 
    p_board_content board.board_content%type
)
IS
BEGIN 
    insert into Board(Board_seq, student_seq, Board_title, Board_content) values (board_seq.nextVal, p_student_seq, p_board_title, p_board_content);
    
    commit;
        
    dbms_output.put_line('insert success');
END Board_insert_p;

DECLARE
    v_student_seq board.student_seq%type := 1234; -- 적절한 값을 넣어줍니다.
    v_board_title board.board_title%type := '제목입니다'; -- 적절한 값을 넣어줍니다.
    v_board_content board.board_content%type := '내용입니다'; -- 적절한 값을 넣어줍니다.
BEGIN
    Board_insert_p(v_student_seq, v_board_title, v_board_content);
END;

CREATE OR REPLACE PROCEDURE Board_select_all_p
IS
BEGIN
    FOR rec IN (SELECT * FROM Board)
    LOOP
        dbms_output.put_line('Board_seq: ' || rec.Board_seq || ', Student_seq: ' || rec.Student_seq || ', Board_title: ' || rec.Board_title || ', Board_content: ' || rec.Board_content);
    END LOOP;
END;

BEGIN
    Board_select_all_p;
END;

CREATE OR REPLACE PROCEDURE board_update2_p (
    p_board_seq board.board_seq%type,
    p_board_content board.board_content%type
)
IS
BEGIN
    update board
    set board_content = p_board_content
    where board_seq = p_board_seq;
    
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('Update success');
END board_update2_p;

BEGIN
  board_update2_p(p_board_seq => 13, p_board_content => '수정할 내용');
END;


CREATE OR REPLACE PROCEDURE board_delete_p (
    p_board_seq board.board_seq%type
)
IS
BEGIN
    delete from board where board_seq = p_board_seq;
    commit;
END board_delete_p;

DECLARE
   v_board_seq board.board_seq%TYPE := 13;
BEGIN
  board_delete_p(
    p_board_seq => v_board_seq
  );
END;

CREATE OR REPLACE PROCEDURE job_current_update_p (
    p_board_seq board.board_seq%type,
    p_board_content board.board_content%type
)
IS
    
BEGIN
    update board
    set board_content = p_board_content
    where board_seq = p_board_seq;
    
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('Update success');
END board_update2_p;

CREATE OR REPLACE PROCEDURE curriculum_subject_print_p
IS
BEGIN
    FOR subject_record IN (SELECT * FROM curriculum_subject)
    LOOP
        DBMS_OUTPUT.PUT_LINE('CURRICULUM_LIST_SEQ: ' || subject_record.CURRICULUM_LIST_SEQ);
        DBMS_OUTPUT.PUT_LINE('SUBJECT_SEQ: ' || subject_record.SUBJECT_SEQ);
    END LOOP;
END curriculum_subject_print_p;

DECLARE
  -- 변수를 선언합니다.
  v_curriculum_list_seq NUMBER := 1;
BEGIN
  -- 프로시저를 호출합니다.
  curriculum_subject_print_p;
END;


CREATE OR REPLACE PROCEDURE update_student_drop_out_p (
  p_student_seq IN NUMBER
)
IS
BEGIN
  UPDATE student SET drop_out_date = SYSDATE WHERE student_seq = p_student_seq;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Student with ID ' || p_student_seq || ' has been marked as dropped out.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error updating drop out date for student with ID ' || p_student_seq || ': ' || SQLERRM);
END;

DECLARE
  v_student_seq NUMBER := 31;
BEGIN
  update_student_drop_out_p(v_student_seq);
END;
/
select quiz_seq as "퀴즈번호", quiz_title as "퀴즈제목", quiz_content as "퀴즈내용", subject_seq as "과목번호", quiz_answer as "정답번호" from quiz;

CREATE OR REPLACE PROCEDURE quiz_print_p
IS
BEGIN
FOR quiz_record IN (SELECT quiz_seq as "퀴즈번호", quiz_title as "퀴즈제목", quiz_content as "퀴즈내용", subject_seq as "과목번호", quiz_answer as "정답번호" FROM quiz)
LOOP
    DBMS_OUTPUT.PUT_LINE('퀴즈번호: ' || quiz_record."퀴즈번호");
    DBMS_OUTPUT.PUT_LINE('퀴즈제목: ' || quiz_record."퀴즈제목");
    DBMS_OUTPUT.PUT_LINE('퀴즈내용: ' || quiz_record."퀴즈내용");
    DBMS_OUTPUT.PUT_LINE('과목번호: ' || quiz_record."과목번호");
    DBMS_OUTPUT.PUT_LINE('정답번호: ' || quiz_record."정답번호");
    DBMS_OUTPUT.PUT_LINE('---------------------------');
END LOOP;
END quiz_print_p;
/
DECLARE
BEGIN
quiz_print_p;
END;
/

CREATE OR REPLACE PROCEDURE point_print_p(
    student_seq_in IN point.student_seq%TYPE
) AS
    point_record point%ROWTYPE;
BEGIN
    SELECT * 
    INTO point_record
    FROM point
    WHERE student_seq = student_seq_in;

    DBMS_OUTPUT.PUT_LINE('POINT_SEQ: ' || point_record.POINT_SEQ);
    DBMS_OUTPUT.PUT_LINE('STUDENT_SEQ: ' || point_record.STUDENT_SEQ);
    DBMS_OUTPUT.PUT_LINE('PPOINT: ' || point_record.PPOINT);
END point_print_p;
/
DECLARE
v_student_seq point.student_seq%TYPE := 10;
BEGIN
point_print_p(v_student_seq);
END;
/
CREATE OR REPLACE PROCEDURE teacher_info_print_p AS
BEGIN
    FOR t IN (
        SELECT t.name AS "이름", t.ssn AS "주민번호뒷자리", t.tel AS "전화번호", s.subject_name AS "강의가능과목"
        FROM teacher t
            INNER JOIN teaching_subject ts
                ON t.teacher_seq = ts.teacher_seq
                    INNER JOIN subject s
                        ON ts.subject_seq = s.subject_seq
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('이름: ' || t."이름");
        DBMS_OUTPUT.PUT_LINE('주민번호뒷자리: ' || t."주민번호뒷자리");
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || t."전화번호");
        DBMS_OUTPUT.PUT_LINE('강의가능과목: ' || t."강의가능과목");
        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
END teacher_info_print_p;

BEGIN
    teacher_info_print_p;
END;


CREATE VIEW course_scores AS
SELECT DISTINCT cl.curs_name as "과정명", oc.begin_date as "과정기간(시작)", oc.end_date as "과정기간(끝)", sj.subject_name as "과목명", t.name as "교사명", b.subject as "교재명", mb.name as "교육생 이름", mb.ssn as "주민번호 뒷자리", ss.test_writescore as "필기", ss.test_realscore as "실기"
FROM open_subject os
    INNER JOIN subject sj ON sj.subject_seq = os.subject_seq
    INNER JOIN curriculum_subject cs ON sj.subject_seq = cs.subject_seq
    INNER JOIN curriculum_list cl ON cs.curriculum_list_seq = cl.curriculum_list_seq
    INNER JOIN open_curs oc ON cl.curriculum_list_seq = oc.curriculum_list_seq
    INNER JOIN teacher t ON oc.teacher_seq = t.teacher_seq
    INNER JOIN subject_book sb ON sj.subject_seq = sb.subject_seq
    INNER JOIN book b ON sb.book_seq = b.book_seq
    INNER JOIN student st ON cl.curriculum_list_seq = st.curriculum_list_seq
    INNER JOIN member mb ON st.member_seq = mb.member_seq
    INNER JOIN subject_score ss ON st.student_seq = ss.student_seq;

SELECT * FROM course_scores;
    
CREATE VIEW counsel_info AS
SELECT
    c.counsel_date AS "상담 날짜",
    tp.counsel_subject AS "상담 주제",
    m.name AS "학생 이름",
    c.counsel_text AS "상담 내용"
FROM counsel c
    INNER JOIN teacher t
        ON c.teacher_seq = t.teacher_seq
            INNER JOIN open_curs o
                ON o.teacher_seq = c.teacher_seq
                    INNER JOIN counsel_topic tp
                        ON c.counsel_topic_seq = tp.counsel_topic_seq
                            INNER JOIN student s
                                ON c.student_seq = s.student_seq
                                    INNER JOIN member m
                                        ON s.member_seq = m.member_seq;
                                        
SELECT *
FROM counsel_info
WHERE open_curs_seq = <과정 번호> AND name = <'학생 이름'>
ORDER BY counsel_date DESC;

CREATE VIEW job_info AS
SELECT
    s.student_seq AS "학생 번호",
    m.name AS "이름",
    c.curs_name AS "과정명",
    f.field_name AS "분야",
    jc.company AS "회사명",
    jc.hire_date AS "입사일"
FROM job_current jc
    INNER JOIN student s
        ON jc.student_seq = s.student_seq
            INNER JOIN Member m
                ON m.member_seq = s.member_seq
                    INNER JOIN curriculum_list c
                        ON s.curriculum_list_seq = c.curriculum_list_seq
                            INNER JOIN job_field f
                             ON jc.job_field_seq = f.job_field_seq
    WHERE jc.company IS NOT NULL;
/
SELECT *
FROM job_info;

CREATE OR REPLACE VIEW jobless_info AS
SELECT
    s.student_seq AS "학생 번호",
    m.name AS "이름",
    c.curs_name AS "과정명",
    f.field_name AS "분야",
    jc.company AS "회사명",
    jc.hire_date AS "입사일"
FROM job_current jc
    LEFT OUTER JOIN student s
        ON jc.student_seq = s.student_seq
            LEFT OUTER JOIN Member m
                ON m.member_seq = s.member_seq
                    LEFT OUTER JOIN curriculum_list c
                        ON s.curriculum_list_seq = c.curriculum_list_seq
                            LEFT OUTER JOIN job_field f
                                ON jc.job_field_seq = f.job_field_seq
    WHERE jc.company IS NULL;
        
        
SELECT *
FROM jobless_info j
JOIN student s
ON j."학생 번호" = s.student_seq
WHERE MONTHS_BETWEEN(SYSDATE, s.drop_out_date) <= 12;

CREATE VIEW subject_score_info AS
SELECT
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
FROM subject s
INNER JOIN open_subject o
ON s.subject_seq = o.subject_seq
INNER JOIN open_curs c
ON c.open_curs_seq = o.open_curs_seq
INNER JOIN subject_book t
ON t.subject_seq = s.subject_seq
INNER JOIN book b
ON t.book_seq = b.book_seq
INNER JOIN score e
ON e.subject_seq = s.subject_seq;

CREATE VIEW teacher_attendance_info AS
SELECT 
    c.curriculum_list_seq as "과정번호",
    c.subject_seq as "과목번호",
    d.student_seq as "학생번호",
    a.attendance_date as "출석날짜"
FROM teaching_subject s
    INNER JOIN teacher t
        ON s.teacher_seq = t.teacher_seq
    INNER JOIN curriculum_subject c
        ON c.subject_seq = s.subject_seq
    INNER JOIN subject_score e
        ON s.subject_seq = e.subject_seq
    INNER JOIN student d
        ON e.student_seq = d.student_seq
    INNER JOIN attendance a
        ON a.student_seq = d.student_seq;
        
select *
from teacher_attendance_info;
        
CREATE OR REPLACE VIEW subject_score_view AS
SELECT DISTINCT
    s.subject_seq AS "과목번호", 
    s.subject_name AS "과목명",
    os.begin_date AS "과목시작일자",
    os.end_date AS "과목종료일자",
    b.subject AS "교재명",
    t.name AS "교사명",
    sc.score_attend AS "출결배점",
    sc.score_writetest AS "필기시험 배점",
    sc.score_realtest AS "실기시험 배점",
    ss.attend_score AS "출결 점수",
    ss.test_writescore AS "필기 점수",
    ss.test_realscore AS "실기 점수",
    td.test_date AS "과목별 시험날짜",
    q.quiz_content AS "시험문제",
    ss.student_seq AS "교육생 번호"
FROM 
    Subject s
    INNER JOIN open_subject os ON s.subject_seq = os.subject_seq
    INNER JOIN subject_book sb ON sb.subject_seq = s.subject_seq
    INNER JOIN book b ON b.book_seq = sb.book_seq
    INNER JOIN teacher t ON os.teacher_seq = t.teacher_seq
    INNER JOIN score sc ON s.subject_seq = sc.subject_seq
    INNER JOIN subject_score ss ON s.subject_seq = ss.subject_seq
    INNER JOIN test_date td ON td.subject_seq = s.subject_seq
    INNER JOIN quiz q ON q.quiz_seq = td.quiz_seq
    INNER JOIN student ON student.student_seq = ss.student_seq;
        
        
SELECT * FROM subject_score_view WHERE "교육생 번호" = 10;

SELECT 
    * 
from open_curs oc
    inner join teacher t
        on oc.teacher_seq = t.teacher_seq
            inner join counsel c
                on c.teacher_seq = t.teacher_seq
                    inner join student s
                        on s.student_seq = c.student_seq;
                
                
SELECT * from Counsel;

CREATE OR REPLACE TRIGGER trg_counsel_insert
    BEFORE INSERT ON counsel
    FOR EACH ROW
DECLARE
    v_open_curs_seq open_curs.open_curs_seq%type;
    v_teacher_seq NUMBER;
    v_curriculum_list_seq open_curs.curriculum_list_seq%type;
BEGIN
    SELECT COUNT(*) INTO v_teacher_seq
    FROM open_curs oc
    WHERE oc.open_curs_seq = v_open_curs_seq
    AND oc.teacher_seq = :NEW.teacher_seq;

    IF v_teacher_seq = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, '해당 강사는 개설 과목의 담당 강사가 아닙니다.');
    END IF;

    SELECT oc.curriculum_list_seq INTO v_curriculum_list_seq
    FROM open_curs oc
    WHERE oc.open_curs_seq = v_open_curs_seq;

    IF v_curriculum_list_seq NOT BETWEEN 1 AND 6 THEN
        RAISE_APPLICATION_ERROR(-20002, '수강하는 과정과 개설한 강좌의 과정이 일치하지 않습니다.');
    END IF;

    SELECT COUNT(*) INTO v_teacher_seq
    FROM teacher t
    WHERE t.teacher_seq = :NEW.teacher_seq;

    IF v_teacher_seq = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '등록되지 않은 강사입니다.');
    END IF;

    SELECT COUNT(*) INTO v_curriculum_list_seq
    FROM student s
    WHERE s.student_seq = :NEW.student_seq
    AND s.drop_out = '교육이수중';

    IF v_curriculum_list_seq = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '접근 권한이 없는 학생입니다.');
    END IF;
END;

select 
    *
from attendance

CREATE OR REPLACE TRIGGER trg_attendance_detail
AFTER INSERT OR UPDATE ON attendance_detail
FOR EACH ROW
DECLARE
    v_penalty   NUMBER(2);
    v_drop_out  VARCHAR2(10);
BEGIN
    -- check_in이 null이고 sick_etc에도 해당 attendance_seq가 없는 경우
    IF :NEW.check_in IS NULL AND
       (SELECT COUNT(*) FROM sick_etc WHERE attendance_seq = :NEW.attendance_seq) = 0 THEN
        -- penalty를 3 추가
        UPDATE student SET penalty = penalty + 3 WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
    
    -- check_in이 null이 아니고 09:10:00보다 늦은 경우
    IF :NEW.check_in IS NOT NULL AND TO_DATE(:NEW.check_in, 'HH24:MI:SS') > TO_DATE('09:10:00', 'HH24:MI:SS') THEN
        -- penalty를 1 추가
        UPDATE student SET penalty = penalty + 1 WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
    
    -- check_out이 null이 아니고 17:50:00보다 이른 경우
    IF :NEW.check_out IS NOT NULL AND TO_DATE(:NEW.check_out, 'HH24:MI:SS') < TO_DATE('17:50:00', 'HH24:MI:SS') THEN
        -- penalty를 1 추가
        UPDATE student SET penalty = penalty + 1 WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
    
    -- penalty가 15 이상인 경우
    SELECT penalty INTO v_penalty FROM student WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    IF v_penalty >= 15 THEN
        -- drop_out을 '중도탈락'으로 업데이트
        UPDATE student SET drop_out = '중도탈락' WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
END;

-------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_attendance_detail
AFTER INSERT OR UPDATE ON attendance_detail
FOR EACH ROW
DECLARE
v_penalty NUMBER(2);
v_drop_out VARCHAR2(10);
BEGIN
-- check_in이 null이고 sick_etc에도 해당 attendance_seq가 없는 경우
CREATE OR REPLACE TRIGGER trg_attendance_detail
AFTER INSERT OR UPDATE ON attendance_detail
FOR EACH ROW
DECLARE
    v_penalty   NUMBER(2);
    v_drop_out  VARCHAR2(10);
BEGIN
    -- check_in이 null이고 sick_etc에도 해당 attendance_seq가 없는 경우
    IF :NEW.check_in IS NULL AND
       (SELECT COUNT(*) FROM sick_etc WHERE attendance_seq = :NEW.attendance_seq) = 0 THEN
        -- penalty를 3 추가
        UPDATE student SET penalty = penalty + 3 WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
    
    -- check_in이 null이 아니고 09:10:00보다 늦은 경우
    IF :NEW.check_in IS NOT NULL AND TO_DATE(:NEW.check_in, 'HH24:MI:SS') > TO_DATE('09:10:00', 'HH24:MI:SS') THEN
        -- penalty를 1 추가
        UPDATE student SET penalty = penalty + 1 WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
    
    -- check_out이 null이 아니고 17:50:00보다 이른 경우
    IF :NEW.check_out IS NOT NULL AND TO_DATE(:NEW.check_out, 'HH24:MI:SS') < TO_DATE('17:50:00', 'HH24:MI:SS') THEN
        -- penalty를 1 추가
        UPDATE student SET penalty = penalty + 1 WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
    
    -- penalty가 15 이상인 경우
    SELECT penalty INTO v_penalty FROM student WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    IF v_penalty >= 15 THEN
    -- drop_out을 '중도탈락'으로 업데이트
    UPDATE student SET drop_out = '중도탈락' WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = :NEW.attendance_seq);
    END IF;
END;
/
--------------------------------------------------------------------------
desc student;
desc attendance;
desc attendance_detail;

CREATE OR REPLACE TRIGGER attendance_penalty_trigger
AFTER INSERT ON attendance_detail
FOR EACH ROW
DECLARE
  v_penalty NUMBER := 0;
BEGIN
  -- Check if attendance_detail record exists for the student
  SELECT COUNT(*) INTO v_penalty
  FROM student s
  INNER JOIN attendance a ON s.subject_seq = a.subject_seq
  INNER JOIN attendance_detail ad ON ad.attendance_seq = a.attendance_seq
  WHERE ad.student_seq = :new.student_seq AND ad.attendance_seq = :new.attendance_seq;

  -- If attendance_detail record doesn't exist, add a penalty of 3 to the student
  IF v_penalty = 0 THEN
    UPDATE student
    SET penalty = penalty + 3
    WHERE student_seq = :new.student_seq;
  END IF;

  -- If check_in is not null and after 09:10:00, add a penalty of 1 to the student
  IF :new.check_in IS NOT NULL AND TO_CHAR(TO_DATE(:new.check_in, 'HH24:MI:SS'), 'HH24:MI:SS') > '09:10:00' THEN
    UPDATE student
    SET penalty = penalty + 1
    WHERE student_seq = :new.student_seq;
  END IF;

  -- If check_out is not null and before 17:50:00, add a penalty of 1 to the student
  IF :new.check_out IS NOT NULL AND TO_CHAR(TO_DATE(:new.check_out, 'HH24:MI:SS'), 'HH24:MI:SS') < '17:50:00' THEN
    UPDATE student
    SET penalty = penalty + 1
    WHERE student_seq = :new.student_seq;
  END IF;

  -- If penalty is over 15, update the student's drop_out column to '중도탈락'
  SELECT penalty INTO v_penalty
  FROM student
  WHERE student_seq = :new.student_seq;

  IF v_penalty >= 15 THEN
    UPDATE student
    SET drop_out = '중도탈락', drop_out_date = SYSDATE
    WHERE student_seq = :new.student_seq;
  END IF;
END;
/
/
CREATE OR REPLACE TRIGGER attendance_penalty_trigger
AFTER INSERT OR UPDATE ON attendance_detail
FOR EACH ROW
DECLARE
  v_student_seq student.student_seq%TYPE;
  v_attendance_seq attendance_detail.attendance_seq%TYPE;
  v_check_in attendance_detail.check_in%TYPE;
  v_check_out attendance_detail.check_out%TYPE;
  v_penalty student.penalty%TYPE;
  v_total_penalty NUMBER;
BEGIN
  v_attendance_seq := :NEW.attendance_seq;
  SELECT student_seq INTO v_student_seq FROM student WHERE student_seq = (SELECT student_seq FROM attendance WHERE attendance_seq = v_attendance_seq);
  
  IF v_student_seq IS NULL THEN
    RETURN;
  END IF;
  
  v_check_in := :NEW.check_in;
  v_check_out := :NEW.check_out;
  
  IF v_check_in IS NULL AND v_check_out IS NULL THEN
    v_penalty := 3;
  ELSIF v_check_in IS NOT NULL AND to_date(v_check_in, 'HH24:MI:SS') > to_date('09:10:00', 'HH24:MI:SS') THEN
    v_penalty := 1;
  ELSIF v_check_out IS NOT NULL AND to_date(v_check_out, 'HH24:MI:SS') < to_date('17:50:00', 'HH24:MI:SS') THEN
    v_penalty := 1;
  ELSE
    v_penalty := 0;
  END IF;
  
  SELECT penalty INTO v_total_penalty FROM student WHERE student_seq = v_student_seq;
  
  IF v_total_penalty IS NULL THEN
    v_total_penalty := 0;
  END IF;
  
  v_total_penalty := v_total_penalty + v_penalty;
  
  IF v_total_penalty >= 15 THEN
    UPDATE student SET drop_out = '중도탈락' WHERE student_seq = v_student_seq;
  END IF;
  
  UPDATE student SET penalty = v_total_penalty WHERE student_seq = v_student_seq;
END;
/
ALTER TRIGGER attendance_penalty_trigger COMPILE;
select count(*) from attendance;
select count(*) from attendance_detail;
insert into attendance values (52079,1,'23-04-10');
insert into attendance_detail values (52079, 52079, '9:15:00', '17:50:01');
insert into attendance values (52080,1,'23-04-11');
insert into attendance_detail values (52080, 52080, null, null);
insert into attendance values (52081,2,'23-04-10');
insert into attendance_detail values (52081, 52081, '9:15:00', '17:50:01');
insert into attendance values (52082,1,'23-04-12');
insert into attendance_detail values (52082, 52082, null, null);
insert into attendance values (52083,1,'23-04-13');
insert into attendance_detail values (52083, 52083, null, null);
insert into attendance values (52084,1,'23-04-14');
insert into attendance_detail values (52084, 52084, null, null);
insert into attendance values (52085,1,'23-04-15');
insert into attendance_detail values (52085, 52085, null, null);

rollback;
select * from student;

CREATE OR REPLACE TRIGGER trg_subject_completed
    AFTER INSERT 
    ON subject_score
DECLARE
    edate date;
BEGIN
    SELECT os.end_date into edate
    FROM open_subject os
    JOIN subject_score ss ON os.subject_seq = ss.subject_seq
    WHERE sysdate >= os.end_date;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('종강한 과목에 대한 성적만 입력할 수 있습니다.');
        RAISE_APPLICATION_ERROR(-20001, '종강한 과목에 대한 성적만 입력할 수 있습니다.');
        ROLLBACK;
    ELSE
        DBMS_OUTPUT.PUT_LINE('성적 입력이 완료됐습니다.'); 
        COMMIT;
    END IF;
END trg_subject_completed;
------------------------------------------
create or replace trigger trg_subject_score
    before insert or update
    on Subject_score
    for each row
begin

    dbms_output.put_line('트리거 실행');
    
    if :new.attend_score > 30 then
        raise_application_error (-21000, '출결점수는 최대 30점입니다.');
    elsif :new.test_writescore > 30 then
        raise_application_error (-21000, '필기점수는 최대 30점입니다.');
    elsif :new.test_realscore > 40 then
        raise_application_error (-21000, '실기점수는 최대 40점입니다.');
    end if;
    
end trg_subject_score;
/
CREATE OR REPLACE PROCEDURE open_curs_info IS
BEGIN
  FOR c IN (SELECT 
                c.curriculum_list_seq as "과정번호",
                c.curs_name as "과정명",
                o.room_seq as "강의실",
                o.teacher_seq as "담당선생님번호",
                o.begin_date as "시작날짜",
                o.end_date as "종료날짜",
                o.student_limit as "수강인원"
              FROM Curriculum_list c
                INNER JOIN open_curs o
                  ON c.curriculum_list_seq = o.curriculum_list_seq)
  LOOP
    -- 결과를 출력합니다.
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || c.과정번호);
    DBMS_OUTPUT.PUT_LINE('과정명: ' || c.과정명);
    DBMS_OUTPUT.PUT_LINE('강의실: ' || c.강의실);
    DBMS_OUTPUT.PUT_LINE('담당선생님번호: ' || c.담당선생님번호);
    DBMS_OUTPUT.PUT_LINE('시작날짜: ' || c.시작날짜);
    DBMS_OUTPUT.PUT_LINE('종료날짜: ' || c.종료날짜);
    DBMS_OUTPUT.PUT_LINE('수강인원: ' || c.수강인원);
  END LOOP;
END open_curs_info;
/
set serveroutput on;
begin
    open_curs_info;
end;
/
BEGIN
    all_subject_selecct_p;
END;
/
begin
curriculum_attendance_select_p(1, 1);
end;
/
CREATE OR REPLACE PROCEDURE job_current_info (pcurriculum_list_seq IN NUMBER) IS
BEGIN
    FOR c IN (
        SELECT
            j.student_seq AS "학생 번호",
            m.name AS "이름",
            m.tel AS "전화번호",
            f.field_name AS "취업 분야",
            j.company AS "회사",
            j.hire_date AS "취업일"
        FROM job_current j
            LEFT OUTER JOIN student s
                ON j.student_seq = s.student_seq
                   LEFT OUTER JOIN member m
                        ON m.member_seq = s.member_seq
                            LEFT OUTER JOIN curriculum_list c
                                ON s.curriculum_list_seq = c.curriculum_list_seq
                                    LEFT OUTER JOIN job_field f
                                        ON j.job_field_seq = f.job_field_seq
        WHERE c.curriculum_list_seq = pcurriculum_list_seq
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('학생 번호: ' || c."학생 번호");
        DBMS_OUTPUT.PUT_LINE('이름: ' || c."이름");
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || c."전화번호");
        DBMS_OUTPUT.PUT_LINE('취업 분야: ' || c."취업 분야");
        DBMS_OUTPUT.PUT_LINE('회사: ' || c."회사");
        DBMS_OUTPUT.PUT_LINE('취업일: ' || c."취업일");
    END LOOP;
END job_current_info;

begin
    job_current_info(10);
end;
/
begin
    board_select_p;
end;
/
BEGIN
    student_private_score(1091031);
END;
/
CREATE OR REPLACE PROCEDURE counsel_info2(pstudent_seq IN number) 
AS
BEGIN
    FOR c IN (
        select 
        teacher_seq as "상담선생님번호",
        counsel_date as "상담일자",
        counsel_text as "상담내용"
    from Counsel 
    where student_seq = pstudent_seq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('상담선생님번호: ' || c.상담선생님번호);
        DBMS_OUTPUT.PUT_LINE('상담일자: ' || c.상담일자);
        DBMS_OUTPUT.PUT_LINE('상담내용: ' || c.상담내용);
    END LOOP;
END counsel_info2;
/
BEGIN
    counsel_info2(2);
END;
/
select * from counsel;

