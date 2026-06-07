-- ================================================================================
-- PROJECT: Campaign Performance Analysis
-- ================================================================================

-- TOOLS USED:
-- Excel: Data cleaning
-- MySQL: Data analysis
-- Tableau: Data visualization

-- ================================================================================
-- PROJECT OVERVIEW:
-- ================================================================================

-- This project analyzes marketing campaign performance across brands, campaign
-- types, customer segments, marketing channels, languages, and time periods.

-- The cleaned dataset was imported into MySQL for structured analysis. The goal is
-- to evaluate campaign effectiveness and identify patterns that can support better
-- marketing decisions.

-- ================================================================================
-- BUSINESS OBJECTIVE:
-- ================================================================================

-- To analyze campaign performance and provide insights for improving revenue,
-- profitability, return on investment, customer acquisition efficiency, and
-- conversion performance.

-- ================================================================================
-- KEY BUSINESS QUESTIONS:
-- ================================================================================

-- 1. What is the overall performance of the marketing campaigns?
-- 2. Which marketing channels generate the highest revenue, ROI, and profit?
-- 3. Which campaign types perform best in conversions and ROAS?
-- 4. Which customer segments are the most valuable?
-- 5. Which brands achieve the strongest campaign performance?
-- 6. How does campaign performance change over time?
-- 7. Which campaigns have high acquisition cost but low returns?
-- 8. What are the top-performing campaigns by revenue, profit, and conversions?
-- 9. Which target audiences respond best to different marketing channels?
-- 10. Which campaigns generated revenue higher than the overall average revenue?
-- 11. Which marketing channels have ROI higher than the overall average ROI?
-- 12. Which customer segments have ROAS higher than the overall average ROAS?
-- 13. Which brands generate profit higher than the average brand-level profit?
-- 14. Which campaign types generate conversions higher than the average campaign-type conversions?

-- ================================================================================
-- STEP 1: DATA VALIDATION
-- ================================================================================

-- 1. Check total number of records
SELECT 
    COUNT(*) AS total_rows
FROM Campaign.performance;

-- 2. Preview sample records
SELECT *
FROM Campaign.performance
LIMIT 10;

-- ================================================================================
-- STEP 2: BUSINESS KPI OVERVIEW
-- ================================================================================

-- What is the overall performance of the marketing campaigns?

SELECT
    COUNT(DISTINCT Campaign_ID) AS total_campaigns,
    SUM(Impressions) AS total_impressions,
    SUM(Clicks) AS total_clicks,
    SUM(Leads) AS total_leads,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Acquisition_Cost), 2) AS total_acquisition_cost,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(`CTR %`), 2) AS average_ctr_percentage,
    ROUND(AVG(CPA), 2) AS average_cpa,
    ROUND(AVG(ROAS), 2) AS average_roas,
    ROUND(AVG(ROI), 2) AS average_roi
FROM Campaign.performance;


-- ================================================================================
-- STEP 3: MARKETING CHANNEL PERFORMANCE ANALYSIS
-- ================================================================================

-- Which marketing channels generate the highest revenue, ROI, and profit?

SELECT
    Channel_Used,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(ROAS), 2) AS average_roas,
    SUM(Conversions) AS total_conversions
FROM Campaign.performance
GROUP BY Channel_Used
ORDER BY total_revenue DESC;

-- ================================================================================
-- STEP 4: CAMPAIGN TYPE PERFORMANCE ANALYSIS
-- ================================================================================

-- Which campaign types perform best in terms of conversions and ROAS?

SELECT
    Campaign_Type,
    COUNT(DISTINCT Campaign_ID) AS total_campaigns,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(ROAS), 2) AS average_roas,
    ROUND(AVG(ROI), 2) AS average_roi
FROM Campaign.performance
GROUP BY Campaign_Type
ORDER BY total_conversions DESC;


-- ================================================================================
-- STEP 5: CUSTOMER SEGMENT PERFORMANCE ANALYSIS
-- ================================================================================

