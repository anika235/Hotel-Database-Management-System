--How many distinct guest have made bookings for a particular month?

SELECT guest_first_name, guest_last_name,guest_contact_number
FROM hotel_database.guests
WHERE guest_id IN
( SELECT distinct guests_guest_id
FROM hotel_database.bookings
WHERE EXTRACT(MONTH FROM check_in_date) = 8);

------------------------------------------------------------------------------

--How many distinct guest have made bookings for a particular month?

SELECT guest_first_name, guest_last_name,guest_contact_number
FROM hotel_database.guests
WHERE guest_id IN
( SELECT distinct guests_guest_id
FROM hotel_database.bookings
WHERE EXTRACT(MONTH FROM booking_date) = 8);

---------------------------------------------------------------------------------

--How many hotels are in a hotel chain?

SELECT count(*) AS "Total Hotels"
FROM hotel_database.hotel_chain_has_hotel
WHERE hotel_chains_hotel_chain_id = 1;

-----------------------------------------------------------------------------------

--Find all the hotels in a particular city

SELECT hotel_name
FROM hotel_database.hotel
JOIN hotel_database.addresses ON addresses.address_id = hotel.addresses_address_id
WHERE city = 'Mumbai';

------------------------------------------------------------------------------------

--Find the names and email addresses of all guests who have booked a room for more than 7 days
SELECT guest_first_name, guest_last_name, guest_email_address
FROM hotel_database.guests
JOIN hotel_database.bookings ON guests.guest_id = bookings.guests_guest_id
WHERE CAST(duration_of_stay AS INTEGER) > 7;


------------------------------------------------------------------------------------

--Find the names of all guests who have used the ’Laundry’ service

SELECT guest_first_name, guest_last_name
FROM hotel_database.guests
JOIN hotel_database.bookings ON guests.guest_id = bookings.guests_guest_id
JOIN hotel_database.hotel_services_used_by_guests ON bookings.booking_id =
hotel_services_used_by_guests.bookings_booking_id
JOIN hotel_database.hotel_services ON hotel_services_used_by_guests.hotel_services_service_id =
hotel_services.service_id
WHERE service_name = 'Laundry';

-------------------------------------------------------------------------------------

--Find the names and contact numbers of all employees who work at the hotel with ID ’1’
SELECT emp_first_name, emp_last_name, emp_contact_numberFROM hotel_database.employees
WHERE hotel_hotel_id = '1';

-------------------------------------------------------------------------------------

--Find the total number of rooms booked for each month in 2018

SELECT EXTRACT(MONTH FROM booking_date) as month, SUM(total_rooms_booked) as total_rooms_booked
FROM hotel_database.bookings
WHERE EXTRACT(YEAR FROM booking_date) = 2018
GROUP BY month;


-------------------------------------------------------------------------------------

--Find the names of all hotels that are part of the ’China Town Hotels’ chain

SELECT hotel_name
FROM hotel_database.hotel
JOIN hotel_database.hotel_chain_has_hotel ON hotel.hotel_id = hotel_chain_has_hotel.hotels_hotel_id
JOIN hotel_database.hotel_chain ON hotel_chain_has_hotel.hotel_chains_hotel_chain_id =
hotel_chain.hotel_chain_id
WHERE hotel_chain_name = 'China Town Hotels';

---------------------------------------------------------------------------------------

--Find the names of all guests who booked a room in a hotel located in a specific city

SELECT g.guest_first_name, g.guest_last_name
FROM hotel_database.guests AS g
CROSS JOIN hotel_database.bookings AS b
CROSS JOIN hotel_database.hotel AS h
CROSS JOIN hotel_database.addresses AS a
WHERE h.hotel_id = b.hotel_hotel_id AND b.guests_guest_id = g.guest_id AND h.addresses_address_id =
a.address_id AND a.city = 'Surrey';

-----------------------------------------------------------------------------------------

--Find all hotel chains and the hotels they are associated with, along with the address of the head office for each chain

