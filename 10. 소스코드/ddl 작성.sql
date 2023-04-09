--seq references Movie(seq)
/* 개설과목 */
CREATE TABLE Open_subject (
	open_subject_seq NUMBER PRIMARY KEY, /* 개설과목번호 */
	subject_seq REFERENCES SUBJECT(subject_seq) NOT NULL, /* 과목번호 */
	teacher_seq REFERENCES TEACHER(teacher_seq) NOT NULL, /* 교사번호 */
	open_curs_seq REFERENCES OPEN_CURS(open_curs_seq) NOT NULL, /* 개설과정번호 */
	begin_date DATE NOT NULL, /* 과목시작일 */
	end_date DATE NOT NULL /* 과목종료일 */
);

/* 강의실 */
CREATE TABLE Room (
	room_seq NUMBER PRIMARY KEY, /* 강의실번호 */
	room_name VARCHAR2(50) NOT NULL, /* 강의실명 */
	student_limit NUMBER NOT NULL /* 수용정원 */
);

/* 개설과정 */
CREATE TABLE Open_curs (
	open_curs_seq NUMBER PRIMARY KEY, /* 개설과정번호 */
	curriculum_list_seq REFERENCES CURRICULUM_LIST(curriculum_list_seq) NOT NULL, /* 전체과정번호 */
	room_seq REFERENCES ROOM(room_seq) NOT NULL, /* 강의실번호 */
	teacher_seq REFERENCES TEACHER(teacher_seq) NOT NULL, /* 교사번호 */
	curs_name VARCHAR2(100), /* 과정명 */
	begin_date DATE, /* 과정시작날짜 */
	end_date DATE, /* 과정종료날짜 */
	student_limit NUMBER /* 수강정원 */
);

/* 교육생목록 */
CREATE TABLE Student (
	student_seq NUMBER PRIMARY KEY, /* 교육생번호 */
	open_curs_seq REFERENCES OPEN_CURS(open_curs_seq) NOT NULL, /* 개설과정번호 */
	enroll_date DATE NOT NULL, /* 등록일 */
	drop_out VARCHAR2(20) NOT NULL, /* 교육생현재상태 */
	drop_out_date DATE /* 수료 및 중도탈락 날짜 */
);

/* 상담 */
CREATE TABLE Counsel (
	counsel_seq NUMBER PRIMARY KEY, /* 상담번호 */
	teacher_seq REFERENCES TEACHER(teacher_seq) NOT NULL, /* 교사번호 */
	student_seq REFERENCES STUDENT(student_seq) NOT NULL, /* 교육생번호 */
	counsel_topic_seq REFERENCES COUNSEL_TOPIC(counsel_topic_seq) NOT NULL, /* 상담주제번호 */
	counsel_date DATE NOT NULL, /* 상담일자 */
	counsel_text VARCHAR2(500) /* 상담내용 */
);

/* 상담주제 */
CREATE TABLE Counsel_topic (
	counsel_topic_seq NUMBER PRIMARY KEY, /* 상담주제번호 */
	counsel_seq VARCHAR2(100) NOT NULL /* 상담주제 */
);


