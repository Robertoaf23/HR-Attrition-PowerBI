
-- A tabela SurveyPingPong (meter bem o nome) tambem tem de estar criada na PBI
-- (clique direito em PBI -> Tasks -> Import Flat File).
-- São só 6 colunas (employee_number + as 5 satisfações), todas numéricas.
-- Não definir Primary Key.

-- SATISFACTION: satisfação do período 2 (Junho, depois da mesa de ping-pong).
-- Junta-se ao período 1 que já lá está, via a chave composta (EmployeeNumber + PeriodID).

USE PBI;
GO

INSERT INTO dbo.Satisfaction
    (EmployeeNumber, PeriodID, EnvironmentSatisfaction,
     JobInvolvementID, JobSatisfaction, RelationshipSatisfaction, WorkLifeBalanceID)

SELECT
    employee_number,
    2,                          -- PeriodID 2 = pós mesa de ping-pong (Junho/2026)
    environment_satisfaction,
    job_involvement,
    job_satisfaction,
    relationship_satisfaction,
    work_life_balance

FROM dbo.SurveyPingPong;
GO

SELECT 'Employee' AS TableName, COUNT(*) AS RowCnt FROM dbo.Employee
UNION ALL SELECT 'Job', COUNT(*) FROM dbo.Job
UNION ALL SELECT 'Compensation', COUNT(*) FROM dbo.Compensation
UNION ALL SELECT 'Satisfaction (total)', COUNT(*) FROM dbo.Satisfaction
UNION ALL SELECT 'Satisfaction P1 (Maio)', COUNT(*) FROM dbo.Satisfaction WHERE PeriodID = 1
UNION ALL SELECT 'Satisfaction P2 (Junho)', COUNT(*) FROM dbo.Satisfaction WHERE PeriodID = 2;