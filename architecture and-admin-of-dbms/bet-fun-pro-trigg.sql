
-- a) Create the nGoals function, which receives as argument the code of a game and the name of a team and which
-- returns the number of goals scored by that team in that game. The function can throw the following exceptions: -20502 e -20501.

create or replace function nGoals
(IdGame number, IdTeam number)
return number
is
v_team_id number;
v_game_id number;
v_score number;
error_code number;
begin

error_code := -20501;

select id
into v_team_id
from teams
where id = IdTeam;

error_code := -20502;

select id
into v_game_id
from games
where id = IdGame;

error_code := 1;

select score
into v_score
from
(select games.id as gameid, games.hostid as teamid, score.hostscore as score
from games, score
where games.id = score.id

union

select games.id, games.guestid, score.guestscore
from games, score
where games.id = score.id)
where gameid = IdGame and teamid = IdTeam;

return v_score;

exception
    when no_data_found then
    if error_code = -20501 then
        Raise_application_error(-20501, 'team' || v_team_id ||'does not exist');
    elsif error_code = -20502 then
        Raise_application_error(-20502, 'game' || v_game_id ||  'does not exist');
    elsif error_code = 1 then
        Raise_application_error(-20500, 'no such team with id' || v_team_id || 'in the game with id ' ||  v_game_id);
    end if;
    return -1;

end nGoals;
/


-- b) Create the nGamesBetweenTeams function, which receives as argument the name of two teams (the visited team
-- and the visiting team) and optionally the number of years (lastNYears), by default should consider 5 years,
-- and which returns the number of games that occurred between those 2 teams in the last last lastNYears years.
-- The function can release the following exceptions: -20501 e -20510.

create or replace function nGamesBetweenTeams
(teamA varchar,teamB varchar, lastNYears number default 5)
return number
is
v_teamA varchar(50);
v_teamB varchar(50);
v_checked_team varchar(50);
v_games_played number;
error_code number;
begin

if lastNYears <= 0 then
    Raise_application_error(-20510, 'Years less than 0');
end if;


error_code := -20501;
v_checked_team := teamA;

select name
into v_teamA
from teams
where name = teamA;

v_checked_team := teamB;

select name
into v_teamA
from teams
where name = teamB;

select count(id)
into v_games_played
from score
where id in
(select id from games
where hostid in
(select id from teams
where name = teamA)
and guestid in
(select id from teams
where name = teamB)
and matchtime >= add_months(matchtime,-12 * lastNYears));

return v_games_played;


exception
when no_data_found then
 if error_code = -20501 then
    Raise_application_error(-20501, 'Team ' || v_checked_team || ' does not exist');
 end if;
 return -1;

end nGamesBetweenTeams;
/


-- c) Create the gameDiffGoals function, which receives as argument the identifier of a game and returns the difference
-- between the goals scored by the visited team and the visiting team. The function can launch the following exceptions: -20502.

create or replace function gameDiffGoals(vIdGame Number)
return number is
    error_code number;
    v_diff number;
    v_game games%rowtype;

begin
    error_code := -20502;
    select * into v_game from games where id = vIdGame;

    select abs(hostscore - guestscore) into v_diff from score
    where gameid = vIdGame;
    return v_diff;

exception
    when no_data_found then
        if error_code = -20502 then
             Raise_application_error(-20502, 'Game does not exist');
        end if;
end;
/


-- d) Create the lastJourney function, which receives as argument the name of a competition and returns the identifier
-- of the last occurred (realized) journey of that competition, that is, whose journey date is inferior to the current one.
-- The function can post the following exceptions: -20505 e -20511.

create or replace function lastPhase
(competitionName varchar)
return number
is
v_competition_name varchar(50);
v_phase_id number;
error_code number;
begin

error_code := -20505;

select name
into v_competition_name
from tournaments
where name = competitionName;

error_code := -20511;

select id
into v_phase_id
from phase
where tournamentID
in (select id
from tournaments where name = competitionName)
and id in
(select phaseid
from games
where id in
(select gameid
from score)
and matchtime =
(select max(matchtime) from games
where id in (select gameid from score)));

