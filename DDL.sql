-- DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
-- 오라클에서 제공하는 객체(OBJECT)를 만들고(CREATE), 구조를 변경하고(ALTER)하고, 구조를 삭제(DROP) 하는 언어
-- 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
-- 주로 DB관리자, 설계자가 사용함
-- 오라클 객체(구조) : 테이블, 뷰, 시퀀스, 인덱스, 패키지, 트리거, 프로시저, 함수, 동의어, 사용자

-- CREATE : 객체 생성
-- 1. 테이블 생성
-- 테이블이란 : 행과 열로 구성된 가장 기본적인 데이터베이스 객체이고 모든 데이터들은 테이블을 통해 저장됨
-- CREATE TABLE 테이블명 (
--                          컬럼명 자료형 (크기),                    
--                          컬럼명 자료형 (크기),
--                          컬럼명 자료형,
--                          ...
--                      )
-- 1.1 자료형
-- 1) 문자 (CHAR (바이트크기)) | (VALCHAR (바이트크기)) : 반드시 크기 지정 해야됨
--  1) CHAR    : 최대 2000BYTE 까지 지정 가능, 지정한 크기보다 적은 값이 들어와도 공백으로 채워서 지정한 크기만큼 고정, 고정된 길이의 데이터 사용시
--  2) VARCHAR2 : 최대 4000BYTE 까지 지정 가능, 들어오는 크기에 따라 공간이 맞춰짐                                 , 일정하지 않은 길이의 데이터 사용시
-- 1.2 숫자(NUMBER)
-- 1.3 날짜(DATE)

CREATE TABLE MEMBER (
                        MEM_NO NUMBER,
                        MEM_ID VARCHAR2(20),
                        MEM_PWD VARCHAR2(20),
                        MEM_NAME VARCHAR2(20),
                        GENDER CHAR(3),
                        PHONE VARCHAR2(15),
                        EMAIL VARCHAR2(40),
                        MEM_DATE DATE
                    );

-- 2. 컬럼에 주석 달기(컬럼에 대한 설명)
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';

COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.GENDER IS '회원성별';
COMMENT ON COLUMN MEMBER.PHONE IS '회원전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '회원이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

INSERT INTO MEMBER VALUES (1, 'User01', 'Pass01', '강아지', '남', '010-1111-1111', 'gang@naver.com', '20/08/22');
INSERT INTO MEMBER VALUES (2, 'User02', 'Pass02', '고양이', '여', '010-0000-0000', 'go@naver.com', '20/04/12');                    
INSERT INTO MEMBER VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);                    
INSERT INTO MEMBER VALUES (3, 'User03', 'Pass03', '개구리', NULL, NULL, NULL, NULL);

-- 3. 제약 조건
-- 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
-- 데이터 무결성 보장을 목적으로 함 : 데이터에 결합이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
-- 1) 개체 무결성 제약조건 : NOT NULL, UNIQUE, PRIMARY KEY 조건 위배
-- 2) 참조 무결성 제약조건 : FOREIGN KEY(외래키) 조건 위배

-- 종류 : NOT NULL, UNIQUE, CHECK(조건), PRIMARY_KEY, FOREIGN KET
-- 제약조건을 부여하는 방식 2가지
-- 1) 컬럼 라벨 방식 : 컬럼명 자료형 옆에 기술
-- 2) 테이블 라벨 방식 : 모든 컬럼을 정의한 후 마지막 기술

-- NOT NULL : 해당 컬럼에 반드시 값이 존재해야 됨(즉, NULL이 들어오면 안됨), 삽입/수정시 NULL값을 허용하지 않음
-- 주의사항 : 컬럼 라벨 방식밖에 안됨

-- 컬럼 라벨 방식
CREATE TABLE MEM_NOTNULL (
                            MEM_NO NUMBER NOT NULL,
                            MEM_ID VARCHAR2(20) NOT NULL,
                            MEM_PWD VARCHAR2(20) NOT NULL,
                            MEM_NAME VARCHAR2(20) NOT NULL
                         );
                        
INSERT INTO MEM_NOTNULL VALUES (1, 'User013', 'Pass01', '강아지');
INSERT INTO MEM_NOTNULL VALUES (4, 'User02', 'Pass02', NULL); -- NULL 값이 입력 안됨                   

