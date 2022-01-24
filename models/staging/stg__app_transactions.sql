select
   user_pseudo_id
  --,up.value.int_value as ga_session_id
  ,event_timestamp
  ,parse_date('%Y%m%d',event_date) as event_date
  ,regexp_replace(
    case 
      when geo.country not in ('Australia', 'New Zealand', 'United States') then 'Other'
      else geo.country
   end, ' ', '') as country
  ,case 
      when device.operating_system in ('iOS', 'IOS') then 'iOS' else 'Android' end 
    as operating_system
  ,max(event_value_in_usd) as event_value_in_usd
from {{ ref('base__app_logs') }},
     unnest (user_properties) as up
where event_name = 'ecommerce_purchase' or event_name = 'purchase' --and up.key = 'ga_session_id'
group by 1,2,3,4,5