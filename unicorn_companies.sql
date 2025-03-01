WITH unicorns as (SELECT d.company_id,
EXTRACT(YEAR FROM d.date_joined) as year,
f.valuation
 FROM dates as d JOIN funding as f on d.company_id=f.company_id 
where EXTRACT(YEAR FROM date_joined) IN (2019, 2020, 2021)),
 data as
(SELECT i.industry ,
u.year,
COUNT(u.company_id) AS num_unicorns ,
ROUND(AVG(u.valuation/1000000000),2) AS average_valuation_billions 
FROM industries AS i JOIN unicorns as u on i.company_id=u.company_id 
group by i.industry,u.year order by u.year, num_unicorns desc ),

best_perf as
(SELECT industry, SUM(num_unicorns) as sum 
from data 
group by industry 
order by sum desc limit 3)

SELECT bp.industry ,d.year,
d.num_unicorns,d.average_valuation_billions
 FROM best_perf as bp JOIN data as d 
 on 
bp.industry=d.industry 
order by year desc, num_unicorns desc