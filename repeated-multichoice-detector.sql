with response_multiple_normalized as (
    select 
        s.id as sub_id,
        --s.project_id as project_id,
        unnest(a.response_multiple) as response
    from submissions s
    left join answers a on a.submission_id = s.id
    --left join submission_qa_statuses sqs on sqs.submission_id = s.id
    where s.project_id = ({{Project ID}})
    --and sqs.status is null
    and (a.project_survey_item_id = ({{First Ques First Num}}) or a.project_survey_item_id = ({{Second Ques First Num}}))
)

select
    --project_id as "Project ID",
    sub_id as "Sub ID", 
    response as "Repeated Response", 
    count(*) as "Repeated Count"
from response_multiple_normalized
group by 1,2--,3
having count(*) > 1