-- UNIQUE
-- 컬럼값에 중복값을 제한하는 제약조건
-- 삽입/수정시 기존의 데이터와 동일한 중복값이 있을 때 오류 발생

-- 컬럼 라벨 방식
-- CREATE TABLE 테이블명 (
--                          컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
--                          컬럼명 자료형,
--                          ...
--                      )

CREATE TABLE MEM_UNIQUE(
                            MEM_NO NUMBER NOT NULL UNIQUE,
                            MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
                            MEM_PWD VARCHAR2(20) NOT NULL,
                            MEM_NAME VARCHAR2(20) NOT NULL UNIQUE,
                            GENDER CHAR(3),
                            PHONE CHAR(13),
                            EMAIL VARCHAR(40),
                            BIRTH DATE
                        );

INSERT INTO MEM_UNIQUE VALUES (1, 'User01', 'Pass01', '강아지', '남', '010-1111-1111', 'gang@naver.com', '20/08/22');
INSERT INTO MEM_UNIQUE VALUES (2, 'User02', 'Pass02', '고양이', '여', '010-0000-0000', 'go@naver.com', '20/04/12');                    
INSERT INTO MEM_UNIQUE VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);                    
INSERT INTO MEM_UNIQUE VALUES (3, 'User03', 'Pass03', '개구리', NULL, NULL, NULL, NULL);


-- 테이블 라벨 방식
-- CREATE TABLE 테이블명 (
--                          컬럼명 자료형,
--                          컬럼명 자료형,
--                          ...
--                          제약조건명 (컬럼명),
--                          ...
--                      )

CREATE TABLE MEM_UNIQUE2 (
                            MEM_NO NUMBER NOT NULL,
                            MEM_ID VARCHAR2(20) NOT NULL,
                            MEM_PWD VARCHAR2(20) NOT NULL,
                            MEM_NAME VARCHAR2(20) NOT NULL,
                            GENDER CHAR(3),
                            PHONE CHAR(13),
                            EMAIL VARCHAR(40),
                            BIRTH DATE,
                            UNIQUE (MEM_NO),
                            UNIQUE (MEM_ID),
                            UNIQUE (MEM_NAME)
                        );

INSERT INTO MEM_UNIQUE2 VALUES (1, 'User01', 'Pass01', '강아지', '남', '010-1111-1111', 'gang@naver.com', '20/08/22');
INSERT INTO MEM_UNIQUE2 VALUES (2, 'User02', 'Pass02', '고양이', '여', '010-0000-0000', 'go@naver.com', '20/04/12');                    
INSERT INTO MEM_UNIQUE2 VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);                    
INSERT INTO MEM_UNIQUE2 VALUES (3, 'User03', 'Pass03', '개구리', NULL, NULL, NULL, NULL);

CREATE TABLE MEM_UNIQUE3 (
                MEM_NO NUMBER CONSTRAINT NO_NULL NOT NULL,
                MEM_ID VARCHAR2(20) CONSTRAINT ID_NULL NOT NULL,
                MEM_PWD VARCHAR2(20) CONSTRAINT PWD_NULL NOT NULL,
                MEM_NAME VARCHAR2(20) CONSTRAINT NAME_NULL NOT NULL,
                GENDER CHAR(3),
                PHONE CHAR(13),
                EMAIL VARCHAR(40),
                BIRTH DATE,
                CONSTRAINT NO_UNIQUE UNIQUE (MEM_NO),
                CONSTRAINT ID_UNIQUE UNIQUE (MEM_ID),
                CONSTRAINT NAME_UNIQUE UNIQUE (MEM_NAME)
            );

INSERT INTO MEM_UNIQUE3 VALUES (1, 'User01', 'Pass01', '강아지', '남', '010-1111-1111', 'gang@naver.com', '20/08/22');
INSERT INTO MEM_UNIQUE3 VALUES (2, 'User02', 'Pass02', '고양이', '여', '010-0000-0000', 'go@naver.com', '20/04/12');                    
INSERT INTO MEM_UNIQUE3 VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);                    
INSERT INTO MEM_UNIQUE3 VALUES (3, 'User03', 'Pass03', '개구리', NULL, NULL, NULL, NULL); 
INSERT INTO MEM_UNIQUE3 VALUES (4, 'User04', 'Pass04', '호랑이', 'ㄱ', NULL, NULL,NULL); 

