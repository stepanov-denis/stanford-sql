-- Find the titles of all movies directed by Steven Spielberg.
select title from movie where director='Steven Spielberg';

-- Find all years that have a movie that received a rating of 4 or 5,
-- and sort them in increasing order.
select distinct year from movie, rating
where movie.mid=rating.mid and (stars=4 or stars=5) order by year;

-- Find the titles of all movies that have no ratings.
select title from movie
except
select distinct title from movie, rating
where movie.mid=rating.mid;

-- Some reviewers didn't provide a date with their rating.
-- Find the names of all reviewers who have ratings with a NULL value for the date.
select distinct name from reviewer, rating
where reviewer.rid=rating.rid and rating.ratingdate is null;

-- Write a query to return the ratings data in a more readable format:
-- reviewer name, movie title, stars, and ratingDate.
-- Also, sort the data, first by reviewer name, then by movie title,
-- and lastly by number of stars.
select distinct reviewer.name, movie.title, rating.stars, rating.ratingdate
from reviewer, movie, rating
where reviewer.rid=rating.rid and rating.mid=movie.mid
order by reviewer.name, movie.title, rating.stars;

-- For all cases where the same reviewer rated the same movie twice
-- and gave it a higher rating the second time,
-- return the reviewer's name and the title of the movie.
select name, title
from movie
inner join rating r1 using(mid)
inner join rating r2 using(rid)
inner join reviewer using(rid) 
where r1.mid=r2.mid and r1.ratingdate < r2.ratingdate and r1.stars < r2.stars;

-- For each movie that has at least one rating,
-- find the highest number of stars that movie received.
-- Return the movie title and number of stars. Sort by movie title.
select title, max(stars)
from movie
inner join rating using(mid)
group by title
order by title;

-- For each movie, return the title and the 'rating spread',
-- that is, the difference between highest and lowest ratings given to that movie.
-- Sort by rating spread from highest to lowest, then by movie title.
select title, max(stars)-min(stars) as rating_spread
from movie
inner join rating using(mid)
group by title
order by rating_spread desc, title;

-- Find the difference between the average rating of movies
-- released before 1980 and the average rating of movies released after 1980.
-- (Make sure to calculate the average rating for each movie,
-- then the average of those averages for movies before 1980 and movies after.
-- Don't just calculate the overall average rating before and after 1980.)
select avg(before1980.avg) - avg(after1980.avg)
from (
  select avg(stars) as avg
  from movie
  inner join rating using(mid)
  where year < 1980
  group by mid
) as before1980, (
  select avg(stars) as avg
  from movie
  inner join rating using(mid)
  where year > 1980
  group by mid
) as after1980;