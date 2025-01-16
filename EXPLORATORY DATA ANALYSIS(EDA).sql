-- EXPLORATORY DATA ANALYSIS(EDA)

SELECT *
FROM layoffs_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc ;

SELECT min(`DATE`), max(`DATE`)
FROM layoffs_staging2;

select INDUSTRY, sum(total_laid_off)
from layoffs_staging2
group by INDUSTRY
order by 2 desc ;

SELECT *
FROM layoffs_staging2;

select COUNTRY, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc ;

select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc ;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc ;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc ;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc ;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2;

select substring(`date`,6,2) as 'MONTH'
from layoffs_staging2;

SELECT 
    SUBSTRING(`date`, 1, 7) AS `MONTH`, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

SELECT 
    SUBSTRING(`date`, 1, 7) AS `MONTH`,
    SUM(total_laid_off) AS monthly_total,
    SUM(SUM(total_laid_off)) OVER (ORDER BY SUBSTRING(`date`, 1, 7)) AS rolling_total
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
ORDER BY 3 desc;


with Company_Year (company, years, total_laid_off) as 
(
select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
), Company_Year_Ranks as
(
select *, DENSE_RANK() OVER(partition by years order by total_laid_off DESC) as ranking
from Company_Year
WHERE years is not null
)
select *
from Company_Year_Ranks
where ranking <= 5;