-- CHECK(조건식) 제약조건
-- 해당 컬럼값에 들어올 수 있는 값에 대한 조건을 제시
-- 해당 조건에 맞는 데이터값만 입력하도록 함

CREATE TABLE MEMBER_CHECK (
    MEMBER_NO NUMBER NOT NULL UNIQUE,
    MEMBER_ID VARCHAR(30) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR(30) NOT NULL,
    MEMBER_NAME VARCHAR(30) NOT NULL,
    MEMBER_GENDER CHAR(3) CONSTRAINT "남/여 외의 글자" CHECK(MEMBER_GENDER IN ('남', '여')),
    MEMBER_PHONE VARCHAR(30) UNIQUE,
    MEMBER_EMAIL VARCHAR(50) UNIQUE
    -- CHECK(GENDER IN ('남', '여'))
);

COMMENT ON COLUMN MEMBER_CHECK.MEMBER_NO IS '회원번호';

INSERT INTO MEMBER_CHECK VALUES (1, 'user01', 'pass01', '강아지', 'm', NULL, NULL);

DROP TABLE MEM_NOTNULL;
DROP TABLE MEM_UNIQUE;
DROP TABLE MEM_UNIQUE2;
DROP TABLE MEM_UNIQUE3; 
DROP TABLE MEMBER;
DROP TABLE MEMBER_CHECK;



-- PRIMARY KEY(기본키) 제약조건
-- 테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)
-- 그 컬럼에 NOT NULL + UNIQUE 제약조건 : 검색, 삭제, 수정 등에 기본키의 컬럼을 이용
-- 예)회원번호, 학번, 사원번호, 운송장 번호, 예약번호, 주문번호 ...
-- 유의 사항 : 한 테이블 당 오직 한 개만 설정 가능

CREATE TABLE MEMBER_PRIMARY (
    MEMEBR_NO NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR(20) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR(20) NOT NULL,
    MEMBER_NAME VARCHAR(30) NOT NULL UNIQUE
    --, PRIMARY KEY (MEMBER_NO)
    --, UNIQUE (MEMBER_ID)
);

COMMENT ON COLUMN MEMBER_PRIMARY.MEMBER_NO IS '회원번호';

INSERT INTO MEMBER_PRIMARY VALUES (NULL, 'user01', 'pass01', '강아지'); -- PRIMARY KEY에는 NULL 값이나 중복된 값이 들어갈 수 없음
INSERT INTO MEMBER_PRIMARY VALUES (1, 'user01', 'pass01', '강아지');

DROP TABLE MEMBER_PRIMARY;

-- 복합키 : 기본키를 2개 이상의 컬럼을 묶어서 사용
-- 예)찜하기(회원번호|제품명)
-- 회원번호 1 제품명 A : 1A
-- 회원번호 1 제품명 B : 1B
-- 회원번호 1 제품명 C : 1C
-- 회원번호 2 제품명 A : 2A
-- 회원번호 2 제품명 C : 2C
-- PRIMARY KEY를 회원번호와 제품명으로 설정 했기 때문에 회원이 찜한 제품명을 설정 가능
-- 2개의 PRIMARY KEY가 합쳐져서 고유한 복합키가 생성됨 : 복합키로 회원과 회원이 찜한 제품을 식별
CREATE TABLE MULTY_PRIMARY (
    MEMBER_NO NUMBER,
    PRODUCT_NAME VARCHAR(20),
    PRODUCE_DATE DATE,
    PRIMARY KEY(MEMBER_NO, PRODUCT_NAME) -- 이 방식으로만 2개의 PRIMARY KEY를 설정할 수 있음
);

INSERT INTO MULTY_PRIMARY VALUES (1, 'A', SYSDATE);

DROP TABLE MULTY_PRIMARY;

