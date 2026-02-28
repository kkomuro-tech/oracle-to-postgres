-- get tableInfo on Oracle
COLUMN owner FORMAT A10
COLUMN table_name FORMAT A25
COLUMN tablespace_name FORMAT A15
spool table_output.csv

SELECT
    LOWER(owner)||','||LOWER(table_name)||','||LOWER(tablespace_name)
FROM
    DBA_TABLES
WHERE
    owner IN ('testuser1', 'testuser2') AND temporary ＝ 'N'
ORDER BY
    owner, table_name,

spool off

-- get partitionInfo on Oracle
COLUMN table_owner FORMAT A10
COLUMN table_name FORMAT A25
COLUMN partition_name FORMAT A10
spool partition_output.csv

SELECT
    LOWER(table_owner)||','||LOWER(table_name)||','||LOWER(partition_name)||','||LOWER(tablespace_name)
FROM
    DBA_TAB_PARTITIONS
WHERE
    table_owrer IN ('testuser1', 'testuser2')
ORDER BY
    table_owner, table_name, partition_ name, tablespace_name;

spool off


-- get sequenceInfo on Oracle
COLUMN sequence_owner FORMAT A10
COLUMN sequence_name FORMAT A25
spool sequence_output.csv

SELECT
    LOWER(sequence_owner)||','||LOWER(sequence_name)||','||LOWER(increment_by)||','||LOWER(last_number)||','||LOWER(min_value)
FROM
    DBA_SEQUENCES
WHERE
    sequence_owner IN ('testuser1', 'testuser2')
ORDER BY
    sequence_name;

spool off


-- get tblcount on Oracle
spool tblcount_output.csv
    
SELECT 'testuser1.testtable1'||','||count(*) FROM testuser1.testtable1
UNION ALL SELECT 'testuser2.testtable2'||','||count(*) FROM testuser2.testtable2;
-- 以降繰り返し
spool off


-- get table_partiton_count on Oracle
spool table_partiton_count_output.csv
    
SELECT 'testuser1.testtable1:partition_1'||','||count(*) FROM testuser1.testtable1 PARTITION partition_1
UNION ALL SELECT 'testuser2.testtable2:partition_2'||','||count(*) FROM testuser2.testtable2  PARTITION partition_2;
-- 以降繰り返し
spool off


-- get indexInfo on Oracle
COLUMN index_name FORMAT A28
spool index_output.csv
    
SELECT
    LOWER(owner)||','||LOWER(table_name)||','||LOWER(index_name)||','||LOWER(tablespace_name)
FROM
    DBA_INDEXES
WHERE
    owner IN ('testuser1', 'testuser2') AND 
    index_name not like 'SYS_IL%' AND
    index_name not like 'SYS_CO%' 
ORDER BY
    owner, index_name;

spool off


-- get packageInfo on Oracle
COLUMN object_name FORMAT A28
COLUMN procedure_name FORMAT A28
spool package_output.csv
    
SELECT
    LOWER(o.object_name)||','||LOWER(p.procedure_name)
FROM
    all_obects o
JOIN
    all_procedures p ON o.object_name = pobject_name AND o.owner = p.owner
WHERE
    o.object_type = 'PACKAGE' AND 
    o.owner IN ('testuser1', 'testuser2') AND
    p.procedure_name IS NOT NULL
ORDER BY
    o.object_name, p procedure_name;

spool off


-- get procedureInfo on Oracle
COLUMN object_name FORMAT A28
spool procedure_output.csv

SELECT
    LOWER(owner)||','||LOWER(object_name)
FROM
    dbe_objects
WHERE
    object_type IN('PROCEDURE') AND owner IN ('testuser1', 'testuser2')
ORDER BY
    owner, object_name;

spool off


-- get triggerInfo on Oracle
COLUMN trigger_name FORMAT A28
spool trigger_output.csv
    
SELECT
    LOWER(owner)I:||LOWER(trizger name)
FROM
    DBA_TRIGGERS
WHERE
    owner IN ('testuser1', 'testuser2')
ORDER BY
    owner, trigger_name;

spool off


-- get viewInfo on Oracle
COLUMN view_name FORMAT A40
spool view_output.csv
    
SELECT
    LOWER(owner)||','||LOWER(view_name)
FROM
    DBA_VIEWS
WHERE
    IN ('testuser1', 'testuser2')
ORDER BY
    owner, view_name;

spool off