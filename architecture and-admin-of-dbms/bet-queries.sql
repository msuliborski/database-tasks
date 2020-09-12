CREATE VIEW VIEW_A AS

select games.matchtime, (select name from teams where id = games.hostid) as host, 
(select name from teams where id = games.guestid) as guest, score.hostscore, score.guestscore,
CASE WHEN score.hostscore=score.guestscore THEN 'x'
WHEN score.hostscore>score.guestscore THEN '1'
ELSE '2' END as result
from games
join score on games.id = score.gameId;
/









CREATE VIEW VIEW_B AS

select tempTable6.matchDate, tempTable6.hostname, tempTable6.guestName, tempTable6.bets_for_game, NVL(tempTable7.totalAmountForGame, 0) as totalAmountForGameWon
from
(select tempTable1.gameid, tempTable1.matchDate, tempTable1.hostname, tempTable1.guestName, NVL(tempTable2.betsForGame, 0) as bets_for_game

from

(select temp.gameID, temp.matchDate, temp.hostName, teams.name as guestName from (
select games.id as gameID, to_date(to_char(games.matchtime,'DD-MON-RRRR')) as matchDate, teams.name as hostName, games.guestid as guestID from games 
inner join teams
on games.hostid = teams.id) temp
inner join teams
on temp.guestID = teams.id
where temp.matchDate = (
select max(dateOfMatch) from (
select to_date(to_char(matchtime,'DD-MON-RRRR')) as dateOfMatch from games))) tempTable1

left join

(select gameid, count(*) as betsForGame from
(select bets.id as betID, bets.amountineuro as amountineuro, odds.gameid as gameID from bets
inner join odds
on bets.oddid = odds.id) temp2
group by gameid) tempTable2

on

tempTable1.gameid = tempTable2.gameid) tempTable6

left join

(select gameID, sum(amountWon) as totalAmountForGame from
(select tempTable4.id as betID, tempTable3.gameID, CAST((tempTable4.Value * tempTable4.amountInEuro) as float) as amountWon
from
(select gameid,
case 
WHEN hostscore < guestscore THEN 0
WHEN hostscore > guestscore THEN 1
WHEN hostscore = guestscore THEN 2
END as resultOfGame
from score
where gameid in (
select id from games 
where to_date(to_char(matchtime,'DD-MON-RRRR')) = (
select max(dateOfMatch) from (
select to_date(to_char(matchtime,'DD-MON-RRRR')) as dateOfMatch from games)))) tempTable3

inner join

(select bets.id, bets.amountineuro, odds.gameid, odds.oddtypeid, odds.value
from bets
inner join odds
on bets.oddid = odds.id) tempTable4

on tempTable3.gameID = tempTable4.gameID AND tempTable3.resultOfGame = tempTable4.oddtypeid) tempTable5
group by gameid) tempTable7

on

tempTable6.gameID = tempTable7.gameID
order by tempTable6.bets_for_game desc;
/












CREATE VIEW VIEW_C AS

select teams.name, (NVL(winsTable.totalWins, 0) + NVL(lostTable.totalLost, 0) + NVL(drawTable.totalDraws, 0)) as totalPlayed, NVL(winsTable.totalWins, 0) as totalWins,
NVL(lostTable.totalLost, 0) as totalLost, NVL(drawTable.totalDraws, 0) as totalDraws, (3 * NVL(winsTable.totalWins, 0) + 1 *  NVL(drawTable.totalDraws, 0)) points
from

(select teamID, (hostWins + guestWins) as totalWins
from
(select hostWonTable.hostid as teamID, hostWonTable.numberOfWins as hostWins, guestWonTable.numberOfWins as guestWins
from
-- host won
(select hostid, count(whowon) as numberOfWins from
(select whoWonTable.gameid, games.hostid, games.guestid, whoWonTable.whoWon
from
(select gameid, 
CASE
WHEN hostscore > guestscore then'Host won'
WHEN hostscore < guestscore then 'Guest won'
WHEN hostscore = guestscore then'Draw'
END as whoWon
from score) whoWonTable
inner join games
on games.id = whoWonTable.gameid
where whoWon='Host won')
group by hostid) hostWonTable

left join
--guest won
(select guestid, count(whowon) as numberOfWins from
(select whoWonTable.gameid, games.hostid, games.guestid, whoWonTable.whoWon
from
(select gameid, 
CASE
WHEN hostscore > guestscore then'Host won'
WHEN hostscore < guestscore then 'Guest won'
WHEN hostscore = guestscore then'Draw'
END as whoWon
from score) whoWonTable
inner join games
on games.id = whoWonTable.gameid
where whoWon='Guest won')
group by guestid) guestWonTable

on hostWonTable.hostid = guestWonTable.guestid)) winsTable

