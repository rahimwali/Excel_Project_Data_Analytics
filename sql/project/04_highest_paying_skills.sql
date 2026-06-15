/*
Question: What skills pay the most money?

  - Look at average salary for each skill
  - Focuses on roles with salaries (not NULL) & postings that are local
  - Why? It reveals how different skills impact salary for analyst roles & helps identify
      which skills are most financially rewarding
*/

SELECT
  skills_dim.skills,
  ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title LIKE '%Analyst%'
  AND job_location = 'Albany, NY'
  AND salary_year_avg IS NOT NULL
GROUP BY
  skills_dim.skills
HAVING 
  COUNT(skills_job_dim.job_id) >= 2
ORDER BY
  avg_salary DESC

/*

Key Insights

    - Python(16) and R(20) offer one of the strongest combinations of competitive salaries and broad demand.
    - Specialized technologies such as SQL Server(3), Azure(2), and Oracle(4) command higher salaries but appear in fewer postings.
    - Traditional analytics tools like SAS(36) and SQL(19) continue to provide strong long-term value in the Albany market.

*/