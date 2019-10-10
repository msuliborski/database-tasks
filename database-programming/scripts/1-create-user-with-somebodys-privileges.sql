set pages 0 feed off veri off lines 500

accept oldname prompt "Enter username to create like: "
accept newname prompt "Enter new user name: "
-- accept psw prompt "Enter new user's password: "

-- Create user...
select 'create user &&newname identified by values '''||password||''''||
-- select 'create user &&newname identified by &psw'||
' default tablespace '||default_tablespace||
' temporary tablespace '||temporary_tablespace||' profile '||
profile||';'
from sys.dba_users
where username = upper('&&oldname');

-- Grant Roles...
select 'grant '||granted_role||' to &&newname'||
decode(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION')||';'
from sys.dba_role_privs
where grantee = upper('&&oldname');

-- Grant System Privs...
select 'grant '||privilege||' to &&newname'||
decode(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION')||';'
from sys.dba_sys_privs
where grantee = upper('&&oldname');

-- Grant Table Privs...
select 'grant '||privilege||' on '||owner||'.'||table_name||' to &&newname;'
from sys.dba_tab_privs
where grantee = upper('&&oldname');

-- Grant Column Privs...
select 'grant '||privilege||' on '||owner||'.'||table_name||
'('||column_name||') to &&newname;'
from sys.dba_col_privs
where grantee = upper('&&oldname');

-- Tablespace Quotas...
select 'alter user '||username||' quota '||
decode(max_bytes, -1, 'UNLIMITED', max_bytes)||
' on '||tablespace_name||';'
from sys.dba_ts_quotas
where username = upper('&&oldname');

-- Set Default Role...
set serveroutput on
declare
defroles varchar2(4000);
begin
for c1 in (select * from sys.dba_role_privs
where grantee = upper('&&oldname')
and default_role = 'YES'
) loop
if length(defroles) > 0 then
defroles := defroles||','||c1.granted_role;
else
defroles := defroles||c1.granted_role;
end if;
end loop;
dbms_output.put_line('alter user &&newname default role '||defroles||';');
end;