
create table users(
 id      number(10) not null ,
 name    varchar2(20) not null ,
 balance number(10) not null ,
 constraint pk_users primary key (id)
);




create table stadiums(
 id   number(10) not null ,
 name nvarchar2(100) not null ,
 constraint pk_stadium primary key (id)
);



create table teams(
 id        number(10) not null ,
 name      nvarchar2(40) not null ,
 stadiumid number(10) not null ,
 constraint pk_team primary key (id),
 constraint fk_stadium foreign key (stadiumid)  references stadiums(id)
);




create table disciplines (
 id   number(10) not null ,
 name varchar2(50) not null ,
 constraint pk_discipine primary key (id)
);



create table tournaments(
 id           number(10) not null ,
 name         varchar2(50) not null ,
 starttime    timestamp(3) not null ,
 endtime      timestamp(3) not null ,
 disciplineid number(10) not null ,
 constraint pk_id_tour primary key (id),
 constraint fk_discipline foreign key (disciplineid)  references disciplines(id),
 constraint check_time check ( starttime <= endtime )
);



create table teamstotournaments(
 tournamentid number(10) not null ,
 teamid       number(10) not null ,
 constraint pk_teamstotournaments primary key (tournamentid, teamid),
 constraint fk_tour foreign key (tournamentid)  references tournaments(id),
 constraint fk_team foreign key (teamid)  references teams(id)
);


create table phasetypes(
 id   number(10) not null ,
 name varchar2(20) not null ,
 constraint pk_phasetype primary key (id)
);


create table phase(
 id           number(10) not null ,
 tournamentid number(10) not null ,
 phasetype    number(10) not null ,
 constraint pk_phase primary key (id),
 constraint fk_tour1 foreign key (tournamentid)  references tournaments(id),
 constraint fk_phasetype foreign key (phasetype)  references phasetypes(id)
);


create table games
(
 id        number(10) not null ,
 matchtime timestamp(3) not null ,
 hostid    number(10) not null ,
 guestid   number(10) not null ,
 stadiumid number(10) not null ,
 phaseid   number(10) not null ,
 constraint pk_game primary key (id),
 constraint fk_stadium1 foreign key (stadiumid)  references stadiums(id),
 constraint fk_phase1 foreign key (phaseid)  references phase(id),
 constraint fk_guest_1 foreign key (guestid)  references teams(id),
 constraint fk_host_1 foreign key (hostid)  references teams(id)
);


create table eventtypes (
 id   number(10) not null ,
 name varchar2(20) not null ,
 constraint pk_eventtype primary key (id)
);


create table gameevents (
 id          number(10) not null ,
 time        timestamp(3) not null ,
 gameid      number(10) not null ,
 eventtypeid number(10) not null ,
 teamid      number(10) not null ,
 constraint pk_gameevent primary key (id),
 constraint fk_eventype foreign key (eventtypeid)  references eventtypes(id),
 constraint fk_team2 foreign key (teamid)  references teams(id),
 constraint fk_gameid1 foreign key (gameid)  references games(id)
);




create table oddtypes(
 id   number(10) not null ,
 name varchar2(20) not null ,
 constraint pk_oddtype primary key (id)
);



create table odds(
 id        number(10) not null ,
 value     float not null ,
 time  timestamp(3) not null ,
 gameid    number(10) not null ,
 oddtypeid number(10) not null ,
 constraint pk_odd primary key (id),
 constraint fk_oddtype2 foreign key (oddtypeid)  references oddtypes(id),
 constraint fk_upgame foreign key (gameid)  references games(id)
);



create table bets (
 id           number(10) not null ,
 amountineuro float not null ,
 time         timestamp(3) not null ,
 userid       number(10) not null ,
 oddid        number(10) not null ,
 constraint pk_bet primary key (id),
 constraint fk_user1 foreign key (userid)  references users(id),
 constraint fk_odd1 foreign key (oddid)  references odds(id),
 constraint amount_check check ( amountineuro > 0 )
);

create table winners(
 id    number(10) not null ,
 betid number(10) not null ,
 constraint pk_winners primary key (id),
 constraint fk_betid foreign key (betid)  references bets(id)
);

create table oddshistory(
 id    number(10) not null ,
 time  timestamp(3) not null ,
 oddid number(10) not null ,
 constraint pk_oddhistory primary key (id),
 constraint fk_odd3 foreign key (oddid)  references odds(id)
);


create table probability(
 team1id   number(10) not null ,
 team2id   number(10) not null ,
 value     float not null ,
 oddtypeid number(10) not null ,
 constraint pk_probability primary key (team1id, team2id),
 constraint fk_oddtype4 foreign key (oddtypeid)  references oddtypes(id),
 constraint fk_team11 foreign key (team1id)  references teams(id),
 constraint fk_team12 foreign key (team2id)  references teams(id)
);



create table score(
 id        number(10) not null ,
 gameid    number(10) not null ,
 matchtime number(10) not null ,
 hostscore number(10) not null,
 guestscore number(10) not null,
 constraint pk_score primary key (id),
 constraint fk_game10 foreign key (gameid)  references games(id)
);


insert into users (id, name, balance) values (0, 'John Smith', 500);
insert into users (id, name, balance) values (1, 'Jesse Robotham', 700);
insert into users (id, name, balance) values (2, 'Natty Pawelec', 500);
insert into users (id, name, balance) values (3, 'Anselm Smieton', 1000);
insert into users (id, name, balance) values (4, 'Yvon Pilmore', 5000);
insert into users (id, name, balance) values (5, 'Cybil Welburn', 500);
insert into users (id, name, balance) values (6, 'Chaddie Leckenby', 3000);
insert into users (id, name, balance) values (7, 'Davis Pool', 1500);
insert into users (id, name, balance) values (8, 'Viviene Kondratenko', 2500);
insert into users (id, name, balance) values (9, 'Madeline Halcro', 100);


insert into stadiums (id, name) values (0, 'Estádio da Mata Real');
insert into stadiums (id, name) values (1, 'Estádio José Alvalade');
insert into stadiums (id, name) values (2, 'Estádio Cidade de Barcelos');
insert into stadiums (id, name) values (3, 'Estádio do Restelo');
insert into stadiums (id, name) values (4, 'Parque de Jogos Comendador Joaquim de Almeida Freitas');
insert into stadiums (id, name) values (5, 'Estádio do Dragão');
insert into stadiums (id, name) values (6, 'Estádio do Bonfim');
insert into stadiums (id, name) values (7, 'Estádio João Cardoso');
insert into stadiums (id, name) values (8, 'Estádio Municipal de Braga');
insert into stadiums (id, name) values (9, 'Estádio Municipal 22 de Junho');
insert into stadiums (id, name) values (10, 'Estádio da Luz');
insert into stadiums (id, name) values (11, 'Estádio de São Miguel');
insert into stadiums (id, name) values (12, 'Estádio D. Afonso Henriques');
insert into stadiums (id, name) values (13, 'Estádio do Marítimo');
insert into stadiums (id, name) values (14, 'Estádio do CD Aves');
insert into stadiums (id, name) values (15, 'Estádio do Bessa');
insert into stadiums (id, name) values (16, 'Estádio dos Arcos');
insert into stadiums (id, name) values (17, 'Estádio Municipal de Portimão');




