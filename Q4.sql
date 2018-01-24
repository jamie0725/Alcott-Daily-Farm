SELECT
motherPrefix,motherSuffix,
fatherPrefix,fatherSuffix,
COUNT(*)
FROM 
Cattle
WHERE
motherPrefix IS NOT NULL
GROUP BY motherPrefix,motherSuffix,fatherPrefix,fatherSuffix
