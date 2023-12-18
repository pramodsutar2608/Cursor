================================================================================

                                CURSOR

================================================================================
Defination: Cursor is private SQL memory area which is used to store multiple
records and also process record by record.

Types of Cursors: A) Implicit Cursor
                  B) Explicit Cursor

--------------------------------------------------------------------------------
                            A) Implicit Cursor

- SQL statements returns a single record is called Implicit Cursor
- Contains SELECT INTO CLAUSE or DML statements
- When block contains SELECT INTO CLAUSE oracle server creates Memory Area & returns
single record.
- This memory area is also called SQL Area.

set serveroutput on;

Declare 
v_ename varchar2(10);
v_sal number (10);

Begin
select ename,sal into v_ename,v_sal from emp1
where empno=7902;
dbms_output.put_line(v_ename||'-->'||v_sal);
end;

--------------------------------------------------------------------------------
                            A)Explicit Cursor
                            
- SQL statements returns multiple records is called Explicit Cursor.
- Explicit cursor memory area is also called as active set area.
- In this cursor we are storing multiple records & also these records are controlled
by database developers explicitly but database developers cannot control implicit 
cursor memory area records.
- Explicit Cursor Lifecycle:
            1) Declare
            2) Open
            3) Fetch
            4) Close
-Syntax:  
            Fetch cursor_name into variable_1,vriable_2....
            
--------------------------------------------------------------------------------
select * from cursor1;

Declare
cursor c1 is select empno,ename,sal from cursor1;
v_empno number;
v_ename varchar2(100);
v_sal number;

Begin
open c1;
fetch c1 into v_empno,v_ename,v_sal;

dbms_output.put_line(v_empno||'--->'||v_ename||'--->'||v_sal);
close c1;
end;           

------OR-----

Declare 
Cursor c1 is select * from cursor1;
i c1%rowtype;

Begin
open c1;
fetch c1 into i;

dbms_output.put_line(i.empno||'--->'||i.ename||'--->'||i.sal);
close c1;
end;

--------------------------------------------------------------------------------
                    EXPLICIT CURSOR ATTRIBUTE
            
1) %notfound
2) %found
3) %isopen
4) %rowcount

- All cursor attributes used along with cursor_name only
- Syntax : 
            cursor_name % attribute_name
            c1%notfound
            
--------------------------------------------------------------------------------
                EXAMPLES ON EXPLICIT CURSOR LIFECYCLE
--------------------------------------------------------------------------------
Display all records from emp1 table using explicit lifecycle.

select * from emp1;

Declare
cursor c1 is select ename,sal from emp1;
v_ename varchar2(20);
v_sal number(10);

Begin
open c1;
loop
fetch c1 into v_ename,v_sal;
exit when c1%notfound;
dbms_output.put_line(v_ename||' --> '||v_sal);
end loop;
close c1;
end;

set serveroutput on;

------------------

Declare 
cursor c1 is select * from emp1;
i emp1%rowtype;

Begin
open c1;
loop
fetch c1 into i;
exit when c1%notfound;
dbms_output.put_line(i.ename||' --> '||i.sal);
end loop;
close c1;
end;






--------------------------------------------------------------------------------
WRITE A PL/SQL CURSOR PROGRAM TO DISPLAY FIRST FIVE HIGHEST SALARY EMPLOYEES FROM 
EMP1 TABLE USING %ROWCOUNT ATTRIBUTE.

-------
DECLARE 
CURSOR C1 IS SELECT ENAME,SAL FROM EMP1
WHERE SAL IS NOT NULL
ORDER BY SAL DESC;

V_ENAME VARCHAR2(20);
V_SAL NUMBER(10);

BEGIN 
OPEN C1;
LOOP
FETCH C1 INTO V_ENAME,V_SAL;
DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME-->'||V_ENAME||', SALARY-->'||V_SAL);
EXIT WHEN C1%ROWCOUNT=5;
END LOOP;
CLOSE C1;
END;






--------------------------------------------------------------------------------

WRITE A PL/SQL CURSOR PROGRAM TO DISPLAY EVEN NUMBER OF ROWS FROM EMP1 TABLE
USING %ROWCOUNT ATTRIBUTE.


