 \copy day1 from 'output.txt';

 with firsts as (
   select substring(entry from '[0-9]') as entry from day1
 ), lasts as (
 select substring(reverse(entry) from '[0-9]') as entry from day1
 )
 select sum((first_num.entry || last_num.entry)::numeric)
 from (
   select entry, ROW_NUMBER() OVER () as rn
   from firsts
 ) first_num
 JOIN (
   SELECT entry, ROW_NUMBER() over () as rn
   FROM lasts
 ) last_num ON first_num.rn = last_num.rn;
