select


p.id,
p.internal_ref,
s.user_id,
u.ip_country,
case
    when date_part('year', age(u.date_of_birth))::int<20 then '<20'
    when date_part('year', age(u.date_of_birth))::int<25 then '20-24'
    when date_part('year', age(u.date_of_birth))::int<35 then '25-34'
    when date_part('year', age(u.date_of_birth))::int<45 then '35-44'
    when date_part('year', age(u.date_of_birth))::int<55 then '45-54'
    when date_part('year', age(u.date_of_birth))::int<70 then '55-69' end as age,
u.gender
    
    
    
from submissions s
left join users u on s.user_id = u.id
left join projects p on p.id = s.project_id

where s.project_id in ({{Project ID}})