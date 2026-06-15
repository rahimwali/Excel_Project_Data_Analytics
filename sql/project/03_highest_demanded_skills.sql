/*
Question: What are the most demanded skills for analyst jobs in my area?
  - Why? It provides insight into which skills are most commonly required for analyst jobs, 
    helping me understand which skills to develop to increase my chances of getting hired in this field.
*/

SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title LIKE '%Analyst%' AND
  job_location = 'Albany, NY' AND
  job_title !~* '(Senior|Principal|3|4|Lead|Chief)'
GROUP BY
  skills_dim.skills
ORDER BY
  demand_count DESC
LIMIT 10

/*
Key Insights

    - SQL(86), SAS(72), and Excel(70) are the three most frequently requested skills in the local market.

    - Programming and visualization skills, including Python(54), Tableau(45), and R(38), are also consistently sought after.

    - Communication and reporting tools such as Word(27), Power BI(23), and PowerPoint(15) remain valuable supporting skills.
*/