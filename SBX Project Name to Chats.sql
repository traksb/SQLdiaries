select
    session_id,
    chat
    
from 
    sbx_transcripts.answer_quality

where
    partition_0 in ('{{project name}}')