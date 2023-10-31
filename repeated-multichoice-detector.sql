with response_multiple_normalized as (
    select 
        s.id as sub_id,
        unnest(a.response_multiple) as response
    from submissions s
    left join answers a on a.submission_id = s.id
    --left join submission_qa_statuses sqs on sqs.submission_id = s.id
    where s.project_id = ({{Project ID}})
    --and sqs.status is null
)

select 
    sub_id as "Sub ID", 
    response as "Repeated Response", 
    count(*) as "Repeated Count"
from response_multiple_normalized
group by sub_id, response
having count(*) > 1