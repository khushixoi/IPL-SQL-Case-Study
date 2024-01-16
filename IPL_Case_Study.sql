-- Questions – Write SQL queries to get data for following requirements:

-- 1. Show the percentage of wins of each bidder in the order of highest to lowest percentage.
SELECT IPL_BIDDING_DETAILS.bidder_id, ipl_bidder_details.bidder_name ,
SUM(CASE WHEN bid_status = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(bid_status) AS percentage_of_won
FROM IPL_BIDDING_DETAILS inner join ipl_bidder_details 
on IPL_BIDDING_DETAILS.bidder_id = ipl_bidder_details.bidder_id
GROUP BY bidder_id ,bidder_name
ORDER BY percentage_of_won desc;

-- 2. Which teams have got the highest and the lowest no. of bids?
select team_id , team_name , count(*) as no_of_bids
from IPL_BIDDING_DETAILS a 
JOIN IPL_TEAM  b 
on  a.bid_team=b.team_id where bid_status != 'cancelled' group by bid_team
having 
count(*)=  (select count(*) from ipl_bidding_details where bid_status != 'cancelled' 
group by bid_team order by count(*) desc limit 1) 
or 
count(*) = (select count(*) from ipl_bidding_details where bid_status != 'cancelled' 
group by bid_team order by count(*) limit 1) ;

-- 3. In a given stadium, what is the percentage of wins by a team which has won the toss?
select stadium_id 'Stadium ID', stadium_name 'Stadium Name',
(select count(*) from ipl_match m join ipl_match_schedule ms on m.match_id = ms.match_id
where ms.stadium_id = s.stadium_id and (toss_winner = match_winner)) /
(select count(*) from ipl_match_schedule ms where ms.stadium_id = s.stadium_id) * 100 
as 'Percentage of Wins by teams who won the toss '
from ipl_stadium s;

-- 4. What is the total no. of bids placed on the team that has won the highest no. of matches?
select team_id 'Team ID', team_name 'Team Name', count(*) 'Total Bids'
from ipl_bidding_details join ipl_team on team_id = bid_team 
where bid_status != 'cancelled' group by bid_team
having bid_team = (select team_id from ipl_team_standings order by matches_won desc limit 1);

/* 5. From the current team standings, if a bidder places a bid on which of the teams,
 there is a possibility of (s)he winning the highest no. of points – in simple words, 
 identify the team which has the highest jump in its total points (in terms of percentage)
 from the previous year to current year.*/
 select t.team_id 'Team ID', t.team_name 'Team Name', 
((select total_points from ipl_team_standings ts where ts.team_id = t.team_id and tournmt_id = 2018) - 
(select total_points from ipl_team_standings ts where ts.team_id = t.team_id and tournmt_id = 2017) ) /
(select total_points from ipl_team_standings ts where ts.team_id = t.team_id and tournmt_id = 2017) * 100 
as 'Jump in total points from last year (%)'
from ipl_team t order by 3 desc limit 1;
 
 
 
 
select * from IPL_USER;
select * from IPL_BIDDER_DETAILS;
select * from IPL_BIDDER_POINTS;
select * from IPL_BIDDING_DETAILS;
select * from IPL_MATCH;
select * from IPL_MATCH_SCHEDULE;
select * from IPL_PLAYER;
select * from IPL_STADIUM;
select * from IPL_TEAM;
select * from IPL_TEAM_PLAYERS;
select * from IPL_TEAM_STANDINGS;
select * from IPL_TOURNAMENT;
