-- 3:2:1 Crack spread
SELECT 
	co.Date,
	co.[Weekly Cushing, OK WTI Spot Price ] AS crude_barrel,
	gs.[Weekly U#S# Gulf Coast Conventional Gasoline Regular Spot Price ] AS gas_spot_gallon,
	ds.[Weekly U#S# Gulf Coast Ultra-Low Sulfur No 2 Diesel Spot Price  ] AS diesel_spot_gallon,
	-- For every three barrels of crude, assuming two are gasoline and one is diesel, what do I profit per barrel?
	-- The first calculation takes the gas and diesel spot prices from gallons into barrels assuming 42 gallons per barrel and splits them into 2 gas, 1 diesel
	-- It then subtracts the cost of the 3 barrels of crude input, and divide the resulting gross profit by 3 to get the refining margin per barrel of crude processed
	(2*(gs.[Weekly U#S# Gulf Coast Conventional Gasoline Regular Spot Price ]*42) + (ds.[Weekly U#S# Gulf Coast Ultra-Low Sulfur No 2 Diesel Spot Price  ]*42) - (3 * co.[Weekly Cushing, OK WTI Spot Price ]))/3 AS crack_321_barrel,
	-- This formula does the same as above but splits into profit per gallon
	((2*(gs.[Weekly U#S# Gulf Coast Conventional Gasoline Regular Spot Price ]*42) + (ds.[Weekly U#S# Gulf Coast Ultra-Low Sulfur No 2 Diesel Spot Price  ]*42) - (3 * co.[Weekly Cushing, OK WTI Spot Price ]))/3)/42 AS crack_321_gallon
FROM [crude-futures-spot] co
RIGHT JOIN [usa-gasoline-spot] gs
	ON co.Date = gs.Date
RIGHT JOIN [usa-diesel-spot] ds
	ON co.Date = ds.Date

-- Retail Margin
-- We have a data issue here. The crude spots (end of week) and the retail prices (beginning of week) are misaligned on date patterns. 
-- Solving this issue with cross apply function to pull one date out of the week
SELECT 
	gr.Date,
	gr.[Weekly U#S# Regular Conventional Retail Gasoline Prices  (Dollar] AS retail_gas_gallon,
	dr.[Weekly U#S# No 2 Diesel Retail Prices  (Dollars per Gallon)] AS retail_diesel_gallon,
	-- Crude barrel converted to gallons, plus the crack spread gallon cost estimate equals gallon price for the wholesaler
	(c.[Weekly Cushing, OK WTI Spot Price ]/42 + crack.crack_321_gallon) AS wholesaler_gallon_cost,
	-- Takes the historic retail price that the retailer charged and subtracts the wholesale gallon cost
	gr.[Weekly U#S# Regular Conventional Retail Gasoline Prices  (Dollar] - (c.[Weekly Cushing, OK WTI Spot Price ]/42 + crack.crack_321_gallon) AS retailer_margin
FROM [usa-gasoline-retail] gr
JOIN [usa-diesel-retail] dr
	ON gr.Date = dr.Date
CROSS APPLY (
    SELECT TOP 1 c.[Weekly Cushing, OK WTI Spot Price ]
    FROM [Fuel-Prices].dbo.[crude-futures-spot] c
    WHERE c.date <= DATEADD(day, 7, gr.date) 
      AND c.date >= DATEADD(day, -7, gr.date)
    ORDER BY ABS(DATEDIFF(day, gr.date, c.date))
) c
CROSS APPLY (
    SELECT TOP 1 crack_321_gallon
    FROM [crack_321_spread] crack
    WHERE crack.date <= DATEADD(day, 7, gr.date) 
      AND crack.date >= DATEADD(day, -7, gr.date)
    ORDER BY ABS(DATEDIFF(day, gr.date, crack.date))
) crack