-- Which customer segments are the most valuable?

SELECT
    Customer_Segment,
    COUNT(DISTINCT Campaign_ID) AS total_campaigns,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(CPA), 2) AS average_cpa,
    ROUND(AVG(ROAS), 2) AS average_roas,
    ROUND(AVG(ROI), 2) AS average_roi
FROM Campaign.performance
GROUP BY Customer_Segment
ORDER BY total_revenue DESC;


-- ================================================================================
-- STEP 6: BRAND PERFORMANCE ANALYSIS
-- ================================================================================

-- Which brands achieve the strongest campaign performance?

SELECT
    Brand,
    COUNT(DISTINCT Campaign_ID) AS total_campaigns,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(CPA), 2) AS average_cpa,
    ROUND(AVG(ROAS), 2) AS average_roas,
    ROUND(AVG(ROI), 2) AS average_roi
FROM Campaign.performance
GROUP BY Brand
ORDER BY total_revenue DESC;


-- ================================================================================
-- STEP 7: MONTHLY CAMPAIGN PERFORMANCE TREND
-- ================================================================================

-- How does campaign performance change over time?

SELECT
    Year,
    Month,
    COUNT(DISTINCT Campaign_ID) AS total_campaigns,
    SUM(Impressions) AS total_impressions,
    SUM(Clicks) AS total_clicks,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(ROAS), 2) AS average_roas
FROM Campaign.performance
GROUP BY Year, Month
ORDER BY 
    Year ASC,
    FIELD(Month, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec') ASC;


-- ================================================================================
-- STEP 8: HIGH COST, LOW RETURN CAMPAIGNS
-- ================================================================================

-- Which campaigns have high acquisition cost but low returns?

SELECT
    Campaign_ID,
    Brand,
    Campaign_Type,
    Channel_Used,
    Customer_Segment,
    ROUND(Acquisition_Cost, 2) AS acquisition_cost,
    ROUND(Revenue, 2) AS revenue,
    ROUND(Profit, 2) AS profit,
    ROUND(ROI, 2) AS roi,
    ROUND(ROAS, 2) AS roas,
    Conversions
FROM Campaign.performance
WHERE Acquisition_Cost > Revenue
ORDER BY Acquisition_Cost DESC;

-- ================================================================================
-- STEP 9: TOP-PERFORMING CAMPAIGNS
-- ================================================================================

-- What are the top-performing campaigns by revenue, profit, and conversions?

SELECT
    Campaign_ID,
    Brand,
    Campaign_Type,
    Channel_Used,
    Customer_Segment,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(ROAS), 2) AS average_roas
FROM Campaign.performance
GROUP BY 
    Campaign_ID,
    Brand,
    Campaign_Type,
    Channel_Used,
    Customer_Segment
ORDER BY total_revenue DESC
LIMIT 10;


-- ================================================================================
-- STEP 10: TARGET AUDIENCE PERFORMANCE ANALYSIS
-- ================================================================================

-- Which target audiences respond best to different marketing channels?

SELECT
    Target_Audience,
    Channel_Used,
    COUNT(DISTINCT Campaign_ID) AS total_campaigns,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(ROAS), 2) AS average_roas
FROM Campaign.performance
GROUP BY Target_Audience, Channel_Used
ORDER BY total_conversions DESC;

-- ================================================================================
-- STEP 11  CAMPAIGNS ABOVE AVERAGE REVENUE 
-- ================================================================================

-- Which campaigns generated revenue higher than the overall average campaign revenue?

SELECT
    Campaign_ID,
    Brand,
    Campaign_Type,
    Channel_Used,
    Customer_Segment,
    ROUND(Revenue, 2) AS revenue,
    ROUND(Profit, 2) AS profit,
    ROUND(ROI, 2) AS roi,
    ROUND(ROAS, 2) AS roas