-- FOREIGN KEY(외래키) 제약조건
-- 다른 테이블에 존재하는 값만 들어와야 되는 컬럼에 부여하는 제약조건
-- 다른 테이블을 참조한다라고 표현
-- 주로 FOREIGHN KEY 제약조건에 의해 테이블 간의 관계가 형성됨
-- 컬럼 라벨 방식 : 컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 (참조할컬럼명)
-- 테이블 라벨 방식 : [CONSTRAINT 제약조건명] FOREIGN KEY (컬럼명) REFERENCES 참조할테이블명 (참조할컬럼명)
CREATE TABLE MEMBER_GRADE (
    GRADE_CODE NUMBER,
    GRADE_NAME VARCHAR(30) NOT NULL,
    
    PRIMARY KEY (GRADE_CODE)
);
INSERT INTO MEMBER_GRADE VALUES (30, '특별 회원');
INSERT INTO MEMBER_GRADE VALUES (20, '우수 회원');
INSERT INTO MEMBER_GRADE VALUES (10, '일반 회원');

CREATE TABLE MEMBER_INFO1 (
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR(30) NOT NULL,
    MEMBER_PWD VARCHAR(30) NOT NULL,
    MEMBER_NAME VARCHAR(30) NOT NULL,
    MEMBER_GENDER CHAR(3),
    MEMBER_PHONE VARCHAR(30),
    MEMBER_EMAIL VARCHAR(50),
    GRADE_CODE NUMBER NOT NULL,
    
    PRIMARY KEY (MEMBER_NO),
    UNIQUE (MEMBER_ID, MEMBER_NAME, MEMBER_PHONE, MEMBER_EMAIL),
    CHECK (MEMBER_GENDER IN ('남', '여')),
    FOREIGN KEY (GRADE_CODE) REFERENCES MEMBER_GRADE -- [(GRADE_CODE)] 부모 테이블의 PRIMARY KEY를 참조할 때는 부모 테이블의 컬럼명을 생략 가능  
);

INSERT INTO MEMBER_INFO VALUES (1, 'user01', 'pass01', '강아지', '남', '010-1111-1111', NULL, 20);
INSERT INTO MEMBER_INFO VALUES (2, 'user02', 'pass02', '고양이', '여', '010-1111-1111', NULL, 50); -- 무결성 제약조건 위배(부모 키가 없음) 부모(MEMBER_GRADE) 자식(MEMBER_INFO)

-- 주의사항 : 부모 테이블에서 데이터 값을 삭제할 경우 문제 발생 -> 부모 테이블에서 자식 테이블에서 사용하고 있는 데이터를 삭제, 수정 할 경우 자식 테이블의 데이터가 어떻게 수정 될 것인지 지정해줘야 됨
-- 데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;                    
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = '20'; -- 자식 테이블에서 '20' 데이터를 사용하고 있기 때문에 삭제 불가(삭제 제한 옵션이 걸려 있음)
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = '30'; -- 자식 테이블에서 '30' 데이터를 사용하고 있지 않기 때문에 삭제 가능
INSERT INTO MEMBER_GRADE VALUES (30, '특별회원');

-- 자식 테이블 생성시 외래키 제약조건 기술시 삭제 옵션 지정 가능
-- 1. ON DELETE RESTRICT(기본값) : 자식 테이블이 부모 테이블의 데이터를 사용하고 있으면 삭제 불가
-- 2. ON DELETE SET NULL : 부모 테이블의 데이터가 삭제될 때, 해당 데이터를 사용하고 있는 자식 데이터의 값을 NULL로 변경
-- 3. ON DELETE CASCADE : 부모 테이블의 데이터가 삭제될 때, 해당 데이터를 사용하고 있는 자식 데이터의 값도 같이 삭제(행 전체삭제)

CREATE TABLE MEMBER_INFO2 (
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR(30) NOT NULL,
    MEMBER_PWD VARCHAR(30) NOT NULL,
    MEMBER_NAME VARCHAR(30) NOT NULL,
    MEMBER_GENDER CHAR(3),
    MEMBER_PHONE VARCHAR(30),
    MEMBER_EMAIL VARCHAR(50),
    GRADE_CODE NUMBER NOT NULL,
    
    PRIMARY KEY (MEMBER_NO),
    UNIQUE (MEMBER_ID, MEMBER_NAME, MEMBER_PHONE, MEMBER_EMAIL),
    CHECK (MEMBER_GENDER IN ('남', '여')),
    FOREIGN KEY (GRADE_CODE) REFERENCES MEMBER_GRADE (GRADE_CODE) ON DELETE CASCADE  
);
INSERT INTO MEMBER_INFO2 VALUES (1, 'user01', 'pass01', '강아지', NULL, NULL, NULL, 20);
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = '20'; -- 자식 테이블에서 ON DELETE CASCADE 라고 했기 때문에 '20'의 데이터 쓴 행이 삭제됨
INSERT INTO MEMBER_GRADE VALUES ('20', '우수회원');
DROP TABLE MEMBER_INFO2;
DROP TABLE MEMBER_GRADE;

