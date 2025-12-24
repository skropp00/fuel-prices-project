# fuel-prices-project

A portfolio project exploring U.S. fuel pricing dynamics using historical EIA data.

## What It Does
- Pulls weekly EIA data for:
  - Wholesale spot prices (Gulf Coast gasoline & diesel)
  - National retail gasoline & diesel prices
  - Crude oil (WTI spot)
- Calculates industry-standard **3:2:1 crack spread** to estimate refining margins
- Approximates **retail gross margin** as: pump price − (crude per gallon + crack proxy per gallon)

## Why I Built It
To better understand the fuel supply chain — from crude oil to refinery to terminal (rack) to pump — and how refining profitability affects what consumers pay. Inspired by a real-world fuel pricing analyst role.

## Data Sources
All public weekly series from the U.S. Energy Information Administration (EIA):
- [Retail Gasoline](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=pet&s=emm_epmru_pte_nus_dpg&f=w)
- [Retail Diesel](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=pet&s=emd_epd2d_pte_nus_dpg&f=w)
- [Crude Oil WTI Spot](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=RWTC&f=W)
- [Gasoline Spot](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=EER_EPMRU_PF4_RGC_DPG&f=W)
- [Diesel Spot](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=pet&s=eer_epd2dxl0_pf4_rgc_dpg&f=w)

## Notes
- This focuses on gross retail margin before taxes (which vary significantly by state and add ~$0.40–$0.70/gallon on average).
- Static copies of the source data are included in the repo for reproducibility when EIA updates live series.