inner join

(select teamID, (hostLost + guestLost) as totalLost
from
(select hostLostTable.hostid as teamID, hostLostTable.hostLost as hostLost, guestLostTable.guestLost as guestLost
from
-- host lost
(select hostid, count(whowon) as hostLost from
(select whoWonTable.gameid, games.hostid, games.guestid, whoWonTable.whoWon
from
(select gameid, 
CASE
WHEN hostscore > guestscore then'Host won'
WHEN hostscore < guestscore then 'Guest won'
WHEN hostscore = guestscore then'Draw'
END as whoWon
from score) whoWonTable
inner join games
on games.id = whoWonTable.gameid
where whoWon='Guest won')
group by hostid) hostLostTable

inner join
--guest lost
(select guestid, count(whowon) as guestLost from
(select whoWonTable.gameid, games.hostid, games.guestid, whoWonTable.whoWon
from
(select gameid, 
CASE
WHEN hostscore > guestscore then'Host won'
WHEN hostscore < guestscore then 'Guest won'
WHEN hostscore = guestscore then'Draw'
END as whoWon
from score) whoWonTable
inner join games
on games.id = whoWonTable.gameid
where whoWon='Host won')
group by guestid) guestLostTable
on hostLostTable.hostid = guestLostTable.guestid)) lostTable

on winsTable.teamID = lostTable.teamID

left join

(select teamID, (hostDraws + guestDraws) as totalDraws
from
(select hostDraw.hostid as teamID, hostDraw.hostDraws as hostDraws, guestDraw.guestDraws as guestDraws
from
--host draw
(select hostid, count(whowon) as hostDraws from
(select whoWonTable.gameid, games.hostid, games.guestid, whoWonTable.whoWon
from
(select gameid, 
CASE
WHEN hostscore > guestscore then'Host won'
WHEN hostscore < guestscore then 'Guest won'
WHEN hostscore = guestscore then'Draw'
END as whoWon
from score) whoWonTable
inner join games
on games.id = whoWonTable.gameid
where whoWon='Draw')
group by hostid) hostDraw

inner join
--guest draw
(select guestid, count(whowon) guestDraws from
(select whoWonTable.gameid, games.hostid, games.guestid, whoWonTable.whoWon
from
(select gameid, 
CASE
WHEN hostscore > guestscore then'Host won'
WHEN hostscore < guestscore then 'Guest won'
WHEN hostscore = guestscore then'Draw'
END as whoWon
from score) whoWonTable
inner join games
on games.id = whoWonTable.gameid
where whoWon='Draw')
group by guestid) guestDraw
on hostDraw.hostid = guestDraw.guestid)) drawTable

on winsTable.teamID = drawTable.teamID
inner join teams
on winsTable.teamID = teams.id
order by points desc,
totalplayed asc,
totalwins desc;
/














CREATE VIEW VIEW_D AS

select * from 

(select totalPaidTable.gameid, totalPaidTable.totalPaidBets, totalBetorsTable.totalBetors

from

(select gameid, CAST(sum(amountineuro) as float) as totalPaidBets
from
(select bets.id, odds.gameid, bets.amountineuro
from bets
inner join odds
on 
bets.oddid = odds.id
where to_char(bets.time, 'YYYY') >= (
select to_char(sysdate, 'YYYY') - 1 from dual))
group by gameid) totalPaidTable

inner join

(select gameid, count(*) as totalBetors from
(select bets.id as betID, odds.gameid as gameID from bets
inner join odds
on bets.oddid = odds.id) temp2
group by gameid) totalBetorsTable

on totalPaidTable.gameid = totalBetorsTable.gameid
order by totalpaidbets desc)
where rownum <= 10;
/













CREATE VIEW VIEW_E AS