-- DEFAULT 기본값
-- 제약 조건은 아니며, 컬럼에 값을 넣지 않았을 때(NULL 값을 넣었을 때) 기본값이 들어가도록 해줄 수 있음
-- 컬럼명 자료형 [DEFAULT 기본값] [[CONSTRAINT 제약조건명] 제약조건]

CREATE TABLE MEMBER (
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR (20) NOT NULL,
    MEMBER_NAME VARCHAR (30) NOT NULL,
    MEMBER_HOBBY VARCHAR (50) DEFAULT '없음',
    REGISTER_DATE DATE DEFAULT SYSDATE,
    MEMBER_AGE NUMBER,
    
    PRIMARY KEY (MEMBER_NO)
);

INSERT INTO MEMBER VALUES (1, 'user01', '강아지', '운동', '25/11/22', 25);
INSERT INTO MEMBER VALUES (2, 'user02', '고양이', NULL, NULL, NULL);
INSERT INTO MEMBER (MEMBER_NO, MEMBER_ID, MEMBER_NAME) VALUES (3, 'user03', '호랑이');
INSERT INTO MEMBER VALUES (4, 'user04', '개구리', DEFAULT, DEFAULT, NULL);
INSERT INTO MEMBER (MEMBER_NAME, MEMBER_ID, MEMBER_NO) VALUES ('참새', 'user05', 5);

-- SELECT 계정으로 실행
-- SUBQUERY를 이용한 테이블 생성
-- 1. 테이블을 모두 복사
-- 2. 테이블의 구조만 복사
-- 3. 테이블의 구조 및 데이터 모두 복사
-- CREATE TABLE 테이블명 AS 서브쿼리;

-- 1. 테이블을 모두 복사
CREATE TABLE EMPLOYEE_COPY1 AS 
    SELECT * 
    FROM EMPLOYEE;
-- 컬럼, 데이터만 복사
-- 제약조건의 경우 NOT NULL만 복사됨
DROP TABLE EMPLOYEE_COPY1;

-- 2. 테이블의 구조만 복사
CREATE TABLE EMPLOYEE_COPY2 AS 
    SELECT * 
    FROM EMPLOYEE 
    WHERE 1 = 0;
    
-- 3. 
CREATE TABLE EMPLOYEE_COPY3 AS 
    SELECT EMP_NO, EMP_ID, EMP_NAME, SALARY , SALARY*12 연봉
    FROM EMPLOYEE; -- 연산식이 들어간 컬럼은 반드시 별칭 부여
    
-- 테이블을 생성한 뒤 제약조건 추가
-- ALTER TABLE 테이블명 ADD(MODIFY) 변경할 내용;
-- ALTER TABLE 테이블명 ADD PRIMARY KEY (컬럼명);
-- ALTER TABLE 테이블명 ADD FOREIGN KEY (컬럼명) REFRENCES 참조할테이블명 (참조할컬럼명) [삭제 조건];
-- ALTER TABLE 테이블명 ADD UNIQUE (컬럼명);
-- ALTER TABLE 테이블명 ADD CHECK (컬럼에 대한 조건식);
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT 'N';

ALTER TABLE EMPLOYEE_COPY3 ADD PRIMARY KEY (EMP_ID);

ALTER TABLE EMPLOYEE_COPY1 ADD FOREIGN KEY (DEPT_CODE) REFERENCES DEPARTMENT (DEPT_ID);

COMMENT ON COLUMN EMPLOYEE_COPY1.EMP_NAME IS '사원 이름'; 

ALTER TABLE EMPLOYEE_COPY1 ADD CHECK (ENT_YN IN ('Y', 'N'));

ALTER TABLE EMPLOYEE_COPY1 ADD FOREIGN KEY (JOB_CODE) REFERENCES JOB ;

ALTER TABLE EMPLOYEE_COPY1 MODIFY ENT_YN DEFAULT 'N';

