
-- Consultas de negocio - exploracao inicial dos dados em SQL.
-- Correr DEPOIS do 01, 02, 03 e 04 (base montada e com os dois periodos carregados).

USE PBI;
GO


-- ============================================================================
-- TEMA 1 - PERFIL DA EMPRESA
-- ============================================================================

-- Quantos colaboradores por departamento e genero?

SELECT
    j.Department,
    e.Gender,
    COUNT(*) AS NumEmployees
FROM dbo.Employee e
JOIN dbo.Job j ON j.EmployeeNumber = e.EmployeeNumber
GROUP BY j.Department, e.Gender
ORDER BY j.Department, e.Gender;
GO


-- ============================================================================
-- TEMA 2 - RISCO DE ATTRITION
-- ============================================================================

-- Que departamento perde mais gente?

SELECT
    j.Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
    CAST(SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
         / COUNT(*) AS DECIMAL(5,2)) AS AttritionRatePct
FROM dbo.Employee e
JOIN dbo.Job j ON j.EmployeeNumber = e.EmployeeNumber
GROUP BY j.Department
ORDER BY AttritionRatePct DESC;
GO

-- O overtime influencia a saida? (esperado: cerca de 30% vs 10%)

SELECT
    j.OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leavers,
    CAST(SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
         / COUNT(*) AS DECIMAL(5,2)) AS AttritionRatePct
FROM dbo.Employee e
JOIN dbo.Job j ON j.EmployeeNumber = e.EmployeeNumber
GROUP BY j.OverTime
ORDER BY AttritionRatePct DESC;
GO


-- ============================================================================
-- TEMA 3 - RISCO DE REFORMA
-- ============================================================================

-- Quem esta perto da reforma, e em que departamento e cargo?
-- So conta quem ficou - nao se planeia sucessao de quem ja saiu.

SELECT
    j.Department,
    j.JobRole,
    COUNT(*) AS NearRetirement
FROM dbo.Employee e
JOIN dbo.Job j ON j.EmployeeNumber = e.EmployeeNumber
WHERE e.Attrition = 'No'
  AND e.Age >= 55
GROUP BY j.Department, j.JobRole
ORDER BY NearRetirement DESC;
GO


-- ============================================================================
-- TEMA 4 - SATISFACAO E BEM-ESTAR
-- ============================================================================

-- Satisfacao media nos dois periodos.
-- Periodo 1 = Maio (antes), Periodo 2 = Junho (depois da mesa de ping-pong).

SELECT
    mp.PeriodName,
    COUNT(*) AS NumRespostas,
    AVG(CAST(s.JobSatisfaction AS DECIMAL(6,3))) AS AvgJobSatisfaction,
    AVG(CAST(s.EnvironmentSatisfaction AS DECIMAL(6,3))) AS AvgEnvironment,
    AVG(CAST(s.RelationshipSatisfaction AS DECIMAL(6,3))) AS AvgRelationship,
    AVG(CAST(s.WorkLifeBalanceID AS DECIMAL(6,3))) AS AvgWorkLifeBalance
FROM dbo.Satisfaction s
JOIN dbo.MeasurementPeriod mp ON mp.PeriodID = s.PeriodID
GROUP BY mp.PeriodID, mp.PeriodName
ORDER BY mp.PeriodID;
GO

-- A mesa de ping-pong melhorou a satisfacao?
-- O JOIN entre os dois periodos garante que so entram as pessoas que
-- responderam nas DUAS medicoes. Se comparassemos as medias em bruto,
-- os 237 que sairam (so aparecem em Maio) distorciam o resultado.

SELECT
    COUNT(*) AS EmployeesInBothPeriods,
    AVG(CAST(pre.JobSatisfaction AS DECIMAL(6,3))) AS Pre_JobSatisfaction,
    AVG(CAST(post.JobSatisfaction AS DECIMAL(6,3))) AS Post_JobSatisfaction,
    AVG(CAST(post.JobSatisfaction AS DECIMAL(6,3)))
        - AVG(CAST(pre.JobSatisfaction AS DECIMAL(6,3))) AS Delta_JobSatisfaction
FROM dbo.Satisfaction pre
JOIN dbo.Satisfaction post
    ON post.EmployeeNumber = pre.EmployeeNumber
   AND pre.PeriodID = 1
   AND post.PeriodID = 2;
GO
