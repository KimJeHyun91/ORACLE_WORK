-- ALTER : 객체를 변경하는 구문
-- ALTER 객체 객체명 변경할 내용;
-- 변경할 내용
-- 1. 컬럼 추가/삭제/수정
-- 2. 제약조건 추가/삭제 : 제약조건 수정 불가
-- 3. 컬럼명/제약조건명/테이블명 변경
-- 4. 테이블 삭제

-- 1. 컬럼 추가/수정/삭제
-- 1.1 컬럼 추가 (ADD)
-- ADD 컬럼명 데이터타입 [DEFAULT 기본값]
ALTER TABLE DEPT_COPY ADD PROFESSOR_ID VARCHAR (10);

ALTER TABLE DEPT_COPY ADD NATIONAL_CODE CHAR (2) DEFAULT 'KO' CHECK(NATIONAL_CODE IN ('KO', 'NA'));

ALTER TABLE DEPT_COPY ADD PRIMARY KEY (DEPT_ID);

-- 1.2 컬럼 수정 (MODIFY)
-- 데이터 타입 수정
-- MODIFY 컬럼명 데이터타입 [DEFAULT 기본값]
ALTER TABLE DEPT_COPY MODIFY PROFESSOR_ID DEFAULT '000';

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR (30);

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NUMBER; -- 오류 : 컬럼의 타입을 변경하려면 값들을 모두 지워야 변경가능

ALTER TABLE EMP_COPY MODIFY EMP_ID CHAR (20);

ALTER TABLE EMP_COPY MODIFY SALARY VARCHAR (50); -- 오류 : 컬럼의 타입을 변경하려면 값들을 모두 지워야 변경가능

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR (40);

ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR (2);

ALTER TABLE DEPT_COPY MODIFY NATIONAL_CODE DEFAULT 'TA';

ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE VARCHAR (50)
MODIFY LOCATION_ID VARCHAR (3)
MODIFY NATIONAL_CODE DEFAULT 'KO';

-- 1.3 컬럼 삭제(DROP)
-- DROP COLUMN 컬럼명
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

-- 다중 삭제가 안됨
ALTER TABLE DEPT_COPY2 
DROP COLUMN DEPT_ID
DROP COLUMN DEPT_LOCATION; -- 오류

-- 테이블에 하나의 컬럼만 있을 때 삭제가 안됨
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_LOCATION;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID; -- 오류 : 한개의 컬럼만 남아 있음

-- 2. 제약조건
ALTER TABLE DEPT_COPY2 ADD PRIMARY KEY (DEPT_ID);


-- 3. 컬럼명/테이블명 변경
-- 3.1 컬럼명 변경
-- RENAME COLUMN 기본컬럼명 TO 바꿀컬럼명
ALTER TABLE DEPT_COPY RENAME COLUMN PROFESSOR_ID TO P_ID;
ALTER TABLE DEPT_COPY RENAME COLUMN NATIONAL_CODE TO N_CODE;
-- 3.2 테이블명 변경
-- RENAME TO 바꿀테이블명
ALTER TABLE DEPT_COPY RENAME TO DEPT_COPY3;
-- 3.3 제약조건명 변경
-- RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
ALTER TABLE DEPT_COPY3 RENAME CONSTRAINT SYS_C007583 TO PRI;

-- 4. 테이블 삭제
-- DROP TABLE 테이블명;
DROP TABLE DEPT_COPY2;
-- 외래키의 부모테이블은 삭제 안됨
-- 삭제하고 싶으면
-- 1. 자식테이블을 먼저 삭제한 후 부모테이블 삭제
-- 2. 부모테이블만 삭제하는데 제약조건을 같이 삭제하는 방법
-- DROP TABLE 부모테이블명 CASCADE CONSTRAINT;






