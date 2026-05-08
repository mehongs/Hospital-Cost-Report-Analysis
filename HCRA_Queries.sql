--"Do certain facility types tend to make more income per bed?"
SELECT CCN_Facility_Type, SUM(Net_Income)/SUM(Number_of_Beds) AS [IncomePerBed],
	CASE
		WHEN SUM(Net_Income)/SUM(Number_of_Beds) > 0 THEN 'Revenue'
		ELSE 'Debt'
	END AS [DebtOrNot]
FROM CostReport_2023_Final
WHERE CCN_Facility_Type <> 'TC' --Do not include 'TC', it has nothing in there.
GROUP BY CCN_Facility_Type
ORDER BY CCN_Facility_Type

--"Do hospitals in certain states have better cost/income ratios?"
--Query 1:
SELECT
	[Hospital_Name],[State_Code],[Total_Income],
	[Total_Costs],
FROM dbo.[CostReport_2023_Final]
WHERE [Total_Income] IS NOT NULL
AND [Total_Costs] IS NOT NULL;

--Query 2:
SELECT
	[State_Code],
	AVG([Total_Costs] * 1.0 / NULLIF([Total_Income], 0)) AS Cost_Income_Ratio
FROM dbo.[CostReport_2023_Final]
GROUP BY [State_Code]
ORDER BY Cost_Income_Ratio ASC;

--"Which states have the highest Medicaid usage?"
--Query 1:
ALTER TABLE dbo.CostReport_2023_Final
ADD Adopted_Medicaid_Expansion BIT;

UPDATE dbo.CostReport_2023_Final
SET Adopted_Medicaid_Expansion = 1
WHERE State_Code IN ('AZ', 'AK', 'CA', 'OR', 'NV', 'UT', 'ID', 'WA', 'MT', 'CO', 'NM', 'ND', 'SD', 'NE', 'LA', 'OK', 'AR', 'MO', 'IA', 'MN', 'IL', 'IN', 'MI',
'KY', 'OH', 'WV', 'NC', 'VA', 'PA', 'DE', 'NJ', 'RI', 'NY', 'NH', 'ME', 'HI',
'VT', 'MA', 'CT', 'MD', 'DC');

UPDATE dbo.CostReport_2023_Final
SET Adopted_Medicaid_Expansion = 0
WHERE Adopted_Medicaid_Expansion IS Null;

--Query 2:
SELECT
State_Code,
COUNT(Hospital_Name) AS Hospital_Count,
Adopted_Medicaid_Expansion, 
SUM(Net_Revenue_from_Medicaid + Net_Revenue_from_Stand_Alone_CHIP) AS Total_Low_Income_Health_Insurance
FROM [HospitalProviderCostReport].[dbo].[CostReport_2023_Final]
GROUP BY State_Code, Adopted_Medicaid_Expansion
ORDER BY Total_Low_Income_Health_Insurance DESC;

--"How does the total number of employees affect overall profitability?"
SELECT
State_Code,
Hospital_Name,
SUM(Total_Income - Total_Costs) AS Overall_Profitability,
FTE_Employees_on_Payroll
FROM [HospitalProviderCostReport].[dbo].[CostReport_2023_Final]
GROUP BY State_Code, Hospital_Name, FTE_Employees_on_Payroll
ORDER BY FTE_Employees_on_Payroll DESC;