return v_phase_id;

exception
when no_data_found then
if error_code = -20505 then
    Raise_application_error(-20505, 'Contest ' || competitionName || ' does not exist');
elsif error_code = -20511 then
    Raise_application_error(-20511, 'There is no accomplished phase of the competition ' || competitionName);
end if;

end lastPhase;
/


-- e) Create the new_game procedure that, receives the name of the two teams (the visited team and the visitor),
-- and the time of the game (date and time) and the competition and records that game. The game must be associated
-- with the respective match day (determined by date). The procedure can throw the following exceptions: -20501, -20505, -20512 e -20513.

create or replace procedure new_game(teamA varchar, teamB varchar, dateTime timestamp, competitionName varchar)
is
error_code number;
v_teamA varchar(50);
v_teamB varchar(50);
v_checkedTeam varchar(50);
v_Competition varchar(50);
v_competitionStart timestamp;
v_competitionEnd timestamp;
v_phase_id number;
v_games_count number;
begin

error_code := -20501;
v_checkedTeam := teamA;

select name
into v_teamA
from teams
where name = teamA;

v_checkedTeam := teamB;

select name
into v_teamB
from teams
where name = teamB;

error_code := -20505;

select name
into v_Competition
from tournaments
where name = competitionName;

select min(startdate)
into v_competitionStart
from phase
where tournamentid in
(select id
from tournaments
where name = competitionName
);

select max(enddate)
into v_competitionEnd
from phase
where tournamentid in
(select id
from tournaments
where name = competitionName
);

error_code := -20512;

select id
into v_phase_id
from phase
where dateTime >= startdate and dateTime <= enddate
and tournamentid in (
select id
from tournaments
where name = competitionName
);

select count(id)
into v_games_count
from games
where hostid in
(select id
from teams
where name = teamA
)
and guestid in
(select id
from teams
where name = teamB
)
and phaseid = v_phase_id;

if v_games_count <>  0 then
    Raise_application_error(-20513, 'Game between ' || teamA || ' and ' || teamB || ' was already played in phase ' || v_phase_id || ' in tournament '|| competitionName);
end if;

insert into games(matchtime, hostid, guestid, stadiumid, phaseid)
values(dateTime, getTeamID(teamA), getTeamID(teamB), 0, v_phase_id);

exception
when no_data_found then
if error_code = -20501 then
    Raise_application_error(-20501, 'Team with name ' || v_checkedteam || ' does not exist');
elsif error_code = -20505 then
    Raise_application_error(-20505, 'Tournament with name ' || competitionName || ' does not exist');
elsif error_code = -20512 then
     Raise_application_error(-20512, 'There is no phase for the tournament in a given time');

end if;

end new_game;
/


-- f) Create the procedure defines_starter_odds_21a that, receives the name of the two teams (the visited team and the visitor),
-- and the time of the game (date and time) and defines the starting odds of that game according to the historical
-- information (defined in section 2.1.a) ). The procedure can throw the following exceptions: - 20501, -20502 e -20514.

create or replace procedure sets_odds_initial_21b(teamA varchar, teamB varchar, dateHora date) is
    v_tax number(10,3) := 0.3;

    error_code number;

    v_odd_host_losts_guest_wins_1 number(10,3);
    v_odd_host_win_guest_losts_1 number(10,3);
    v_odd_draws_1 number(10,3);
    v_prob_host_win_guest_losts_1 number(10,3);
    v_prob_host_losts_guest_wins_1 number(10,3);
    v_prob_draws_1 number(10,3);

    teams_games_tg number(10,3);
    teams_draws_tg number(10,3);
    host_wins_guest_losts_tg number(10,3);
    host_losts_guest_wins_tg number(10,3);
    v_id_host number;
    v_id_guest number;

    v_game games%rowtype;
