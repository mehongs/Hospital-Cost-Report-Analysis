SELECT CCN_Facility_Type, SUM(Net_Income)/SUM(Number_of_Beds) AS [IncomePerBed],
	CASE
		WHEN SUM(Net_Income)/SUM(Number_of_Beds) > 0 THEN 'Revenue'
		ELSE 'Debt'
	END AS [DebtOrNot]
FROM CostReport_2023_Final
WHERE CCN_Facility_Type <> 'TC' --Do not include 'TC', it has nothing in there.
GROUP BY CCN_Facility_Type
ORDER BY CCN_Facility_Type
