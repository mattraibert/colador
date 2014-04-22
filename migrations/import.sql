insert into event
  (select uw_id as id, uw_title as title, uw_content as content, uw_source as citation,
     uw_end as "years#end_year", uw_start as "years#start_year"
     FROM uw_la_entries);