begin
    error_code = -20501;
    select id into v_id_host from teams where name = teamA;
    select id into v_id_guest from teams where name = teamB;

    error_code = -20502;
    select * into v_game from games where hostid = v_id_host and guestid = v_id_guest and matchtime = dateHora;

    select count(*) into teams_games_tg from games
    where hostid = v_game.hostid and guestid = v_game.guestid and games.matchtime < v_game.matchtime;

    select count(*) into teams_draws_tg from games
    join score on games.id = score.gameid
    where hostid = v_game.hostid and guestid = v_game.guestid and games.matchtime < v_game.matchtime and
    score.hostscore = score.guestscore;

    select count(*) into host_wins_guest_losts_tg from games
    join score on games.id = score.gameid
    where hostid = v_game.hostid and guestid = v_game.guestid and games.matchtime < v_game.matchtime and
    score.hostscore > score.guestscore;

    host_losts_guest_wins_tg := teams_games_tg - (teams_draws_tg + host_wins_guest_losts_tg);

    if teams_games_tg = 0 then
        v_prob_host_win_guest_losts_1 := 0.333;
        v_prob_host_losts_guest_wins_1 := 0.333;
        v_prob_draws_1 := 0.333;
    else
        v_prob_host_win_guest_losts_1 := host_wins_guest_losts_tg / teams_games_tg;
        v_prob_host_losts_guest_wins_1 := host_losts_guest_wins_tg / teams_games_tg;
        v_prob_draws_1 := teams_draws_tg / teams_games_tg;
    end if;

    if v_prob_host_win_guest_losts_1 < 0.03 then v_prob_host_win_guest_losts_1 := 0.03; end if;
    if v_prob_host_losts_guest_wins_1 < 0.03 then v_prob_host_losts_guest_wins_1 := 0.03; end if;
    if v_prob_draws_1 < 0.03 then v_prob_draws_1 := 0.03; end if;

    v_odd_host_losts_guest_wins_1 := 1/v_prob_host_losts_guest_wins_1 * (1 - v_tax);
    v_odd_host_win_guest_losts_1 := 1/v_prob_host_win_guest_losts_1 * (1 - v_tax);
    v_odd_draws_1 := 1/v_prob_draws_1 * (1 - v_tax);

    insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_losts_guest_wins_1, v_game.matchtime, v_game.id, 0);
    insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_win_guest_losts_1, v_game.matchtime, v_game.id, 1);
    insert into odds (value, time, gameid, oddtypeid) values (v_odd_draws_1, v_game.matchtime, v_game.id, 2);

exception
    when no_data_found then
    if error_code = -20501 then
        Raise_application_error(-20501, 'Team with name does not exist');
    elsif error_code = -20502 then
        Raise_application_error(-20502, 'Game does not exist');
    end if;
end;
/


-- g) Create the payBets procedure, which receives the identifier of a game, and records the payment of all winning bets in that game.
-- The procedure can post the following exceptions: -20502, -205017 e -20518.

create or replace procedure payBets
(v_gameID number)
is
scoreDifference number;
winOddType number;
v_game_check number;
v_bet_check number;
v_is_populated number;
error_code number;
cursor winningBets(winOdd number) is
select bets.id, bets.userid, bets.amountineuro, odds.value
from bets, odds
where bets.oddid in
(select id from odds
where oddtypeid = winOdd
)
and bets.oddid = odds.id;

begin

error_code := -20502;

select id
into v_game_check
from games
where id = v_gameid;

error_code := -20517;

select gameid
into v_game_check
from score
where gameid = v_gameid;

select hostscore - guestscore
into scoreDifference
from score
where gameid = v_gameID;

if scoreDifference < 0 then
winOddType := 0;
elsif scoreDifference > 0 then
winOddType := 1;
else winOddType := 2;
end if;

for bet in winningBets(winOddType)
loop

    select count(id)
    into v_is_populated
    from winners
    where betid = bet.id
    and userid = bet.userid;

    if v_is_populated <> 0 then
        select isPaid
        into v_bet_check
        from winners
        where betid = bet.id
        and userid = bet.userid;
    end if;

    if v_bet_check = 0 or v_is_populated = 0 then

        insert into winners(betid, userid)
        values(bet.id, bet.userid);

        update users
        set balance = balance + bet.amountineuro * bet.value
        where id = bet.userid;

        update winners
        set isPaid = 1
        where betid = bet.id
        and userid = bet.userid;

    elsif v_bet_check = 1 then
        Raise_application_error(-20518, 'Bet with id ' || bet.id || ' is already paid');
    end if;

