/*
Question: What are the most optimal skills for analyst positions in my area?

  - Find skills that are high in salary and demand
  - Considers only positions with specified salaries (no NULLs)
  - Why? Provides insight on which skills to focus on for career growth and job market competitiveness

*/

WITH skills_demand AS (
    SELECT
      skills_dim.skill_id,
      skills_dim.skills,
      COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
      job_title LIKE '%Analyst%' AND
      job_location = 'Albany, NY' AND
      salary_year_avg IS NOT NULL
    GROUP BY
      skills_dim.skill_id
), average_salary AS (
      SELECT
      skills_job_dim.skill_id,
      ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
      job_title LIKE '%Analyst%' AND
      job_location = 'Albany, NY' AND
      salary_year_avg IS NOT NULL
    GROUP BY
      skills_job_dim.skill_id
)

SELECT
  skills_demand.skill_id,
  skills_demand.skills,
  skills_demand.demand_count,
  average_salary.avg_salary
FROM
  skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
  skills_demand.demand_count >= 5
ORDER BY
  average_salary.avg_salary DESC,
  skills_demand.demand_count DESC;

/*

Key Insights

    - SQL(19), Python(16), R(20), and SAS(18) provide the strongest balance between employer demand and earning potential.

    - Excel(14) remains a foundational skill that complements nearly every analyst role.

    - Adding a visualization or collaboration tool such as Tableau(8) or SharePoint(8) can help create a more competitive analyst skill set.

*/