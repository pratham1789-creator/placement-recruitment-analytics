USE placement_analytics;

-- ============================================================
-- 03_RECRUITMENT_ANALYSIS.SQL
-- Placement & Recruitment Analytics Portfolio Project
-- ============================================================


-- ============================================================
-- BUSINESS PROBLEM 1:
-- How many applications reach each recruitment stage?
-- This gives us the basic recruitment funnel.
-- ============================================================

SELECT
    rs.stage_name,
    COUNT(DISTINCT ast.application_id) AS applications
FROM Recruitment_Stages AS rs
LEFT JOIN Application_Stages AS ast
    ON rs.stage_id = ast.stage_id
GROUP BY
    rs.stage_id,
    rs.stage_name
ORDER BY
    rs.stage_id;


-- ============================================================
-- BUSINESS PROBLEM 2:
-- What is the stage-to-stage conversion rate?
-- This shows what percentage of candidates move from
-- one recruitment stage to the next.
-- ============================================================

WITH stage_counts AS (
    SELECT
        rs.stage_id,
        rs.stage_name,
        COUNT(DISTINCT ast.application_id) AS applications
    FROM Recruitment_Stages AS rs
    LEFT JOIN Application_Stages AS ast
        ON rs.stage_id = ast.stage_id
    GROUP BY
        rs.stage_id,
        rs.stage_name
),
stage_conversion AS (
    SELECT
        stage_id,
        stage_name,
        applications,
        LAG(applications) OVER (
            ORDER BY stage_id
        ) AS previous_stage_applications
    FROM stage_counts
)
SELECT
    stage_name,
    applications,
    previous_stage_applications,
    ROUND(
        applications * 100.0 / previous_stage_applications,
        2
    ) AS conversion_rate
FROM stage_conversion
WHERE previous_stage_applications IS NOT NULL
ORDER BY stage_id;


-- ============================================================
-- BUSINESS PROBLEM 3:
-- Which recruitment stages have the highest candidate
-- drop-off?
-- This helps identify the biggest bottlenecks in the funnel.
-- ============================================================

WITH stage_counts AS (
    SELECT
        rs.stage_id,
        rs.stage_name,
        COUNT(DISTINCT ast.application_id) AS applications
    FROM Recruitment_Stages AS rs
    LEFT JOIN Application_Stages AS ast
        ON rs.stage_id = ast.stage_id
    GROUP BY
        rs.stage_id,
        rs.stage_name
),
stage_with_previous AS (
    SELECT
        stage_id,
        stage_name,
        applications,
        LAG(applications) OVER (
            ORDER BY stage_id
        ) AS previous_stage_applications
    FROM stage_counts
)
SELECT
    stage_name,
    applications,
    previous_stage_applications,
    previous_stage_applications - applications AS drop_off,
    ROUND(
        (previous_stage_applications - applications) * 100.0
        / previous_stage_applications,
        2
    ) AS drop_off_rate
FROM stage_with_previous
WHERE previous_stage_applications IS NOT NULL
ORDER BY drop_off_rate DESC;


-- ============================================================
-- BUSINESS PROBLEM 4:
-- Which companies have the highest candidate selection rates?
-- This helps identify companies where applicants are more likely
-- to successfully complete the recruitment process.
-- ============================================================

SELECT
    c.company_id,
    c.company_name,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE
        WHEN ast.stage_id = 6
        THEN a.application_id
    END) AS selected_candidates,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN ast.stage_id = 6
            THEN a.application_id
        END) * 100.0
        / COUNT(DISTINCT a.application_id),
        2
    ) AS selection_rate
FROM Companies AS c
JOIN Jobs AS j
    ON c.company_id = j.company_id
JOIN Applications AS a
    ON j.job_id = a.job_id
JOIN Application_Stages AS ast
    ON a.application_id = ast.application_id
GROUP BY
    c.company_id,
    c.company_name
ORDER BY
    selection_rate DESC;


-- ============================================================
-- BUSINESS PROBLEM 5:
-- Which jobs have the highest candidate selection rates?
-- This helps identify job roles with stronger hiring outcomes.
-- ============================================================

SELECT
    j.job_id,
    j.job_title,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE
        WHEN ast.stage_id = 6
        THEN a.application_id
    END) AS selected_candidates,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN ast.stage_id = 6
            THEN a.application_id
        END) * 100.0
        / COUNT(DISTINCT a.application_id),
        2
    ) AS selection_rate
FROM Jobs AS j
JOIN Applications AS a
    ON j.job_id = a.job_id
JOIN Application_Stages AS ast
    ON a.application_id = ast.application_id
GROUP BY
    j.job_id,
    j.job_title
ORDER BY
    selection_rate DESC;


