with wc as (
    select 
        session_id as sub_id
        ,max(cardinality(split(m['content'], ' ')) - 1) as max_answer_word_count
    from sbx_transcripts.answer_quality,
        unnest(chat) as t(m)
    where 
        m['role'] = 'user'
    group by 1
)

select
    s.partition_0
    ,ac.user_id
    ,s.session_id as sub_id
    ,s.score
    ,wc.max_answer_word_count
    ,case
        when length(s.session_id) = 8 then 'https://admin.streetbees.com/projects/' || substr(s.partition_0, 1,5) || '/submissions/' || s.session_id
        else 'https://project-guiness-throwaway-production.streetbees.com/admin/projects/' || s.partition_0 || '/chats/' || s.session_id
    end as session_link
from sbx_transcripts.answer_quality s
    left join sbx_transcripts.allchats ac on ac.session_id = s.session_id
    left join wc on wc.sub_id = s.session_id

where
    s.partition_0 in ('{{project name}}')
order by 1;