/* 관리자 */
-- 관리자 3~5명
CREATE TABLE Admin (
	admin_seq NUMBER PRIMARY KEY, /* 관리자번호 */
	name VARCHAR2(15) NOT NULL, /* 이름 */
	ssn NUMBER NOT NULL, /* 주민등록번호 뒷자리 */
	tel VARCHAR2(20) /* 전화번호 */
);

/* 교사 */
-- 강의 인원 6명, 대기 인원 4명
CREATE TABLE Teacher (
	teacher_seq NUMBER PRIMARY KEY, /* 교사번호 */
	name VARCHAR2(15) NOT NULL, /* 이름 */
	ssn NUMBER NOT NULL, /* 주민등록번호 뒷자리 */
	tel VARCHAR2(20) /* 전화번호 */
);

/* 과목 전체 목록 */
-- 과목 30개~50과목 
-- 공통 과목 : 자바, 오라클, JDBC, HTML, CSS
-- 선택 과목 : SPRING, MYBatits, Python, 빅데이터, C++, C, MongoDB, 데이터구조, MySQL, 블록체인, 네트워킹, 클라우드, C99, Ruby, Vue
-- 선택 과목 : Kotlin, aws, javascript, swift, C#, PHP, node.js, Go, D, 리눅스, React, Django, GIT, figma, Android, OOP, 딥러닝, 머신러닝, flutter, 컴파일러, ERD, firebase
CREATE TABLE Subject (
	subject_seq NUMBER PRIMARY KEY, /* 과목번호 */
	subject_name VARCHAR2(50) NOT NULL /* 과목명 */
);

/* 강의가능과목 */
CREATE TABLE Teaching_subject (
	teacher_seq references Teacher(teacher_seq) NOT NULL, /* 교사번호 */
	subject_seq references Subject(subject_seq) NOT NULL /* 과목번호 */
);

/* 추천도서 */
CREATE TABLE Comment_Book (
	comment_book_seq NUMBER PRIMARY KEY, /* 도서번호 */
	subject_seq references Subject(subject_seq) NOT NULL, /* 과목번호 */
	teacher_seq references Teacher(teacher_seq) NOT NULL, /* 교사번호 */
	book_name VARCHAR2(500) NOT NULL /* 도서명 */
);

/* 교재 */

CREATE TABLE BOOK (
	book_seq NUMBER PRIMARY KEY, /* 교재번호 */
	subject VARCHAR2(300) NOT NULL, /* 제목 */
	author VARCHAR2(50) NOT NULL, /* 저자 */
	publisher VARCHAR2(50) NOT NULL, /* 출판사 */
	pub_year VARCHAR2(10)/* 발행년도 */
);

/* 과목 사용 교재 */
CREATE TABLE Subject_Book (
	subject_seq references Subject(subject_seq) NOT NULL, /* 과목번호 */
	book_seq references Book(book_seq) NOT NULL /* 교재번호 */
);

CREATE TABLE Curriculum_list (
	curriculum_list_seq NUMBER PRIMARY KEY, /* 전체과정번호 */
	curs_name VARCHAR2(100) NOT NULL /* 과정명 */
);

/*  과정에 따른 과목 테이블 */
CREATE TABLE Curriculum_subject (
    curriculum_list_seq NUMBER REFERENCES Curriculum_list(curriculum_list_seq) NOT NULL, /*과정번호*/
    subject_seq REFERENCES Subject(subject_seq) NOT NULL/*과목번호*/
);

/* 강의실 */
-- 강의실 6개
-- 수용인원 1~3 강의실 30명
-- 수용인원 4~6 강의실 26명
CREATE TABLE Room (
   room_seq NUMBER PRIMARY KEY, /* 강의실번호 */
   room_name VARCHAR2(50) NOT NULL, /* 강의실명 */
   student_limit NUMBER NOT NULL /* 수용정원 */
);

