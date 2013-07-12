/*	Script applicable to SQL Server 2005, 2008 and 2012.
	This script will generate Create SYNONYM script, that can then be executed, to add each instance of a SYNONYM to the current database.
	This script is used to replicate security from one database to another. 

There are four scripts used in conjunction with each other, with overall objective being to correct region specific security that is overwritten when a database refresh occurs.. 
It is envisaged you would run these scripts prior to any refresh, in order to capture correct configuration.
The output that is saved from execution of these scripts, then becomes the sql scripts (input) to run after the refresh as sometimes DBAS like to overwrite security even when security is requested to persist :-P
This becomes your fallback when you don't want to wait...

Part 1: 1_generate_create_user_script_for_current_database.sql
Part 2: 2_generate_execute_sp_addRoleMember_script_for_current_database.sql
Part 3: 3_generate_create_synonym_script_for_current_database.sql
Part 4: 4_generate_create_view_script_for_current_database.sql
*/

SELECT * FROM SYS.SYNONYMS

SELECT 'CREATE SYNONYM [' + name + '] for  '+ base_object_name + ''
from SYS.SYNONYMS
