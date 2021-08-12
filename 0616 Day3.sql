-- 테이블 만들기
CREATE TABLE tb_student(
	stu_idx NUMBER(4) NOT NULL,
	stu_name VARCHAR2(20),
	stu_gender CHAR(1),
	stu_hp VARCHAR2(20),
	CONSTRAINT stu_gender CHECK (stu_gender IN ('m', 'w'))
);

-- 데이터 확인
SELECT * FROM TB_STUDENT;

-- 테이블 삭제
DROP TABLE tb_student;

-- 테이블 수정(컬럼 추가)
ALTER TABLE tb_student ADD(
	stu_email VARCHAR2(50)
);

-- 테이블 수정(컬럼 수정)
ALTER TABLE tb_student MODIFY(
	stu_gender VARCHAR2(6) CHECK(stu_gender IN ('male', 'female'))
);

-- 테이블 수정(컬럼 삭제)
--ALTER TABLE tb_student DROP(
--	stu_email
--);

ALTER TABLE tb_student DROP COLUMN stu_email;

-- 테이블 이름변경
ALTER TABLE tb_student RENAME TO tb_member;
ALTER TABLE tb_member RENAME TO tb_student;

-- 컬럼 이름변경
ALTER TABLE tb_student RENAME COLUMN stu_hp TO stu_tel;

SELECT * FROM tb_student;


/*
 * 	INSERT(삽입)
 *  1. INSERT INTO 테이블명 VALUES (값1, 값2, 값3 ..);
 *  2. INSERT INTO 테이블명 (컬럼명1, 컬럼명2 ..) VALUES (값1, 값2, 값3 ..);
 */
INSERT INTO TB_STUDENT VALUES (1, '김사과', 'w', '010-1111-1111');
INSERT INTO TB_STUDENT VALUES (2, '반하나', 'w'); -- not enough values
INSERT INTO TB_STUDENT VALUES (4, '이메론', 'm', '010-4444-4444');
INSERT INTO TB_STUDENT VALUES (5, '배애리', '1', '010-5555-5555'); -- check constraint (SYSTEM.STU_GENDER) violated

INSERT INTO TB_STUDENT (stu_idx, stu_name) VALUES (2, '반하나');
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp) VALUES (3, '오렌지', 'm', '010-2222-2222');
INSERT INTO TB_STUDENT (stu_name, stu_gender) VALUES ('이메론', 'm'); -- cannot insert NULL into ("SYSTEM"."TB_STUDENT"."STU_IDX")

SELECT * FROM tb_student;


/*
 * UPDATE(수정)
 * 1. UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2
 * 2. UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2 WHERE 조건식;
 */
UPDATE TB_STUDENT SET STU_GENDER = 'w';
UPDATE TB_STUDENT SET STU_GENDER = 'm' WHERE STU_IDX = 3;
UPDATE TB_STUDENT SET STU_GENDER = 'm' WHERE STU_NAME = '오렌지';
UPDATE TB_STUDENT SET STU_GENDER = 'm' WHERE STU_HP = '010-2222-2222';

-- 테이블 수정(컬럼 추가)
ALTER TABLE tb_student ADD(
	stu_jumsu NUMBER(3)
);

SELECT * FROM tb_student;

-- 점수를 모두 0으로 설정
UPDATE TB_STUDENT SET stu_jumsu = 0;

-- 10점을 모든 학생에게 더해줌
UPDATE tb_student SET stu_jumsu=stu_jumsu+10;


/*
 * DELETE(삭제)
 * 1. DELETE FROM 테이블명
 * 2. DELETE FROM 테이블명 WHERE 조건식
 */
DELETE FROM TB_STUDENT WHERE STU_IDX = 3;


/*
 * SELECT(검색)
 * SELECT 컬럼1, 컬럼2 .. FROM 테이블명
 */

SELECT * FROM tb_student; -- *는 모든 컬럼
SELECT STU_IDX, STU_NAME, STU_GENDER FROM tb_student;
SELECT STU_GENDER, STU_NAME, STU_IDX FROM tb_student;

-- SELECT 컬럼1, 컬럼2 .. FROM 테이블명 WHERE 조건식
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (3, '오렌지', 'm', '010-2222-2222', 40);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (4, '이메론', 'm', '010-3333-3333', 60);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (5, '배애리', 'w', '010-4444-4444', 80);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (6, '안가도', 'm', '010-5555-5555', 10);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (7, '채리', 'w', '010-6666-6666', 75);

/* 비교 연산자
 * = : 같다
 * != : 다르다
 * > : 크다
 * < : 작다
 * >= : 크거나 같다
 * <= : 작거나 같다
 */
-- 이름이 '김사과'인 학생의 정보를 출력
SELECT * FROM TB_STUDENT WHERE STU_NAME ='김사과';
-- 점수가 50점 이상인 학생의 정보를 출력
SELECT * FROM TB_STUDENT WHERE stu_jumsu >= 50;
-- 성별이 남자(m)이 아닌 학생의 정보를 출력
SELECT * FROM TB_STUDENT WHERE STU_GENDER != 'm';

/*
 * 논리 연산자
 * and : 두 조건식의 결과가 모두 참일 때 참
 * or : 두 조건식의 결과중 하나라도 참일 때 참
 * not : 결과를 반대로 출력
 */
-- 이름이 '김사과'이고, 성별이 'w'(여자)인 학생을 출력
SELECT * FROM TB_STUDENT WHERE stu_name = '김사과' AND STU_GENDER ='w'; -- O
SELECT * FROM TB_STUDENT WHERE stu_name = '김사과' AND STU_GENDER ='m'; -- X
-- 점수가 40점 이상이고 75점 이하인 학생을 출력
SELECT * FROM TB_STUDENT WHERE stu_jumsu >= 40 AND stu_jumsu <= 75;
-- 성별이 여자이거나 점수가 50점 이상인 학생을 출력
SELECT * FROM TB_STUDENT WHERE STU_GENDER ='w' OR stu_jumsu >= 50;
-- 연락처가 있는 학생만 출력
SELECT * FROM TB_STUDENT WHERE stu_hp is null; -- null인 학생을 출력
SELECT * FROM TB_STUDENT WHERE stu_hp IS NOT null; -- null을 제외한 학생을 출력

-- in : 데이터를 포함하고 있는 레코드 출력
 SELECT * FROM TB_STUDENT WHERE stu_jumsu IN (40, 60, 10);
 SELECT * FROM TB_STUDENT WHERE stu_jumsu NOT IN (40, 60, 10);

-- like : 해당 문자열을 포함하고 있는 레코드를 출력
SELECT * FROM TB_STUDENT WHERE stu_hp LIKE '%4%';
SELECT * FROM TB_STUDENT WHERE stu_name LIKE '김%';
SELECT * FROM TB_STUDENT WHERE stu_name LIKE '%리';

-- BETWEEN A and B : A이상 B이하인 레코드를 출력
 -- 점수가 40점 이상이고 75점 이하인 학생을 출력
SELECT * FROM TB_STUDENT WHERE stu_jumsu >= 40 AND stu_jumsu <= 75;
SELECT * FROM TB_STUDENT WHERE stu_jumsu BETWEEN 40 AND 75;

