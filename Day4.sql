CREATE TABLE tb_member(
	mem_userid varchar2(20),
	mem_userpw varchar2(20) NOT NULL,
	mem_name varchar2(10) NOT NULL,
	mem_gender varchar2(10),
	mem_email varchar2(50) UNIQUE,
	mem_hp varchar2(20) UNIQUE,
	mem_zipcode char(5),
	mem_address1 varchar2(50),
	mem_address2 varchar2(50),
	mem_address3 varchar2(50),
	mem_regdate DATE DEFAULT sysdate,
	CONSTRAINT pk_userid PRIMARY KEY(mem_userid),
	CONSTRAINT ck_gender check(mem_gender IN ('남자', '여자'))
);
-- 여러 필드에 primary key를 적용
-- CONSTRAINT pk_userid PRIMARY KEY(mem_userid, mem_hp)
-- 1개의 테이블에 primary key는 하나의 이름에만 여러개 필드를 적용

DROP TABLE tb_member;
SELECT * FROM tb_member;

ALTER TABLE tb_member ADD PRIMARY KEY (mem_hp); --table can have only one primary KEY

INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('apple', '1111', '김사과', '여자', 'apple@apple.com', 
'010-1111-1111', '11111', '서울', '서초구', '양재동');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('banana', '2222', '반하나', '여자', 'banana@banana.com', 
'010-2222-2222', '11111', '서울', '서초구', '서초동');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('orange', '3333', '오렌지', '남자', 'orange@orange.com', 
'010-3333-3333', '11111', '서울', '강남구', '역삼동');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('melon', '4444', '이메론', '남자', 'melon@melon.com', 
'010-4444-4444', '11111', '서울', '강남구', '삼성동');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('cherry', '5555', '채리', '여자', 'cherry@cherry.com', 
'010-5555-5555', '11111', '서울', '동작구', '사당동');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('avocado', '6666', '안가도', '남자', 'avocado@avocado.com', 
'010-6666-6666', '11111', '서울', '강남구', '개포동');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('berry', '7777', '배애리', '여자', 'berry@berry.com', 
'010-7777-7777', '11111', '서울', '강남구', '대치동');


SELECT mem_userid, mem_name, mem_gender FROM tb_member;
SELECT mem_userid, 'mem_weight' FROM tb_member;
-- 필드를 별칭으로 바꾸기 (일시적)
SELECT mem_userid AS "아이디", mem_userpw AS "비밀번호" FROM tb_member;

-- order by (정렬)
-- asc : 오름차순, desc : 내림차순
-- 오름차순 기준으로 => 한글 : 가나다라.., 영어 : ABCD.., 숫자 : 1234.., 날짜 : 예전날짜..,
SELECT mem_userid, mem_name, mem_regdate FROM tb_member ORDER BY mem_regdate ASC;
SELECT mem_userid, mem_name, mem_regdate FROM tb_member ORDER BY mem_regdate DESC;

-- 가장 최근에 가입한 순으로 성별이 여자만 출력
SELECT * FROM tb_member WHERE mem_gender = '여자' ORDER BY mem_regdate DESC;

SELECT * FROM tb_member ORDER BY mem_gender DESC;
-- 성별로 내림차순 정렬 후 같은 등수일 경우 가입순으로 출력
SELECT mem_userid, mem_name, mem_gender, mem_regdate FROM tb_member ORDER BY mem_gender DESC, mem_regdate ASC;

-- 중복값 없애기(distinct)
SELECT DISTINCT mem_gender FROM tb_member;


-- 주문 테이블 생성
CREATE TABLE tb_order (
	ord_no varchar2(10),
	ord_userid varchar2(20),
	ord_product varchar2(50) NOT null,
	ord_count number(3),
	ord_regdate DATE DEFAULT sysdate,
	CONSTRAINT pk_no PRIMARY KEY(ord_no),
	CONSTRAINT fk_userid FOREIGN KEY(ord_userid) REFERENCES tb_member(mem_userid)
);

SELECT * FROM tb_order;
DROP TABLE tb_order;

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000001','jhjun', '맥프로',1); --integrity constraint (SYS.FK_USERID) violated - parent key not FOUND
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000001','apple', '맥프로',1);
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000002','orange', '청소기',1);
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000003','melon', '세탁기',1);
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000004','apple', '모니터',1);

-- 조인(join)
-- 각 테이블간에 공통된 컬럼(조건)으로 데이터를 합쳐 표현
-- SELECT M.mem_userid, M.mem_name, O.ord_product, O.ord_regdate FROM tb_member AS M, tb_order AS O WHERE M.mem_userid = O.ord_userid;

-- inner join(교집합)
SELECT mem_userid, mem_name, ord_product, ord_regdate FROM tb_member JOIN tb_order 
ON tb_member.mem_userid = tb_order.ord_userid;

-- left join(원본테이블 기준)
SELECT mem_userid, mem_name, ord_product, ord_regdate FROM tb_member LEFT JOIN tb_order 
ON tb_member.mem_userid = tb_order.ord_userid;

-- right join(참조테이블 기준)
SELECT mem_userid, mem_name, ord_product, ord_regdate FROM tb_member RIGHT JOIN tb_order 
ON tb_member.mem_userid = tb_order.ord_userid;


-- group by(그룹)
-- select 컬럼명1, 컬럼명2 .. from 테이블명 where 조건절 group by 그룹을 맺을 컬럼명 having 조건절 order by 정렬할 컬럼
-- 그룹을 맺을 경우 select 뒤에 나오는 키워드은 그룹을 맺은 컬럼 또는 집계함수만 가능
-- 집계함수 ( count() : 개수, sum() : 총합, avg() : 평균, max() : 최대값, min() : 최소값 )
SELECT * FROM tb_member;
SELECT mem_gender FROM tb_member GROUP BY mem_gender;
SELECT mem_gender, mem_userid FROM tb_member GROUP BY mem_gender; -- not a GROUP BY expression
SELECT mem_gender, count(mem_userid) FROM tb_member GROUP BY mem_gender;
SELECT mem_gender, count(mem_userid) FROM tb_member GROUP BY mem_gender HAVING count(mem_userid) > 3;
SELECT mem_gender, count(mem_userid) FROM tb_member WHERE mem_userid
NOT IN ('banana', 'melon', 'avocado') GROUP BY mem_gender HAVING count(mem_userid) > 2;

-- hr 계정 활성화
ALTER USER hr account unlock;
ALTER USER hr IDENTIFIED BY hr;

SELECT * FROM hr.EMPLOYEES;