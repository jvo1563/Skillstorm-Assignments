USE investment_db;
GO

SELECT * FROM investment;
SELECT * FROM investment_name;
SELECT * FROM investment_type;
SELECT * FROM investment_sector;
SELECT * FROM investment_time;
SELECT
	n.investment_name AS [name],
	t.investment_date AS [date],
	i.closing_price,
	i.daily_return,
	SUM(i.daily_return) OVER (
		PARTITION BY n.investment_name
		ORDER BY t.investment_date
	) cumulative_return,
	i._10_day_ma AS [10_day_ma],
	i._100_day_ma AS [100_day_ma],
	i.volatility,
	i.sharpe_ratio,
	i.beta
FROM investment i
JOIN investment_name n ON i.investment_name_id = n.investment_name_id
JOIN investment_time t ON i.time_id = t.time_id
JOIN investment_type ty ON i.investment_type_id = ty.investment_type_id
WHERE ty.investment_type IN ('Stock', 'ETF', 'Forex')
	AND (t.investment_month IN (3,4,5,6)  AND t.investment_year=2024)



SELECT
	n.investment_name AS [name],
	t.investment_date AS [date],
	i._10_day_ma AS [10_day_ma],
	i._100_day_ma AS [100_day_ma]
FROM investment i
JOIN investment_name n ON i.investment_name_id = n.investment_name_id
JOIN investment_time t ON i.time_id = t.time_id
JOIN investment_type ty ON i.investment_type_id = ty.investment_type_id
WHERE ty.investment_type IN ('Stock', 'ETF', 'Market')
	AND (t.investment_month IN (3,4,5,6)  AND t.investment_year=2024)

