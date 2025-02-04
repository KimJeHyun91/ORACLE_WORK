-- 한줄 주석(단축키 : Ctrl +/)
/*
여러줄 주석(단축키 : Alt + Shift + c)
*/

-- 나의 계정 보기
SHOW USER;

-- 사용자 계정 조회
SELECT * FROM DBA_USERS;

SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS;

-- 사용자 만들기
-- 오라클 12버전부터 일반사용자는 C##으로 시작하는 이름을 가져야한다.
CREATE USER C##user2 IDENTIFIED BY 1234;

-- C##을 회피하는 방법
ALTER SESSION SET "_oracle_script" = true;

CREATE USER user2 IDENTIFIED BY 1234;

-- 사용할 계정 만들기
-- 계정 이름은 대소문자 상관없음
-- 비밀번호는 대소문자 가림
CREATE USER jehyun IDENTIFIED BY 0920;

-- 권한 생성
-- GRANT 권한1, 권한2, ... TO 계정명;
GRANT CONNECT TO jehyun;
GRANT RESOURCE TO jehyun;

-- INSERT 할 때 테이블 스페이스 USERS에 대한 권한이 없습니다. 오류시 테이블 스페이스를 할당해야됨
-- ALTER USER jehyun QUOTA 50M ON USERS; 테이블 스페이스 직접 지정
ALTER USER jehyun DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS; -- 테이블 스페이스 무제한으로 지정

CREATE USER C##workbook IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO C##workbook;
ALTER USER C##workbook DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

