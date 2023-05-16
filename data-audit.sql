--As audit ADMIN
SELECT
    *
FROM
    UNIFIED_AUDIT_TRAIL;

SELECT
    *
FROM
    AUDIT_UNIFIED_ENABLED_POLICIES;

--Enable audit policies
AUDIT POLICY ORA_LOGON_FAILURES WHENEVER NOT SUCCESSFUL;

AUDIT POLICY ORA_DV_AUDPOL;

AUDIT POLICY ORA_SECURECONFIG;

SELECT
    *
FROM
    AUDIT_UNIFIED_ENABLED_POLICIES;

--Genrate some audit RECORD
SELECT
    *
FROM
    UNIFIED_AUDIT_TRAIL;

--what is being audited?

SELECT
    POLICY_NAME,
    AUDIT_OPTION
FROM
    AUDIT_UNIFIED_POLICIES
WHERE
    POLICY_NAME IN ('ORA_LOGON_FAILURES',
    'ORA_SECURECONFIG')
ORDER BY
    1,
    2;