CREATE DATABASE footballmanager;
USE footballmanager;


CREATE TABLE TEAMS(
	team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL,
    founded_year INT  NOT NULL ,
    stadium VARCHAR(100) NOT NULL ,
    ranking_position INT DEFAULT 0

);


CREATE TABLE COACHES(
	coach_Id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    experience_years INT DEFAULT 0 ,
    team_id INT ,
    foreign key (team_id) references TEAMS(team_id)

);


CREATE TABLE PLAYERS(
	player_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    jersey_number INT NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(12,2) NOT NULL,
	team_id INT ,
    foreign key (team_id) references TEAMS(team_id)
    

);


CREATE TABLE MATCHES(
	match_id INT PRIMARY KEY AUTO_INCREMENT,
    match_date DATETIME NOT NULL,
    home_team_id INT ,
    away_team_id INT ,
    foreign key (home_team_id) references TEAMS(team_id),
	foreign key (away_team_id) references TEAMS(team_id),
    stadium VARCHAR(100) NOT NULL,
    match_status VARCHAR(30) DEFAULT 'Scheduled'

);


CREATE TABLE PLAYER_STATISTICS(
	stat_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT ,
    foreign key (player_id) references PLAYERS(player_id),
    match_id INT ,
	foreign key (match_id) references MATCHES(match_id),
    goals INT DEFAULT 0,
    assists INT DEFAULT 0 ,
    yellow_cards INT DEFAULT 0 ,
    rating_score DECIMAL(3,1) DEFAULT 0
    
);



INSERT INTO TEAMS(team_id , team_name,founded_year,stadium,ranking_position)
VALUES 
(1 , 'Manchester City','1880','Etihad Stadium',1),
(2 , 'Real Madrid','1902','Santiago Bernabeu',2),
(3 , 'Hanoi FC','2006','Hang Day Stadium',3),
(4 , 'Saigon United','2015','Thong nhat stadium',5),
(5 , 'Thep xanh Nam Dinh','1979','Thien Truong Stadium Stadium',10);


INSERT INTO COACHES(coach_id , full_name , nationality , experience_years , team_id)
VALUES
(1 , 'Pep Guardiola' ,'Spanish' , 15 , 1),
(2 , 'Carlo Ancelotti','Italian', 25 , 2),
(3 , 'Chu Dinh Nghiem','Vietnamese',12,3),
(4,'Alexandre Polking','German-Brazilian',10,4),
(5,'Park Hang-seo','Korean',30 , 5);


INSERT INTO PLAYERS(player_id , full_name , jersey_number , position , salary , team_id) 
VALUES 
(1 ,'Erling Haaland' ,9,'Forward', 450000000,1),
(2,'Kevin De Bruyne',17,'Midfielder',400000000,1),
(3,'Nguyen Quan Hai',19,'Midfielder',60000000,3),
(4,'Kylian Mbappe',7,'Forward',600000000,2),
(5,'Nguyen Van Quyet',10,'Forward',55000000,3),
(6,'Nguyen Van C',10,'Forward',4500,3);


INSERT INTO MATCHES (match_id , home_team_id , away_team_id , match_date , stadium , match_status )
VALUES
(1,1,2,'2026-05-10 19:00','Etihad Stadium','Finished'),
(2,3,4,'2026-05-12 18:30','Hang Day Stadium','Finished'),
(3,5,1,'2026-05-15 20:00','Thien Truong Stadium','Scheduled'),
(4,2,3,'2026-05-20 21:00','Santiago Bernabeu','Scheduled'),
(5,4,5,'2026-05-25 17:00','Thong Nhat Stadium','Scheduled');



INSERT INTO PLAYER_STATISTICS(stat_id , player_id , match_id , goals , assists , yellow_cards , rating_score) 
VALUES 
(1,1,1,2,1,0,9.5),
(2,4,1,1,0,1,8.2),
(3,3,2,0,2,0,8.5),
(4,5,2,3,0,0,9.0),
(5,1,4,0,0,3,5.0);



-- VIET CAU LENH TANG LUONG CHO CAC CAU THU 
UPDATE PLAYERS
SET salary = salary * 1.05
WHERE position = 'Forward' ;


-- xoa ban ghi cau thu so the vang lon hon 2

DELETE FROM PLAYER_STATISTICS
WHERE yellow_cards > 2;

-- LIET KE CAC THONG TIN cau thu

SELECT full_name , jersey_number , position 
FROM PLAYERS 
WHERE salary > 50000000 OR position = 'Midfielder' ;


-- LIET KE CAC THONG TIN DOI BONG GOM DOI CO THU HANG 1 DEN 5 VA TEN SAN BAT DAU BANG S

SELECT team_name , stadium 
FROM TEAMS 
WHERE (ranking_position BETWEEN 1 AND 5 ) AND stadium LIKE 'S%';

-- LIET KE THONG TIN TRAN DAU 

SELECT match_id , stadium , match_date 
FROM MATCHES 
ORDER BY match_date DESC
LIMIT 3
OFFSET 2;

-- LIET KE THONG TIN CAU THU 

SELECT P.full_name , T.team_name , PS.goals , PS.assists
FROM PLAYERS P 
JOIN TEAMS T ON P.team_id = T.team_id 
JOIN PLAYER_STATISTICS PS ON P.player_id = PS.player_id;


-- LIET KE THONG TIN DOI BONG 

-- SELECT team_name , SUM()
-- FROM TEAMS
-- WHERE


-- liet ke thong tin cau thu gom muc luong cao nhat

SELECT player_id , full_name , salary 
FROM PLAYERS 
WHERE salary = 
(SELECT MAX(salary) 
FROM PLAYERS);


-- TAO MOT CHI MUC 

CREATE INDEX idx_players ON PLAYERS(position,salary);


-- tao mot view
-- CREATE VIEW viewTeam AS
 	-- SELECT team_name , COUNT(team_id) FROM TEAMS 
--     WHERE team_id = (SELECT COUNT(team_id) FROM PLAYERS)
--     GROUP BY team_name
  

-- trigger  tu dong tang luong cau thu tuong ung them 5%
DELIMITER //

CREATE TRIGGER updateSalaryplayer 
AFTER INSERT 
ON PLAYER_STATISTICS
FOR EACH ROW
BEGIN
	IF goals > 10 THEN 
		UPDATE PLAYERS PS
		SET salary = salary * 1.05
		WHERE P.player_id = PS.player_id;
	END IF;


END //

DELIMITER ;

DROP TRIGGER updateSalaryplayer;

SELECT * FROM PLAYERS;


UPDATE PLAYER_STATISTICS
SET goals = goals + 69
WHERE player_id = 1;
SELECT * FROM PLAYER_STATISTICS;


-- stored procedure 

DELIMITER //

CREATE PROCEDURE rankingCheck(
	IN inputPlayer_ID INT,
    OUT message_v VARCHAR(100))
proc : BEGIN 
	DECLARE v_goals INT;
	SELECT goals INTO v_goals FROM PLAYER_STATISTICS
    WHERE inputPlayer_ID = player_id;
	IF v_goals < 10 THEN
		SET message_v = 'Average';
	ELSEIF v_goals BETWEEN 10 AND 20 THEN
		SET message_v = 'Good';
	ELSEIF v_goals > 20 THEN 
		SET message_v = 'Excellent';
	END IF;
  
END //

DELIMITER ;


