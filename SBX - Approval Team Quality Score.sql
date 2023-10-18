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
    ,sub.user_id
    ,s.session_id as sub_id
    ,s.score
    ,wc.max_answer_word_count
    ,MAX(time_stamp) - MIN(time_stamp) as time_difference
    ,case
        when length(s.session_id) = 8 then 'https://admin.streetbees.com/projects/' || substr(s.partition_0, 1,5) || '/submissions/' || s.session_id
        else 'https://project-guiness-throwaway-production.streetbees.com/admin/projects/' || s.partition_0 || '/chats/' || s.session_id
    end as session_link
    
FROM dl_data_streetbees_api.submissions sub
    left join sbx_transcripts.answer_quality s on CAST(sub.id AS varchar) = s.session_id
    left join wc on wc.sub_id = s.session_id
    left join sbx_transcripts.allchats ac on ac.session_id = s.session_id


where
    s.partition_0 in ('{{project name}}')
group by 1,2,3,4,5
order by 1;
