
-- A Tabela Ibm_HR já tem de estar criada na PBI 
-- (Direito do rato em PBI -> Tasks -> Import Flat File) 
-- Depois mudar Attrition e OverTime para nvarchar(5), não definir nenhuma Primary Key

-- LOOKUPS � tabelas pequenas que traduzem os c�digos (1,2,3...) em texto
-- (ex.: Education 3 = "Bachelor"). Separadas para n�o repetir texto em todo o lado.


CREATE TABLE EducationLevel (
    EducationID   TINYINT      NOT NULL PRIMARY KEY,
    EducationLabel  VARCHAR(20)  NOT NULL
);

CREATE TABLE SatisfactionLevel (
    SatisfactionID   TINYINT      NOT NULL PRIMARY KEY,
    SatisfactionLabel  VARCHAR(20)  NOT NULL
);

-- Uma s� tabela para os 3 tipos de satisfa��o (ambiente, trabalho, rela��es),
-- porque todos usam a mesma escala 1=Low..4=Very High.

CREATE TABLE InvolvementLevel (
    InvolvementID   TINYINT      NOT NULL PRIMARY KEY,
    InvolvementLabel  VARCHAR(20)  NOT NULL
);

CREATE TABLE PerformanceRatingLevel (
    PerformanceRatingID   TINYINT      NOT NULL PRIMARY KEY,
    RatingLabel  VARCHAR(20)  NOT NULL
);


CREATE TABLE WorkLifeBalanceLevel (
    WorkLifeBalanceID   TINYINT      NOT NULL PRIMARY KEY,
    BalanceLabel  VARCHAR(20)  NOT NULL
);

-- Os per�odos em que medimos a satisfa��o (1 = baseline de Maio, 2 = p�s ping-pong).
-- Cada medi��o nova � s� uma linha aqui. A data fica nesta tabela porque � igual
-- para toda a gente do mesmo per�odo � n�o faz sentido repeti-la em cada colaborador.

CREATE TABLE MeasurementPeriod (
    PeriodID     TINYINT       NOT NULL PRIMARY KEY,
    PeriodName   VARCHAR(40)   NOT NULL,
    MeasureDate  DATE          NOT NULL
);

GO

-- EMPLOYEE � quem � o colaborador (dados pessoais) + se saiu ou n�o (Attrition)

CREATE TABLE Employee (
    EmployeeNumber    INT           NOT NULL PRIMARY KEY,
    Age               TINYINT       NOT NULL,
    Gender            VARCHAR(10)   NOT NULL,
    MaritalStatus     VARCHAR(10)   NOT NULL,
    EducationID     TINYINT       NOT NULL,
    EducationField    VARCHAR(30)   NOT NULL,
    DistanceFromHome  SMALLINT      NOT NULL,
    Attrition         CHAR(3)       NOT NULL,   -- 'Yes' / 'No'

    CONSTRAINT FK_Employee_EducationLevel
        FOREIGN KEY (EducationID) REFERENCES EducationLevel(EducationID),
    CONSTRAINT CK_Employee_Attrition CHECK (Attrition IN ('Yes','No')),
    CONSTRAINT CK_Employee_Gender CHECK (Gender IN ('Male','Female'))
);
GO

-- JOB � o que o colaborador faz: departamento, cargo, antiguidade, performance

CREATE TABLE Job (
    EmployeeNumber        INT           NOT NULL PRIMARY KEY,
    Department            VARCHAR(30)   NOT NULL,
    JobRole               VARCHAR(40)   NOT NULL,
    JobLevel              TINYINT       NOT NULL,
    BusinessTravel        VARCHAR(20)   NOT NULL,
    OverTime              CHAR(3)       NOT NULL,
    NumCompaniesWorked    TINYINT       NOT NULL,
    TotalWorkingYears     TINYINT       NOT NULL,
    YearsAtCompany        TINYINT       NOT NULL,
    YearsInCurrentRole    TINYINT       NOT NULL,
    YearsSinceLastPromotion TINYINT     NOT NULL,
    YearsWithCurrManager  TINYINT       NOT NULL,
    PerformanceRatingID              TINYINT       NOT NULL,
    TrainingTimesLastYear TINYINT       NOT NULL,

    CONSTRAINT FK_Job_Employee
        FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
        ON DELETE CASCADE,   -- ON DELETE CASCADE apaga a linha do EmployeeNumber em cada tabela que esteja inserido
    CONSTRAINT FK_Job_RatingLevel
        FOREIGN KEY (PerformanceRatingID) REFERENCES PerformanceRatingLevel(PerformanceRatingID),
    CONSTRAINT CK_Job_OverTime CHECK (OverTime IN ('Yes','No'))
);
GO

-- COMPENSATION � tudo o que tem a ver com pagamento e incentivos

CREATE TABLE Compensation (
    EmployeeNumber     INT           NOT NULL PRIMARY KEY,
    DailyRate          INT           NOT NULL,
    HourlyRate         INT           NOT NULL,
    MonthlyIncome      INT           NOT NULL,
    MonthlyRate        INT           NOT NULL,
    PercentSalaryHike  TINYINT       NOT NULL,
    StockOptionLevel   TINYINT       NOT NULL,

    CONSTRAINT FK_Compensation_Employee
        FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
        ON DELETE CASCADE
);
GO

-- SATISFACTION � satisfa��o de cada colaborador em cada per�odo.
-- Chave composta (EmployeeNumber + PeriodID): 1 linha por pessoa por medi��o,
-- por isso a mesma pessoa pode aparecer em Maio e em Junho

CREATE TABLE Satisfaction (
    EmployeeNumber           INT          NOT NULL,
    PeriodID                 TINYINT      NOT NULL,   -- FK -> MeasurementPeriod
    EnvironmentSatisfaction  TINYINT      NOT NULL,
    JobInvolvementID         TINYINT      NOT NULL,
    JobSatisfaction          TINYINT      NOT NULL,
    RelationshipSatisfaction TINYINT      NOT NULL,
    WorkLifeBalanceID        TINYINT      NOT NULL,

    CONSTRAINT PK_Satisfaction PRIMARY KEY (EmployeeNumber, PeriodID),
    CONSTRAINT FK_Satisfaction_Period
        FOREIGN KEY (PeriodID) REFERENCES MeasurementPeriod(PeriodID),
    CONSTRAINT FK_Satisfaction_Employee
        FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
        ON DELETE CASCADE,
    CONSTRAINT FK_Satisfaction_EnvLevel
        FOREIGN KEY (EnvironmentSatisfaction) REFERENCES SatisfactionLevel(SatisfactionID),
    CONSTRAINT FK_Satisfaction_JobSatLevel
        FOREIGN KEY (JobSatisfaction) REFERENCES SatisfactionLevel(SatisfactionID),
    CONSTRAINT FK_Satisfaction_RelLevel
        FOREIGN KEY (RelationshipSatisfaction) REFERENCES SatisfactionLevel(SatisfactionID),
    CONSTRAINT FK_Satisfaction_InvolvementLevel
        FOREIGN KEY (JobInvolvementID) REFERENCES InvolvementLevel(InvolvementID),
    CONSTRAINT FK_Satisfaction_BalanceLevel
        FOREIGN KEY (WorkLifeBalanceID) REFERENCES WorkLifeBalanceLevel(WorkLifeBalanceID)
);
GO

