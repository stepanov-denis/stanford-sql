-- For every situation where student A likes student B,
-- but student B likes a different student C,
-- return the names and grades of A, B, and C.
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from highschooler h1, highschooler h2, highschooler h3, likes l1, likes l2
where h1.id = l1.id1 and h2.id = l1.id2 and (
    h2.id = l2.id1 and h3.id = l2.id2 and h3.id <> h1.id
);

-- Find those students for whom all of their friends are in different grades from themselves.
-- Return the students' names and grades.
select name, grade
from highschooler h1
where grade not in (
    select h2.grade
    from friend, highschooler h2
    where h1.id = friend.id1 and h2.id = friend.id2
);

-- What is the average number of friends per student?
-- (Your result should be just one number.)
select avg(count)
from (
    select count(*) as count
    from friend
    group by id1
);

-- Find the number of students who are either friends with Cassandra
-- or are friends of friends of Cassandra.
-- Do not count Cassandra, even though technically she is a friend of a friend.
select count(*)
from friend
where id1 in (
    select id2
    from friend
    where id1 in (
        select id
        from highschooler
        where name = 'Cassandra'
    )
);

-- Find the name and grade of the student(s) with the greatest number of friends.
select name, grade
from highschooler
inner join friend on highschooler.id = friend.id1
group by id1
having count(*) = (
    select max(count)
    from (
        select count(*) as count
        from friend
        group by id1
    )
);