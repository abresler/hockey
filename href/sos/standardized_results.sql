begin;

drop table if exists href.results;

create table href.results (
	game_id		      integer,
	year		      integer,
	game_date	      date,
	game_type	      text,
	team_name	      text,
	team_id		      text,
	opponent_name	      text,
	opponent_id	      text,
	location_id	      text,
	field		      text,
	team_score	      integer,
	opponent_score	      integer,
	game_length	      text
);

-- Regular season

insert into href.results
(game_id,year,game_date,
 game_type,
 team_name,team_id,
 opponent_name,opponent_id,
 location_id,field,
 team_score,opponent_score,game_length)
(
select
game_id,
year,
game_date::date,
'regular_season' as game_type,
trim(both from home_name),
home_id,
trim(both from visitor_name),
visitor_id,
home_id as location_id,
'offense_home' as field,
(case when status in ('OT','SO') then
      least(g.home_score,g.visitor_score)
else g.home_score
end) as team_score,
(case when status in ('OT','SO') then
      least(g.home_score,g.visitor_score)
else g.visitor_score
end) as opponent_score,
coalesce(status,'0 OT') as game_length
from href.games g
where
--    g.home_score is not NULL
--and g.visitor_score is not NULL
    TRUE
and g.home_id is not NULL
and g.visitor_id is not NULL
);

insert into href.results
(game_id,year,game_date,
 game_type,
 team_name,team_id,
 opponent_name,opponent_id,
 location_id,field,
 team_score,opponent_score,game_length)
(
select
game_id,
year,
game_date::date,
'regular_season' as game_type,
trim(both from visitor_name),
visitor_id,
trim(both from home_name),
home_id,
home_id as location_id,
'defense_home' as field,
(case when status in ('OT','SO') then
      least(g.home_score,g.visitor_score)
else g.visitor_score
end) as team_score,
(case when status in ('OT','SO') then
      least(g.home_score,g.visitor_score)
else g.home_score
end) as opponent_score,
coalesce(status,'0 OT') as game_length
from href.games g
where
--    g.home_score is not NULL
--and g.visitor_score is not NULL
    TRUE
and g.home_id is not NULL
and g.visitor_id is not NULL
);

-- Playoffs

insert into href.results
(game_id,year,game_date,
 game_type,
 team_name,team_id,
 opponent_name,opponent_id,
 location_id,field,
 team_score,opponent_score,game_length)
(
select
game_id,
year,
game_date::date,
'playoffs' as game_type,
trim(both from home_name),
home_id,
trim(both from visitor_name),
visitor_id,
home_id as location_id,
'offense_home' as field,
--(case when status in ('OT','SO') then
--      least(g.home_score,g.visitor_score)
--else g.home_score
--end) as team_score,
g.home_score as team_score,
--(case when status in ('OT','SO') then
--      least(g.home_score,g.visitor_score)
--else g.visitor_score
--end) as opponent_score,
g.visitor_score as opponent_score,
coalesce(status,'0 OT') as game_length
from href.playoffs g
where
--    g.home_score is not NULL
--and g.visitor_score is not NULL
    TRUE
and g.home_id is not NULL
and g.visitor_id is not NULL
);

insert into href.results
(game_id,year,game_date,
 game_type,
 team_name,team_id,
 opponent_name,opponent_id,
 location_id,field,
 team_score,opponent_score,game_length)
(
select
game_id,
year,
game_date::date,
'playoffs' as game_type,
trim(both from visitor_name),
visitor_id,
trim(both from home_name),
home_id,
home_id as location_id,
'defense_home' as field,
--(case when status in ('OT','SO') then
--      least(g.home_score,g.visitor_score)
--else g.visitor_score
--end) as team_score,
g.visitor_score as team_score,
--(case when status in ('OT','SO') then
--      least(g.home_score,g.visitor_score)
--else g.home_score
--end) as opponent_score,
g.home_score as opponent_score,
coalesce(status,'0 OT') as game_length
from href.playoffs g
where
--    g.home_score is not NULL
--and g.visitor_score is not NULL
    TRUE
and g.home_id is not NULL
and g.visitor_id is not NULL
);

commit;