end loop;

exception
when no_data_found then
if error_code = -20502 then
    Raise_application_error(-20502, 'Game with id ' || v_gameID || ' does not exist');
elsif error_code = -20517 then
    Raise_application_error(-20517, 'Game with id ' || v_gameID || ' not played yet');
end if;

end payBets;
/


-- h) Create the nGameEvents function that, receives the code of a game, the code of a team and the type of event
-- that can happen in a game, and returns the number of such events that happened in that game by that team.
-- Ex. the number of goals the team scored in that game. The function can throw the following exceptions: -20501, -20502 e -20515.

create or replace function nGameEvents
(vIDgame NUMBER, vIDTeam number, vIdEventType NUMBER )
return number
is
error_code number;
v_game_check number;
v_team_check number;
v_event_type_check number;
v_event_number number;
begin

error_code := -20501;

select id
into v_team_check
from teams
where id = vIDTeam;

error_code := -20502;

select id
into v_game_check
from games
where id = vIDgame;


error_code := -20515;
select id
into v_event_type_check
from eventtypes
where id = vIdEventType;

select count(id)
into v_event_number
from gameevents
where gameid = vIDgame
and teamid = vIDTeam
and eventtypeid = vIdEventType;

return v_event_number;

exception
when no_data_found then
    if error_code = -20501 then
        Raise_application_error(-20501, 'Team with id ' || vIDTeam || ' team does not exist');
    elsif error_code = -20502 then
         Raise_application_error(-20502, 'Game with id ' || vIDgame || ' team does not exist');
    elsif error_code = -20515 then
         Raise_application_error(-20515, 'Event type with id ' || vIdEventType || ' team does not exist');
    end if;
    return -1;

end nGameEvents;
/


-- i) Create the placeBet procedure, which receives the code from a user/poster, the identifier of a game,
-- the type of bet and the amount of the bet and registers that bet. The minimum stake value is 1. The procedure can post the following exceptions: -20503, -20502, -20506, -20507, -20508, -20509 e -20516.

e6create or replace procedure placeBet(vIdUser NUMBER,vIdGame NUMBER,vIdOddType NUMBER,valueOfBet NUMBER) is
    v_max_odds_id number(10,3) := 0;
    error_code number;
    v_tax number(10,3) := 0.3;
    v_random number(10,3);
    v_all_bets_value number(10,3);
    c_counter_premio_resultado_0 number(10,3) := 0;
    c_counter_premio_resultado_1 number(10,3) := 0;
    c_counter_premio_resultado_2 number(10,3) := 0;
    c_max_premios number(10) := 999999;

    v_odd_host_losts_guest_wins_1 number(10,3);
    v_odd_host_win_guest_losts_1 number(10,3);
    v_odd_draws_1 number(10,3);

    v_game games%rowtype;

    v_odds_value number;

    user_balance number;

    cursor c_bets (p_game_id number, p_odd_type number) is
    select * from bets
    join odds on odds.id = bets.oddid
    where gameid = p_game_id and odds.oddtypeid = p_odd_type;
