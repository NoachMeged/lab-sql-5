-- Drop column picture from staff.
alter table staff
drop column picture;
select * from sakila.staff;

DELETE FROM sakila.staff
WHERE staff_id BETWEEN 10 AND 13;
select * from sakila.staff;

-- populating tables
-- A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
INSERT INTO sakila.staff (store_id, first_name, last_name, email, address_id, active, username, password, last_update)
SELECT
    -- Replace with the appropriate store_id
    (SELECT customer_id FROM sakila.customer WHERE staff_id = 1 LIMIT 1),
    first_name,
    last_name,
    email,
    address_id,
    1 AS active,  -- Assuming staff members are considered active
    CONCAT(first_name,'.' , last_name) AS username,
    'your_password_hash' AS password,  
    CURRENT_TIMESTAMP AS last_update
FROM sakila.customer
WHERE
    first_name = 'Tammy' AND
    last_name = 'Sanders';
select * from sakila.staff;
-- Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1.
-- Get the inventory_id for the movie "Academy Dinosaur"
SELECT inventory_id
FROM sakila.inventory
WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = 'Academy Dinosaur' LIMIT 1)
LIMIT 1;

-- Get the customer_id for "Charlotte Hunter"
SELECT customer_id
FROM sakila.customer
WHERE first_name = 'Charlotte' AND last_name = 'Hunter'
LIMIT 1;

-- Get the staff_id for "Mike Hillyer"
SELECT staff_id
FROM sakila.staff
WHERE first_name = 'Mike' AND last_name = 'Hillyer'
LIMIT 1;

-- Add a rental for the movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1
INSERT INTO sakila.rental (rental_date, inventory_id, customer_id, staff_id, return_date)
VALUES (
    CURRENT_TIMESTAMP,  -- current date and time
    -- Replace with the correct inventory_id
    (SELECT inventory_id FROM sakila.inventory WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = 'Academy Dinosaur' LIMIT 1) LIMIT 1),
    -- Use the provided query to get the correct customer_id
    (SELECT customer_id FROM sakila.customer WHERE first_name = 'Charlotte' AND last_name = 'Hunter' LIMIT 1),
    -- Replace with the correct staff_id
    (SELECT staff_id FROM sakila.staff WHERE first_name = 'Mike' AND last_name = 'Hillyer' LIMIT 1),
    NULL  -- return_date initially set to NULL
    );
    
-- Use similar method to get inventory_id, film_id, and staff_id.

SELECT inventory_id
FROM sakila.inventory;

SELECT film_id
FROM sakila.film;

SELECT staff_id
FROM sakila.staff;

-- Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:
-- Create the backup table
CREATE TABLE deleted_users (
    backup_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    email VARCHAR(255),
    deletion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert the data into the backup table before deleting from the original table
INSERT INTO deleted_users (customer_id, email)
SELECT customer_id, email
FROM sakila.customer
WHERE active = 0;

SET SQL_SAFE_UPDATES = 0;

-- Delete the inactive users from the original table
DELETE FROM sakila.customer
WHERE active = 0;

select * from sakila.deleted_users;



