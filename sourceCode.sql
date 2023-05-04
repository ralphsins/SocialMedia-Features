

CREATE TABLE USERS(
   user_id INT IDENTITY(1,1),
   username varchar(30) NOT NULL,
   email varchar(50) NOT NULL UNIQUE,
   profile_pic varchar(50) DEFAULT 'user.png',
   password varchar(30) NOT NULL,
   isPublic BIT DEFAULT 1,
   PRIMARY KEY(user_id)
);
CREATE TABLE PERSONAL_DETAILS( 
  personal_details_id INT IDENTITY(1,1) not null,
  user_id INT UNIQUE NOT NULL,
  about varchar(200),
  education varchar(100),
  address varchar(50),
  FOREIGN KEY (user_id) REFERENCES USERS(user_id) on delete cascade on update cascade
);


-- STORY SYSTEM
CREATE TABLE STORY(
    story_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
	pic_path varchar(30),
	video_path varchar(30),
	pushed_at DATE DEFAULT getDate(),
	FOREIGN KEY(user_id) REFERENCES USERS(user_id),
);
CREATE TABLE REPLIED_USER(
    id INT IDENTITY(1,1)  PRIMARY KEY,
    user_id INT NOT NULL,
	story_id INT NOT NULL,
	content varchar(100) NOT NULL,
	FOREIGN KEY(user_id) REFERENCES USERS(user_id),
	FOREIGN KEY(story_id) REFERENCES STORY(story_id)
);

CREATE TABLE LIKED_USER(
    user_id INT NOT NULL,
	story_id INT NOT NULL,
	PRIMARY KEY(user_id,story_id),
	FOREIGN KEY(user_id) REFERENCES USERS(user_id),
	FOREIGN KEY(story_id) REFERENCES STORY(story_id)
);