FROM Campaign.performance
WHERE Revenue > (
    SELECT AVG(Revenue)
    FROM Campaign.performance
)
ORDER BY Revenue DESC;


-- ================================================================================
-- STEP 12: CHANNELS ABOVE AVERAGE ROI
-- ================================================================================

-- Which marketing channels have an ROI higher than the overall average ROI?

SELECT
    Channel_Used,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    SUM(Conversions) AS total_conversions
FROM Campaign.performance
GROUP BY Channel_Used
HAVING AVG(ROI) > (
    SELECT AVG(ROI)
    FROM Campaign.performance
)
ORDER BY average_roi DESC;

-- ================================================================================
-- STEP 13: CUSTOMER SEGMENTS ABOVE AVERAGE ROAS
-- ================================================================================

-- Which customer segments have ROAS higher than the overall average ROAS?

SELECT
    Customer_Segment,
    ROUND(AVG(ROAS), 2) AS average_roas,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    SUM(Conversions) AS total_conversions
FROM Campaign.performance
GROUP BY Customer_Segment
HAVING AVG(ROAS) > (
    SELECT AVG(ROAS)
    FROM Campaign.performance
)
ORDER BY average_roas DESC;

-- ================================================================================
-- STEP 14: BRANDS ABOVE AVERAGE PROFIT
-- ================================================================================

-- Which brands generate total profit higher than the average brand-level profit?

SELECT
    Brand,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(ROAS), 2) AS average_roas,
    SUM(Conversions) AS total_conversions
FROM Campaign.performance
GROUP BY Brand
HAVING SUM(Profit) > (
    SELECT AVG(brand_profit)
    FROM (
        SELECT
            Brand,
            SUM(Profit) AS brand_profit
        FROM Campaign.performance
        GROUP BY Brand
    ) AS brand_summary)
ORDER BY total_profit DESC;

-- ================================================================================
-- STEP 15: CAMPAIGN TYPES ABOVE AVERAGE CONVERSIONS
-- ================================================================================

-- Which campaign types generate total conversions higher than the average campaign-type conversions?

SELECT
    Campaign_Type,
    SUM(Conversions) AS total_conversions,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(ROI), 2) AS average_roi,
    ROUND(AVG(ROAS), 2) AS average_roas
FROM Campaign.performance
GROUP BY Campaign_Type
HAVING SUM(Conversions) > (
    SELECT AVG(type_conversions)
    FROM (
        SELECT
            Campaign_Type,
            SUM(Conversions) AS type_conversions
        FROM Campaign.performance
        GROUP BY Campaign_Type
    ) AS campaign_type_summary)
ORDER BY total_conversions DESC;


-- ================================================================================
-- KEY BUSINESS INSIGHTS
-- ================================================================================

-- 1. Overall Campaign Performance:
-- The campaign portfolio generated 166,665 campaigns, 9.17B impressions,
-- 780.39M clicks, 171.51M conversions, ₹85.65B revenue, and ₹85.59B profit.
-- The average CTR was 8.50%, average CPA was ₹2.08, average ROAS was 6,439.07,
-- and average ROI was 2.69.

-- 2. Marketing Channel Performance:
-- Email was the strongest individual marketing channel, generating the highest
-- revenue of ₹4.90B, profit of ₹4.90B, and 9.78M conversions. WhatsApp had the
-- highest average ROAS among the top individual channels.

-- 3. Campaign Type Performance:
-- Paid Ads generated the highest revenue and profit, while Email generated the
-- highest conversions. Social Media achieved the highest average ROAS, making it
-- the most efficient campaign type by return on ad spend.

-- 4. Customer Segment Performance:
-- College Students generated the highest revenue and profit. Youth generated the
-- highest conversions, while Working Women achieved the highest average ROAS.

-- 5. Brand Performance:
-- Nykaa was the strongest-performing brand, leading in revenue, profit,
-- conversions, average ROI, and average ROAS. Purplle ranked second, followed by Tira.

