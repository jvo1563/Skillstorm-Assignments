USE investment_db;
GO

SELECT * FROM investment;
SELECT * FROM investment_type;

SELECT
	n.investment_name AS [name],
	t.investment_date AS [date],
	i.closing_price,
	i.daily_return,
	i.volatility,
	i.sharpe_ratio,
	i.beta
FROM investment i
JOIN investment_name n ON i.investment_name_id = n.investment_name_id
JOIN investment_time t ON i.time_id = t.time_id
JOIN investment_type ty ON i.investment_type_id = ty.investment_type_id
WHERE (ty.investment_type LIKE '%Stock%' OR ty.investment_type LIKE '%ETF%')
	AND (t.investment_month = 1  AND t.investment_year=2023)