-- Find the names of all students who are friends with someone named Gabriel.
select h1.name
from highschooler h1
inner join friend on h1.id = friend.id1
inner join highschooler h2 on h2.id = friend.id2
where h2.name = 'Gabriel';

-- For every student who likes someone 2 or more grades younger than themselves,
-- return that student's name and grade, and the name and grade of the student they like.
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1
inner join likes on h1.id = likes.id1
inner join highschooler h2 on h2.id = likes.id2
where (h1.grade - h2.grade) >= 2;

-- For every pair of students who both like each other, return the name and grade of both students.
-- Include each pair only once, with the two names in alphabetical order.
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes l1, likes l2
where (h1.id = l1.id1 and h2.id = l1.id2)
and (h2.id = l2.id1 and h1.id = l2.id2) and h1.name < h2.name
order by h1.name, h2.name;

-- Find all students who do not appear in the Likes table (as a student who likes or is liked)
-- and return their names and grades. Sort by grade, then by name within each grade.
select name, grade
from highschooler
where id not in (
	select distinct id1
	from likes
	union
	select distinct id2
	from likes
)
order by grade, name;

-- For every situation where student A likes student B, but we have no information about whom B likes
-- (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1
inner join likes on h1.id = likes.id1
inner join highschooler h2 on h2.id = likes.id2
where (h1.id = likes.id1 and h2.id = likes.id2)
and h2.id not in (
	select distinct id1
	from likes
);

-- Find names and grades of students who only have friends in the same grade.
-- Return the result sorted by grade, then by name within each grade.
select name, grade
from highschooler h1
where id not in (
	select id1
	from friend, highschooler h2
	where h1.id = friend.id1 and h2.id = friend.id2 and h1.grade <> h2.grade
)
order by grade, name;

-- For each student A who likes a student B where the two are not friends,
-- find if they have a friend C in common (who can introduce them!).
-- For all such trios, return the name and grade of A, B, and C.
select distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from highschooler h1, highschooler h2, highschooler h3, likes l, friend f1, friend F2
where (h1.id = l.id1 and h2.id = l.id2) and h2.id not in (
    select id2
    from friend
    where id1 = h1.id
) and (h1.id = f1.id1 and h3.id = f1.id2) and (h2.id = f2.id1 and h3.id = f2.id2);

-- Find the difference between the number of students in the school and the number of different first names.
select count(name) - count(distinct name)
from highschooler;

-- Find the name and grade of all students who are liked by more than one other student.
select name, grade
from highschooler
inner join likes on highschooler.id = likes.id2
group by id2
having count(*) > 1;