-- 6. Monthly Performance Trend:
-- August 2024 generated the highest monthly revenue and profit. February 2025
-- recorded the highest average ROI and ROAS. June 2025 had lower totals because
-- it contained fewer campaign records.

-- 7. High Cost, Low Return Campaigns:
-- 11 campaigns had acquisition cost greater than revenue. These campaigns produced
-- negative profit and ROAS below 1, indicating inefficient budget usage.

-- 8. Top-Performing Campaigns:
-- NY-CMP-13007 from Nykaa was the top-performing campaign, generating ₹4.58M
-- revenue, ₹4.58M profit, 6,686 conversions, ROI of 74.42, and ROAS of 504,395.37.

-- 9. Target Audience and Channel Performance:
-- Working Women through Email generated the highest audience-channel revenue and
-- conversions. Tier 2 City Customers also performed strongly through Instagram,
-- Email, and WhatsApp.

-- 10. Above-Average Revenue Campaigns:
-- The highest above-average revenue campaign was NY-CMP-13007 from Nykaa, followed
-- by TI-CMP-42309 from Tira and NY-CMP-44157 from Nykaa. These campaigns showed
-- strong revenue, profit, ROI, and ROAS performance.

-- 11. Above-Average ROI Channels:
-- YouTube, Google, and Email had the highest average ROI among above-average
-- channel combinations, followed by Google, Email, and Instagram.

-- 12. Above-Average ROAS Customer Segments:
-- Working Women had the highest above-average ROAS, followed by College Students,
-- Tier 2 City Customers, and Youth.

-- 13. Above-Average Profit Brands:
-- Nykaa was the only brand with total profit above the average brand-level profit.
-- This shows that profit performance is concentrated in Nykaa, making it the
-- strongest benchmark brand for future campaign planning.

-- 14. Above-Average Conversion Campaign Types:
-- Email, Paid Ads, Social Media, and Influencer campaigns generated conversions
-- above the average campaign-type conversion benchmark. Email ranked highest,
-- followed closely by Paid Ads, Social Media, and Influencer campaigns.


-- ================================================================================
-- FINAL RECOMMENDATIONS
-- ================================================================================

-- 1. Increase investment in Email marketing because Email generated the highest
-- revenue, profit, and conversions among individual marketing channels.

-- 2. Scale Paid Ads carefully because Paid Ads generated the highest revenue and
-- profit among campaign types, but acquisition cost should be monitored closely.

-- 3. Use Social Media campaigns for efficiency-focused marketing because Social
-- Media achieved the highest average ROAS among campaign types.

-- 4. Prioritize College Students, Youth, and Working Women because these customer
-- segments showed strong revenue, conversion, and ROAS performance.

-- 5. Use Nykaa as the key benchmark brand because it was the only brand with
-- total profit above the average brand-level profit.

-- 6. Replicate successful elements from top-performing campaigns such as
-- NY-CMP-13007, especially the use of Paid Ads with Email, YouTube, and Facebook.

-- 7. Review and optimize the 11 campaigns where acquisition cost exceeded revenue,
-- as these campaigns generated negative profit and ROAS below 1.

-- 8. Strengthen audience-channel alignment by focusing on proven combinations,
-- especially Working Women through Email and Tier 2 City Customers through
-- Instagram, Email, and WhatsApp.

-- 9. Focus conversion-growth efforts on Email, Paid Ads, Social Media, and
-- Influencer campaigns because these campaign types performed above the
-- average campaign-type conversion benchmark.

-- 10. Track ROI, ROAS, CPA, profit, and conversions continuously to identify
-- underperforming campaigns early and reallocate budget toward stronger
-- brands, channels, segments, and campaign types.

-- ================================================================================
-- END OF ANALYSIS
-- ================================================================================

-- This analysis identified key drivers of campaign performance across channels,
-- campaign types, customer segments, brands, audience groups, and time periods.
-- The findings will be used to support Tableau dashboard development and
-- data-driven marketing recommendations.