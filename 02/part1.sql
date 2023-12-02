 create table turns (turn_num integer, reds integer, greens integer, blues integer);
 \copy turns from 'sample.txt' delimiter ',';
with exclusions as (
  select distinct turn_num from turns
  where 
    reds > 12
    or greens > 13
    or blues > 14
) select 
  sum(distinct turn_num)
from turns
  where
    turn_num not in (select turn_num from exclusions);
