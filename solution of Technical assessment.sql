--Q1 calculating the number of movies where genre is Comedy, I used the count aggregate function and put the condition that genre is Comedy to calculate the number of Comedy movies
Select genres, count(genres) NumberOfMovies from dbo.title_basics_2018
where genres like 'Comedy'
Group by genres

----Q2 Calculating the total number of movies that were ranked 8.0 or higher, we had to do inner join to be able to put the condition that rating is higher than 8.0 and calculate the result
SELECT t1.tconst, COUNT(*) OVER () AS TotalnumOfMovies, originalTitle, numVotes, averageRating
FROM dbo.title_basics_2018 t1
JOIN dbo.title_rating t2 ON t1.tconst = t2.tconst
WHERE t2.averageRating >= 8.0 AND t1.year = 2018
GROUP BY t1.tconst, originalTitle, numVotes, averageRating
ORDER BY numVotes DESC, averageRating DESC;



---------Q3 selecting the name of the best movie based on their rating
Select top 1 originalTitle, MAX(averageRating) Ratings from dbo.title_basics_2018 t1
Join dbo.title_rating t2 on t1.tconst= t2.tconst
Group by averageRating, originalTitle
Order by averageRating Desc


--------Q4 Calculating people preference in movies based on the timing, number of votes, rating
WITH MovieCategories AS (
  SELECT
    CASE
      WHEN runtimeMinutes >= 120 THEN 'Long'
      WHEN runtimeMinutes < 120 THEN 'Short'
    END AS MovieLengthCategory,
    t2.averageRating AS Rating,
    t2.numVotes AS Votes,
    ROW_NUMBER() OVER (PARTITION BY
      CASE
        WHEN runtimeMinutes >= 120 THEN 'Long'
        WHEN runtimeMinutes < 120 THEN 'Short'
      END
      ORDER BY t2.numVotes DESC) AS RankByVotes
  FROM dbo.title_basics_2018 t1
  JOIN dbo.title_rating t2 ON t1.tconst = t2.tconst
)
SELECT
  MovieLengthCategory,
  Rating,
  Votes
FROM MovieCategories
WHERE RankByVotes = 1;


