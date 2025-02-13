-- TCL(TRANSACTION CONTROL LANGUAGE) : 트랜잭션 제어언어
-- 트랜잭션
-- 1. 데이터베이스의 논리적 연산단위
-- 2. 데이터의 변경사항(DML)들을 하나의 트랜잭션에 묶어서 처리
--      - DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
--      - 트랜잭션이 존재하지 않으면 트랜잭션을 만들어서 묶어서 처리
--      - COMMIT 하기 전까지의 변경사항들을 하나의 트랜잭션에 담음
-- 3. 트랜잭션의 대상이 되는 SQL은 INSERT, UPDATE, DELETE
-- 
-- COMMIT : 트랜잭션 종료 처리 후 확정
--      - 한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영 시킴(트랜잭션 없어짐)
--      - 자동으로 COMMIT이 되는 경우
--          1) 정상 종료
--          2) DCL과 DDL(CREATE, ALTER, DROP) 명령문이 수행된 경우
-- ROLLBACK : 트랜잭션 취소
--      - 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 COMMIT시점으로 돌아감
--      - 자동으로 ROLLBACK이 되는 경우
--          1) 비정상 종료
-- SAVEPOINT : 임시 저장
--      - 현재 이 시점에 해당포인트명으로 임시저장점을 정의해둠
--      - ROLLBACK 진행시 변경사항들을 다 삭제하는 것이 아니라 일부만 삭제 가능

CREATE TABLE EMP_01 AS (
    SELECT *
    FROM EMPLOYEE
);

SELECT *
FROM EMP_01;

-- 1
DELETE 
FROM EMP_01
WHERE EMP_ID = '301'; -- 트랜잭션에 저장(DB에는 반영되지 않음)
-- 2
DELETE
FROM EMP_01
WHERE EMP_ID = '210'; -- 트랜잭션에 저장(DB에는 반영되지 않음)

ROLLBACK; -- 1, 2의 트랜잭션에 저장된 내용들의 취소

-- 3
INSERT 
INTO EMP_01 (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) 
VALUES ('302', '호랑이', '952333-1352882', 'J2'); -- 트랜잭션에 저장(DB에는 반영되지 않음)

-- 4
DELETE
FROM EMP_01
WHERE EMP_ID = '201'; -- 트랜잭션에 저장(DB에는 반영되지 않음)

COMMIT; -- 3, 4의 트랜잭션에 저장된 내용들을 DB에 반영 후 트랜잭션 삭제

ROLLBACK; -- 트랜잭션에 저장된 내용이 없으므로 아무런 변화가 없음

-- 5
DELETE
FROM EMP_01
WHERE EMP_ID IN ('210', '302', '211'); -- 트랜잭션에 저장(DB에는 반영되지 않음)

SAVEPOINT S1; -- 5의 트랜잭션 저장이 세이브포인트에 저장됨

-- 6
INSERT 
INTO EMP_01 (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) 
VALUES ('303', '개구리', '922633-1252882', 'J2'); -- 트랜잭션에 저장(DB에는 반영되지 않음)

ROLLBACK TO S1; -- 세이브포인트 S1으로 트랜잭션이 저장됨/6 트랜잭션 작업 취소됨

ROLLBACK; -- 마지막 COMMIT 시점 즉 5,6 트랜잭션 작업과 세이브포인트 생성이 취소됨

COMMIT;

-- 자동
-- 1
DELETE 
FROM EMP_01
WHERE EMP_ID IN ('205', '213'); -- 트랜잭션에 저장(DB에는 반영되지 않음)
-- 2
DELETE
FROM EMP_01
WHERE EMP_ID = '215';  -- 트랜잭션에 저장(DB에는 반영되지 않음)
-- 3
CREATE TABLE TEST (
    NAME CHAR (2)
); -- TEST 테이블이 생성되고 트랜잭션에 저장된 작업들과 합께 DB에 반영됨(자동 COMMIT됨)(트랜잭션 종료)

ROLLBACK; -- 3 작업으로 인해서 자동으로 COMMIT이 되었기 때문에 트랜잭션에 저장된 작업이 없음