-- ============================================================
-- BUSINESS PROBLEM 6:
-- Which companies generate the highest number of selected
-- candidates?
-- This focuses on hiring volume rather than selection rate.
-- ============================================================

SELECT
    c.company_id,
    c.company_name,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE
        WHEN ast.stage_id = 6
        THEN a.application_id
    END) AS selected_candidates
FROM Companies AS c
JOIN Jobs AS j
    ON c.company_id = j.company_id
JOIN Applications AS a
    ON j.job_id = a.job_id
JOIN Application_Stages AS ast
    ON a.application_id = ast.application_id
GROUP BY
    c.company_id,
    c.company_name
ORDER BY
    selected_candidates DESC;


-- ============================================================
-- BUSINESS PROBLEM 7:
-- Does candidate experience affect the likelihood of selection?
-- This helps determine whether experience level is associated
-- with recruitment success.
-- ============================================================

SELECT
    c.experience,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE
        WHEN ast.stage_id = 6
        THEN a.application_id
    END) AS selected_candidates,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN ast.stage_id = 6
            THEN a.application_id
        END) * 100.0
        / COUNT(DISTINCT a.application_id),
        2
    ) AS selection_rate
FROM Candidates AS c
JOIN Applications AS a
    ON c.candidate_id = a.candidate_id
JOIN Application_Stages AS ast
    ON a.application_id = ast.application_id
GROUP BY
    c.experience
ORDER BY
    c.experience;


-- ============================================================
-- BUSINESS PROBLEM 8:
-- Which candidate locations have the highest selection rates?
-- This helps identify whether candidate location is associated
-- with recruitment success.
-- ============================================================

SELECT
    c.location,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE
        WHEN ast.stage_id = 6
        THEN a.application_id
    END) AS selected_candidates,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN ast.stage_id = 6
            THEN a.application_id
        END) * 100.0
        / COUNT(DISTINCT a.application_id),
        2
    ) AS selection_rate
FROM Candidates AS c
JOIN Applications AS a
    ON c.candidate_id = a.candidate_id
JOIN Application_Stages AS ast
    ON a.application_id = ast.application_id
GROUP BY
    c.location
ORDER BY
    selection_rate DESC;


-- ============================================================
-- BUSINESS PROBLEM 9:
-- Which candidate skill profiles are associated with higher
-- selection rates?
-- This helps identify skill combinations that perform better
-- in the recruitment process.
-- ============================================================

SELECT
    c.skills,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE
        WHEN ast.stage_id = 6
        THEN a.application_id
    END) AS selected_candidates,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN ast.stage_id = 6
            THEN a.application_id
        END) * 100.0
        / COUNT(DISTINCT a.application_id),
        2
    ) AS selection_rate
FROM Candidates AS c
JOIN Applications AS a
    ON c.candidate_id = a.candidate_id
JOIN Application_Stages AS ast
    ON a.application_id = ast.application_id
GROUP BY
    c.skills
ORDER BY
    selection_rate DESC;


-- ============================================================
-- BUSINESS PROBLEM 10:
-- What is the overall recruitment funnel performance?
-- This provides the headline KPIs for the project:
-- total applications, selected candidates and selection rate.
-- ============================================================

SELECT
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE
        WHEN ast.stage_id = 6
        THEN a.application_id
    END) AS selected_candidates,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN ast.stage_id = 6
            THEN a.application_id
        END) * 100.0
        / COUNT(DISTINCT a.application_id),
        2
    ) AS overall_selection_rate
FROM Applications AS a
JOIN Application_Stages AS ast
    ON a.application_id = ast.application_id;


-- ============================================================
-- BUSINESS PROBLEM 11:
-- How much time do candidates spend between recruitment stages?
-- This helps identify stages where the recruitment process
-- may be taking longer than expected.
-- ============================================================

WITH stage_dates AS (
    SELECT
        ast.application_id,
        rs.stage_id,
        rs.stage_name,
        ast.stage_date,
        LEAD(ast.stage_date) OVER (
            PARTITION BY ast.application_id
            ORDER BY ast.stage_id
        ) AS next_stage_date
    FROM Application_Stages AS ast
    JOIN Recruitment_Stages AS rs
        ON ast.stage_id = rs.stage_id
)
SELECT
    stage_name,
    COUNT(*) AS candidates_processed,
    ROUND(
        AVG(DATEDIFF(next_stage_date, stage_date)),
        2
    ) AS avg_days_to_next_stage
FROM stage_dates
WHERE next_stage_date IS NOT NULL
GROUP BY
    stage_id,
    stage_name
ORDER BY
    stage_id;


-- ============================================================
-- END OF RECRUITMENT ANALYSIS
-- ============================================================
