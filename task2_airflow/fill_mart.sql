--добавлен параметр '{{ ds }}' для формирования Jinja шаблона - преимущество такого метода в том, что появляется возможность пересчитать исторические данные за необходимый период, а не только от текущей даты
DELETE FROM mart_data.marketing_account WHERE date BETWEEN '{{ ds }}' - INTERVAL '30 days' AND '{{ ds }}';
INSERT INTO mart_data.marketing_account
SELECT costs.*, crm_deals.stage_of_lead, COALESCE(crm_deals.stage_of_lead,'')<>'Junk' is_lead
FROM (
	SELECT date, 'Google' channel, account_name, cost::decimal(16,5) 
  	FROM google_ads
  	WHERE date BETWEEN '{{ ds }}' - INTERVAL '30 days' AND '{{ ds }}' 
	union all 
	SELECT date, 'Yandex' channel, account_name, cost::decimal(16,5) 
  	FROM yandex_costs 
  	WHERE date BETWEEN '{{ ds }}' - INTERVAL '30 days' AND '{{ ds }}'
) costs 
LEFT JOIN crm_deals 
	ON crm_deals.date_create BETWEEN costs.date AND costs.date + INTERVAL '1 day' 
    AND costs.account_name = crm_deals.account_name
ORDER BY 1,2;