-- FOLLOWING SYSTEM
CREATE TABLE USER_FRIEND(
    follower_id INT Identity(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    follower_user_id INT NOT NULL,
    valid_type VARCHAR(30) CHECK (valid_type IN ('Follow', 'delete')),
	createdAt Date default getDate(),
	updatedAt Date default getDate(),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (follower_user_id) REFERENCES USERS(user_id),
);

ALTER TABLE USER_FRIEND ADD status varchar(10) CHECK(status in('pending','accepted','rejected')) DEFAULT 'pending';
DROP table USER_FRIEND

-- MESSAGING SYSTEM
CREATE TABLE USER_MESSAGE(
    message_id INT Identity(1,1) PRIMARY KEY,
    sender_id INT NOT NULL,
    target_id INT NOT NULL,
    message VARCHAR(30),
	createdAt Date default getDate(),
	updatedAt Date default getDate(),
    FOREIGN KEY (sender_id) REFERENCES USERS(user_id),
    FOREIGN KEY (target_id) REFERENCES USERS(user_id),
);



-- POSTING SYSTEM
CREATE TABLE USER_POST (
	post_id INT IDENTITY(1,1) PRIMARY KEY,
	user_id INT NOT NULL,
	picture_path varchar(50),
	video_path varchar(50),
	description varchar(50) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES USERS(user_id),
)
CREATE TABLE POST_COMMENT (
	id INT IDENTITY(1,1)  PRIMARY KEY,
    user_id INT NOT NULL,
	post_id INT NOT NULL,
	content varchar(100) NOT NULL,
	FOREIGN KEY(user_id) REFERENCES USERS(user_id),
	FOREIGN KEY(post_id) REFERENCES USER_POST(post_id)
)
CREATE TABLE LIKED_USER_POST(
    user_id INT NOT NULL,
	post_id INT NOT NULL,
	PRIMARY KEY(user_id,post_id),
	FOREIGN KEY(user_id) REFERENCES USERS(user_id),
	FOREIGN KEY(post_id) REFERENCES USER_POST(post_id)
);
-- POLL SYSTEM
CREATE TABLE POLL (
   poll_id INT IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   question varchar(200) NOT NULL,
   start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
   end_time DATETIME NOT NULL,
   FOREIGN KEY(user_id) REFERENCES USERS(user_id)
);

CREATE TABLE POLL_OPTION (
   option_id INT IDENTITY(1,1) PRIMARY KEY,
   poll_id INT NOT NULL,
   option_text varchar(200) NOT NULL,
   FOREIGN KEY(poll_id) REFERENCES POLL(poll_id)
);
CREATE TABLE POLL_VOTE (
   vote_id INT IDENTITY(1,1) PRIMARY KEY,
   poll_id INT NOT NULL,
   option_id INT NOT NULL,
   user_id INT NOT NULL,
   FOREIGN KEY(poll_id) REFERENCES POLL(poll_id),
   FOREIGN KEY(option_id) REFERENCES POLL_OPTION(option_id),
   FOREIGN KEY(user_id) REFERENCES USERS(user_id)
);
-- Event system
CREATE TABLE EVENTS (
   event_id INT IDENTITY(1,1) PRIMARY KEY,
   title varchar(50) NOT NULL,
   description varchar(200) NOT NULL,
   location varchar(50) NOT NULL,
   start_date DATETIME NOT NULL,
   end_date DATETIME NOT NULL,
   creator_id INT NOT NULL,
   FOREIGN KEY (creator_id) REFERENCES USERS(user_id)
);

-- USER WITH PERSONAL DETAILS
-- INSERTION
INSERT INTO USERS (username, email, password) VALUES ('john', 'john@example.com', 'password');
INSERT INTO USERS (username, email, password) VALUES ('mikel', 'mikel@example.com', 'password');
INSERT INTO USERS (username, email, password) VALUES ('Ahmad', 'ahmad@example.com', 'password');

--procedure for insertion of users
CREATE PROCEDURE insert_user
    @username VARCHAR(50),
    @email VARCHAR(50),
    @password VARCHAR(50)
AS
BEGIN
    INSERT INTO USERS (username, email, password)
    VALUES (@username, @email, @password);
END

-- UPDATE
UPDATE USERS SET email = 'new_email@example.com' WHERE user_id = 2;
-- DELETE
CREATE PROCEDURE delete_user 
     @user_id INT
AS 
BEGIN 
DELETE FROM USERS WHERE user_id = @user_id;
END

EXEC delete_user 3
  

--procedure for get all users
CREATE PROCEDURE get_ALL_USERS
AS
BEGIN
    SELECT * FROM USERS
END
EXEC get_ALL_USERS
-- RETRIEVE all users
SELECT * FROM USERS

-- INSERTION
INSERT INTO PERSONAL_DETAILS (user_id,about, education, address)
VALUES (1,'software engineer backend specialist', 'Computer Science', '123 Main St, Anytown USA');



-- UPDATE PERSONAL DETAILS TO SPECIFIC USER
UPDATE PERSONAL_DETAILS 
SET about='I am a solution architect',
education='Aws practioner',
address='Hon kong'
WHERE user_id=1

-- RETIREVE
SELECT * FROM PERSONAL_DETAILS

-- RETRIEVE TO A SPECIFIC USER
SELECT p.about,p.address,p.education ,p.personal_details_id FROM PERSONAL_DETAILS as p 
INNER JOIN USERS as u 
ON u.user_id = p.user_id
WHERE u.user_id=1

-- DELETE personal_details for a specific user
DELETE  FROM PERSONAL_DETAILS
WHERE user_id=1



--Function of story system
-- CREATE A STORY (IMAGE) BY THE USER

INSERT INTO STORY(user_id,pic_path)
VALUES (1,'background.png');


-- CREATE A STORY (Video) BY THE USER
INSERT INTO STORY(user_id,video_path)
VALUES (1,'background.mp4');

-- GET STORY TO A SPECIFIC USER
SELECT * FROM STORY WHERE user_id=1
-- optional 
SELECT * FROM STORY WHERE user_id=1
AND pic_path is NOT NULL

-- DELETE STORY
DELETE FROM STORY WHERE user_id=1

-- REPLY TO A USER
INSERT INTO REPLIED_USER (user_id, story_id, content)
SELECT 1, 3, 'great background'
WHERE NOT EXISTS (
  SELECT 1 FROM STORY
  WHERE story_id = 3 AND user_id = 1
);

-- GET THE USER REPLIES
SELECT r.content FROM REPLIED_USER as r
join STORY as s on s.story_id = r.story_id
join USERS as u on u.user_id = r.user_id

--Get the user replies
CREATE PROCEDURE getReplies 
AS 
BEGIN 
        SELECT r.content FROM REPLIED_USER as r
		join STORY as s on s.story_id = r.story_id
		join USERS as u on u.user_id = r.user_id
END

--Liked
INSERT INTO LIKED_USER (user_id, story_id)
SELECT 3, 1
WHERE NOT EXISTS (
  SELECT * FROM STORY
  WHERE story_id = 1 AND user_id = 3
);
-- Unlike
DELETE FROM LIKED_USER 
WHERE user_id = 2 AND story_id = 3

-- get the names of the persons who liked the story
SELECT u.username FROM LIKED_USER as l
JOIN STORY as s on l.story_id = s.story_id
JOIN USERS as u on u.user_id = l.user_id and s.story_id=1


--get the total number of likes for a specific story
SELECT COUNT(*) 'number of  likes' from LIKED_USER AS L
JOIN STORY AS s on L.story_id=s.story_id
AND s.user_id=1 AND s.story_id=1

select * from LIKED_USER
select * from STORY


--follow a user
IF EXISTS (
	SELECT 1 FROM USER_FRIEND
	WHERE user_id = 1
	AND
	follower_user_id=2
)
BEGIN 
UPDATE USER_FRIEND
SET valid_type = 
    CASE valid_type
       WHEN 'Follow' THEN 'delete'
    END,
    updatedAt = getDate()
WHERE user_id = 1
AND follower_user_id = 2

DELETE from USER_FRIEND where user_id=1 and follower_user_id=2 and valid_type='delete'
END
ELSE 
BEGIN
INSERT INTO USER_FRIEND (user_id,follower_user_id,valid_type) VALUES (1,2,'Follow')
END

--return the username of requests 
SELECT u.username FROM USER_FRIEND as uf
JOIN USERS as u ON u.user_id=uf.user_id
and uf.follower_user_id=2 and uf.status='pending';

--return the count of requests
SELECT COUNT(*) 'nb of followers' FROM USER_FRIEND as uf
JOIN USERS as u on u.user_id=uf.user_id
and uf.follower_user_id=2 and uf.status='pending';

--return the count of followers
SELECT COUNT(*) 'nb of followers' FROM USER_FRIEND as uf
JOIN USERS as u on u.user_id=uf.user_id
and uf.follower_user_id=2 and uf.status='accepted';

--procedure for returning the number of followers
CREATE PROCEDURE return_NUMBER_OF_FOLLOWERS 
    @follower_user_id INT
AS
BEGIN
   SELECT COUNT(*) 'nb of followers' FROM USER_FRIEND as uf
	JOIN USERS as u on u.user_id=uf.user_id
	and uf.follower_user_id=@follower_user_id and uf.status='accepted';
END

EXEC return_NUMBER_OF_FOLLOWERS 2

--return username of followers
SELECT u.username FROM USER_FRIEND as uf
JOIN USERS as u ON u.user_id=uf.user_id
and uf.follower_user_id=2 and uf.status='accepted';

--accept the follow for a specific user
UPDATE USER_FRIEND SET status='accepted' where follower_user_id=2 and user_id=1
--accept all requests
UPDATE USER_FRIEND SET status='accepted' where follower_user_id=2 and user_id=1
--reject a specific user
UPDATE USER_FRIEND SET status='rejected' where follower_user_id=2 and user_id=1

--option1

IF EXISTS(
    SELECT 1 from USER_FRIEND 
	where follower_user_id=2
	and user_id=1
)
BEGIN
UPDATE USER_FRIEND set status=
    CASE status
	WHEN 'pending' THEN 'rejected'
    WHEN 'accepted' THEN 'rejected'
	END
	where user_id=1 and follower_user_id=2
DELETE from USER_FRIEND where status='rejected';
END

--option2
DELETE from USER_FRIEND where user_id=1 and follower_user_id=2;


--accept a user
UPDATE USER_FRIEND SET valid_type = 'Follow' Where user_id = 1 and follower_user_id = 2

--retreive tables
SELECT * from USER_FRIEND;
SELECT * from USERS


---messaging system
--send a message
INSERT INTO USER_MESSAGE(sender_id,target_id,message) VALUES (1,3,'Hi Ahmad,are you fine');
INSERT INTO USER_MESSAGE(sender_id,target_id,message) VALUES (1,3,'Hi Ahmad');
INSERT INTO USER_MESSAGE(sender_id,target_id,message) VALUES (2,3,'Hi mustafa');

--delete a message
DELETE FROM USER_MESSAGE WHERE message_id=2;

--getAll messages between two users
SELECT * from USER_MESSAGE where sender_id=1 and target_id=3;

--get list of messaging user
SELECT DISTINCT u.username from USER_MESSAGE as us
JOIN USERS as u ON u.user_id=us.sender_id
where us.target_id=3

--debugging purposes
SELECT * FROM users
SELECT * FROM USER_MESSAGE