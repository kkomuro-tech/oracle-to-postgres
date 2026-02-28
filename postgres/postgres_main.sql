-- get tableInfo on Postgres
COPY (
    SELECT
        schemaname, tablename, tablespace
    FROM
        pg_tables
    WHERE
        schemaname IN ('testuser1', 'testuser2')
        -- $AND バーティションが存在する場合除外条件を追加
    ORDER BY
        schemaname, table name
）TO 'table_output_2.csv' WITH CSV;

-- get partitionInfo on Postgres
COPY (
    SELECT
        nmsp_parent, nspname, parent.reIname, child.reIname, ts.spcname
    FROM
        pg_inherits
    JOIN
        pg_class child ON pg_inherits.inhparent = child.oid
    JOIN
        pg class parent ON pg_inherits.inhparent = parent.oid
    JOIN
        pg_namespace nmsp_parent ON parent.reInamespace = nmsp_perent.oid
    JOIN
        pg_namespace msp_child ON child.reInamespace = nmsp_child.oid
    LEFT JOIN
        pg_tablespace ts ON child.reItablespace = ts.oid
    WHERE
        ts.spcname IS NOT NULL
    ORDER BY
        nmsp_parent.nspname, parent.reIname, child.reIname
）TO 'partition_output_2.csv' WITH CSV;


-- get sequenceInfo on Postgres
COPY (
    SELECT
        i.sequence_schema, i.sequence_name, p.increment_by, p.start_value, p.min_value
    FROM
        information_schema.sequences i
    JOIN
        pg_sequences p ON sequence_name = sequence_name
    WHERE
        sequence_schema IN ('testuser1', 'testuser2')
    ORDER BY
        sequence_name
） TO 'sequence_output_2.csv' WITH CSV;


-- get sequenceInfo(Option) on Postgres
COPY (
    SELECT
        i.sequence_schema, i.sequence_name, p.cache_size, p.max_value
    FROM
        information_schema.sequences i
    JOIN
        pg_sequences p ON sequence_name = sequence_name
    WHERE
        sequence_schema IN ('testuser1', 'testuser2')
    ORDER BY
        sequence_name
）TO 'sequence_output_3.csv' WITH CSV


-- get tblcount on Postgres
COPY (
    SELECT 'testuser1.testtable1'，count(*) FROM testuser1.testtable1
    UNION ALL SELECT 'testuser2.testtable2'，count(*) FROM testuser2.testtable2
    -- 以降繰り返し
）TO 'tblcount_output_2.csv' WITH CSV;


-- get table_partiton_count on Postgres
-- in Postgres partition is tablemaking 
COPY(
    SELECT 'testuser1.testtable1:partition_1'||','||count(*) FROM testuser1.partition_1
    UNION ALL SELECT 'testuser2.testtable2:partition_2'||','||count(*) FROM testuser2.partition_2;
    -- 以降繰り返し
) TO 'table_partiton_count_2.csv' WITH CSV;


-- get indexInfo on Postgres
COPY(
    SELECT
        schema_name, table_name, indexname, tablespace
    FROM
        pg_indexes
    WHERE
        schemaname IN ('testuser1', 'testuser2') AND
        tablespace IS NOT NULL
    ORDER BY
        schemaname, tablename, indexname
）TO 'index_output_2.csv' WITH CSV;


-- get packageInfo on Postgres
COPY (
    SELECT
        n.nspname, p.proname
    FROM
        pg_proc p
    JOIN
        pg_namespace n ON n.oid = p.pronamespace
    WHERE
        n.nspname NOT IN ('information_schema', 'pg catalog','public')
    ORDER BY
        nunspname, p.proname
）TO 'package_output_2.csv' WITH CSV;


-- get packageExtradoing on Postgres
-- そのままだと権限付与してくれないので別途設定後以下で確認が必要
--＜所属スキーマ（＝バッケージ名）、バッケージ名（＝バッケージ内でのブロシージャ名）、実行権限保持ユーザ、実行権限種別＞

¥o package_extra.txt
    
SELECT
    specific_scherna, routine_name, grantee, privilege_type
FROM
    information.schemaroutine_privileges
WHERE
    specific_scherna IN（'package1','package2'）AND
    grantee <> 'postgres' AND
    grantee <> 'PUBLIC';
¥o

-- ＜所属スキーマ（＝バッケージ名）、実行権限保持ユーザ、バッケージへのアクセス権限＞
¥o package_priv list2 txt
SELECT
    nspname,rolname,has_schema_privilege(rolname, spname, 'USAGE')
FROM
    pg_namespace
JOIN
    pg_roles ON has_schema_privilege(rolname, spname, 'USAGE')
WHERE
    rolname IN ('package_owner') AND
    nspname IN ('package_name')
ORDER BY 1;

¥o


-- get procedureInfo on Postgres
COPY (
    SELECT
        n.nspname, p.proname
    FROM
        pg_proc p
    JOIN
        pg_namespace n ON n.oid = p.pronamespace
    WHERE
        n.nspname IN ('testuser1', 'testuser2') AND
        n.proname NOT LIKE 'trigger%'
    ORDER BY
        n.nspname, p.proname
）TO 'procedure_output_2.csv' WITH CSV;


-- get triggerInfo on Postgres
COPY (
    SELECT
        DISTINCT event_object_schema, trigger_name
    FROM
        information_schema.triggers
    WHERE
        event_object_schema IN ('testuser1', 'testuser2')
    ORDER BY
        event_object_schema, trigger_name
） TO 'trigger_output.csv' WITH CSV;


-- get viewInfo on Postgres
-- 文字化け防止のためにSUISをSET
SET client encoding TO SJIS:

COPY(
    SELECT
        table_schema, table_name
    FROM
        information_schema.views
    WHERE
        table_schema IN ('testuser1', 'testuser2')
    ORDER BY
        table_schema, table_name
）TO 'view_output_2.csv' WITH CSV;
    
-文字コードを元に戻す
SET client_encoding TO 'UTF8';


-- getSchema_ownerInfo on Postgres
¥o schema_owner_list.txt

¥dn

¥o


-- SHOW DEFAULT PRIVILEGES LIST on Postgres
¥o user_priv_list.txt
    
SELECT
   defacl bitype, defacinamespace: regnamespace, defacirole re grole, defaclacl
FROM
    pg_default_acl;

¥o


SHOW search_path;


ーースキーマへの新規テーブル作成時にフルコントロール持つよう権限変更
ALTER DEFAULT PRIVILEGES IN SCHEMA testuser1 GRANT ALL PRIVILEGES ON TABLES TO testuser1;
ースキーマへの新規シーケンス作成時にフルコントロール持つよう権限変更
ALTER DEFAULT PRIVILEGES IN SCHEMA testuser1 GRANT ALL PRIVILEGES ON SEQUENCES TO testuser1;
ーースキーマへの新規データ型作成時にフルコントロール持つよう権限変更
ALTER DEFAULT PRIVLEGES IN SCHEM GRANT ALL PRIVLEGES ON TYPES TO $｛移行対象ユーザ名！
ースキーマへの新規ファンクション作成時にフルコントロール持つよう権限変更
ALTER DEFAULT PRIVILEGES IN SCHEMA $｛移行対象ユーザ名｝ GRANT ALL PRIVLEGES ON FUNCTIONS TO $｛移行対象ユーザ名