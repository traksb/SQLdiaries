WITH birth_year_demog AS
  (SELECT s.id AS sub_id,
          a.response_text AS birth_year
   FROM submissions s
   LEFT JOIN answers a ON a.submission_id = s.id
   WHERE a.project_survey_item_id = ({{The first digit under Que}}) )
SELECT sub_id as "Sub ID",
       birth_year as "Year of Birth"
FROM birth_year_demog 
WHERE birth_year BETWEEN ({{First Year}})::varchar AND ({{Second Year}})::varchar