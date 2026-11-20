
-- Pega nos dados em bruto da tabela Ibm_HR (importado do CSV) e distribui
-- pelas tabelas certas do modelo: Employee, Job, Compensation e Satisfaction.
-- Correr DEPOIS do 01 (tabelas criadas) e do 02 (lookups preenchidas).


USE PBI;
GO

-- EMPLOYEE: dados pessoais de cada colaborador

INSERT INTO Employee
    (EmployeeNumber, Age, Gender, MaritalStatus, EducationID, EducationField, DistanceFromHome, Attrition)
SELECT
    EmployeeNumber,
    Age,
    Gender,
    MaritalStatus,
    Education,
    EducationField,
    DistanceFromHome,
    Attrition
FROM dbo.Ibm_HR;
GO

-- JOB: o que cada um faz na empresa

INSERT INTO Job
    (EmployeeNumber, Department, JobRole, JobLevel, BusinessTravel, OverTime,
     NumCompaniesWorked, TotalWorkingYears, YearsAtCompany, YearsInCurrentRole,
     YearsSinceLastPromotion, YearsWithCurrManager, PerformanceRatingID, TrainingTimesLastYear)
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    JobLevel,
    BusinessTravel,
    OverTime,
    NumCompaniesWorked,
    TotalWorkingYears,
    YearsAtCompany,
    YearsInCurrentRole,
    YearsSinceLastPromotion,
    YearsWithCurrManager,
    PerformanceRating,
    TrainingTimesLastYear
FROM dbo.Ibm_HR;
GO

-- COMPENSATION: pagamentos e incentivos

INSERT INTO Compensation
    (EmployeeNumber, DailyRate, HourlyRate, MonthlyIncome, MonthlyRate, PercentSalaryHike, StockOptionLevel)
SELECT
    EmployeeNumber,
    DailyRate,
    HourlyRate,
    MonthlyIncome,
    MonthlyRate,
    PercentSalaryHike,
    StockOptionLevel
FROM dbo.Ibm_HR;
GO

-- SATISFACTION: satisfação no período 1 (Maio). O período 2 entra depois, no Momento 2.

INSERT INTO Satisfaction
    (EmployeeNumber, PeriodID, EnvironmentSatisfaction,
     JobInvolvementID, JobSatisfaction, RelationshipSatisfaction, WorkLifeBalanceID)
SELECT
    EmployeeNumber,
    1,                          -- PeriodID 1 = Baseline (Maio/2026)
    EnvironmentSatisfaction,
    JobInvolvement,
    JobSatisfaction,
    RelationshipSatisfaction,
    WorkLifeBalance
FROM dbo.Ibm_HR;
GO

-- Confere se os dados entraram todos. Esperado neste momento (só Maio):
-- Employee, Job e Compensation com 1470 cada, e Satisfaction também com 1470
-- (só o período 1). Depois de carregar a survey de Junho (SurveyPingPongTable)
-- Verificar novamente e ver se tabela Satisfaction tem um numero diferente a 1470

SELECT 'Employee' AS TableName, COUNT(*) AS RowCnt FROM dbo.Employee
UNION ALL SELECT 'Job', COUNT(*) FROM dbo.Job
UNION ALL SELECT 'Compensation', COUNT(*) FROM dbo.Compensation
UNION ALL SELECT 'Satisfaction', COUNT(*) FROM dbo.Satisfaction;
GO


-- Limpeza opcional para remover a tabela Ibm_HR depois de confirmar
-- que os dados passaram bem para o modelo final.

-- DROP TABLE PBI.dbo.Ibm_HR;
-- GO