/* 개설과정 */ 
-- 과정 갯수 12개
-- 과정 기간 5.5 or 6 or 7
CREATE TABLE Open_curs (
   open_curs_seq NUMBER PRIMARY KEY, /* 개설과정번호 */
   curriculum_list_seq REFERENCES CURRICULUM_LIST(curriculum_list_seq) NOT NULL, /* 전체과정번호 */
   room_seq REFERENCES ROOM(room_seq) NOT NULL, /* 강의실번호 */
   teacher_seq REFERENCES TEACHER(teacher_seq) NOT NULL, /* 교사번호 */
   curs_name VARCHAR2(100) NOT NULL, /* 과정명 */
   begin_date DATE NOT NULL, /* 과정시작날짜 */
   end_date DATE NOT NULL, /* 과정종료날짜 */
   student_limit NUMBER NOT NULL/* 수강정원 */
);

/* 개설과목 */ 
CREATE TABLE Open_subject (
   open_subject_seq NUMBER PRIMARY KEY, /* 개설과목번호 */
   subject_seq REFERENCES SUBJECT(subject_seq) NOT NULL, /* 과목번호 */
   teacher_seq REFERENCES TEACHER(teacher_seq) NOT NULL, /* 교사번호 */
   open_curs_seq REFERENCES OPEN_CURS(open_curs_seq) NOT NULL, /* 개설과정번호 */
   begin_date DATE NOT NULL, /* 과목시작일 */
   end_date DATE NOT NULL /* 과목종료일 */
);

/* 교육생목록 */
-- 500명
CREATE TABLE Student (
   student_seq NUMBER PRIMARY KEY, /* 교육생번호 */
   curriculum_list_seq REFERENCES Curriculum_list(curriculum_list_seq), /* 과정번호 */
   enroll_date DATE DEFAULT SYSDATE NOT NULL, /* 등록일 */
   drop_out VARCHAR2(20) NOT NULL, /* 교육생현재상태 */
   drop_out_date DATE, /* 수료 및 중도탈락 날짜 */
   member_seq references MEMBER(member_seq) NOT NULL /* 지원생 번호 */
);

/* 상담주제 */
CREATE TABLE Counsel_topic (
   counsel_topic_seq NUMBER PRIMARY KEY, /* 상담주제번호 */
   counsel_subject VARCHAR2(100) NOT NULL /* 상담주제 */
);

/* 상담 */
CREATE TABLE Counsel (
   counsel_seq NUMBER PRIMARY KEY, /* 상담번호 */
   teacher_seq REFERENCES TEACHER(teacher_seq) NOT NULL, /* 교사번호 */
   student_seq REFERENCES STUDENT(student_seq) NOT NULL, /* 교육생번호 */
   counsel_topic_seq REFERENCES COUNSEL_TOPIC(counsel_topic_seq) NOT NULL, /* 상담주제번호 */
   counsel_date DATE DEFAULT SYSDATE NOT NULL, /* 상담일자 */
   counsel_text VARCHAR2(500) /* 상담내용 */
);

-- 지원생
-- 1000명
CREATE TABLE Member (
   member_seq NUMBER PRIMARY KEY NOT NULL, /* 지원번호 */
   name VARCHAR2(15) NOT NULL, /* 이름 */
   ssn NUMBER NOT NULL, /* 주민번호 뒷자리 */
   tel VARCHAR2(20) /* 전화번호 */
);

-- 수강신청
CREATE TABLE Enrollment (
   enrollment_seq NUMBER PRIMARY KEY, /* 수강신청번호 */
   open_curs_seq NUMBER references Open_curs(open_curs_seq)  NOT NULL, /* 개설과정번호 */
   member_seq NUMBER references Member(member_seq) NOT NULL, /* 지원번호 */
   enroll_date DATE DEFAULT SYSDATE NOT NULL /* 신청일 */
);

--공휴일
CREATE TABLE Holiday (
   holiday_seq NUMBER PRIMARY KEY NOT NULL, /* 공휴일번호 */
   holiday_date DATE NOT NULL, /* 날짜 */
   holiday_name VARCHAR2(50) NOT NULL /* 공휴일명 */
);

--수강신청결과
CREATE TABLE Enrollment_result (
   enrollment_result_seq NUMBER PRIMARY KEY NOT NULL, /* 수강신청 결과 번호 */
   member_seq NUMBER references Member(member_seq) NOT NULL, /* 지원번호 */
   interview_score NUMBER NOT NULL, /* 면접점수 */
   test_score NUMBER NOT NULL, /* 시험점수 */
   result VARCHAR2(10) NOT NULL /* 합격여부 */
);

