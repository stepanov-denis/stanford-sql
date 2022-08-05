-- Add the reviewer Roger Ebert to your database, with an rID of 209.
insert into reviewer (rid, name) values (209, 'Roger Ebert');

-- For all movies that have an average rating of 4 stars or higher,
-- add 25 to the release year.
-- (Update the existing tuples; don't insert new tuples.)
update movie
set year = year + 25
where mid in (
    select mid
    from movie
    inner join rating using(mid)
    group by mid
    having avg(stars) >= 4
);

-- Remove all ratings where the movie's year is before 1970 or after 2000,
-- and the rating is fewer than 4 stars.
delete from rating
where mid in (
    select mid
    from movie
    where year < 1970 or year > 2000
) and stars < 4;