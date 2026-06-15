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
  skills_demand.demand_count > 5
ORDER BY
  average_salary.avg_salary DESC,
  skills_demand.demand_count DESC
LIMIT 25;

/*

Key Insights

    - SQL (19), R (20), SAS (18), and Python (16) provide the strongest combination of high demand and strong salaries.

    - Python (~$97K) and R (~$96K) offer the highest average salaries among widely requested skills.

    - SQL and Excel remain essential foundational skills, appearing in 19 and 14 postings respectively.

    - Tableau and SharePoint have moderate demand, making them valuable complementary skills for reporting and business intelligence.

    - The data suggests that the most competitive analyst skill stack for the Albany market is SQL + Excel + Python, 
        supplemented by SAS or R and a visualization tool like Tableau.

*/