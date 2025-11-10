/* - Delete bad jokes
- Make sure which to delete
do a select first to double check the rows
*/
SELECT
    *
FROM
    funny_jokes
WHERE
    rating < 5;

-- after checking the right joke to delete, proceed to delete

DELETE FROM funny_jokes
WHERE
    rating < 5;