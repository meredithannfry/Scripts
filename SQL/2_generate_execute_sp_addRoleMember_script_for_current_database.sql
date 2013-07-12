/* Script applicable to SQL Server 2005, 2008 and 2012.
   http://msdn.microsoft.com/en-us/library/ms187328.aspx
This script will generate EXECUTE sp_AddRoleMember script, that can then be executed, to add a user as a role member to the current database.
This script is used to replicate security from one database to another. Assuming SQL objects stored procedures, tables etc have required role permissions already granted.


There are four scripts used in conjunction with each other, with overall objective being to correct region specific security that is overwritten when a database refresh occurs.. 
It is envisaged you would run these scripts prior to any refresh, in order to capture correct configuration.
The output that is saved from execution of these scripts, then becomes the sql scripts (input) to run after the refresh as sometimes DBAS like to overwrite security even when security is requested to persist :-P
This becomes your fallback when you don't want to wait...

Part 1: 1_generate_create_user_script_for_current_database.sql
Part 2: 2_generate_execute_sp_addRoleMember_script_for_current_database.sql
Part 3: 3_generate_create_synonym_script_for_current_database.sql
Part 4: 4_generate_create_view_script_for_current_database.sql


*/
SELECT 'EXECUTE sp_AddRoleMember ''' + roles.name + ''', ''' + users.name + ''''
 from sys.database_principals users
  inner join sys.database_role_members link
   on link.member_principal_id = users.principal_id
  inner join sys.database_principals roles
   on roles.principal_id = link.role_principal_id