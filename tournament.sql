-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- In order to check whether we are connected to the correct database,
-- We are deleting the old database connection and creating a new database

DROP DATABASE if exists tournament;
CREATE DATABASE tournament;

-- We are creating new tables by deleting if any other tables with same name exists
-- We are using CASCADE to delete any dependancies on the table

DROP TABLE if exists players CASCADE;
CREATE TABLE players(player_id SERIAL primary Key,
                     player_name TEXT);

DROP TABLE if exists matches CASCADE;
CREATE TABLE matches (player1 INTEGER,
                      player2 INTEGER,
                      winner INTEGER,
                      loser INTEGER);

-- View winstand tabulates data about the player and the number of matches he won

CREATE VIEW winstand AS SELECT winner ,count(winner) as won FROM matches group by winner order by winner;

-- View lostand tabulates data about the player and the number of matches he lost

CREATE VIEW lostand AS SELECT loser,count(loser) as lost FROM matches group by loser order by loser;

-- VIEW standings tabulates data about the players and their match history like total matches played ,number of matches won

CREATE VIEW standings AS SELECT p.player_id,p.player_name,
                                COALESCE(w.won,0) as wins,
                                COALESCE(w.won,0)+COALESCE(l.lost,0) as matches
                                from players p
                                left join winstand w on p.player_id=w.winner
                                left join lostand l on p.player_id=l.loser
