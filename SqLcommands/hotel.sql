-- Database: hotel management

-- DROP DATABASE IF EXISTS "hotel management";

CREATE DATABASE "hotel management"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


------------------------------------------------------------------------
-- SCHEMA: hotel_database

-- DROP SCHEMA IF EXISTS hotel_database ;

CREATE SCHEMA IF NOT EXISTS hotel_database
    AUTHORIZATION postgres;

-----------------------------------------------------------------------

-- Table: hotel_database.addresses

-- DROP TABLE IF EXISTS hotel_database.addresses;

CREATE TABLE IF NOT EXISTS hotel_database.addresses
(
    address_id integer NOT NULL,
    address_line1 character varying(100) COLLATE pg_catalog."default",
    address_line2 character varying(100) COLLATE pg_catalog."default",
    city character varying(45) COLLATE pg_catalog."default",
    state character varying(45) COLLATE pg_catalog."default",
    country character varying(45) COLLATE pg_catalog."default",
    zipcode character varying(8) COLLATE pg_catalog."default",
    CONSTRAINT addresses_pkey PRIMARY KEY (address_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.addresses
    OWNER to postgres;

--------------------------------------------------------------------------

-- Table: hotel_database.bookings

-- DROP TABLE IF EXISTS hotel_database.bookings;

CREATE TABLE IF NOT EXISTS hotel_database.bookings
(
    booking_id integer NOT NULL,
    booking_date date,
    duration_of_stay character varying(10) COLLATE pg_catalog."default",
    check_in_date date,
    check_out_date date,
    booking_payment_type character varying(45) COLLATE pg_catalog."default",
    total_rooms_booked integer,
    hotel_hotel_id integer NOT NULL,
    guests_guest_id integer NOT NULL,
    employees_emp_id integer NOT NULL,
    total_amount numeric(10,2),
    CONSTRAINT bookings_pkey PRIMARY KEY (booking_id, hotel_hotel_id, guests_guest_id, employees_emp_id),
    CONSTRAINT bookings_id UNIQUE (booking_id),
    CONSTRAINT fk_bookings_employees1 FOREIGN KEY (employees_emp_id)
        REFERENCES hotel_database.employees (emp_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_bookings_guests1 FOREIGN KEY (guests_guest_id)
        REFERENCES hotel_database.guests (guest_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_bookings_hotel1 FOREIGN KEY (hotel_hotel_id)
        REFERENCES hotel_database.hotel (hotel_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.bookings
    OWNER to postgres;
-- Index: fk_bookings_employees1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_bookings_employees1_idx;

CREATE INDEX IF NOT EXISTS fk_bookings_employees1_idx
    ON hotel_database.bookings USING btree
    (employees_emp_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_bookings_guests1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_bookings_guests1_idx;

CREATE INDEX IF NOT EXISTS fk_bookings_guests1_idx
    ON hotel_database.bookings USING btree
    (guests_guest_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_bookings_hotel1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_bookings_hotel1_idx;

CREATE INDEX IF NOT EXISTS fk_bookings_hotel1_idx
    ON hotel_database.bookings USING btree
    (hotel_hotel_id ASC NULLS LAST)
    TABLESPACE pg_default;


---------------------------------------------------------------------

-- Table: hotel_database.department

-- DROP TABLE IF EXISTS hotel_database.department;

CREATE TABLE IF NOT EXISTS hotel_database.department
(
    department_id integer NOT NULL,
    department_name character varying(45) COLLATE pg_catalog."default",
    department_description character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT department_pkey PRIMARY KEY (department_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.department
    OWNER to postgres;

----------------------------------------------------------------------------

-- Table: hotel_database.employees

-- DROP TABLE IF EXISTS hotel_database.employees;

CREATE TABLE IF NOT EXISTS hotel_database.employees
(
    emp_id integer NOT NULL,
    emp_first_name character varying(45) COLLATE pg_catalog."default",
    emp_last_name character varying(45) COLLATE pg_catalog."default",
    emp_designation character varying(45) COLLATE pg_catalog."default",
    emp_contact_number character varying(12) COLLATE pg_catalog."default",
    emp_email_address character varying(45) COLLATE pg_catalog."default",
    department_department_id integer NOT NULL,
    addresses_address_id integer NOT NULL,
    hotel_hotel_id integer NOT NULL,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_id, department_department_id, addresses_address_id, hotel_hotel_id),
    CONSTRAINT "hotel management" UNIQUE (emp_id),
    CONSTRAINT fk_employees_addresses1 FOREIGN KEY (addresses_address_id)
        REFERENCES hotel_database.addresses (address_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_employees_hotel1 FOREIGN KEY (hotel_hotel_id)
        REFERENCES hotel_database.hotel (hotel_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_employees_services1 FOREIGN KEY (department_department_id)
        REFERENCES hotel_database.department (department_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.employees
    OWNER to postgres;
-- Index: fk_employees_addresses1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_employees_addresses1_idx;

CREATE INDEX IF NOT EXISTS fk_employees_addresses1_idx
    ON hotel_database.employees USING btree
    (addresses_address_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_employees_hotel1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_employees_hotel1_idx;

CREATE INDEX IF NOT EXISTS fk_employees_hotel1_idx
    ON hotel_database.employees USING btree
    (hotel_hotel_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_employees_services1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_employees_services1_idx;

CREATE INDEX IF NOT EXISTS fk_employees_services1_idx
    ON hotel_database.employees USING btree
    (department_department_id ASC NULLS LAST)
    TABLESPACE pg_default;


---------------------------------------------------------------------------------


-- Table: hotel_database.guests

-- DROP TABLE IF EXISTS hotel_database.guests;

CREATE TABLE IF NOT EXISTS hotel_database.guests
(
    guest_id integer NOT NULL,
    guest_first_name character varying(45) COLLATE pg_catalog."default",
    guest_last_name character varying(45) COLLATE pg_catalog."default",
    guest_contact_number character varying(12) COLLATE pg_catalog."default",
    guest_email_address character varying(45) COLLATE pg_catalog."default",
    guest_credit_card character varying(45) COLLATE pg_catalog."default",
    guest_id_proof character varying(45) COLLATE pg_catalog."default",
    addresses_address_id integer NOT NULL,
    CONSTRAINT guests_pkey PRIMARY KEY (guest_id, addresses_address_id),
    CONSTRAINT hotelmanagements UNIQUE (guest_id),
    CONSTRAINT fk_guests_addresses1 FOREIGN KEY (addresses_address_id)
        REFERENCES hotel_database.addresses (address_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.guests
    OWNER to postgres;
-- Index: fk_guests_addresses1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_guests_addresses1_idx;

CREATE INDEX IF NOT EXISTS fk_guests_addresses1_idx
    ON hotel_database.guests USING btree
    (addresses_address_id ASC NULLS LAST)
    TABLESPACE pg_default;


--------------------------------------------------------------------------------


-- Table: hotel_database.hotel

-- DROP TABLE IF EXISTS hotel_database.hotel;

CREATE TABLE IF NOT EXISTS hotel_database.hotel
(
    hotel_id integer NOT NULL,
    hotel_name character varying(45) COLLATE pg_catalog."default",
    hotel_contact_number character varying(12) COLLATE pg_catalog."default",
    hotel_email_address character varying(45) COLLATE pg_catalog."default",
    hotel_website character varying(45) COLLATE pg_catalog."default",
    hotel_description character varying(100) COLLATE pg_catalog."default",
    hotel_floor_count integer,
    hotel_room_capacity integer,
    hotel_chain_id integer,
    addresses_address_id integer NOT NULL,
    star_ratings_star_rating integer NOT NULL,
    check_in_time time without time zone,
    check_out_time time without time zone,
    CONSTRAINT hotel_pkey PRIMARY KEY (hotel_id, addresses_address_id, star_ratings_star_rating),
    CONSTRAINT hotelmanagement UNIQUE (hotel_id),
    CONSTRAINT fk_hotel_star_ratings1 FOREIGN KEY (star_ratings_star_rating)
        REFERENCES hotel_database.star_ratings (star_rating) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_hotels_addresses1 FOREIGN KEY (addresses_address_id)
        REFERENCES hotel_database.addresses (address_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.hotel
    OWNER to postgres;
-- Index: fk_hotel_star_ratings1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotel_star_ratings1_idx;

CREATE INDEX IF NOT EXISTS fk_hotel_star_ratings1_idx
    ON hotel_database.hotel USING btree
    (star_ratings_star_rating ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_hotels_addresses1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotels_addresses1_idx;

CREATE INDEX IF NOT EXISTS fk_hotels_addresses1_idx
    ON hotel_database.hotel USING btree
    (addresses_address_id ASC NULLS LAST)
    TABLESPACE pg_default;


------------------------------------------------------------------------------------------

-- Table: hotel_database.hotel_chain

-- DROP TABLE IF EXISTS hotel_database.hotel_chain;

CREATE TABLE IF NOT EXISTS hotel_database.hotel_chain
(
    hotel_chain_id integer NOT NULL,
    hotel_chain_name character varying(45) COLLATE pg_catalog."default",
    hotel_chain_contact_number character varying(12) COLLATE pg_catalog."default",
    hotel_chain_email_address character varying(45) COLLATE pg_catalog."default",
    hotel_chain_website character varying(45) COLLATE pg_catalog."default",
    hotel_chain_head_office_address_id integer NOT NULL,
    CONSTRAINT hotel_chain_pkey PRIMARY KEY (hotel_chain_id, hotel_chain_head_office_address_id),
    CONSTRAINT hotel_chains UNIQUE (hotel_chain_id),
    CONSTRAINT fk_hotel_chains_addresses1 FOREIGN KEY (hotel_chain_head_office_address_id)
        REFERENCES hotel_database.addresses (address_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.hotel_chain
    OWNER to postgres;
-- Index: fk_hotel_chains_addresses1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotel_chains_addresses1_idx;

CREATE INDEX IF NOT EXISTS fk_hotel_chains_addresses1_idx
    ON hotel_database.hotel_chain USING btree
    (hotel_chain_head_office_address_id ASC NULLS LAST)
    TABLESPACE pg_default;


-------------------------------------------------------------------------------------------


-- Table: hotel_database.hotel_chain_has_hotel

-- DROP TABLE IF EXISTS hotel_database.hotel_chain_has_hotel;

CREATE TABLE IF NOT EXISTS hotel_database.hotel_chain_has_hotel
(
    hotel_chains_hotel_chain_id integer NOT NULL,
    hotels_hotel_id integer NOT NULL,
    CONSTRAINT hotel_chain_has_hotel_pkey PRIMARY KEY (hotel_chains_hotel_chain_id, hotels_hotel_id),
    CONSTRAINT fk_hotel_chains_has_hotels_hotel_chains1 FOREIGN KEY (hotel_chains_hotel_chain_id)
        REFERENCES hotel_database.hotel_chain (hotel_chain_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_hotel_chains_has_hotels_hotels1 FOREIGN KEY (hotels_hotel_id)
        REFERENCES hotel_database.hotel (hotel_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.hotel_chain_has_hotel
    OWNER to postgres;
-- Index: fk_hotel_chains_has_hotels_hotel_chains1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotel_chains_has_hotels_hotel_chains1_idx;

CREATE INDEX IF NOT EXISTS fk_hotel_chains_has_hotels_hotel_chains1_idx
    ON hotel_database.hotel_chain_has_hotel USING btree
    (hotel_chains_hotel_chain_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_hotel_chains_has_hotels_hotels1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotel_chains_has_hotels_hotels1_idx;

CREATE INDEX IF NOT EXISTS fk_hotel_chains_has_hotels_hotels1_idx
    ON hotel_database.hotel_chain_has_hotel USING btree
    (hotels_hotel_id ASC NULLS LAST)
    TABLESPACE pg_default;


---------------------------------------------------------------------------------------

-- Table: hotel_database.hotel_services

-- DROP TABLE IF EXISTS hotel_database.hotel_services;

CREATE TABLE IF NOT EXISTS hotel_database.hotel_services
(
    service_id integer NOT NULL,
    service_name character varying(45) COLLATE pg_catalog."default",
    service_description character varying(100) COLLATE pg_catalog."default",
    service_cost numeric(10,2),
    hotel_hotel_id integer NOT NULL,
    CONSTRAINT hotel_services_pkey PRIMARY KEY (service_id, hotel_hotel_id),
    CONSTRAINT services_id UNIQUE (service_id),
    CONSTRAINT fk_hotel_services_hotel1 FOREIGN KEY (hotel_hotel_id)
        REFERENCES hotel_database.hotel (hotel_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.hotel_services
    OWNER to postgres;
-- Index: fk_hotel_services_hotel1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotel_services_hotel1_idx;

CREATE INDEX IF NOT EXISTS fk_hotel_services_hotel1_idx
    ON hotel_database.hotel_services USING btree
    (hotel_hotel_id ASC NULLS LAST)
    TABLESPACE pg_default;


-----------------------------------------------------------------------------------------


-- Table: hotel_database.hotel_services_used_by_guests

-- DROP TABLE IF EXISTS hotel_database.hotel_services_used_by_guests;

CREATE TABLE IF NOT EXISTS hotel_database.hotel_services_used_by_guests
(
    service_used_id integer NOT NULL,
    hotel_services_service_id integer NOT NULL,
    bookings_booking_id integer NOT NULL,
    CONSTRAINT hotel_services_used_by_guests_pkey PRIMARY KEY (service_used_id, hotel_services_service_id, bookings_booking_id),
    CONSTRAINT fk_hotel_services_has_bookings_bookings1 FOREIGN KEY (bookings_booking_id)
        REFERENCES hotel_database.bookings (booking_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_hotel_services_has_bookings_hotel_services1 FOREIGN KEY (hotel_services_service_id)
        REFERENCES hotel_database.hotel_services (service_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.hotel_services_used_by_guests
    OWNER to postgres;
-- Index: fk_hotel_services_has_bookings_bookings1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotel_services_has_bookings_bookings1_idx;

CREATE INDEX IF NOT EXISTS fk_hotel_services_has_bookings_bookings1_idx
    ON hotel_database.hotel_services_used_by_guests USING btree
    (bookings_booking_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_hotel_services_has_bookings_hotel_services1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_hotel_services_has_bookings_hotel_services1_idx;

CREATE INDEX IF NOT EXISTS fk_hotel_services_has_bookings_hotel_services1_idx
    ON hotel_database.hotel_services_used_by_guests USING btree
    (hotel_services_service_id ASC NULLS LAST)
    TABLESPACE pg_default;



-------------------------------------------------------------------------------------------------------


-- Table: hotel_database.room_rate_discount

-- DROP TABLE IF EXISTS hotel_database.room_rate_discount;

CREATE TABLE IF NOT EXISTS hotel_database.room_rate_discount
(
    discount_id integer NOT NULL,
    discount_rate numeric(10,2),
    start_month integer,
    end_month integer,
    room_type_room_type_id integer NOT NULL,
    CONSTRAINT room_rate_discount_pkey PRIMARY KEY (discount_id, room_type_room_type_id),
    CONSTRAINT fk_room_rate_discount_room_type1 FOREIGN KEY (room_type_room_type_id)
        REFERENCES hotel_database.room_type (room_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.room_rate_discount
    OWNER to postgres;
-- Index: fk_room_rate_discount_room_type1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_room_rate_discount_room_type1_idx;

CREATE INDEX IF NOT EXISTS fk_room_rate_discount_room_type1_idx
    ON hotel_database.room_rate_discount USING btree
    (room_type_room_type_id ASC NULLS LAST)
    TABLESPACE pg_default;


-----------------------------------------------------------------------------------------

-- Table: hotel_database.room_type

-- DROP TABLE IF EXISTS hotel_database.room_type;

CREATE TABLE IF NOT EXISTS hotel_database.room_type
(
    room_type_id integer NOT NULL,
    room_type_name character varying(45) COLLATE pg_catalog."default",
    room_cost numeric(10,2),
    room_type_description character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT room_type_pkey PRIMARY KEY (room_type_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.room_type
    OWNER to postgres;

------------------------------------------------------------------------------------------

-- Table: hotel_database.rooms

-- DROP TABLE IF EXISTS hotel_database.rooms;

CREATE TABLE IF NOT EXISTS hotel_database.rooms
(
    room_id integer NOT NULL,
    room_number integer,
    rooms_type_rooms_type_id integer NOT NULL,
    hotel_hotel_id integer NOT NULL,
    CONSTRAINT rooms_pkey PRIMARY KEY (room_id, rooms_type_rooms_type_id, hotel_hotel_id),
    CONSTRAINT rooms_id UNIQUE (room_id),
    CONSTRAINT fk_rooms_hotel1 FOREIGN KEY (hotel_hotel_id)
        REFERENCES hotel_database.hotel (hotel_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_rooms_rooms_type1 FOREIGN KEY (rooms_type_rooms_type_id)
        REFERENCES hotel_database.room_type (room_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.rooms
    OWNER to postgres;
-- Index: fk_rooms_hotel1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_rooms_hotel1_idx;

CREATE INDEX IF NOT EXISTS fk_rooms_hotel1_idx
    ON hotel_database.rooms USING btree
    (hotel_hotel_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_rooms_rooms_type1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_rooms_rooms_type1_idx;

CREATE INDEX IF NOT EXISTS fk_rooms_rooms_type1_idx
    ON hotel_database.rooms USING btree
    (rooms_type_rooms_type_id ASC NULLS LAST)
    TABLESPACE pg_default;

---------------------------------------------------------------------------------------

-- Table: hotel_database.rooms_booked

-- DROP TABLE IF EXISTS hotel_database.rooms_booked;

CREATE TABLE IF NOT EXISTS hotel_database.rooms_booked
(
    rooms_booked_id integer NOT NULL,
    bookings_booking_id integer NOT NULL,
    rooms_room_id integer NOT NULL,
    CONSTRAINT rooms_booked_pkey PRIMARY KEY (rooms_booked_id, bookings_booking_id, rooms_room_id),
    CONSTRAINT fk_rooms_booked_bookings1 FOREIGN KEY (bookings_booking_id)
        REFERENCES hotel_database.bookings (booking_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_rooms_booked_rooms1 FOREIGN KEY (rooms_room_id)
        REFERENCES hotel_database.rooms (room_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.rooms_booked
    OWNER to postgres;
-- Index: fk_rooms_booked_bookings1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_rooms_booked_bookings1_idx;

CREATE INDEX IF NOT EXISTS fk_rooms_booked_bookings1_idx
    ON hotel_database.rooms_booked USING btree
    (bookings_booking_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fk_rooms_booked_rooms1_idx

-- DROP INDEX IF EXISTS hotel_database.fk_rooms_booked_rooms1_idx;

CREATE INDEX IF NOT EXISTS fk_rooms_booked_rooms1_idx
    ON hotel_database.rooms_booked USING btree
    (rooms_room_id ASC NULLS LAST)
    TABLESPACE pg_default;

-----------------------------------------------------------------------------------------

-- Table: hotel_database.star_ratings

-- DROP TABLE IF EXISTS hotel_database.star_ratings;

CREATE TABLE IF NOT EXISTS hotel_database.star_ratings
(
    star_rating integer NOT NULL,
    star_rating_image character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT star_ratings_pkey PRIMARY KEY (star_rating)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hotel_database.star_ratings
    OWNER to postgres;


--------------------------------------------------------------------------------------