select teamsNamesTable.matchtime, teamsNamesTable.hostName, teamsNamesTable.guestName, users.name, almostDoneTable.userPaidForGame, almostDoneTable.percentage
from
(select userGameTable.userid, userGameTable.gameid, userGameTable.userPaidForGame, gameTable.totalPaidForGame, ROUND((userGameTable.userPaidForGame/gameTable.totalPaidForGame) * 100 , 2) as percentage
from
(select bets.userid, odds.gameid, sum(bets.amountineuro) as userPaidForGame 
from bets
inner join odds
on
bets.oddid = odds.id
where to_char(bets.time, 'YYYY') >= (
select to_char(sysdate, 'YYYY') - 1 from dual)
group by bets.userid, odds.gameid) userGameTable
inner join
(select odds.gameid, sum(bets.amountineuro) as totalPaidForGame
from bets
inner join odds
on bets.oddid = odds.id
where to_char(bets.time, 'YYYY') >= (
select to_char(sysdate, 'YYYY') - 1 from dual)
group by odds.gameid) gameTable
on userGameTable.gameid = gameTable.gameid
where  ROUND((userGameTable.userPaidForGame/gameTable.totalPaidForGame) * 100 , 2) >= 10) almostDoneTable
inner join
(select temp.gameID, temp.hostName, teams.name as guestName, temp.matchtime  from (
select games.id as gameID, teams.name as hostName, games.guestid as guestID, games.Matchtime from games 
inner join teams
on games.hostid = teams.id) temp
inner join teams
on temp.guestID = teams.id) teamsNamesTable
on almostDoneTable.gameid = teamsNamesTable.gameID
inner join
users
on almostDoneTable.userid = users.id
order by percentage desc;
/














CREATE VIEW VIEW_F AS

select TO_CHAR(teamInfo.matchTime, 'DD-MM-YYYY HH24:MI'), teamInfo.hostName, teamInfo.guestName, almostDoneTable.fullHour, almostDoneTable.HostLostOdd, almostDoneTable.HostWonOdd, almostDoneTable.drawOdd
from
(select hostLost.gameid, hostLost.fullHour, hostLost.HostLostOdd, hostWin.HostWonOdd, draw.drawOdd

from

(select gameid, fullHour, max(value) as HostLostOdd
from
(select value, gameid, oddtypeid, CONCAT(TO_CHAR(time, 'DD-MM-YY'), CONCAT(TO_CHAR(time, ' HH24'), ':00')) as fullHour 
from odds
where gameid in
(select gameid 
from
(select odds.gameid, count(bets.id) as totalBets
from bets
inner join odds
on bets.oddid = odds.id
group by odds.gameid
order by totalBets desc)
where rownum=1
and oddTypeID=0))
group by fullHour, gameid)  hostLost

inner join 

(select gameid, fullHour, max(value) HostWonOdd
from
(select value, gameid, oddtypeid, CONCAT(TO_CHAR(time, 'DD-MM-YY'), CONCAT(TO_CHAR(time, ' HH24'), ':00')) as fullHour 
from odds
where gameid in
(select gameid 
from
(select odds.gameid, count(bets.id) as totalBets
from bets
inner join odds
on bets.oddid = odds.id
group by odds.gameid
order by totalBets desc)
where rownum=1
and oddTypeID=1))
group by fullHour, gameid)  hostWin

on hostLost.fullHour = hostWin.fullHour

inner join

(select gameid, fullHour, max(value) as drawOdd
from
(select value, gameid, oddtypeid, CONCAT(TO_CHAR(time, 'DD-MM-YY'), CONCAT(TO_CHAR(time, ' HH24'), ':00')) as fullHour 
from odds
where gameid in
(select gameid 
from
(select odds.gameid, count(bets.id) as totalBets
from bets
inner join odds
on bets.oddid = odds.id
group by odds.gameid
order by totalBets desc)
where rownum=1
and oddTypeID=2))
group by fullHour, gameid) draw

on hostLost.fullHour = draw.fullHour) almostDoneTable

inner join

(select temp.gameID, temp.hostName, teams.name as guestName, temp.matchTime from (
select games.id as gameID, games.matchTime, teams.name as hostName, games.guestid as guestID from games 
inner join teams
on games.hostid = teams.id) temp
inner join teams
on temp.guestID = teams.id) teamInfo

on almostDoneTable.gameid = teamInfo.gameid;
/













CREATE VIEW VIEW_G AS

SELECT * FROM (select id, matchtime, 
(select z.value from odds z where z.id = (select max(o.id) from odds o where o.gameid = g.id and o.oddtypeid = 0 )) as host_loses_odd,
(select z.value from odds z where z.id = (select max(o.id) from odds o where o.gameid = g.id and o.oddtypeid = 1 )) as host_wins_odd,
(select z.value from odds z where z.id = (select max(o.id) from odds o where o.gameid = g.id and o.oddtypeid = 2 )) as draw_odd
from
games g where g.id not in (select gameid from score) order by matchtime asc) WHERE ROWNUM <= 10;
/














CREATE VIEW VIEW_H AS

