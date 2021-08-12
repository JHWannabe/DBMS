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
	CONSTRAINT ck_gender check(mem_gender IN ('����', '����'))
);
-- ���� �ʵ忡 primary key�� ����
-- CONSTRAINT pk_userid PRIMARY KEY(mem_userid, mem_hp)
-- 1���� ���̺� primary key�� �ϳ��� �̸����� ������ �ʵ带 ����

DROP TABLE tb_member;
SELECT * FROM tb_member;

ALTER TABLE tb_member ADD PRIMARY KEY (mem_hp); --table can have only one primary KEY

INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('apple', '1111', '����', '����', 'apple@apple.com', 
'010-1111-1111', '11111', '����', '���ʱ�', '���絿');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('banana', '2222', '���ϳ�', '����', 'banana@banana.com', 
'010-2222-2222', '11111', '����', '���ʱ�', '���ʵ�');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('orange', '3333', '������', '����', 'orange@orange.com', 
'010-3333-3333', '11111', '����', '������', '���ﵿ');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('melon', '4444', '�̸޷�', '����', 'melon@melon.com', 
'010-4444-4444', '11111', '����', '������', '�Ｚ��');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('cherry', '5555', 'ä��', '����', 'cherry@cherry.com', 
'010-5555-5555', '11111', '����', '���۱�', '��絿');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('avocado', '6666', '�Ȱ���', '����', 'avocado@avocado.com', 
'010-6666-6666', '11111', '����', '������', '������');
INSERT INTO tb_member (mem_userid, mem_userpw, mem_name, mem_gender, mem_email, mem_hp, mem_zipcode, 
mem_address1, mem_address2, mem_address3) VALUES ('berry', '7777', '��ָ�', '����', 'berry@berry.com', 
'010-7777-7777', '11111', '����', '������', '��ġ��');


SELECT mem_userid, mem_name, mem_gender FROM tb_member;
SELECT mem_userid, 'mem_weight' FROM tb_member;
-- �ʵ带 ��Ī���� �ٲٱ� (�Ͻ���)
SELECT mem_userid AS "���̵�", mem_userpw AS "��й�ȣ" FROM tb_member;

-- order by (����)
-- asc : ��������, desc : ��������
-- �������� �������� => �ѱ� : �����ٶ�.., ���� : ABCD.., ���� : 1234.., ��¥ : ������¥..,
SELECT mem_userid, mem_name, mem_regdate FROM tb_member ORDER BY mem_regdate ASC;
SELECT mem_userid, mem_name, mem_regdate FROM tb_member ORDER BY mem_regdate DESC;

-- ���� �ֱٿ� ������ ������ ������ ���ڸ� ���
SELECT * FROM tb_member WHERE mem_gender = '����' ORDER BY mem_regdate DESC;

SELECT * FROM tb_member ORDER BY mem_gender DESC;
-- ������ �������� ���� �� ���� ����� ��� ���Լ����� ���
SELECT mem_userid, mem_name, mem_gender, mem_regdate FROM tb_member ORDER BY mem_gender DESC, mem_regdate ASC;

-- �ߺ��� ���ֱ�(distinct)
SELECT DISTINCT mem_gender FROM tb_member;


-- �ֹ� ���̺� ����
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
VALUES ('0000000001','jhjun', '������',1); --integrity constraint (SYS.FK_USERID) violated - parent key not FOUND
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000001','apple', '������',1);
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000002','orange', 'û�ұ�',1);
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000003','melon', '��Ź��',1);
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count)
VALUES ('0000000004','apple', '�����',1);

-- ����(join)
-- �� ���̺��� ����� �÷�(����)���� �����͸� ���� ǥ��
-- SELECT M.mem_userid, M.mem_name, O.ord_product, O.ord_regdate FROM tb_member AS M, tb_order AS O WHERE M.mem_userid = O.ord_userid;

-- inner join(������)
SELECT mem_userid, mem_name, ord_product, ord_regdate FROM tb_member JOIN tb_order 
ON tb_member.mem_userid = tb_order.ord_userid;

-- left join(�������̺� ����)
SELECT mem_userid, mem_name, ord_product, ord_regdate FROM tb_member LEFT JOIN tb_order 
ON tb_member.mem_userid = tb_order.ord_userid;

-- right join(�������̺� ����)
SELECT mem_userid, mem_name, ord_product, ord_regdate FROM tb_member RIGHT JOIN tb_order 
ON tb_member.mem_userid = tb_order.ord_userid;


-- group by(�׷�)
-- select �÷���1, �÷���2 .. from ���̺�� where ������ group by �׷��� ���� �÷��� having ������ order by ������ �÷�
-- �׷��� ���� ��� select �ڿ� ������ Ű������ �׷��� ���� �÷� �Ǵ� �����Լ��� ����
-- �����Լ� ( count() : ����, sum() : ����, avg() : ���, max() : �ִ밪, min() : �ּҰ� )
SELECT * FROM tb_member;
SELECT mem_gender FROM tb_member GROUP BY mem_gender;
SELECT mem_gender, mem_userid FROM tb_member GROUP BY mem_gender; -- not a GROUP BY expression
SELECT mem_gender, count(mem_userid) FROM tb_member GROUP BY mem_gender;
SELECT mem_gender, count(mem_userid) FROM tb_member GROUP BY mem_gender HAVING count(mem_userid) > 3;
SELECT mem_gender, count(mem_userid) FROM tb_member WHERE mem_userid
NOT IN ('banana', 'melon', 'avocado') GROUP BY mem_gender HAVING count(mem_userid) > 2;

-- hr ���� Ȱ��ȭ
ALTER USER hr account unlock;
ALTER USER hr IDENTIFIED BY hr;

SELECT * FROM hr.EMPLOYEES;