begin
    error_code := -20502;
    select * into v_game from games where id = vIdGame;

    error_code := -20506;
    if vIdOddType <> 0 and vIdOddType <> 1 and vIdOddType <> 2 and vIdOddType <> 3 and vIdOddType <> 4 and vIdOddType <> 5 then
        raise_application_error(-20506, 'Wrong odd type');
    end if;

    error_code := -20508;
    select balance into user_balance from users
    where id = vIdUser;
    if user_balance - valueOfBet < 0 then
        raise_application_error(-20508, 'Not enough money to place bet');
    end if;

    error_code := -20516;
    if valueOfBet < 1 then
        raise_application_error(-20516, 'Minimum value of the bet is 1');
    end if;
    select max(id) into v_max_odds_id from odds where oddtypeid = vIdOddType and gameid = v_game.id;

    -- v_random := dbms_random.value(1,10);
    insert into bets (amountineuro, time, userid, oddid) values (valueOfBet, TO_TIMESTAMP(CURRENT_TIMESTAMP, 'DD/MM/YYYY HH24:MI'), vIdUser, v_max_odds_id); --v_game.matchtime + interval '15' minute * v_random - interval '1' day


    -- part of update_odds trigger @@@@@@@@@@@@
    select sum(value) into v_all_bets_value from bets join odds on odds.id = bets.oddid where odds.gameid = v_game.id;

    for v_c_bets in c_bets(v_game.id, 0) loop
        c_counter_premio_resultado_0 := c_counter_premio_resultado_0 + v_c_bets.amountineuro * v_c_bets.value;
    end loop;
    if c_counter_premio_resultado_0 = 0 then c_counter_premio_resultado_0 := 15; end if;

    for v_c_bets in c_bets(v_game.id, 1) loop
        c_counter_premio_resultado_1 := c_counter_premio_resultado_1 + v_c_bets.amountineuro * v_c_bets.value;
    end loop;
    if c_counter_premio_resultado_1 = 0 then c_counter_premio_resultado_1 := 15; end if;

    for v_c_bets in c_bets(v_game.id, 2) loop
        c_counter_premio_resultado_2 := c_counter_premio_resultado_2 + v_c_bets.amountineuro * v_c_bets.value;
    end loop;
    if c_counter_premio_resultado_2 = 0 then c_counter_premio_resultado_2 := 15; end if;

    if v_all_bets_value >= 100 or valueOfBet >= v_all_bets_value*0.02 or (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) >= c_max_premios then
        select sum(amountineuro) * (1 - v_tax) into c_max_premios from bets
        join odds on bets.oddid = odds.id
        where odds.gameid = v_game.id;

        v_odd_host_losts_guest_wins_1 := (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) / least(c_counter_premio_resultado_0, c_max_premios);
        v_odd_host_win_guest_losts_1 := (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) / least(c_counter_premio_resultado_1, c_max_premios);
        v_odd_draws_1 := (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) / least(c_counter_premio_resultado_2, c_max_premios);

        insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_losts_guest_wins_1,  TO_TIMESTAMP(CURRENT_TIMESTAMP, 'DD/MM/YYYY HH24:MI'), v_game.id, 0); -- v_game.matchtime + interval '15' minute * v_random - interval '1' day,
        insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_win_guest_losts_1,  TO_TIMESTAMP(CURRENT_TIMESTAMP, 'DD/MM/YYYY HH24:MI'), v_game.id, 1); -- v_game.matchtime + interval '15' minute * v_random - interval '1' day,
        insert into odds (value, time, gameid, oddtypeid) values (v_odd_draws_1,  TO_TIMESTAMP(CURRENT_TIMESTAMP, 'DD/MM/YYYY HH24:MI'), v_game.id, 2); -- v_game.matchtime + interval '15' minute * v_random - interval '1' day,
    end if;


    -- part of update_saldo_user trigger @@@@@@@@@@@@@@@
    select value into v_odds_value from odds
    where id = (select max(id) from odds where oddtypeid = vIdOddType and gameid = v_game.id);

    update bets
    set potencialwin = valueOfBet * v_odds_value
    where id = (select max(id) from bets);

exception
    when no_data_found then
        if error_code = -20502 then
             Raise_application_error(-20502, 'Game with id ' || vIDgame || ' team does not exist');
        end if;
end;
/


-- j) Create a prize_update_matchj) trigger which when a winning bet is registered updates (increments) that player's account balance with the prize amount.

create or replace trigger update_prize
after insert on winners
for each row
declare
prize number;
v_userid number;
v_betid number;
begin

v_userid := :new.userid;
v_betid := :new.betid;

select (bets.amountineuro * odds.value)
into prize
from bets, odds
where bets.oddid = odds.id
and bets.id = v_betid
and bets.userid = v_userid;