--출결
CREATE TABLE Attendance (
   attendance_seq NUMBER PRIMARY KEY NOT NULL, /* 출결번호 */
   student_seq NUMBER references Student(student_seq) NOT NULL, /* 교육생번호 */
   attendance_date DATE DEFAULT SYSDATE NOT NULL /* 날짜 */
);

--병가-기타
CREATE TABLE Sick_etc (
   sick_etc_seq NUMBER PRIMARY KEY NOT NULL, /* 병가기타번호 */
   sick_or_etc VARCHAR2(50) NOT NULL, /* 병가기타 */
   attendance_seq NUMBER references Attendance(attendance_seq) NOT NULL /* 출결번호 */
);

--출결세부정보
CREATE TABLE Attendance_detail (
   Attendance_detail_seq NUMBER PRIMARY KEY NOT NULL, /* 출결세부번호 */
   attendance_seq NUMBER references Attendance(attendance_seq) NOT NULL, /* 출결번호 */
   check_in DATE DEFAULT SYSDATE, /* 입실 */
   check_out DATE DEFAULT SYSDATE /* 퇴실 */
);

/* 지역 */
-- 서울, 부산, 대구, 인천, 광주, 대전, 울산, 세종, 경기, 강원, 충북, 충남, 전북, 전남, 경북, 경남, 제주
CREATE TABLE City (
   city_seq NUMBER PRIMARY KEY, /* 지역번호 */
   city_name VARCHAR2(50) NOT NULL /* 지역명 */
);

/* 취업 분야 테이블 */
-- 분야명 : 보안, DBA, 인공지능, 클라우드, 웹개발, 앱개발, 기타
CREATE TABLE Job_field (
   job_field_seq NUMBER PRIMARY KEY, /* 분야 번호 */
   field_name VARCHAR2(100) NOT NULL /* 분야명 */
);

/* 계약 형태 */
-- 정규직, 계약직, 인턴
CREATE TABLE Contract_type (
   contract_type_seq NUMBER PRIMARY KEY, /* 계약 형태 번호 */
   contract_type VARCHAR2(100) NOT NULL/* 계약 형태 */
);

/* 취업공고 */
-- 삼성, 엘지, 구글, 기아, 현대, 그외는 찾아보는걸로
CREATE TABLE Job_announce (
    job_announce_seq NUMBER PRIMARY KEY, /* 취업공고번호 */
    city_seq NUMBER references city(city_seq) NOT NULL, /* 지역번호 */
    job_field_seq NUMBER references job_field(job_field_seq) NOT NULL, /* 분야 번호 */
   contract_type_seq NUMBER references contract_type(contract_type_seq) NOT NULL, /* 계약 형태 번호 */
   company VARCHAR2(100) NOT NULL, /* 회사명 */
   people NUMBER NOT NULL, /* 모집인원 */
   begin_date DATE, /* 모집시작일 */
   end_date DATE /* 모집종료일 */
);

/* 수료생 취업 현황 테이블 */
CREATE TABLE Job_current (
   job_current_seq NUMBER PRIMARY KEY, /* 취업 현황 번호 */
    job_field_seq NUMBER references job_field(job_field_seq), /* 분야 번호 */
    student_seq NUMBER references student(student_seq) NOT NULL, /* 교육생번호 */  
   company VARCHAR2(100), /* 회사명 */
   hire_date DATE /* 입사 날짜 */
);

/* 면접 */
CREATE TABLE Interview (
   interview_seq NUMBER PRIMARY KEY, /* 면접번호 */
    member_seq NUMBER references member(member_seq) NOT NULL, /* 지원번호 */
   motive VARCHAR2(500), /* 지원동기 */
   enroll_subject VARCHAR2(100) NOT NULL /* 지원과정 */
);

/* 시험 */
CREATE TABLE Test (
   test_seq NUMBER PRIMARY KEY, /* 시험 번호 */
   subject_seq NUMBER references subject(subject_seq) NOT NULL, /* 과목번호 */
   test_type VARCHAR2(20) NOT NULL, /* 시험 종류 */
   test_name VARCHAR2(30) NOT NULL /* 시험 이름 */
);
drop table Test;