SELECT x.name, max(o.value) as maximum FROM
    (SELECT t.id as team_id, t.name, g.id as match_id, g.matchtime, g.hostid, g.guestid FROM teams t left join games g on g.hostid = t.id UNION
    SELECT t.id as team_id, t.name, g.id as match_id, g.matchtime, g.hostid, g.guestid FROM teams t left join games g on g.guestid = t.id) x
JOIN odds o ON o.gameid = x.match_id WHERE 
(x.team_id = x.hostid AND o.oddtypeid = 1) OR 
(x.team_id = x.guestid AND o.oddtypeid = 0)
GROUP BY x.name;
/













CREATE VIEW VIEW_I AS

select * from (
    select users1.id, users1.name, sum(amountineuro * odds.value) as total_prizes from users users1
    join bets on bets.userid = users1.id
    join odds on odds.id = bets.oddid
    where bets.id in (
        select bets.id from bets
        join odds on odds.id = bets.oddid
        join games on games.id = odds.gameid
        join score on score.gameid = games.id
        where ((score.hostscore=score.guestscore and odds.oddtypeid=2) or
        (score.hostscore>score.guestscore and odds.oddtypeid=1) or
        (score.hostscore<score.guestscore and odds.oddtypeid=0)) and
        extract (year from bets.time) >= 2020) and users1.id in (
            select bets.userid from bets
            join odds on odds.id = bets.oddid
            where extract (year from bets.time) >= 2020
            having (count(odds.gameid) / (select count(*) from games where extract (year from matchtime) >= 2020)) > 0.1
            group by bets.userid)
    group by users1.id, users1.name
    having sum(amountineuro * odds.value) > (
        select sum(amountineuro) from users users2
        join bets on bets.userid = users2.id
        where users1.id = users2.id and bets.id in (
            select bets.id from bets
            join odds on odds.id = bets.oddid
            join games on games.id = odds.gameid
            join score on score.gameid = games.id
            where ((score.hostscore=score.guestscore and odds.oddtypeid!=2) or
            (score.hostscore>score.guestscore and odds.oddtypeid!=1) or
            (score.hostscore<score.guestscore and odds.oddtypeid!=0)) and
            extract (year from bets.time) >= 2020))
    order by total_prizes desc)
where rownum <= 10;
/












--Arkadiusz Zasina
-- Highest average value of bet in each phase of the tournament
CREATE VIEW VISTA_J_a2019156579 AS 
SELECT pt.name as week, MAX(x.avgpermatch) as maximum_average_bet_per_match  
FROM (SELECT AVG(b.amountineuro) as avgpermatch, g.id as gameid FROM bets b JOIN odds o ON b.oddid =o.id JOIN games g ON o.gameid = g.id GROUP BY g.id) x 
JOIN games g ON x.gameid = g.id JOIN phase p ON g.phaseid = p.id
JOIN phasetypes pt ON pt.id = p.phasetype GROUP BY pt.name ORDER BY maximum_average_bet_per_match desc;
/








--Michał Suliborski 
-- Sum and amount of bets in each phase of the tournament 
CREATE VIEW VISTA_J_a2019156841 AS 
select phasetypes.name, sum(amountineuro) as sum_of_all_bets, count(bets.id) as amount_of_all_bets from phasetypes
join games on games.phaseid = phasetypes.id
join odds on odds.gameid = games.id
join bets on bets.oddid = odds.id
group by phasetypes.name
order by sum_of_all_bets desc;
/






--Emilia Markowska
-- Shows the number of bets in favour of the teams descending, this way we can see who is the most probable to win the game according to the bettors
CREATE VIEW VISTA_J_a2019156689 AS 
select teams.name, (onHostTable.onHosts + onGuestTable.onGuests) as total_bets_in_favour
from
(select hostid, count(onWhom) as onHosts
from
(
select bets.id, bets.oddid, odds.gameid, odds.oddtypeid, games.hostid, games.guestid,
case 
when odds.oddtypeid = 0 then 'For host'
when odds.oddtypeid = 1 then 'For guest'
end onWhom
from bets
inner join odds
on bets.oddid=odds.id
inner join games
on odds.gameid = games.id)
where onWhom is not null
and onWhom='For host'
group by hostid) onHostTable
inner join
(select guestid, count(onWhom) as onGuests
from
(
select bets.id, bets.oddid, odds.gameid, odds.oddtypeid, games.hostid, games.guestid,
case 
when odds.oddtypeid = 0 then 'For host'
when odds.oddtypeid = 1 then 'For guest'
end onWhom
from bets
inner join odds
on bets.oddid=odds.id
inner join games
on odds.gameid = games.id)
where onWhom is not null
and onWhom='For guest'
group by guestid) onGuestTable
on onHostTable.hostid=onGuestTable.guestid
inner join teams
on onHostTable.hostid = teams.id
order by total_bets_in_favour desc;
/