insert into teams (id, name, stadiumid) values (0, 'Ferreira', 0);
insert into teams (id, name, stadiumid) values (1, 'Sporting', 1);
insert into teams (id, name, stadiumid) values (2, 'Gil Vicente', 2);
insert into teams (id, name, stadiumid) values (3, 'Belenenses', 3);
insert into teams (id, name, stadiumid) values (4, 'Moreirense', 4);
insert into teams (id, name, stadiumid) values (5, 'FC Porto', 5);
insert into teams (id, name, stadiumid) values (6, 'Vitória FC', 6);
insert into teams (id, name, stadiumid) values (7, 'Tondela', 7);
insert into teams (id, name, stadiumid) values (8, 'Braga', 8);
insert into teams (id, name, stadiumid) values (9, 'Famalicao', 9);
insert into teams (id, name, stadiumid) values (10, 'Benfica', 10);
insert into teams (id, name, stadiumid) values (11, 'Santa Clara', 11);
insert into teams (id, name, stadiumid) values (12, 'Vitória SC', 12);
insert into teams (id, name, stadiumid) values (13, 'Maritimo', 13);
insert into teams (id, name, stadiumid) values (14, 'Aves', 14);
insert into teams (id, name, stadiumid) values (15, 'Boavista', 15);
insert into teams (id, name, stadiumid) values (16, 'Rio Ave', 16);
insert into teams (id, name, stadiumid) values (17, 'Portimonense', 17);



insert into disciplines (id, name) values (0, 'Football');
insert into disciplines (id, name) values (1, 'Basketball');
insert into disciplines (id, name) values (2, 'Tennis');
insert into disciplines (id, name) values (3, 'Cricket');
insert into disciplines (id, name) values (4, 'Baseball');
insert into disciplines (id, name) values (5, 'American football');
insert into disciplines (id, name) values (6, 'Boxing');
insert into disciplines (id, name) values (7, 'Ice Hockey');
insert into disciplines (id, name) values (8, 'Volleyball');
insert into disciplines (id, name) values (9, 'Rugby');
insert into disciplines (id, name) values (10, 'Handball');
insert into disciplines (id, name) values (11, 'Table Tennis');
insert into disciplines (id, name) values (12, 'Wrestling');
insert into disciplines (id, name) values (13, 'Fencing');