/* 배점 */
-- 출석 : 30, 필기 시험 : 30, 실기 시험 : 40

CREATE TABLE Score (
   score_seq NUMBER PRIMARY KEY, /* 배점 번호 */
   subject_seq NUMBER references subject(subject_seq) NOT NULL, /* 과목번호 */
   score_attend NUMBER DEFAULT 30 NOT NULL, /* 출석 배점 */
   score_writeTest NUMBER DEFAULT 30 NOT NULL, /* 필기 시험 배점 */
   score_realTest NUMBER DEFAULT 40 NOT NULL /* 실기 시험 배점 */
);


/* 과목 성적 */
--과목성적번호, 과정 번호, 교육생번호, 과목번호, 출결,필기,실기
CREATE TABLE Subject_score (
   subject_scoreseq NUMBER PRIMARY KEY, /* 과목성적번호 */
   curriculum_list_seq NUMBER references curriculum_list(curriculum_list_seq) NOT NULL, /* 과정번호 */
   student_seq NUMBER references Student(student_seq) NOT NULL, /* 교육생번호 */
   subject_seq NUMBER references subject(subject_seq) NOT NULL, /* 과목번호 */
   attend_score NUMBER DEFAULT 30 NOT NULL , /* 출결점수 */
   test_writescore NUMBER NOT NULL, /* 필기 시험점수 */
   test_realscore NUMBER NOT NULL /* 실기 시험점수 */
);



/* 만남의광장 */
CREATE TABLE Board (
   Board_seq NUMBER PRIMARY KEY, /* 게시물번호 */
   student_seq NUMBER references Student(student_seq) NOT NULL, /* 교육생번호 */
   Board_title VARCHAR2(100) NOT NULL, /* 게시물제목 */
   Board_content VARCHAR2(500) NOT NULL /* 게시물내용 */
);

/* 만남의광장답글 */
CREATE TABLE Board_Reply (
   reply_seq NUMBER PRIMARY KEY, /* 답글번호 */
   Board_seq NUMBER references Board(Board_seq) NOT NULL, /* 게시물번호 */
   student_seq NUMBER references Student(student_seq) NOT NULL, /* 교육생번호 */
   reply_content VARCHAR2(500) NOT NULL/* 답글내용 */
);

/* 달란트시장퀴즈 */
CREATE TABLE QUIZ (
   quiz_seq NUMBER PRIMARY KEY, /* 퀴즈번호 */
   quiz_title VARCHAR2(100) NOT NULL, /* 퀴즈제목 */
   quiz_content VARCHAR2(500) NOT NULL, /* 퀴즈내용 */
   teacher_seq NUMBER references Teacher(teacher_seq) NOT NULL, /* 교사번호 */
   subject_seq NUMBER references Subject(subject_seq) NOT NULL, /* 과목번호 */
   quiz_answer NUMBER NOT NULL /* 정답번호 */
);

/* 달란트시장퀴즈정답 */
-- 정답 여부 : 정답,오답
CREATE TABLE QUIZ_Correct (
   correct_seq NUMBER PRIMARY KEY, /* 퀴즈정답번호 */
   quiz_seq NUMBER references QUIZ(quiz_seq) NOT NULL, /* 퀴즈번호 */
   quiz_input NUMBER NOT NULL, /* 교육생답변 */
   quiz_check VARCHAR2(50) NOT NULL, /* 정답여부 */
   student_seq references Student(student_seq) NOT NULL /* 교육생 번호 */
);

/* 포인트 */
CREATE TABLE POINT (
   point_seq NUMBER PRIMARY KEY, /* 포인트번호 */
   student_seq NUMBER references Student(student_seq) NOT NULL, /* 교육생번호 */
   ppoint NUMBER NOT NULL /* 포인트 */
);

/* 상품 */
-- 텀블러
-- 핸드크림
-- 마우스
-- 키보드
-- 마우스 패드
-- 교재
-- 헤드셋
-- 차이팟
-- 에코백
-- 충전기
CREATE TABLE PRIZE (
   prize_seq NUMBER PRIMARY KEY, /* 상품번호 */
   prize_name VARCHAR2(50) NOT NULL, /* 상품명 */
   prize_point NUMBER NOT NULL /* 필요포인트 */
);