update users
set balance = balance + prize
where id = v_userid;

end;
/


-- k) Create a trigger update_bet that when a bet is registered, updates (decreases) the player account balance with the bet amount.

create or replace trigger update_saldo_bet
after insert on bets
for each row
declare
begin
    update users
    set balance = balance - :new.amountineuro
    where id = :new.userid;
end;
/


-- l) Create a trigger fillBet that when a gambler registers a bet, indicating the game, the type of bet and the amount of that bet, it fills in the missing information,
-- namely the date of registration of that bet, the current value of the odd and the potential win of the bet.

create or replace trigger update_saldo_user
after insert on bets
for each row
declare
begin
    dbms_output.put_line('update_saldo_user: this trigger should be compound trigger, otherwise it will not work. Since our database does not support it, actions of this trigger are performed in placeBet procedure');
end;
/

-- m) Create the trigger update_odds which after the registration of a bet, checks and, if necessary, recalculates the odds value of that game (see section 2.2).

create or replace trigger update_odds
after insert on bets
for each row
declare
begin
    dbms_output.put_line('update_odds: this trigger should be compound trigger, otherwise it will not work. Since our database does not support it, actions of this trigger are performed in placeBet procedure');
end;
/

-- n) Each element of the group must create a role, with the format func_n_student , that it considers relevant,
-- justifying its relevance. The relevance and level of complexity will strongly influence its assessment. E.g.

-- FUNCTION FUNCT_A2018xxxx (emila)

create or replace function getTheMostEffectiveTeam
return varchar
is
v_team number;
begin

select team
into v_team
from
(select team, sum(score)
from
(select games.hostid as team, score.hostscore as score
from games, score
where games.id = score.gameid

union

select games.guestid, score.guestscore
from games, score
where games.id = score.gameid)
group by team
order by sum(score) desc)
where rownum = 1;

return getTeamName(v_team);


end getTheMostEffectiveTeam;
/

-- FUNCTION FUNCT_A2018xxxx (arek)

create or replace function getWins
(teamName varchar)
return number
is
total_wins number;
v_team_check varchar(50);
v_teamID number;

begin

v_teamID := getTeamID(teamName);

select name
into v_team_check
from teams
where name = teamName;

select sum(wonNumber)
into total_wins
from
(select count(gameid) as wonNumber
from score
where hostscore > guestscore
and gameid in
(select id from games
where hostid = v_teamID)

union

select count(gameid)
from score
where hostscore < guestscore
and gameid in
(select id from games
where guestid = v_teamID
));

return total_wins;

exception
when no_data_found then
    Raise_application_error(-20501, 'Team ' || teamName || ' does not exist ');
    return -1;
end getWins;
/

-- FUNCTION FUNCT_A2018xxxx (michal)

create or replace function getTotalPlacedMoney(p_game_id number)
return number is
    error_code number;
    v_game games%rowtype;
    v_sum_of_bets number;
begin
    error_code := -20502;
    select * into v_game from games where id = p_game_id;

    select sum(bets.amountineuro) into v_sum_of_bets from bets
    join odds on bets.oddid = odds.id
    join games on odds.gameid = games.id
    where games.id = p_game_id;

    return v_sum_of_bets;
exception
    when no_data_found then
        if error_code = -20502 then
             Raise_application_error(-20502, 'Game does not exist');
        end if;
end;
/

-- o) Each element of the group must create a procedure, with the format proc_ n_student , that it considers relevant,
-- justifying its relevance. The relevance and level of complexity will strongly influence its evaluation. E.g.

-- PROCEDURE PROC_A2018xxxx (emila):

create or replace function getStadiumName
(stadiumid number)
return varchar
is
v_stadium varchar(50);
begin

select name
into v_stadium
from stadiums
where id = stadiumid;

return v_stadium;
end getStadiumName;
/
create or replace function getTeamName
(teamid number)
return varchar
is
v_team varchar(50);
begin

select name
into v_team
from teams
where id = teamid;

