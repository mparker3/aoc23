with maxes as (
   with max_reds as (
     select * from (
       select
         turn_num,
         reds,
         row_number()
       over(partition by turn_num order by reds desc)
       from turns
     ) max_reds
     where row_number = 1
   ), max_greens as (
     select * from (
       select
         turn_num,
         greens,
         row_number()
       over(partition by turn_num order by greens desc)
       from turns
     ) max_greens
     where row_number = 1
   ), max_blues as (
     select * from (
       select
         turn_num,
         blues,
         row_number()
       over(partition by turn_num order by blues desc)
       from turns
     ) max_blues
     where row_number = 1
   ) select
       mr.turn_num,
       reds,
       greens,
       blues
     from
     max_reds mr
     join max_greens mg
       on mr.turn_num = mg.turn_num
     join max_blues mb
       on mr.turn_num = mb.turn_num
 ) select sum(reds * greens * blues) from maxes