-------
DECLARE 
CURSOR C1 IS SELECT EMPNO,ENAME,SAL
FROM EMP1;
V_EMPNO NUMBER(10);
V_ENAME VARCHAR2(20);
V_SAL NUMBER(10);

BEGIN 
OPEN C1;
LOOP
FETCH C1 INTO V_EMPNO,V_ENAME,V_SAL;
IF MOD(C1%ROWCOUNT,2)=0 THEN 
DBMS_OUTPUT.PUT_LINE('NO-->'||V_EMPNO||' NAME-->'||V_ENAME||' SALARY--> '||V_SAL);
END IF;
EXIT WHEN C1%NOTFOUND;
END LOOP;
CLOSE C1;
END;

OR

-----------------------
DECLARE 
CURSOR C1 IS SELECT * FROM EMP1;
I EMP1%ROWTYPE;

BEGIN 
OPEN C1;
LOOP
FETCH C1 INTO I;
IF MOD(C1%ROWCOUNT,2)=0 THEN 
DBMS_OUTPUT.PUT_LINE(I.ENAME||' '||I.SAL);
END IF;
EXIT WHEN C1%NOTFOUND;
END LOOP;
CLOSE C1;
END;

--------------------------------------------------------------------------------

Requirement: Get empno,ename,sal from emp1 using %rowtype attribute


-------
Declare 
cursor c1 is select * from emp1;
i c1%rowtype;

Begin
open c1;
loop
fetch c1 into i;
exit when c1%notfound;
dbms_output.put_line(i.empno||'-->'||i.ename||'-->'||i.sal);
end loop;
close c1;
end;

--------------------------------------------------------------------------------
Fetch records of employees whose salary is more than 2000

Declare 
cursor c1 is select * from emp1;
i c1%rowtype;

Begin
open c1;
loop
fetch c1 into i;
if i.sal>2000 then
dbms_output.put_line(i.ename||' --> '||i.sal);
exit when c1%notfound;
end if;
end loop;
close c1;
end;

--------------------------------------------------------------------------------
Transfer data from one table to other table- Insert records from emp1 (sal>2000) into target table.

create table target
as select * from emp1
where 1=2;

select * from target;
select * from emp1
where sal>2000;

---------------
Declare 
cursor c1 is select * from emp1
where sal>2000;
i c1%rowtype;

Begin
open c1;
loop
fetch c1 into i;
insert into target (empno,ename,sal)
            values(i.empno,i.ename,i.sal);
exit when c1%notfound;
end loop;
close c1;
end;

-------
delete from target;
select * from target;
--------------------------------------------------------------------------------
Delete records:

select * from cursor1;

BEGIN
DELETE FROM CURSOR1
WHERE EMPNO=1111;

IF(sql%found) THEN
DBMS_OUTPUT.PUT_LINE('DELETED RECORDS COUNT IS --->'||sql%rowcount);

ELSE 
DBMS_OUTPUT.PUT_LINE('NO ROWS DELETED');

END IF;
END;
--------------------------------------------------------------------------------
Update table:

select * from cursor1 where deptno=10;

BEGIN
UPDATE CURSOR1
SET SAL=SAL+1101
WHERE DEPTNO=10;

IF (SQL%FOUND) THEN
DBMS_OUTPUT.PUT_LINE('ROWS UPDATED '||SQL%ROWCOUNT);

ELSE 
DBMS_OUTPUT.PUT_LINE('NO ROWS UPDATED ');

END IF;
END;

SELECT * FROM CURSOR1
WHERE DEPTNO=10;
--------------------------------------------------------------------------------
Insert:

BEGIN
--INSERT INTO CURSOR1 (EMPNO,ENAME)
--VALUES(1,'RAW');

IF (SQL%FOUND) THEN
DBMS_OUTPUT.PUT_LINE('ROWS INSERTED '||SQL%ROWCOUNT);

ELSE 
DBMS_OUTPUT.PUT_LINE('NO ROWS UPDATED ');

END IF;
END;

SELECT * FROM CURSOR1;

--------------------------------------------------------------------------------