return v_team;
end getTeamName;
/
create or replace procedure getTeamsHistory
(teamA varchar, teamB varchar)
is
teamAid number;
teamBid number;
teamAwins number := 0;
teamBwins number := 0;
totalGoalsA number := 0;
totalGoalsB number := 0;
draws number := 0;

cursor gamesPlayed is
select * from
(select games.id, games.matchtime, games.hostid, games.guestid, games.phaseid, score.hostscore, score.guestscore, games.stadiumid
from games, score
where games.id = score.gameid
and games.hostid = getTeamID(teamA) and games.guestid = getTeamID(teamB)

union

select games.id, games.matchtime, games.hostid, games.guestid, games.phaseid, score.hostscore, score.guestscore, games.stadiumid
from games, score
where games.id = score.gameid
and games.hostid = getTeamID(teamB) and games.guestid = getTeamID(teamA))
order by matchtime;

begin

teamAid := getTeamID(teamA);
teamBid := getTeamID(teamB);

DBMS_OUTPUT.PUT_LINE('History of games between teams ' || teamA || ' and ' || teamB );

for game in gamesPlayed
loop
    if teamAid = game.hostid then
        totalGoalsA := totalGoalsA + game.hostscore;
        totalGoalsB := totalGoalsB + game.guestscore;
        if game.hostscore > game.guestscore then
            teamAwins := teamAwins + 1;
        elsif game.hostscore < game.guestscore then
            teamBwins := teamBwins + 1;
        else
            draws := draws + 1;
        end if;
    elsif teamBid = game.hostid then
        totalGoalsA := totalGoalsA + game.guestscore;
        totalGoalsB := totalGoalsB + game.hostscore;
        if game.hostscore > game.guestscore then
            teamBwins := teamBwins + 1;
        elsif game.hostscore < game.guestscore then
            teamAwins := teamAwins + 1;
        else
            draws := draws + 1;
        end if;
    end if;

    DBMS_OUTPUT.PUT_LINE('Date: ' || game.matchtime  || ' Stadium: ' || getStadiumName(game.stadiumid) || ' Phase: ' || game.phaseid);
    DBMS_OUTPUT.PUT_LINE('Host: ' || getTeamName(game.hostid) || ' Guest: ' || getTeamName(game.guestid));
    DBMS_OUTPUT.PUT_LINE('Score: ' || getTeamName(game.hostid) || ' ' || game.hostscore || ' : ' || game.guestscore || ' ' || getTeamName(game.guestID));
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------');

end loop;
    DBMS_OUTPUT.PUT_LINE('Summary: ' );
    DBMS_OUTPUT.PUT_LINE('Team A stats: ' );
    DBMS_OUTPUT.PUT_LINE('Wins: ' || teamAwins || ' Losts: ' || teamBwins || ' Draws: ' || draws || ' Total goals: ' || totalGoalsA);
    DBMS_OUTPUT.PUT_LINE('Team B stats: ' );
    DBMS_OUTPUT.PUT_LINE('Wins: ' || teamBwins || ' Losts: ' || teamAwins || ' Draws: ' || draws || ' Total goals: ' || totalGoalsB);
end getTeamsHistory;
/


-- PROCEDURE PROC_A2018xxxx (arek):

create or replace procedure insertGoals
(v_gameid number)
is
counter number;
error_code number;
v_game_check number;

cursor playedGames
is
select games.id as gameid, games.hostid as teamid, games.matchtime, score.hostscore as score
from games, score
where games.id = score.gameid
and games.id = v_gameid

union

select games.id, games.guestid, games.matchtime, score.guestscore
from games, score
where games.id = score.gameid
and games.id = v_gameid;

begin

error_code := -20502;

select id
into v_game_check
from games
where id = v_gameid;


error_code := -20520;

select gameid
into v_game_check
from score
where gameid = v_gameid;

for team in playedGames
loop
counter := 0;

    while counter < team.score
    loop
        insert into gameevents(time, gameid, eventtypeid, teamid)
        values(team.matchtime, team.gameid, 4, team.teamid);
        counter := counter + 1;
    end loop;
end loop;