insert into tournaments (id, name, starttime, endtime, disciplineid) values (0, 'NOS League', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (1, 'Copa del Rey', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (2, 'FA Cup', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (3, 'Africa Cup of Nations', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (4, 'UEFA Europa League', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (5, 'Copa Libertadores', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (6, 'Copa America', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (7, 'UEFA Champions League', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (8, 'LaLiga', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (9, 'Premier League', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (10, 'Serie A', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (11, 'Bundesliga', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);
insert into tournaments (id, name, StartTime, EndTime, DisciplineId) values (12, 'Ligue 1', to_timestamp('01/01/2020','DD/MM/YYYY HH24:MI'), to_timestamp('01/06/2020','DD/MM/YYYY HH24:MI'), 0);



insert into teamstotournaments (tournamentid, teamid) values (0, 0);
insert into teamstotournaments (tournamentid, teamid) values (0, 1);
insert into teamstotournaments (tournamentid, teamid) values (0, 2);
insert into teamstotournaments (tournamentid, teamid) values (0, 3);
insert into teamstotournaments (tournamentid, teamid) values (0, 4);
insert into teamstotournaments (tournamentid, teamid) values (0, 5);
insert into teamstotournaments (tournamentid, teamid) values (0, 6);
insert into teamstotournaments (tournamentid, teamid) values (0, 7);
insert into teamstotournaments (tournamentid, teamid) values (0, 8);
insert into teamstotournaments (tournamentid, teamid) values (0, 9);
insert into teamstotournaments (tournamentid, teamid) values (0, 10);
insert into teamstotournaments (tournamentid, teamid) values (0, 11);
insert into teamstotournaments (tournamentid, teamid) values (0, 12);
insert into teamstotournaments (tournamentid, teamid) values (0, 13);
insert into teamstotournaments (tournamentid, teamid) values (0, 14);
insert into teamstotournaments (tournamentid, teamid) values (0, 15);
insert into teamstotournaments (tournamentid, teamid) values (0, 16);
insert into teamstotournaments (tournamentid, teamid) values (0, 17);




insert into PhaseTypes (id, name) values (1, 'Rodada 1');
insert into PhaseTypes (id, name) values (2, 'Rodada 2');
insert into PhaseTypes (id, name) values (3, 'Rodada 3');
insert into PhaseTypes (id, name) values (4, 'Rodada 4');
insert into PhaseTypes (id, name) values (5, 'Rodada 5');
insert into PhaseTypes (id, name) values (6, 'Rodada 6');
insert into PhaseTypes (id, name) values (7, 'Rodada 7');
insert into PhaseTypes (id, name) values (8, 'Rodada 8');
insert into PhaseTypes (id, name) values (9, 'Rodada 9');
insert into PhaseTypes (id, name) values (10, 'Rodada 10');
insert into PhaseTypes (id, name) values (11, 'Rodada 11');
insert into PhaseTypes (id, name) values (12, 'Rodada 12');
insert into PhaseTypes (id, name) values (13, 'Rodada 13');
insert into PhaseTypes (id, name) values (14, 'Rodada 14');
insert into PhaseTypes (id, name) values (15, 'Rodada 15');
insert into PhaseTypes (id, name) values (16, 'Rodada 16');
insert into PhaseTypes (id, name) values (17, 'Rodada 17');
insert into PhaseTypes (id, name) values (18, 'Rodada 18');
insert into PhaseTypes (id, name) values (19, 'Rodada 19');
insert into PhaseTypes (id, name) values (20, 'Rodada 20');
insert into PhaseTypes (id, name) values (21, 'Rodada 21');
insert into PhaseTypes (id, name) values (22, 'Rodada 22');
insert into PhaseTypes (id, name) values (23, 'Rodada 23');
insert into PhaseTypes (id, name) values (24, 'Rodada 24');
insert into PhaseTypes (id, name) values (25, 'Rodada 25');



insert into phase (id, tournamentid, phasetype) values (1, 0, 1);
insert into phase (id, tournamentid, phasetype) values (2, 0, 2);
insert into phase (id, tournamentid, phasetype) values (3, 0, 3);
insert into phase (id, tournamentid, phasetype) values (4, 0, 4);
insert into phase (id, tournamentid, phasetype) values (5, 0, 5);
insert into phase (id, tournamentid, phasetype) values (6, 0, 6);
insert into phase (id, tournamentid, phasetype) values (7, 0, 7);
insert into phase (id, tournamentid, phasetype) values (8, 0, 8);
insert into phase (id, tournamentid, phasetype) values (9, 0, 9);
insert into phase (id, tournamentid, phasetype) values (10, 0, 10);
insert into phase (id, tournamentid, phasetype) values (11, 0, 11);
insert into phase (id, tournamentid, phasetype) values (12, 0, 12);
insert into phase (id, tournamentid, phasetype) values (13, 0, 13);
insert into phase (id, tournamentid, phasetype) values (14, 0, 14);
insert into phase (id, tournamentid, phasetype) values (15, 0, 15);
insert into phase (id, tournamentid, phasetype) values (16, 0, 16);
insert into phase (id, tournamentid, phasetype) values (17, 0, 17);
insert into phase (id, tournamentid, phasetype) values (18, 0, 18);
insert into phase (id, tournamentid, phasetype) values (19, 0, 19);
insert into phase (id, tournamentid, phasetype) values (20, 0, 20);
insert into phase (id, tournamentid, phasetype) values (21, 0, 21);
insert into phase (id, tournamentid, phasetype) values (22, 0, 22);
insert into phase (id, tournamentid, phasetype) values (23, 0, 23);
insert into phase (id, tournamentid, phasetype) values (24, 0, 24);
insert into phase (id, tournamentid, phasetype) values (25, 0, 25);



insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (0, to_timestamp('08/03/2020 11:30','DD/MM/YYYY HH24:MI'), 0, 12, 0, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (1, to_timestamp('08/03/2020 10:30','DD/MM/YYYY HH24:MI'), 1, 14, 1, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (2, to_timestamp('08/03/2020 21:00','DD/MM/YYYY HH24:MI'), 2, 11, 2, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (3, to_timestamp('08/03/2020 11:00','DD/MM/YYYY HH24:MI'), 3, 9, 3, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (4, to_timestamp('08/03/2020 14:45','DD/MM/YYYY HH24:MI'), 4, 13, 4, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (5, to_timestamp('08/03/2020 17:45','DD/MM/YYYY HH24:MI'), 5, 16, 5, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (6, to_timestamp('08/03/2020 12:15','DD/MM/YYYY HH24:MI'), 6, 10, 6, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (7, to_timestamp('08/03/2020 10:45','DD/MM/YYYY HH24:MI'), 7, 15, 7, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (8, to_timestamp('08/03/2020 17:30','DD/MM/YYYY HH24:MI'), 8, 17, 8, 24);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (9, to_timestamp('03/03/2020 17:15','DD/MM/YYYY HH24:MI'), 9, 1, 9, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (10, to_timestamp('02/03/2020 10:30','DD/MM/YYYY HH24:MI'), 10, 4, 10, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (11, to_timestamp('02/03/2020 23:15','DD/MM/YYYY HH24:MI'), 11, 5, 11, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (12, to_timestamp('01/03/2020 23:00','DD/MM/YYYY HH24:MI'), 12, 7, 12, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (13, to_timestamp('01/03/2020 10:30','DD/MM/YYYY HH24:MI'), 13, 8, 13, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (14, to_timestamp('01/03/2020 21:15','DD/MM/YYYY HH24:MI'), 14, 0, 14, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (15, to_timestamp('29/02/2020 17:00','DD/MM/YYYY HH24:MI'), 15, 2, 15, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (16, to_timestamp('29/02/2020 10:15','DD/MM/YYYY HH24:MI'), 16, 3, 16, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (17, to_timestamp('28/02/2020 13:30','DD/MM/YYYY HH24:MI'), 17, 6, 17, 23);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (18, to_timestamp('24/02/2020 14:15','DD/MM/YYYY HH24:MI'), 2, 10, 2, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (19, to_timestamp('23/02/2020 12:15','DD/MM/YYYY HH24:MI'), 5, 17, 5, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (20, to_timestamp('23/02/2020 18:00','DD/MM/YYYY HH24:MI'), 8, 6, 8, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (21, to_timestamp('23/02/2020 19:15','DD/MM/YYYY HH24:MI'), 1, 15, 1, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (22, to_timestamp('23/02/2020 11:45','DD/MM/YYYY HH24:MI'), 0, 9, 0, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (23, to_timestamp('23/02/2020 16:30','DD/MM/YYYY HH24:MI'), 4, 11, 4, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (24, to_timestamp('22/02/2020 12:45','DD/MM/YYYY HH24:MI'), 3, 13, 3, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (25, to_timestamp('22/02/2020 17:45','DD/MM/YYYY HH24:MI'), 7, 16, 7, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (26, to_timestamp('21/02/2020 11:30','DD/MM/YYYY HH24:MI'), 14, 12, 14, 22);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (27, to_timestamp('16/02/2020 14:00','DD/MM/YYYY HH24:MI'), 9, 14, 9, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (28, to_timestamp('16/02/2020 11:45','DD/MM/YYYY HH24:MI'), 12, 5, 12, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (29, to_timestamp('16/02/2020 20:45','DD/MM/YYYY HH24:MI'), 15, 3, 15, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (30, to_timestamp('16/02/2020 13:45','DD/MM/YYYY HH24:MI'), 13, 0, 13, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (31, to_timestamp('15/02/2020 19:15','DD/MM/YYYY HH24:MI'), 16, 1, 16, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (32, to_timestamp('15/02/2020 22:15','DD/MM/YYYY HH24:MI'), 10, 8, 10, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (33, to_timestamp('15/02/2020 17:00','DD/MM/YYYY HH24:MI'), 17, 4, 17, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (34, to_timestamp('15/02/2020 13:45','DD/MM/YYYY HH24:MI'), 11, 7, 11, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (35, to_timestamp('14/02/2020 19:15','DD/MM/YYYY HH24:MI'), 6, 2, 6, 21);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (36, to_timestamp('09/02/2020 12:45','DD/MM/YYYY HH24:MI'), 14, 16, 14, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (37, to_timestamp('09/02/2020 12:15','DD/MM/YYYY HH24:MI'), 1, 17, 1, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (38, to_timestamp('09/02/2020 13:45','DD/MM/YYYY HH24:MI'), 4, 6, 4, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (39, to_timestamp('09/02/2020 12:45','DD/MM/YYYY HH24:MI'), 7, 13, 7, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (40, to_timestamp('08/02/2020 12:15','DD/MM/YYYY HH24:MI'), 5, 10, 5, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (41, to_timestamp('08/02/2020 16:30','DD/MM/YYYY HH24:MI'), 8, 2, 8, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (42, to_timestamp('08/02/2020 15:15','DD/MM/YYYY HH24:MI'), 3, 11, 3, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (43, to_timestamp('08/02/2020 23:15','DD/MM/YYYY HH24:MI'), 9, 12, 9, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (44, to_timestamp('07/02/2020 16:00','DD/MM/YYYY HH24:MI'), 0, 15, 0, 20);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (45, to_timestamp('02/02/2020 22:30','DD/MM/YYYY HH24:MI'), 15, 12, 15, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (46, to_timestamp('02/02/2020 18:45','DD/MM/YYYY HH24:MI'), 8, 1, 8, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (47, to_timestamp('02/02/2020 18:45','DD/MM/YYYY HH24:MI'), 11, 0, 11, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (48, to_timestamp('02/02/2020 12:45','DD/MM/YYYY HH24:MI'), 2, 4, 2, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (49, to_timestamp('02/02/2020 22:45','DD/MM/YYYY HH24:MI'), 13, 14, 13, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (50, to_timestamp('01/02/2020 21:15','DD/MM/YYYY HH24:MI'), 6, 5, 6, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (51, to_timestamp('01/02/2020 15:00','DD/MM/YYYY HH24:MI'), 17, 7, 17, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (52, to_timestamp('31/01/2020 16:45','DD/MM/YYYY HH24:MI'), 16, 9, 16, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (53, to_timestamp('31/01/2020 20:30','DD/MM/YYYY HH24:MI'), 10, 3, 10, 19);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (54, to_timestamp('29/01/2020 13:30','DD/MM/YYYY HH24:MI'), 4, 8, 4, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (55, to_timestamp('28/01/2020 12:45','DD/MM/YYYY HH24:MI'), 5, 2, 5, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (56, to_timestamp('27/01/2020 22:15','DD/MM/YYYY HH24:MI'), 1, 13, 1, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (57, to_timestamp('27/01/2020 11:00','DD/MM/YYYY HH24:MI'), 12, 16, 12, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (58, to_timestamp('26/01/2020 13:15','DD/MM/YYYY HH24:MI'), 14, 15, 14, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (59, to_timestamp('26/01/2020 10:30','DD/MM/YYYY HH24:MI'), 0, 10, 0, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (60, to_timestamp('26/01/2020 16:30','DD/MM/YYYY HH24:MI'), 3, 17, 3, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (61, to_timestamp('26/01/2020 14:15','DD/MM/YYYY HH24:MI'), 9, 11, 9, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (62, to_timestamp('26/01/2020 13:00','DD/MM/YYYY HH24:MI'), 7, 6, 7, 18);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (63, to_timestamp('19/01/2020 23:00','DD/MM/YYYY HH24:MI'), 16, 15, 16, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (64, to_timestamp('19/01/2020 16:15','DD/MM/YYYY HH24:MI'), 9, 13, 9, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (65, to_timestamp('19/01/2020 14:15','DD/MM/YYYY HH24:MI'), 0, 2, 0, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (66, to_timestamp('18/01/2020 12:15','DD/MM/YYYY HH24:MI'), 3, 6, 3, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (67, to_timestamp('18/01/2020 20:15','DD/MM/YYYY HH24:MI'), 7, 4, 7, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (68, to_timestamp('18/01/2020 18:15','DD/MM/YYYY HH24:MI'), 14, 17, 14, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (69, to_timestamp('18/01/2020 18:00','DD/MM/YYYY HH24:MI'), 12, 11, 12, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (70, to_timestamp('17/01/2020 17:45','DD/MM/YYYY HH24:MI'), 1, 10, 1, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (71, to_timestamp('17/01/2020 23:00','DD/MM/YYYY HH24:MI'), 5, 8, 5, 17);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (72, to_timestamp('12/01/2020 19:30','DD/MM/YYYY HH24:MI'), 8, 7, 8, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (73, to_timestamp('12/01/2020 18:30','DD/MM/YYYY HH24:MI'), 13, 12, 13, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (74, to_timestamp('12/01/2020 20:45','DD/MM/YYYY HH24:MI'), 2, 3, 2, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (75, to_timestamp('11/01/2020 22:15','DD/MM/YYYY HH24:MI'), 6, 1, 6, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (76, to_timestamp('11/01/2020 12:00','DD/MM/YYYY HH24:MI'), 15, 9, 15, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (77, to_timestamp('11/01/2020 15:15','DD/MM/YYYY HH24:MI'), 17, 0, 17, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (78, to_timestamp('10/01/2020 22:45','DD/MM/YYYY HH24:MI'), 4, 5, 4, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (79, to_timestamp('10/01/2020 21:45','DD/MM/YYYY HH24:MI'), 10, 14, 10, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (80, to_timestamp('10/01/2020 13:00','DD/MM/YYYY HH24:MI'), 11, 16, 11, 16);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (81, to_timestamp('05/01/2020 11:15','DD/MM/YYYY HH24:MI'), 9, 6, 9, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (82, to_timestamp('05/01/2020 22:15','DD/MM/YYYY HH24:MI'), 1, 5, 1, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (83, to_timestamp('05/01/2020 16:45','DD/MM/YYYY HH24:MI'), 0, 4, 0, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (84, to_timestamp('05/01/2020 11:00','DD/MM/YYYY HH24:MI'), 16, 13, 16, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (85, to_timestamp('05/01/2020 11:45','DD/MM/YYYY HH24:MI'), 7, 2, 7, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (86, to_timestamp('04/01/2020 19:45','DD/MM/YYYY HH24:MI'), 12, 10, 12, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (87, to_timestamp('04/01/2020 14:15','DD/MM/YYYY HH24:MI'), 3, 8, 3, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (88, to_timestamp('04/01/2020 12:45','DD/MM/YYYY HH24:MI'), 14, 11, 14, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (89, to_timestamp('04/01/2020 17:45','DD/MM/YYYY HH24:MI'), 15, 17, 15, 15);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (90, to_timestamp('16/12/2019 14:15','DD/MM/YYYY HH24:MI'), 5, 7, 5, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (91, to_timestamp('16/12/2019 18:45','DD/MM/YYYY HH24:MI'), 11, 1, 11, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (92, to_timestamp('15/12/2019 23:45','DD/MM/YYYY HH24:MI'), 8, 0, 8, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (93, to_timestamp('15/12/2019 18:15','DD/MM/YYYY HH24:MI'), 2, 12, 2, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (94, to_timestamp('15/12/2019 13:30','DD/MM/YYYY HH24:MI'), 4, 3, 4, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (95, to_timestamp('14/12/2019 13:15','DD/MM/YYYY HH24:MI'), 6, 14, 6, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (96, to_timestamp('14/12/2019 11:30','DD/MM/YYYY HH24:MI'), 10, 9, 10, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (97, to_timestamp('14/12/2019 22:00','DD/MM/YYYY HH24:MI'), 13, 15, 13, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (98, to_timestamp('13/12/2019 18:30','DD/MM/YYYY HH24:MI'), 17, 16, 17, 14);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (99, to_timestamp('09/12/2019 15:00','DD/MM/YYYY HH24:MI'), 16, 2, 16, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (100, to_timestamp('08/12/2019 11:00','DD/MM/YYYY HH24:MI'), 3, 5, 3, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (101, to_timestamp('08/12/2019 21:00','DD/MM/YYYY HH24:MI'), 1, 4, 1, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (102, to_timestamp('08/12/2019 12:45','DD/MM/YYYY HH24:MI'), 0, 6, 0, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (103, to_timestamp('08/12/2019 19:45','DD/MM/YYYY HH24:MI'), 12, 17, 12, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (104, to_timestamp('07/12/2019 21:00','DD/MM/YYYY HH24:MI'), 14, 8, 14, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (105, to_timestamp('07/12/2019 11:15','DD/MM/YYYY HH24:MI'), 9, 7, 9, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (106, to_timestamp('07/12/2019 22:00','DD/MM/YYYY HH24:MI'), 13, 11, 13, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (107, to_timestamp('06/12/2019 14:45','DD/MM/YYYY HH24:MI'), 15, 10, 15, 13);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (108, to_timestamp('02/12/2019 16:15','DD/MM/YYYY HH24:MI'), 5, 0, 5, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (109, to_timestamp('02/12/2019 12:00','DD/MM/YYYY HH24:MI'), 8, 16, 8, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (110, to_timestamp('01/12/2019 18:00','DD/MM/YYYY HH24:MI'), 2, 1, 2, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (111, to_timestamp('01/12/2019 11:15','DD/MM/YYYY HH24:MI'), 6, 12, 6, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (112, to_timestamp('01/12/2019 20:30','DD/MM/YYYY HH24:MI'), 7, 3, 7, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (113, to_timestamp('30/11/2019 11:45','DD/MM/YYYY HH24:MI'), 17, 9, 17, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (114, to_timestamp('30/11/2019 15:00','DD/MM/YYYY HH24:MI'), 10, 13, 10, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (115, to_timestamp('30/11/2019 17:30','DD/MM/YYYY HH24:MI'), 4, 14, 4, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (116, to_timestamp('29/11/2019 22:30','DD/MM/YYYY HH24:MI'), 11, 15, 11, 12);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (117, to_timestamp('10/11/2019 17:45','DD/MM/YYYY HH24:MI'), 15, 5, 15, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (118, to_timestamp('10/11/2019 10:30','DD/MM/YYYY HH24:MI'), 12, 8, 12, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (119, to_timestamp('10/11/2019 22:30','DD/MM/YYYY HH24:MI'), 1, 3, 1, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (120, to_timestamp('10/11/2019 15:30','DD/MM/YYYY HH24:MI'), 0, 7, 0, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (121, to_timestamp('10/11/2019 11:15','DD/MM/YYYY HH24:MI'), 13, 17, 13, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (122, to_timestamp('09/11/2019 11:00','DD/MM/YYYY HH24:MI'), 9, 4, 9, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (123, to_timestamp('09/11/2019 21:30','DD/MM/YYYY HH24:MI'), 11, 10, 11, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (124, to_timestamp('09/11/2019 21:30','DD/MM/YYYY HH24:MI'), 16, 6, 16, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (125, to_timestamp('08/11/2019 23:45','DD/MM/YYYY HH24:MI'), 14, 2, 14, 11);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (126, to_timestamp('04/11/2019 20:30','DD/MM/YYYY HH24:MI'), 17, 11, 17, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (127, to_timestamp('04/11/2019 23:15','DD/MM/YYYY HH24:MI'), 6, 15, 6, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (128, to_timestamp('04/11/2019 18:45','DD/MM/YYYY HH24:MI'), 3, 0, 3, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (129, to_timestamp('03/11/2019 18:15','DD/MM/YYYY HH24:MI'), 8, 9, 8, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (130, to_timestamp('03/11/2019 14:45','DD/MM/YYYY HH24:MI'), 5, 14, 5, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (131, to_timestamp('03/11/2019 12:30','DD/MM/YYYY HH24:MI'), 7, 1, 7, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (132, to_timestamp('03/11/2019 14:30','DD/MM/YYYY HH24:MI'), 2, 13, 2, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (133, to_timestamp('02/11/2019 19:00','DD/MM/YYYY HH24:MI'), 4, 12, 4, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (134, to_timestamp('02/11/2019 23:00','DD/MM/YYYY HH24:MI'), 10, 16, 10, 10);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (135, to_timestamp('31/10/2019 14:15','DD/MM/YYYY HH24:MI'), 15, 8, 15, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (136, to_timestamp('31/10/2019 13:30','DD/MM/YYYY HH24:MI'), 11, 6, 11, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (137, to_timestamp('31/10/2019 22:15','DD/MM/YYYY HH24:MI'), 0, 1, 0, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (138, to_timestamp('30/10/2019 12:30','DD/MM/YYYY HH24:MI'), 9, 2, 9, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (139, to_timestamp('30/10/2019 10:15','DD/MM/YYYY HH24:MI'), 10, 17, 10, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (140, to_timestamp('30/10/2019 12:15','DD/MM/YYYY HH24:MI'), 12, 3, 12, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (141, to_timestamp('30/10/2019 23:45','DD/MM/YYYY HH24:MI'), 13, 5, 13, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (142, to_timestamp('30/10/2019 12:15','DD/MM/YYYY HH24:MI'), 16, 4, 16, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (143, to_timestamp('28/10/2019 23:15','DD/MM/YYYY HH24:MI'), 8, 11, 8, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (144, to_timestamp('27/10/2019 22:15','DD/MM/YYYY HH24:MI'), 1, 12, 1, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (145, to_timestamp('27/10/2019 15:45','DD/MM/YYYY HH24:MI'), 5, 9, 5, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (146, to_timestamp('27/10/2019 11:45','DD/MM/YYYY HH24:MI'), 7, 10, 7, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (147, to_timestamp('26/10/2019 20:00','DD/MM/YYYY HH24:MI'), 4, 15, 4, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (148, to_timestamp('26/10/2019 15:45','DD/MM/YYYY HH24:MI'), 6, 13, 6, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (149, to_timestamp('26/10/2019 11:45','DD/MM/YYYY HH24:MI'), 3, 14, 3, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (150, to_timestamp('26/10/2019 23:45','DD/MM/YYYY HH24:MI'), 2, 17, 2, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (151, to_timestamp('25/10/2019 23:00','DD/MM/YYYY HH24:MI'), 0, 16, 0, 8);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (152, to_timestamp('05/10/2019 12:30','DD/MM/YYYY HH24:MI'), 14, 7, 14, 9);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (153, to_timestamp('30/09/2019 13:45','DD/MM/YYYY HH24:MI'), 14, 1, 14, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (154, to_timestamp('29/09/2019 17:00','DD/MM/YYYY HH24:MI'), 16, 5, 16, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (155, to_timestamp('29/09/2019 14:00','DD/MM/YYYY HH24:MI'), 17, 8, 17, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (156, to_timestamp('29/09/2019 23:00','DD/MM/YYYY HH24:MI'), 11, 2, 11, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (157, to_timestamp('29/09/2019 14:15','DD/MM/YYYY HH24:MI'), 12, 0, 12, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (158, to_timestamp('28/09/2019 13:30','DD/MM/YYYY HH24:MI'), 9, 3, 9, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (159, to_timestamp('28/09/2019 22:00','DD/MM/YYYY HH24:MI'), 10, 6, 10, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (160, to_timestamp('28/09/2019 11:00','DD/MM/YYYY HH24:MI'), 13, 4, 13, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (161, to_timestamp('27/09/2019 15:00','DD/MM/YYYY HH24:MI'), 15, 7, 15, 7);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (162, to_timestamp('23/09/2019 18:00','DD/MM/YYYY HH24:MI'), 1, 9, 1, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (163, to_timestamp('23/09/2019 12:15','DD/MM/YYYY HH24:MI'), 8, 13, 8, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (164, to_timestamp('22/09/2019 23:15','DD/MM/YYYY HH24:MI'), 5, 11, 5, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (165, to_timestamp('22/09/2019 16:00','DD/MM/YYYY HH24:MI'), 7, 12, 7, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (166, to_timestamp('22/09/2019 14:15','DD/MM/YYYY HH24:MI'), 6, 17, 6, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (167, to_timestamp('22/09/2019 18:15','DD/MM/YYYY HH24:MI'), 2, 15, 2, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (168, to_timestamp('21/09/2019 20:15','DD/MM/YYYY HH24:MI'), 4, 10, 4, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (169, to_timestamp('21/09/2019 19:00','DD/MM/YYYY HH24:MI'), 3, 16, 3, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (170, to_timestamp('20/09/2019 22:30','DD/MM/YYYY HH24:MI'), 0, 14, 0, 6);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (171, to_timestamp('15/09/2019 10:00','DD/MM/YYYY HH24:MI'), 15, 1, 15, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (172, to_timestamp('15/09/2019 16:45','DD/MM/YYYY HH24:MI'), 17, 5, 17, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (173, to_timestamp('15/09/2019 10:15','DD/MM/YYYY HH24:MI'), 13, 3, 13, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (174, to_timestamp('15/09/2019 12:00','DD/MM/YYYY HH24:MI'), 16, 7, 16, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (175, to_timestamp('15/09/2019 20:00','DD/MM/YYYY HH24:MI'), 11, 4, 11, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (176, to_timestamp('14/09/2019 23:15','DD/MM/YYYY HH24:MI'), 12, 14, 12, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (177, to_timestamp('14/09/2019 19:30','DD/MM/YYYY HH24:MI'), 10, 2, 10, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (178, to_timestamp('14/09/2019 23:00','DD/MM/YYYY HH24:MI'), 9, 0, 9, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (179, to_timestamp('13/09/2019 14:00','DD/MM/YYYY HH24:MI'), 6, 8, 6, 5);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (180, to_timestamp('08/09/2019 13:00','DD/MM/YYYY HH24:MI'), 16, 12, 16, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (181, to_timestamp('01/09/2019 10:00','DD/MM/YYYY HH24:MI'), 8, 10, 8, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (182, to_timestamp('01/09/2019 21:45','DD/MM/YYYY HH24:MI'), 5, 12, 5, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (183, to_timestamp('01/09/2019 10:30','DD/MM/YYYY HH24:MI'), 7, 11, 7, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (184, to_timestamp('31/08/2019 21:15','DD/MM/YYYY HH24:MI'), 2, 6, 2, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (185, to_timestamp('31/08/2019 11:45','DD/MM/YYYY HH24:MI'), 1, 16, 1, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (186, to_timestamp('31/08/2019 19:45','DD/MM/YYYY HH24:MI'), 14, 9, 14, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (187, to_timestamp('31/08/2019 12:30','DD/MM/YYYY HH24:MI'), 0, 13, 0, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (188, to_timestamp('30/08/2019 14:00','DD/MM/YYYY HH24:MI'), 3, 15, 3, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (189, to_timestamp('30/08/2019 10:45','DD/MM/YYYY HH24:MI'), 4, 17, 4, 4);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (190, to_timestamp('25/08/2019 10:30','DD/MM/YYYY HH24:MI'), 12, 9, 12, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (191, to_timestamp('25/08/2019 15:30','DD/MM/YYYY HH24:MI'), 2, 8, 2, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (192, to_timestamp('25/08/2019 23:45','DD/MM/YYYY HH24:MI'), 17, 1, 17, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (193, to_timestamp('25/08/2019 23:15','DD/MM/YYYY HH24:MI'), 13, 7, 13, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (194, to_timestamp('25/08/2019 22:00','DD/MM/YYYY HH24:MI'), 11, 3, 11, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (195, to_timestamp('24/08/2019 20:00','DD/MM/YYYY HH24:MI'), 15, 0, 15, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (196, to_timestamp('24/08/2019 20:30','DD/MM/YYYY HH24:MI'), 10, 5, 10, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (197, to_timestamp('23/08/2019 19:30','DD/MM/YYYY HH24:MI'), 16, 14, 16, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (198, to_timestamp('23/08/2019 13:45','DD/MM/YYYY HH24:MI'), 6, 4, 6, 3);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (199, to_timestamp('19/08/2019 13:15','DD/MM/YYYY HH24:MI'), 7, 17, 7, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (200, to_timestamp('18/08/2019 12:00','DD/MM/YYYY HH24:MI'), 1, 8, 1, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (201, to_timestamp('18/08/2019 21:45','DD/MM/YYYY HH24:MI'), 12, 15, 12, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (202, to_timestamp('18/08/2019 21:30','DD/MM/YYYY HH24:MI'), 14, 13, 14, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (203, to_timestamp('18/08/2019 16:00','DD/MM/YYYY HH24:MI'), 0, 11, 0, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (204, to_timestamp('17/08/2019 12:15','DD/MM/YYYY HH24:MI'), 5, 6, 5, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (205, to_timestamp('17/08/2019 11:00','DD/MM/YYYY HH24:MI'), 3, 10, 3, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (206, to_timestamp('17/08/2019 17:45','DD/MM/YYYY HH24:MI'), 4, 2, 4, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (207, to_timestamp('16/08/2019 21:45','DD/MM/YYYY HH24:MI'), 9, 16, 9, 2);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (208, to_timestamp('12/08/2019 10:15','DD/MM/YYYY HH24:MI'), 6, 7, 6, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (209, to_timestamp('11/08/2019 20:00','DD/MM/YYYY HH24:MI'), 8, 4, 8, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (210, to_timestamp('11/08/2019 17:30','DD/MM/YYYY HH24:MI'), 13, 1, 13, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (211, to_timestamp('11/08/2019 22:15','DD/MM/YYYY HH24:MI'), 15, 14, 15, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (212, to_timestamp('10/08/2019 12:45','DD/MM/YYYY HH24:MI'), 10, 0, 10, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (213, to_timestamp('10/08/2019 15:00','DD/MM/YYYY HH24:MI'), 2, 5, 2, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (214, to_timestamp('10/08/2019 12:15','DD/MM/YYYY HH24:MI'), 11, 9, 11, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (215, to_timestamp('09/08/2019 16:30','DD/MM/YYYY HH24:MI'), 17, 3, 17, 1);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (216, to_timestamp('26/06/2020 23:00','DD/MM/YYYY HH24:MI'), 11, 6, 12, 25);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (217, to_timestamp('26/06/2020 23:00','DD/MM/YYYY HH24:MI'), 12, 5, 11, 25);
insert into games (id, matchtime, hostid, guestid, stadiumid, phaseid) values (218, to_timestamp('26/06/2020 23:00','DD/MM/YYYY HH24:MI'), 10, 4, 10, 25);



insert into eventtypes (id, name) values (0, 'Red card');
insert into eventtypes (id, name) values (1, 'Yellow card');
insert into eventtypes (id, name) values (2, 'Corner'); 
insert into eventtypes (id, name) values (3, 'Faul');
insert into eventtypes (id, name) values (4, 'Goal');


insert into gameevents (id, time, gameid, eventtypeid, teamid) values (0, to_timestamp('01/01/2020 13:00','DD/MM/YYYY HH24:MI'), 0, 0, 0);


-- possible ending of the game
insert into oddtypes (id, name) values (0, 'Host Lose - Method 1');
insert into oddtypes (id, name) values (1, 'Host Win - Method 1');
insert into oddtypes (id, name) values (2, 'Draw - Method 1');
insert into oddtypes (id, name) values (3, 'Host Lose - Method 2');
insert into oddtypes (id, name) values (4, 'Host Win - Method 2');
insert into oddtypes (id, name) values (5, 'Draw - Method 2');


-- insert into OddsHistory (id, Time, OddId) values (0, to_timestamp('01/01/2020 13:00','DD/MM/YYYY HH24:MI'), 0);



insert into score (id, gameid, matchtime, hostscore, guestscore) values (0, 0, 93, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (1, 1, 93, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (2, 2, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (3, 3, 92, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (4, 4, 93, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (5, 5, 96, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (6, 6, 92, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (7, 7, 91, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (8, 8, 95, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (9, 9, 91, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (10, 10, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (11, 11, 92, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (12, 12, 92, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (13, 13, 94, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (14, 14, 94, 1, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (15, 15, 91, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (16, 16, 91, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (17, 17, 93, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (18, 18, 91, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (19, 19, 96, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (20, 20, 93, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (21, 21, 96, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (22, 22, 92, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (23, 23, 93, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (24, 24, 91, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (25, 25, 94, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (26, 26, 96, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (27, 27, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (28, 28, 91, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (29, 29, 93, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (30, 30, 96, 3, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (31, 31, 91, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (32, 32, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (33, 33, 95, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (34, 34, 96, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (35, 35, 91, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (36, 36, 95, 0, 4);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (37, 37, 94, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (38, 38, 95, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (39, 39, 94, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (40, 40, 91, 3, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (41, 41, 93, 2, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (42, 42, 96, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (43, 43, 94, 0, 7);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (44, 44, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (45, 45, 91, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (46, 46, 94, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (47, 47, 94, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (48, 48, 91, 1, 5);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (49, 49, 96, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (50, 50, 91, 0, 4);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (51, 51, 94, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (52, 52, 95, 2, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (53, 53, 94, 3, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (54, 54, 91, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (55, 55, 93, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (56, 56, 93, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (57, 57, 91, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (58, 58, 92, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (59, 59, 96, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (60, 60, 96, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (61, 61, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (62, 62, 94, 0, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (63, 63, 91, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (64, 64, 96, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (65, 65, 95, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (66, 66, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (67, 67, 92, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (68, 68, 94, 3, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (69, 69, 92, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (70, 70, 96, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (71, 71, 93, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (72, 72, 92, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (73, 73, 91, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (74, 74, 92, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (75, 75, 96, 1, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (76, 76, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (77, 77, 91, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (78, 78, 92, 2, 4);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (79, 79, 95, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (80, 80, 92, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (81, 81, 91, 3, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (82, 82, 92, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (83, 83, 91, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (84, 84, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (85, 85, 95, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (86, 86, 95, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (87, 87, 94, 1, 7);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (88, 88, 95, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (89, 89, 94, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (90, 90, 93, 3, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (91, 91, 96, 0, 4);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (92, 92, 92, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (93, 93, 92, 2, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (94, 94, 96, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (95, 95, 95, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (96, 96, 92, 4, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (97, 97, 93, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (98, 98, 94, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (99, 99, 94, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (100, 100, 95, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (101, 101, 93, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (102, 102, 95, 2, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (103, 103, 92, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (104, 104, 96, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (105, 105, 96, 2, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (106, 106, 93, 2, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (107, 107, 92, 1, 4);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (108, 108, 96, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (109, 109, 95, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (110, 110, 91, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (111, 111, 92, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (112, 112, 96, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (113, 113, 92, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (114, 114, 93, 4, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (115, 115, 93, 3, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (116, 116, 91, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (117, 117, 91, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (118, 118, 94, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (119, 119, 93, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (120, 120, 95, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (121, 121, 92, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (122, 122, 96, 3, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (123, 123, 94, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (124, 124, 96, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (125, 125, 94, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (126, 126, 96, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (127, 127, 95, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (128, 128, 94, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (129, 129, 95, 2, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (130, 130, 93, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (131, 131, 91, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (132, 132, 94, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (133, 133, 92, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (134, 134, 94, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (135, 135, 93, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (136, 136, 91, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (137, 137, 96, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (138, 138, 96, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (139, 139, 94, 4, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (140, 140, 91, 5, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (141, 141, 96, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (142, 142, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (143, 143, 91, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (144, 144, 95, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (145, 145, 91, 3, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (146, 146, 92, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (147, 147, 91, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (148, 148, 93, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (149, 149, 95, 3, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (150, 150, 94, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (151, 151, 93, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (152, 152, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (153, 153, 91, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (154, 154, 94, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (155, 155, 93, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (156, 156, 96, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (157, 157, 91, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (158, 158, 91, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (159, 159, 92, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (160, 160, 94, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (161, 161, 93, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (162, 162, 96, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (163, 163, 92, 2, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (164, 164, 95, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (165, 165, 96, 1, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (166, 166, 91, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (167, 167, 92, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (168, 168, 91, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (169, 169, 96, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (170, 170, 96, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (171, 171, 96, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (172, 172, 93, 2, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (173, 173, 91, 1, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (174, 174, 93, 2, 4);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (175, 175, 91, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (176, 176, 91, 5, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (177, 177, 94, 2, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (178, 178, 93, 4, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (179, 179, 93, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (180, 180, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (181, 181, 92, 0, 4);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (182, 182, 93, 3, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (183, 183, 96, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (184, 184, 91, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (185, 185, 92, 2, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (186, 186, 93, 2, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (187, 187, 92, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (188, 188, 96, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (189, 189, 94, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (190, 190, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (191, 191, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (192, 192, 92, 1, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (193, 193, 92, 2, 3);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (194, 194, 92, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (195, 195, 94, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (196, 196, 93, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (197, 197, 92, 5, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (198, 198, 96, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (199, 199, 93, 1, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (200, 200, 93, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (201, 201, 93, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (202, 202, 95, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (203, 203, 94, 0, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (204, 204, 93, 4, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (205, 205, 94, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (206, 206, 91, 3, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (207, 207, 94, 1, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (208, 208, 93, 0, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (209, 209, 92, 3, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (210, 210, 92, 1, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (211, 211, 95, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (212, 212, 94, 5, 0);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (213, 213, 96, 2, 1);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (214, 214, 96, 0, 2);
insert into score (id, gameid, matchtime, hostscore, guestscore) values (215, 215, 92, 0, 0);

-- SEQUENCES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
create sequence odd_sequence
  MINVALUE 0
  start with 0
  increment by 1
  nocache
  nocycle;

create or replace trigger odd_id_on_insert
  before insert on odds
  for each row
begin
  select odd_sequence.nextval into :new.id from dual;
end odd_id_on_insert;
/


create sequence bet_sequence
  MINVALUE 0
  start with 0
  increment by 1
  nocache
  nocycle;

create or replace trigger bet_id_on_insert
  before insert on bets
  for each row
begin
  select bet_sequence.nextval into :new.id from dual;
end bet_id_on_insert;
/

CREATE SEQUENCE events_sequence
  MINVALUE 0
  START WITH 1
  INCREMENT BY 1
  nocache
  nocycle;

create or replace TRIGGER events_id_on_insert
  BEFORE INSERT ON gameevents
  FOR EACH ROW
BEGIN
  SELECT events_sequence.nextval INTO :new.Id FROM dual;
END;
/


create sequence games_sequence
  MINVALUE 0
  start with 300
  increment by 1
  nocache
  nocycle;

create or replace trigger game_id_on_insert
  before insert on games
  for each row
begin
  select games_sequence.nextval into :new.id from dual;
end game_id_on_insert;
/


create sequence tournaments_sequence
  MINVALUE 0
  start with 100
  increment by 1
  nocache
  nocycle;

create or replace trigger tournament_id_on_insert
  before insert on tournaments
  for each row
begin
  select tournaments_sequence.nextval into :new.id from dual;
end tournament_id_on_insert;
/


create sequence phasetypes_sequence
  MINVALUE 0
  start with 100
  increment by 1
  nocache
  nocycle;

create or replace trigger phasetype_id_on_insert
  before insert on phasetypes
  for each row
begin
  select phasetypes_sequence.nextval into :new.id from dual;
end phasetype_id_on_insert;
/


create sequence phase_sequence
  MINVALUE 0
  start with 100
  increment by 1
  nocache
  nocycle;

create or replace trigger phase_id_on_insert
  before insert on phase
  for each row
begin
  select phase_sequence.nextval into :new.id from dual;
end phase_id_on_insert;
/


CREATE SEQUENCE odds_his_sequence
  MINVALUE 0
  START WITH 1
  INCREMENT BY 1
  nocache
  nocycle;

create or replace TRIGGER odds_his_id_insert
  BEFORE INSERT ON oddshistory
  FOR EACH ROW
BEGIN
  SELECT odds_his_sequence.nextval
  INTO :new.Id
  FROM dual;
END;
/

CREATE SEQUENCE winners_sequence
  MINVALUE 0
  START WITH 1
  INCREMENT BY 1
  nocache
  nocycle;

create or replace TRIGGER winners_id_insert
  BEFORE INSERT ON winners
  FOR EACH ROW
BEGIN
  SELECT winners_sequence.nextval
  INTO :new.Id
  FROM dual;
END;
/



-- ALTER TABLES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


alter table phase
add (
startdate timestamp,
enddate timestamp);
/

alter table bets
add potencialwin number default 0;
/

alter table winners
add ispaid number default 0;
/

alter table winners
add userid number;

/
ALTER TABLE winners
ADD FOREIGN KEY (userid) REFERENCES users(id);
/

-- ADDITIONAL FUNCTIONS AND PROCEDURES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

create or replace function getStartDate
(p_phaseid number)
return timestamp is
    startDate timestamp;
begin
    select min(matchtime) into startDate from games
    where phaseid = p_phaseid;
    return startDate;
end getStartDate;
/

create or replace function getEndDate(p_phaseid number)
return timestamp is
    endDate timestamp;
begin
    select max(matchtime) into endDate from games
    where phaseid = p_phaseid;
    return endDate;
end getEndDate;
/

create or replace function getStadiumID(teamID number)
return number is
    v_stadium_id number;
begin
    select stadiumid into v_stadium_id from teams
    where id = teamID;
    return v_stadium_id;
exception
    when no_data_found then
    Raise_application_error(-20511, 'No such team');
end getStadiumID;
/

create or replace function getTeamID(teamName varchar)
return number is
    v_teamid number;
begin
    select id into v_teamid from teams
    where name = teamName;
    return v_teamid;
exception
    when no_data_found then
        Raise_application_error(-20510, 'No such team');
end getTeamID;
/



--     POPULATE DATABASE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
declare
    counter number;
    cursor playedGames is
        select games.id as gameid, games.hostid as teamid, games.matchtime, score.hostscore as score from games, score
        where games.id = score.gameid
union
select games.id, games.guestid, games.matchtime, score.guestscore
from games, score
where games.id = score.gameid;
begin
    for team in playedGames loop
        counter := 0;
            while counter <= team.score
            loop
                insert into gameevents(time, gameid, eventtypeid, teamid)
                values(team.matchtime, team.gameid, 4, team.teamid);
                counter := counter + 1;
            end loop;
    end loop;
end;
/


declare
    cursor phases is
        select id from phase;
begin
    for phase_record in phases
    loop
        update phase set
            startDate = getStartDate(phase_record.id),
            endDate = getEndDate(phase_record.id)
        where id = phase_record.id;
    end loop;
end;
/


declare
  v_tax number(8,2) := 0.3;
  v_max_odds_id number(8) := 0;
  v_rand number(8,2);
  v_last_bet_value number(8,2);
  v_all_bets_value number(12,2);
  c_counter_premio_resultado_0 number(8,2) := 0;
  c_counter_premio_resultado_1 number(8,2) := 0;
  c_counter_premio_resultado_2 number(8,2) := 0;
  c_max_premios number(12,2) := 10;

  v_odd_host_losts_guest_wins_1 number(8,3);
  v_odd_host_win_guest_losts_1 number(8,3);
  v_odd_draws_1 number(8,3);
  v_prob_host_win_guest_losts_1 number(8,3);
  v_prob_host_losts_guest_wins_1 number(8,3);
  v_prob_draws_1 number(8,3);

  teams_games_tg number(4,3);
  teams_draws_tg number(4,3);
  host_wins_guest_losts_tg number(4,3);
  host_losts_guest_wins_tg number(4,3);


  cursor c_bets (p_game_id number, p_odd_type number) is 
  select * from bets 
  join odds on odds.id = bets.oddid
  where gameid = p_game_id and odds.oddtypeid = p_odd_type;

  cursor c_all_games is 
  select * from (select * from games order by matchtime asc) 
  where rownum <= 100;

begin
    for v_game in c_all_games loop
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
        if v_prob_host_losts_guest_wins_1 < 0.03 then v_prob_host_win_guest_losts_1 := 0.03; end if;
        if v_prob_draws_1 < 0.03 then v_prob_host_win_guest_losts_1 := 0.03; end if;

        v_odd_host_losts_guest_wins_1 := 1/v_prob_host_losts_guest_wins_1 * (1 - v_tax);
        v_odd_host_win_guest_losts_1 := 1/v_prob_host_win_guest_losts_1 * (1 - v_tax);
        v_odd_draws_1 := 1/v_prob_draws_1 * (1 - v_tax);

        insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_losts_guest_wins_1, v_game.matchtime, v_game.id, 0);
        insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_win_guest_losts_1, v_game.matchtime, v_game.id, 1);
        insert into odds (value, time, gameid, oddtypeid) values (v_odd_draws_1, v_game.matchtime, v_game.id, 2);

        for i in 1..round(dbms_random.value(5.51,30.49)) loop
            v_rand := round(dbms_random.value(0.51,3.49));
            if v_rand = 1 then
            select max(id) into v_max_odds_id from odds where oddtypeid = 0 and gameid = v_game.id;
            elsif v_rand = 2 then
            select max(id) into v_max_odds_id from odds where oddtypeid = 1 and gameid = v_game.id;
            else
            select max(id) into v_max_odds_id from odds where oddtypeid = 2 and gameid = v_game.id;
            end if;

            v_last_bet_value := dbms_random.value(1,10);
            insert into bets (amountineuro, time, userid, oddid) values (v_last_bet_value, v_game.matchtime + interval '15' minute * i - interval '1' day, dbms_random.value(0,9), v_max_odds_id);


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

            select sum(amountineuro) * (1 - v_tax) into c_max_premios from bets
            join odds on bets.oddid = odds.id
            where odds.gameid = v_game.id;

            if v_all_bets_value >= 100 or v_last_bet_value >= v_all_bets_value*0.02 or (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) >= c_max_premios then
                v_odd_host_losts_guest_wins_1 := (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) / least(c_counter_premio_resultado_0, c_max_premios);
                v_odd_host_win_guest_losts_1 := (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) / least(c_counter_premio_resultado_1, c_max_premios);
                v_odd_draws_1 := (c_counter_premio_resultado_0 + c_counter_premio_resultado_1 + c_counter_premio_resultado_2) / least(c_counter_premio_resultado_2, c_max_premios);

                insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_losts_guest_wins_1, v_game.matchtime + interval '15' minute * i - interval '1' day, v_game.id, 0);
                insert into odds (value, time, gameid, oddtypeid) values (v_odd_host_win_guest_losts_1, v_game.matchtime + interval '15' minute * i - interval '1' day, v_game.id, 1);
                insert into odds (value, time, gameid, oddtypeid) values (v_odd_draws_1, v_game.matchtime + interval '15' minute * i - interval '1' day, v_game.id, 2);
            end if;

            c_counter_premio_resultado_0 := 0;
            c_counter_premio_resultado_1 := 0;
            c_counter_premio_resultado_2 := 0;

        end loop;
    end loop;
end;
/