alter table cursor1
modify ename varchar2(20);

update cursor1
set ename='Pramod Sutar'
where empno=7902;

-----------------------------
--Change variable size

declare 
v_ename varchar2(20);
begin
select ename
into v_ename
from cursor1
where empno=7902;

dbms_output.put_line(v_ename);
end;

-----------------------------------
--Use %type

declare 
v_ename cursor1.ename%type;
begin
select ename
into v_ename
from cursor1
where empno=7902;

dbms_output.put_line(v_ename);
end;

-----------------------------------
select * from emp1
where rowid<>(select min(rowid) from emp1)
             intersect 
select * from emp1
where rowid<>(select max(rowid) from emp1);
             
----------
select max(sal) from emp1
where sal<(select max(sal) from emp1
           where sal<(select max(sal) from emp1));

------------
select level,max(sal) from emp1
where level=3
connect by prior sal>sal
group by level;

--------------------------------------------------------------------------------
set serveroutput on;
--------------------------------------------------------------------------------
             ELIMITING EXPLICIT CURSOR LIFECYCLE

Without using -> %rowtype 
              -    open
              -    fetch
              -    exit
              -    close

When we use "FOR LOOPS" internlly oracle use open,fetch close statements.

REQUIREMENT: Insert all data from n1 to n2 based on empno.

create table n1
as select * from emp1;

create table n2
as select * from n1
where 1=2;

select * from n1;
select * from n2;

insert into n2 (empno)
select empno from n1;

select * from n2;

------------
Declare 
cursor c1 is select * from n1;

Begin
for i in c1
loop
update n2
set ename=i.ename,
    job=i.job,
    mgr=i.mgr,
    hiredate=i.hiredate,
    sal=i.sal,
    comm=i.comm,
    deptno=i.deptno,
    email=i.email
where empno=i.empno;
end loop;
commit;
End;
------------

select * from n2;

--------------------------------------------------------------------------------
Requirement: 
From n1 table insert data of deptno=10 in table n10,
                     data of deptno=20 in table n20,
                     data of other than 10,20 dept in table n30.
                     
create table n10 as select * from n1
where 1=2;

create table n20 as select * from n1
where 1=2;

create table n30 as select * from n1
where 1=2;

select * from n10;
select * from n20;
select * from n30;

--------
Declare 
cursor c1 is select * from n1;

Begin
for i in c1
loop
if i.deptno=10 then
insert into n10
values(i.empno,i.ename,i.job,i.mgr,i.hiredate,i.sal,i.comm,i.deptno,i.email);

elsif i.deptno=20 then
insert into n20
values(i.empno,i.ename,i.job,i.mgr,i.hiredate,i.sal,i.comm,i.deptno,i.email);

else 
insert into n30
values(i.empno,i.ename,i.job,i.mgr,i.hiredate,i.sal,i.comm,i.deptno,i.email);

end if;
end loop;
End;

----------------
select * from n10;
select * from n20;
select * from n30;

--------------------------------------------------------------------------------
Check conddition first & then insert

delete from n10;

-------
Declare 
cursor c1 is select * from n1;
v_count1 number(10);
v_count2 number(10);
v_count3 number(10);

Begin

for i in c1

loop

select count(1) into v_count1 from n10
where empno=i.empno;

select count(1) into v_count2 from n20
where empno=i.empno;

select count(1) into v_count3 from n30
where empno=i.empno;

if v_count1=0 and i.deptno=10 then
insert into n10
values(i.empno,i.ename,i.job,i.mgr,i.hiredate,i.sal,i.comm,i.deptno,i.email);

elsif v_count2=0 and i.deptno=20 then
insert into n20
values(i.empno,i.ename,i.job,i.mgr,i.hiredate,i.sal,i.comm,i.deptno,i.email);

elsif v_count3=0 and i.deptno not in(10,20) then
insert into n30
values(i.empno,i.ename,i.job,i.mgr,i.hiredate,i.sal,i.comm,i.deptno,i.email);

end if;
end loop;
commit;
End;

-------------------------
select * from n10;
select * from n20;
select * from n30;

delete from n30;

commit;




================================================================================