---------------------------------- 연습문제 -----------------------------------
-- DDL 실습문제
-- 도서관리 프로그램을 만들기 위한 테이블들 만들기
-- 이때, 제약조건에 이름을 부여할 것, 각 컬럼에 주석달기
-- 1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
--   컬럼  :  
--  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
--	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
--	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음
--  3개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_PUBLISHER (
    PUB_NO NUMBER,
    PUB_NAME VARCHAR (50) NOT NULL,
    PHONE VARCHAR (20),
    
    PRIMARY KEY (PUB_NO)
);
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사 번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사';

INSERT INTO TB_PUBLISHER VALUES (1, '강아지', NULL);
INSERT INTO TB_PUBLISHER VALUES (2, '고양이', '010-1111-1111');
INSERT INTO TB_PUBLISHER VALUES (3, '호랑이', NULL);

-- 2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
--  컬럼  :  
--  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
--	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
--	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
--	BK_PRICE(가격) NUMBER
--	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
--	이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
--  5개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_BOOK (
    BK_NO NUMBER,
    BK_TITLE VARCHAR (50) NOT NULL,
    BK_AUTHOR VARCHAR (20) NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER,
    FOREIGN KEY (BK_PUB_NO) REFERENCES TB_PUBLISHER (PUB_NO)
        ON DELETE CASCADE,    
    PRIMARY KEY (BK_NO)
);
COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서 번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '작가';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사 번호';

INSERT INTO TB_BOOK VALUES (1, '하늘', '강아지', 10000, 1);
INSERT INTO TB_BOOK VALUES (2, '땅', '고양이', 20000, 2);
INSERT INTO TB_BOOK VALUES (3, '바다', '호랑아', 40000, 1);
INSERT INTO TB_BOOK VALUES (4, '산', '개구리', 15000, 3);
INSERT INTO TB_BOOK VALUES (5, '해변', '참새', 25000, 2);

--3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
--   컬럼명 : 
--   MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
--   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
--   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
--   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
--   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
--   ADDRESS(주소) VARCHAR2(70)
--   PHONE(연락처) VARCHAR2(13)
--   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
--   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)
---- 5개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_MEMBER (
    MEMBER_NO NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR (30) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR (30) NOT NULL,
    MEMBER_NAME VARCHAR (20) NOT NULL,
    GENDER CHAR (1) CHECK (GENDER IN ('M', 'F')),
    ADDRESS VARCHAR (70),
    PHONE VARCHAR (20),
    STATUS CHAR (1) DEFAULT 'N' CHECK (STATUS IN ('Y', 'N')),
    ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL
);
COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원 번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';

INSERT INTO TB_MEMBER VALUES (1, 'user01', 'pass01', '강아지', 'M', '서울시', '010-1111-1111', 'N', '20/11/23');
INSERT INTO TB_MEMBER VALUES (2, 'user02', 'pass02', '고양이', 'F', '강원도', NULL, 'N', DEFAULT);
INSERT INTO TB_MEMBER VALUES (3, 'user03', 'pass03', '호랑이', 'F', '경기도', '010-2222-2222', 'N', '22/1/13');
INSERT INTO TB_MEMBER VALUES (4, 'user04', 'pass04', '개구리', 'M', '경상남도', NULL, 'N', DEFAULT);
INSERT INTO TB_MEMBER VALUES (5, 'user05', 'pass05', '참새', 'M', '서울시', '010-3333-3333', 'Y', '21/10/3');

--4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
--  컬럼  :  
--  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
--	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
--	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
--	RENT_DATE(대여일) DATE -- 기본값 SYSDATE
--   - 3개 정도 샘플데이터 추가하기
CREATE TABLE TB_RENT (
    RENT_NO NUMBER PRIMARY KEY,
    RENT_MEM_NO NUMBER REFERENCES TB_MEMBER (MEMBER_NO) ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER REFERENCES TB_BOOK (BK_NO) ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);
COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';
INSERT INTO TB_RENT VALUES (1, 2, 1, '20/11/21');
INSERT INTO TB_RENT VALUES (2, 3, 5, '21/2/11');
INSERT INTO TB_RENT VALUES (3, 2, 2, '20/4/5');

DROP TABLE TB_RENT CONSTRAINT 'SYS_C007500';
ALTER TABLE TB_RENT ADD

