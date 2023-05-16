
--create empty pluggable dababase

create pluggable database pdb2 ADMIN USER pdb_adm IDENTIFIED by password1
FILE_NAME_CONVERT = ('/u01/app/oracle/oradata/cdb1/pdbs/','/u01/app/oracle/oradata/cdb1/pdb2/');

--check DBA-PDBS view

SELECT pdb_name, status
from dba_pads;

--finish PDB creation by opening the PDB

Alter pluggable database pdb2 open read write;

--check V$PDBS views

Select name, open_mode
from v$pdbs

--close and drop the pdbs

drop pluggable database pdb2 including datafiles;

--unplug the PDB

Alter pluggable database pdb2 close;

Alter pluggable database pdb2 unplug into '/u01/app/oracle/oradata/cdb1/cdb2/pdb2.xml';

--check what PDBS are present.

Select name, open_mode
from  v$PDBS;

--Drop the PDB, but keep the files.
Drop pluggable database pdb2 keep datafiles;