-- Social media Analysis by using SQL


CREATE DATABASE socilamedia;
USE social_media;
SELECt * FROM post;
SHOW TABLES;
SELECT * FROM users;
SELECT * FROM login;
SELECT * FROM comments;



# task 1) display location from maharashtra,delhi,agra

SELECT * FROM post;
SELECT DISTINCT location FROM post WHERE location LIKE '%Maharashtra%' OR location LIKE '%Delhi%' OR location LIKE '%Agra%';

-- no Specific Location present, many city names are without stataes.
-- But from Delhi - 'The Red Fort' and From Agra - 'The Taj Mahal' are identified

# task 2) total number of post 

SELECT count(*) FROM post; 
-- Total number of posts are 100

#task 3) total number of  Users

SELECT count(*) FROM users;

-- There are 50 users curently as per given data

# task 4) average post per user

SELECT round(count(post_id)/count(DISTINCT user_id)) FROM post;

-- On an average 2 Posts are done by each user

#task 5) Display Users who has posted 5 or more posts

# solved by basic HAVING CLAUSE, but we dont get name of user
SELECT user_id,count(post_id) AS top_no_post FROM post 
GROUP BY user_id 
HAVING top_no_post >= 5;

#solved using INNER JOIN 
SELECT username,count(post_id) AS top_no_post 
FROM post p INNER JOIN users u
ON p.user_id=u.user_id
GROUP BY username 
HAVING top_no_post >= 5;


-- Ethan,Freddie,Liam,sunil are the users who have posted 5 or more Posts

#task 6) Users who have not commented on any post.

SELECT username,count(comment_id) AS comments
FROM comments c RIGHT JOIN users u
ON c.user_id=u.user_id
GROUP BY username
HAVING comments = 0;


SELECT username FROM users 
WHERE user_id NOT IN (SELECT user_id FROM comments);

-- Raj gupta has not commented yet on any post


# task 7) Trending hash tag

SELECT * FROM hashtags; 
SELECT * from hashtag_follow;

SELECT hs.hashtag_name,hsf.hashtag_id,count(hsf.hashtag_id) AS top_rated 
FROM hashtag_follow hsf INNER JOIN hashtags hs
ON hsf.hashtag_id=hs.hashtag_id
GROUP BY hashtag_id 
ORDER BY top_rated DESC LIMIT 1;
 
 -- '#festivesale' was the top used hashtag with 14 followers
 
 # task 8)  display users who dont follow anyone
 
 SELECT follower_id, count(followee_id) AS following 
 FROM follows
 GROUP BY follower_id 
 ORDER BY following DESC;
 
 SELECT * from follows;

 SELECT u.username,count(f.followee_id) AS following FROM
 follows f INNER JOIN users u
 ON f.follower_id=u.user_id 
 GROUP BY u.username 
 ORDER BY following DESC; 

SELECT user_id,username 
FROM users 
WHERE user_id NOT IN (SELECT follower_id FROM follows);
 
 -- There is NO User who is not following anyone, with '44' followings raj gupta have max followed and Theo,Ollie with least followings '32'
 
 # task 9) Most inactive User post concept
 
 SELECT u.username,count(p.post_id) 
 FROM post p RIGHT JOIN users u
 ON p.user_id=u.user_id
 GROUP BY u.username;
 
 SELECT user_id,username AS 'inactive user' FROM users
 WHERE user_id NOT IN (SELECT user_id FROM post);
 
 # task 10) Check for bot comments
 
 SELECT u.username,count(*) AS num_comment FROM 
 comments c INNER JOIN  users u
 ON u.user_id=c.user_id
 GROUP BY c.user_id
 HAVING num_comment =(SELECT count(DISTINCT post_id) FROM comments);
 
 
 #task 11) check for bot likes
 SELECT * FROM comment_likes;
 
 SELECT user_id,count(*) AS counts 
 FROM comment_likes
 GROUP BY user_id 
 ORDER BY counts DESC;
 
  SELECT u.username,count(*) AS num_comment 
  FROM comment_likes c INNER JOIN  users u
  ON u.user_id=c.user_id
  GROUP BY c.user_id
  HAVING num_comment =(SELECT count(DISTINCT comment_id) FROM comment_likes);
 
 #task 12) Display most like post
 
 SELECT * FROM post_likes;
 
 WITH cte AS (SELECT post_id,count(*) AS countlike 
 FROM post_likes 
 GROUP BY post_id
 ORDER BY countlike DESC
 LIMIT 1)
 
 SELECT post_id,user_id,caption FROM post WHERE post_id=(SELECT post_id FROM cte);
 
 
 #task 13) long time user
 
 SELECT user_id,username,created_at
 FROM users;
 
 
 #task 14) longest caption in post
 
 SELECT user_id,caption,length(caption) AS cap_len
 FROM post
 ORDER BY cap_len DESC
 LIMIT 5;
 
 #task 15) Find who has more than 40 followers
 
 
 SELECT u.username,count(f.follower_id) AS followers FROM
 follows f INNER JOIN users u
 ON f.followee_id=u.user_id 
 GROUP BY u.username
 HAVING followers > 40
 ORDER BY followers DESC
 LIMIT 5;
 
 -- 9 Followee are having more than 40 followers, and the Top 5 followee are 
 -- Charlie :45 Follower's, Harris:42 Follower's,
 -- Aaron:41 Follower's, Brodie:41 Follower's, kanavphull:41 Follower's.
 
 #task 16) Any specific word in comment
 
 SELECT * FROM comments 
 WHERE comment_text REGEXP 'good|beautyful';
 
 -- Checking 'good' and 'beautiful' in comments there are two comments with this words.
 
