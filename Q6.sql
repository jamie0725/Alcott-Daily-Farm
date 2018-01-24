SELECT fatherPrefix, fatherSuffix, cowPrefix, cowSuffix, AVG(fat)
FROM Cattle JOIN Milk ON prefix = cowPrefix AND suffix = cowSuffix
WHERE fatherPrefix IS NOT NULL
GROUP BY cowPrefix, cowSuffix
ORDER BY 5 DESC