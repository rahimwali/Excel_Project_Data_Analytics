# Albany Analyst Job Market Analysis

## Introduction

This project explores the **2023 Albany, NY analyst job market** using SQL. The goal was to identify the highest-paying opportunities, determine which skills employers value most, and discover which technical skills provide the strongest balance between salary and demand.

By focusing on a single region, this project provides practical insights for aspiring analysts looking to enter the local job market.

## Background

As an aspiring data professional, I wanted to answer a few career-focused questions:

* What analyst jobs pay the most in Albany?
* What skills do those jobs require?
* Which skills appear most often in job postings?
* Which skills are associated with higher salaries?
* Which combination of skills provides the best long-term value?

The analysis uses the **2023 Data Jobs dataset** and focuses specifically on analyst roles located in **Albany, New York**.

## Project Structure

### SQL Queries

* [Top Paying Jobs](project/01_top_paying_jobs.sql)
* [Top Paying Job Skills](project/02_top_paying_job_skills.sql)
* [Most Demenaded Skills](project/03_highest_demanded_skills.sql)
* [Highest Paying Skills](project/04_highest_paying_skills.sql)
* [Most Optimal Skills](project/05_optimal_skills.sql)

## Tools Used

* **SQL** – Used to query, filter, aggregate, and analyze the job market data.
* **PostgreSQL** – Used as the database management system for executing SQL queries.
* **VS Code** – Used to write, test, and organize SQL scripts.
* **Git & GitHub** – Used for version control and project documentation.
* **CSV Exports** – Used to store and review query results for further analysis.


<br>
<br>

# Analysis

## Query 1: Highest-Paying Entry & Junior Analyst Jobs

**Objective:** Identify the highest-paying entry and junior analyst opportunities in Albany, NY.

```sql
SELECT
  job_id,
  job_title,
  job_location,
  job_schedule_type,
  ROUND(salary_year_avg) AS average_salary,
  job_posted_date,
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
LIMIT 20;
```

### Key Insights

* New York State agencies dominate the local analyst job market.
* Most higher-paying entry and junior analyst roles fall between **$89K and $93K**.
* Healthcare and government organizations account for many local opportunities.

[**See Full Query**](project/01_top_paying_jobs.sql)

---

## Query 2: Skills Required for the Highest-Paying Jobs

**Objective:** Determine which skills are required for Albany's highest-paying analyst roles.

```sql
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
  salary_year_avg DESC;
```

### Key Insights

* SQL, SAS, Python, R, and Excel appear consistently across higher-paying positions.
* Enterprise technologies such as Oracle and SQL Server appear in several top-paying roles.
* Strong technical foundations increase access to better-paying analyst opportunities.

[**See Full Query**](project/02_top_paying_job_skills.sql)

---

## Query 3: Most In-Demand Skills

**Objective:** Identify the skills employers request most often in Albany analyst job postings.

```sql
SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title LIKE '%Analyst%'
  AND job_location = 'Albany, NY'
  AND job_title !~* '(Senior|Principal|3|4|Lead|Chief)'
GROUP BY
  skills_dim.skills
ORDER BY
  demand_count DESC
LIMIT 10;
```

### Key Insights

* SQL, SAS, and Excel form the foundation of the Albany analyst market.
* Python, Tableau, and R demonstrate strong demand for programming and visualization skills.
* Business communication tools remain valuable for reporting and collaboration.

[**See Full Query**](project/03_highest_demanded_skills.sql)

---

## Query 4: Highest-Paying Skills

**Objective:** Discover which technical skills are associated with the highest salaries.

```sql
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
  avg_salary DESC;
```

### Key Insights

* Python and R provide one of the strongest combinations of salary and market demand.
* Specialized technologies such as SQL Server and Azure command high salaries but appear less frequently.
* Traditional analytics tools such as SAS and SQL continue to provide strong long-term value.

[**See Full Query**](project/04_highest_paying_skills.sql)

---

## Query 5: Most Optimal Skills

**Objective:** Find the skills that provide the best balance between demand and salary.

```sql
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
```

### Key Insights

* SQL, Python, R, and SAS offer the best balance between demand and salary.
* Excel remains a foundational skill that supports nearly every analyst role.
* Tableau and SharePoint can strengthen an analyst portfolio through reporting and visualization.

[**See Full Query**](project/05_optimal_skills.sql)

<br>
<br>

# What I Learned

Through this project, I strengthened several SQL concepts:

* Built multi-step analyses using **Common Table Expressions (CTEs)**.
* Combined multiple tables using **INNER JOINs and LEFT JOINs** to connect job postings and skill data.
* Applied **aggregate functions, filtering, grouping, and sorting** to transform raw data into actionable insights.

<br>
<br>

# Conclusions

## Main Findings

* Albany's analyst market is heavily influenced by **government and public-sector employers**.
* Higher-paying analyst roles consistently require a core set of technical skills.
* **SQL, SAS, and Excel** are the most commonly requested skills.
* **Python and R** provide strong earning potential while maintaining healthy demand.
* The best long-term strategy is to develop skills that balance both salary and employer demand.

## Skills to Focus On for the Albany Market

Based on this analysis, the strongest skill stack for aspiring analysts in Albany is:

* SQL
* Excel
* Python
* SAS or R
* Tableau
* Basic enterprise reporting and collaboration tools

Developing these skills provides a strong foundation for both entry-level opportunities and long-term career growth within the Albany analyst job market.
