WITH filtered_projects AS (
    SELECT
        p.status,
        p.internal_ref,
        p.code,
        p.id,
        p.log_type,
        p.auto_approve_submissions,
        CASE 
            WHEN p.payout_value = 0.00 OR p.payout_value IS NULL THEN 'No'
            ELSE 'Yes'
        END AS "payout"
    FROM
        projects p
    WHERE
        p.status = 'live'
        AND p.code NOT LIKE 'WELC%'
        AND p.code NOT LIKE 'DEMOG%'
        AND p.code NOT LIKE 'ENGAG%'
        AND p.code NOT LIKE 'TECH%'
        AND p.code NOT LIKE 'COMP%'
        AND p.code NOT LIKE 'MRKT%'
        AND p.code NOT LIKE 'POLL%'
        AND p.code NOT LIKE 'QTMD%'
        AND p.code NOT LIKE 'BINT%'
        AND p.code NOT LIKE 'CAIT%'
        AND p.code NOT LIKE 'MNDZ%'
        AND p.code NOT LIKE 'SAFA%'
        AND p.code NOT LIKE 'TEST%'
        AND p.code NOT LIKE 'XMAS%'
        AND p.code NOT LIKE 'MERC%'
        AND p.code NOT LIKE 'LUCI%'
        AND p.code NOT LIKE 'JAKE%'
        AND p.code NOT LIKE 'CGPT%'
        --AND p.internal_ref NOT LIKE '%test%'
),
projects_with_all_null_sqs AS (
    SELECT
        s.project_id
    FROM
        submissions s
        LEFT JOIN submission_qa_statuses sqs ON sqs.submission_id = s.id
    GROUP BY
        s.project_id
    HAVING
        bool_and(sqs.status IS NULL)
)

SELECT
    fp.code as "Project Code",
    fp.internal_ref as "Internal Ref",
    fp.id as "Project ID",
    fp.status as "Status",
    fp.log_type as "Log Type",
    fp.auto_approve_submissions as "Auto Approve",
    fp.payout as "Payout"
FROM
    filtered_projects fp
WHERE
    fp.id NOT IN (
        SELECT project_id
        FROM projects_with_all_null_sqs
    )