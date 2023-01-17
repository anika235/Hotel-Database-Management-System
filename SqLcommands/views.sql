--createing view : booking_summary_by_payment_type

CREATE VIEW booking_summary_by_payment_type AS
SELECT b.booking_payment_type,
count(rb.rooms_booked_id) AS total_rooms_booked,
sum(b.total_amount) AS total_earnings
FROM hotel_database.bookings b
JOIN hotel_database.rooms_booked rb ON b.booking_id = rb.bookings_booking_id
GROUP BY b.booking_payment_type;

--------------------------------------------------------------------------------

--createing view : hotel_booking_summary

CREATE VIEW hotel_booking_summary AS
SELECT h.hotel_name,
count(b.booking_id) AS total_bookings,
sum(b.total_amount) AS total_earnings
FROM hotel_database.hotel h
JOIN hotel_database.bookings b ON h.hotel_id = b.hotel_hotel_id
GROUP BY h.hotel_name;

------------------------------------------------------------------------------------

--createing view : hotel_employees

SELECT employees.emp_first_name AS "First Name",
employees.emp_last_name AS "Last Name",
employees.emp_email_address AS "Email Address",
employees.emp_contact_number AS "Contact Number",
department.department_name AS "Department"
FROM hotel_database.employees
JOIN hotel_database.department ON department.department_id =
employees.department_department_id;

---------------------------------------------------------------------------------------

--createing view : hotel_guests

SELECT guests.guest_first_name AS "First Name",
guests.guest_last_name AS "Last Name",
guests.guest_email_address AS "Email Address",
guests.guest_contact_number AS "Contact Number",
addresses.country,addresses.state,
addresses.zipcode
FROM hotel_database.guests
JOIN hotel_database.addresses ON addresses.address_id = guests.addresses_address_id
WHERE (guests.guest_id IN ( SELECT DISTINCT bookings.guests_guest_id
FROM hotel_database.bookings
WHERE bookings.hotel_hotel_id = 1));

---------------------------------------------------------------------------------------

--createing view : hotels_in_chain_with_head_office_info

CREATE VIEW hotels_in_chain_with_head_office_info AS
SELECT h.hotel_name,
hc.hotel_chain_contact_number,
hc.hotel_chain_email_address
FROM hotel_database.hotel h
JOIN hotel_database.hotel_chain_has_hotel hchh ON h.hotel_id = hchh.hotels_hotel_id
JOIN hotel_database.hotel_chain hc ON hchh.hotel_chains_hotel_chain_id = hc.hotel_chain_id;

-------------------------------------------------------------------------------------