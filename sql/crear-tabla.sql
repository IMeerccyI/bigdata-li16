CREATE DATABASE IF NOT EXISTS db_nelson;

CREATE TABLE IF NOT EXISTS db_nelson.fb_nelson (
  userid BIGINT,
  age INT,
  dob_day INT,
  dob_year INT,
  dob_month INT,
  gender STRING,
  tenure INT,
  friend_count INT,
  friendships_initiated INT,
  likes INT,
  likes_received INT,
  mobile_likes INT,
  mobile_likes_received INT,
  www_likes INT,
  www_likes_received INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/hive/warehouse/pseudo_facebook_nelson.csv'
OVERWRITE INTO TABLE db_nelson.fb_nelson;
