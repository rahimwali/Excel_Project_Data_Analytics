/*
Question: What skills are required for the top-paying analyst jobs in my area?

  - Use the top paying local jobs identified in the previous query as a starting point
  - Add the skills needed in these roles
  - Why? It provides insight into which higher paying jobs demand what skills, helping me
      understand which skills are common between them and which skills to develop

*/

WITH top_paying_jobs AS (
  SELECT
    job_id,
    job_title,
    salary_year_avg,
    name as company_name
  FROM
    job_postings_fact
  LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
  WHERE
    job_title LIKE '%Analyst%'
    AND job_title !~* '(Senior|Principal|3|4|Lead|Chief)'
    AND job_location = 'Albany, NY'
    AND salary_year_avg IS NOT NULL
  ORDER BY
    salary_year_avg DESC
  LIMIT 10
)

SELECT
  top_paying_jobs.*,
  skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
  salary_year_avg DESC

/*
Key Insights (Entry-Level Albany Analyst Jobs)

    - SQL, SAS, Python, R, and Excel appear repeatedly across the top-paying positions.
    - Many of the highest-paying roles combine technical skills with enterprise tools such as Oracle, SQL Server, and SSIS.   
    - The data suggests that developing a strong core analytics stack provides access to a wider range of higher-paying opportunities.

*/