SELECT hotel_chain.*, hotel_chain_has_hotel.*, addresses.*
FROM hotel_database.hotel_chain
LEFT JOIN hotel_database.hotel_chain_has_hotel ON hotel_chain.hotel_chain_id =
hotel_chain_has_hotel.hotel_chains_hotel_chain_id
LEFT JOIN hotel_database.addresses ON hotel_chain.hotel_chain_head_office_address_id =
addresses.address_id;

---------------------------------------------------------------------------------------------

--Find all bookings and the payment type, along with the name and contact information of the employee who made the booking, even if the booking was not made by an employee, and the guest’s contact information and the address of their permanent residence

SELECT bookings.*, employees.*, guests.*, addresses.*
FROM hotel_database.bookings
RIGHT JOIN hotel_database.employees ON bookings.employees_emp_id = employees.emp_id
LEFT JOIN hotel_database.guests ON bookings.guests_guest_id = guests.guest_id
LEFT JOIN hotel_database.addresses ON guests.addresses_address_id = addresses.address_id;


------------------------------------------------------------------------------------------------

--Find the names and contact numbers of guests who have booked rooms in a hotel located in a city whose name starts with ’S’ and have used the hotel’s ’Laundry’ service

SELECT guest_first_name, guest_last_name, guest_contact_number
FROM hotel_database.guests
WHERE guest_id IN
(SELECT guests_guest_id FROM hotel_database.bookings
WHERE hotel_hotel_id IN
(SELECT hotel_id FROM hotel_database.hotel
WHERE addresses_address_id IN
(SELECT address_id FROM hotel_database.addresses
WHERE city LIKE 'S%'))
AND booking_id IN
(SELECT bookings_booking_id FROM hotel_database.hotel_services_used_by_guests
WHERE hotel_services_service_id IN
(SELECT service_id FROM hotel_database.hotel_services
WHERE service_name = 'Laundry')))

-----------------------------------------------------------------------------------------------------

--Find the names and contact numbers of guests who have booked rooms in a hotel located in a city whose name starts with ’S’ or ’C’

SELECT guest_first_name, guest_last_name, guest_contact_number
FROM hotel_database.guests
WHERE guest_id IN
(SELECT guests_guest_id FROM hotel_database.bookings
WHERE hotel_hotel_id IN
(SELECT hotel_id FROM hotel_database.hotel
WHERE addresses_address_id IN
(SELECT address_id FROM hotel_database.addresses
WHERE city LIKE ANY (array['S%', 'C%']))))

------------------------------------------------------------------------------------------------------------------

--Find all the guests who have used the service "Laundry" during their stay at the hotel

SELECT g.*
FROM hotel_database.guests g
WHERE EXISTS (
SELECT 1
FROM hotel_database.hotel_services_used_by_guests hsug
JOIN hotel_database.hotel_services hs ON hsug.hotel_services_service_id = hs.service_id
WHERE hs.service_name = 'Laundry'
AND hsug.bookings_booking_id IN (
SELECT b.booking_id
FROM hotel_database.bookings b
WHERE b.guests_guest_id = g.guest_id
)
);

--------------------------------------------------------------------------------------------------

--Find all the guests who have used a unique service at least once during their stay at the hotel

SELECT DISTINCT g.*
FROM hotel_database.guests g
WHERE EXISTS (SELECT 1
FROM hotel_database.hotel_services_used_by_guests hsug
WHERE hsug.bookings_booking_id IN (
SELECT b.booking_id
FROM hotel_database.bookings b
WHERE b.guests_guest_id = g.guest_id
)
GROUP BY hsug.bookings_booking_id
HAVING COUNT(DISTINCT hsug.hotel_services_service_id) = 1
);

------------------------------------------------------------------------------------------------------------

--Set the check-out time for all hotels to 11:00 AM

UPDATE hotel_database.hotel
SET chek_out_time = '11:00:00';

----------------------------------------------------------------------------------------------------

--Delete all hotel chains that don’t have any hotels associated with them

DELETE
FROM hotel_database.hotel_chain
WHERE hotel_chain_id NOT IN (
SELECT hotel_chains_hotel_chain_id
FROM hotel_database.hotel_chain_has_hotel);
