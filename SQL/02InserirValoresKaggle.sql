
-- Mete os valores fixos nas tabelas de tradução (lookups).
-- Ex.: na Education, o código 3 passa a significar "Bachelor".
-- Estas tabelas têm de ser preenchidas ANTES dos Employees,
-- senão as ligações (FK) não encontram os códigos.

INSERT INTO EducationLevel (EducationID, EducationLabel) VALUES
    (1, 'Below College'),
    (2, 'College'),
    (3, 'Bachelor'),
    (4, 'Master'),
    (5, 'Doctor');

INSERT INTO SatisfactionLevel (SatisfactionID, SatisfactionLabel) VALUES
    (1, 'Low'),
    (2, 'Medium'),
    (3, 'High'),
    (4, 'Very High');

INSERT INTO InvolvementLevel (InvolvementID, InvolvementLabel) VALUES
    (1, 'Low'),
    (2, 'Medium'),
    (3, 'High'),
    (4, 'Very High');

INSERT INTO PerformanceRatingLevel (PerformanceRatingID, RatingLabel) VALUES
    (1, 'Low'),
    (2, 'Good'),
    (3, 'Excellent'),
    (4, 'Outstanding');

INSERT INTO WorkLifeBalanceLevel (WorkLifeBalanceID, BalanceLabel) VALUES
    (1, 'Bad'),
    (2, 'Good'),
    (3, 'Better'),
    (4, 'Best');
GO

-- Os dois momentos em que medimos a satisfação:
-- período 1 = dados originais (Maio), período 2 = depois da mesa de ping-pong (Junho).

INSERT INTO MeasurementPeriod (PeriodID, PeriodName, MeasureDate) VALUES
    (1, 'Dataset Original', '2026-05-20');
GO

INSERT INTO MeasurementPeriod (PeriodID, PeriodName, MeasureDate) VALUES
    (2, 'Pos mesa de ping-pong', '2026-06-03');
GO

