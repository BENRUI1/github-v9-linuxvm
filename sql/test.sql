
set serveroutput on size 1000000
set heading off
set feedback off
set verify off
set echo off
set lines 2000 
set pages 2000
set linesize 500 
set pagesize 0

declare
  l_date date;
begin
  select sysdate into l_date from dual;
  dbms_output.put_line('sysdate: ' || to_char(l_date, 'DD/MM/YYYY HH24/MI/SS'));
end;
/

exit;
