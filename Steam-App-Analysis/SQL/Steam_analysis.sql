-- Clean Data
--- เอาค่า NULL ออก
UPDATE steam_app_with_genre
SET __price__ = 0
WHERE __price__ ISNULL;

--- Rename column
ALTER TABLE steam_app_with_genre RENAME COLUMN __price__ TO price;
ALTER TABLE steam_app_with_genre RENAME COLUMN __average_forever__ TO average_total;
ALTER TABLE steam_app_with_genre RENAME COLUMN __average_2weeks__ TO average_2weeks;
ALTER TABLE steam_app_with_genre RENAME COLUMN _positive_ TO positive;
ALTER TABLE steam_app_with_genre RENAME COLUMN _negative_ TO negative;

--- Add new column is_free game free = 1 , paid = 0
ALTER TABLE steam_app_with_genre ADD COLUMN is_free INTEGER;

UPDATE steam_app_with_genre
SET is_free =
	CASE
    	WHEN price = 0 THEN  1
      ELSE 0
  END;



-- Analysis : Total play
--- Top 10 game most total play
SELECT name, average_total
FROM steam_app_with_genre
ORDER BY average_total DESC
LIMIT 10;

--- Top 10 free game most total play
SELECT name, average_total, is_free
FROM steam_app_with_genre
WHERE is_free = 1
ORDER BY average_total DESC
LIMIT 10;



-- Analysis : :ast 2 weeks play
--- Top 10 game most 2wks play
SELECT name, average_2weeks
FROM steam_app_with_genre
ORDER BY average_2weeks DESC
LIMIT 10;

--- Top 10 free game most 2wks play
SELECT name, average_2weeks, is_free
FROM steam_app_with_genre
WHERE is_free = 1
ORDER BY average_2weeks DESC
LIMIT 10;



-- Analysis : Price vs Time
--- Is price effect to playtime
SELECT price, average_2weeks
FROM steam_app_with_genre
WHERE price > 0
GROUP BY price
ORDER BY price;



-- Analysis : Positive review
--- Positive rate for each game
SELECT
	name,
    positive,
    (positive + negative) AS total_review,
    ROUND(100 * positive/ (positive + negative) , 2) AS percent_pos
FROM steam_app_with_genre
ORDER BY percent_pos DESC;

--- Paid game that has pos rate > 95
SELECT name, price,
	ROUND(100 * positive/ (positive + negative) , 2) AS percent_pos
FROM steam_app_with_genre
WHERE is_free = 0 AND percent_pos > 95
ORDER BY percent_pos DESC;
