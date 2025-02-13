-- DCL (DATA CONTROL LANGUAGE)
-- 데이터 제어 언어
-- 계정에게 시스템 권한 또는 객체에 접근할 수 있는 권한 부여 (GRANT) 하거나 회수 (REVOKE)하는 구문
-- 1. 시스템 권한 : DB에 접근하는 권한, 객체들을 생성할 수 있는 권한
-- 1) CREATE SESSION : 접속할 수 있는 권한
-- 2) CREATE TABLE : 테이블을 생성할 수 있는 권한
-- 3) CREATE VIEW : 뷰를 생성할 수 있는 권한
-- 4) CREATE SQUENCE : 시퀀스를 생성할 수 있는 권한
-- ...
ALTER SESSION SET "_oracle_script" = true;
CREATE USER SAMPLE_01 IDENTIFIED BY 1234; -- 사용자 생성/접속 권한 없음
GRANT CREATE SESSION TO SAMPLE_01; -- 접속 권한 부여
GRANT CREATE TABLE TO SAMPLE_01; -- 테이블 생성 권한 부여
ALTER USER SAMPLE_01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS; -- 테이블 스페이스 부여

-- 2. 객체 접근 권한 : 객체를 조작할 수 있는 권한
-- 1) SELECT : TABLE, VIEW, SEQUENCE
-- 2) INSERT : TABLE, VIEW
-- 3) UPDATE : TABLE, VIEW
-- 4) DELETE : TABLE, VIEW
-- ...
-- GRANT 권한의 종류 ON 특정객체 TO 계정명;
GRANT SELECT ON JEHYUN.EMPLOYEE TO SAMPLE_01; -- JEHYUN 계정에 있는 EMPLOYEE에 대한 SELECT 권한을 SAMPLE_01에게 부여함

GRANT INSERT ON JEHYUN.EMPLOYEE TO SAMPLE_01; -- JEHYUN 계정에 있는 EMPLOYEE에 대한 INSERT 권한을 SAMPLE_01에게 부여함

-- 권한 회수
-- REVOKE SELECT ON 특정객체 FROM 계정명;
REVOKE SELECT ON JEHYUN.EMPLOYEE FROM SAMPLE_01;

-- ROLE : 특정 권한들을 하나의 집합으로 모아놓은 것
-- CONNECET : CREATE, SESSION
-- RESOURCE : CREATE TABLE, CREATE SEQUENCE, ... 
-- DBA : 시스템 및 객체관리에 대한 모든 권한을 갖고 있는 롤

GRANT CONNECT, RESOURCE TO SAMPLE_01;