exception
when no_data_found then
    if error_code = -20502 then
        Raise_application_error(-20502, 'Game with id ' || v_gameid || ' does not exist');
    elsif error_code = -20520 then
        Raise_application_error(-20520, 'Game with id ' || v_gameid || ' not played yet');
    end if;


end insertGoals;
/


-- PROCEDURE PROC_A2018xxxx (michal):

create or replace procedure createTournament(p_discipline varchar, p_name varchar, p_starttime timestamp, p_endtime timestamp, p_phase_type varchar, p_phase_amount number) is
error_code number;
v_discipline_id number;
v_tournament_id number;
v_phasetype_id number;

begin
    error_code := -20520;

    select id into v_discipline_id from disciplines
    where name = p_discipline;

    insert into tournaments (name, starttime, endtime, disciplineid)
    values(p_name, p_starttime, p_endtime, v_discipline_id)
    returning id into v_tournament_id;

    for i in 1..p_phase_amount loop
        insert into phasetypes(name)
        values(p_phase_type || ' ' || i)
        returning id into v_phasetype_id;

        insert into phase (tournamentid, phasetype)
        values (v_tournament_id, v_phasetype_id);
    end loop;

exception
    when no_data_found then
        if error_code = -20520 then
            Raise_application_error(-20520, 'Discipline ' || p_discipline || ' does not exist');
        end if;

end createTournament;
/


-- p) Each element of the group should create a trigger, with the format trig_ n_student , that it considers relevant,
-- justifying its relevance. The relevance and level of complexity will strongly influence its evaluation. E.g.
-- TRIGGER TRIG_A2018xxxx (emila)

create or replace trigger insert_winners
after insert on score
for each row
declare
v_oddtype number;
cursor winners
(oddtype number)
is
select id from bets
where oddid in
(select id from odds
where oddtypeid = oddtype);

begin

if :new.hostscore - :new.guestscore  < 0 then
    v_oddtype := 0;
elsif :new.hostscore - :new.guestscore  > 0 then
    v_oddtype := 1;
else v_oddtype := 2;
end if;

for bet in winners(v_oddtype)
loop
    insert into winners(betid) values(bet.id);
end loop;

end;
/

-- TRIGGER TRIG_A2018xxxx (arek)

create or replace trigger update_odds_history
after insert on score
for each row
declare
cursor finalodds is

select id, time
from odds
where gameid = :new.gameid
and time in
(select max(time)
from odds where gameid = :new.gameid);

begin

for odd in finalodds
loop
    insert into oddshistory(time, oddid)
    values(odd.time, odd.id);
end loop;
end;
/

-- TRIGGER TRIG_A2018xxxx (michal)

create or replace trigger add_stadion_to_new_game
after insert on games
for each row
declare
    error_code number;
    v_game_check number;
    v_stadium_id number;
begin
    error_code := -20502;

    select id into v_game_check from games
    where id = :new.id;

    select stadiumid into v_stadium_id from teams
    where id = :new.hostid;

    update games set
    stadiumid = v_stadium_id;

exception
when no_data_found then
    if error_code = -20502 then
        Raise_application_error(-20502, 'Game does not exist');
    end if;
end;
/


-- q) Identify the mechanisms necessary to ensure the integrity of the data which are not ensured by restrictions of the DB,
-- including value restrictions (e.g. negative volumes and distances), invalid dates (end before start), ...

-- r) Delivery of the calculation of the physical parameters of the 5 tables of the system, which consider that they will occupy more space.
















-- TEST
-- select * from games order by id desc;
-- execute new_game('Ferreira', 'Sporting', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), 25, 10);
--
--
-- select * from odds order by id desc;
-- execute sets_odds_initial_21b('Ferreira', 'Sporting', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'));
--
--
-- select * from bets order by id desc;
-- execute placeBet(2, 301, 2, 15);
-- execute placeBet(2, 301, 1, 15);
-- execute placeBet(2, 301, 0, 15);

-- select * from odds order by id asc;
-- select * from bets order by id asc;

-- begin delete from bets; delete from odds; end;
























