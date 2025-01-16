-- EXPLORATORY DATA ANALYSIS(EDA)

-- Section 1: Overview of Data
SELECT *
FROM layoffs_staging2;

-- Section 2: Maximum Values Analysis
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Section 3: Companies with 100% Layoffs
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Section 4: Total Layoffs by Company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Section 5: Date Range of Layoffs
SELECT MIN(`DATE`), MAX(`DATE`)
FROM layoffs_staging2;

-- Section 6: Total Layoffs by Industry
SELECT INDUSTRY, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY INDUSTRY
ORDER BY 2 DESC;

-- Section 7: Total Layoffs by Country
SELECT COUNTRY, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY COUNTRY
ORDER BY 2 DESC;

-- Section 8: Daily Layoff Totals
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

-- Section 9: Yearly Layoff Totals
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Section 10: Layoffs by Stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Section 11: Average Percentage Laid Off by Company
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2;

-- Section 12: Monthly Breakdown
SELECT SUBSTRING(`date`, 6, 2) AS 'MONTH'
FROM layoffs_staging2;

SELECT 
    SUBSTRING(`date`, 1, 7) AS `MONTH`, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Section 13: Rolling Monthly Totals
SELECT 
    SUBSTRING(`date`, 1, 7) AS `MONTH`,
    SUM(total_laid_off) AS monthly_total,
    SUM(SUM(total_laid_off)) OVER (ORDER BY SUBSTRING(`date`, 1, 7)) AS rolling_total
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC;

-- Section 14: Company Layoffs by Year
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Section 15: Top Companies by Year
WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Ranks AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Ranks
WHERE ranking <= 5;