--Arkadiusz Zasina
-- Win to lose ratio for each team in games played on not home stadium
CREATE VIEW VISTA_K_a2019156579 AS 
SELECT x.team_id, x.wins/y.loses as wins_to_loses FROM

(SELECT team_id, COUNT(*) as wins FROM (SELECT t.id as team_id, t.name, g.id as match_id, g.matchtime, g.hostid, g.guestid, g.stadiumid as game_stadium, t.stadiumid as team_stadium 
FROM teams t left join games g on g.hostid = t.id UNION
    SELECT t.id as team_id, t.name, g.id as match_id, g.matchtime, g.hostid, g.guestid, g.stadiumid as game_stadium, t.stadiumid as team_stadium 
FROM teams t left join games g on g.guestid = t.id)
JOIN score s ON match_id = s.gameid
WHERE game_stadium != team_stadium
AND ((team_id = hostid AND s.hostscore > s.guestscore) OR 
(team_id = guestid AND s.hostscore < s.guestscore)) GROUP BY team_id) x

JOIN 

(SELECT team_id, COUNT(*) as loses FROM (SELECT t.id as team_id, t.name, g.id as match_id, g.matchtime, g.hostid, g.guestid, g.stadiumid as game_stadium, t.stadiumid as team_stadium 
FROM teams t left join games g on g.hostid = t.id UNION
    SELECT t.id as team_id, t.name, g.id as match_id, g.matchtime, g.hostid, g.guestid, g.stadiumid as game_stadium, t.stadiumid as team_stadium 
FROM teams t left join games g on g.guestid = t.id)
JOIN score s ON match_id = s.gameid
WHERE game_stadium != team_stadium
AND ((team_id = hostid AND s.hostscore < s.guestscore) OR 
(team_id = guestid AND s.hostscore > s.guestscore)) GROUP BY team_id) y

ON x.team_id = y.team_id ORDER BY wins_to_loses desc;
/



--Michał Suliborski 
-- Amount of goals for each team scored in the tournament in the whole season
CREATE VIEW VISTA_K_a2019156841 AS 
select teams.name, (hosttable.score_sum + guesttable.score_sum) as season_score from (
    select hostid as teamid, sum(hostscore) as score_sum from score
    join games on games.id = score.gameid
    group by hostid) hosttable
join teams on teams.id = hosttable.teamid
inner join (
    select guestid as teamid, sum(guestscore) as score_sum from score
    join games on games.id = score.gameid
    group by guestid) guesttable
on hosttable.teamid = guesttable.teamid
order by season_score desc;
/

-- Emilia Markowska
-- Shows the game or games with the biggest difference between scores of teams, this way we can see one of the strongest teams and one of the weakest teams
CREATE VIEW VISTA_K_a2019156689 AS

select id as game_id_with_the_biggest_score_difference, TO_CHAR(matchtime, 'DD-MM-YYYY HH24:MI') as date_of_match,
CASE
WHEN  hostscore > guestscore THEN Concat(Concat(Concat(Concat(CONCAT(CONCAT(hostName, ' won with '),  guestName), ' '), hostscore), ' : '), guestscore)
WHEN  hostscore < guestscore THEN Concat(Concat(Concat(Concat(CONCAT(CONCAT(guestName, ' won with '),  hostName), ' '), guestscore), ' : '), hostscore)
END as result_Of_Match from
(select tempTable2.id, tempTable2.matchtime, tempTable2.hostName, teams.name as guestName, tempTable2.hostscore, tempTable2.guestscore
from
(select tempTable.id, tempTable.matchtime, teams.name as hostName, tempTable.guestid, tempTable.hostscore, tempTable.guestscore from

(select gameTable.id, gameTable.matchtime, gameTable.hostid, gameTable.guestid, scoreTable.hostscore, scoreTable.guestscore 
from
(select id, matchtime, hostid, guestid from games
where id in
((select gameid from score 
where abs(hostscore - guestscore) =
(select max(abs(hostscore - guestscore)) from score)))) gameTable

inner join

(select gameid, hostscore, guestscore 
from score
where gameid in 
((select gameid from score 
where abs(hostscore - guestscore) =
(select max(abs(hostscore - guestscore)) from score)))) scoreTable

on gameTable.id = scoreTable.gameid) tempTable
inner join teams
on teams.id = tempTable.hostid) tempTable2
inner join teams
on tempTable2.guestid = teams.id) ;
/














