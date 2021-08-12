-- 테이블 만들기
CREATE TABLE test(
	idx number(4) NOT NULL,
	name varchar(10) NOT NULL,
	age number(3),
	birthday DATE,
	job varchar(2)
);

SELECT * FROM test;

DROP TABLE test;