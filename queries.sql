--================================================================
-- Creation of tables
--================================================================

create table Users(
  user_id serial primary key ,
  name varchar(50) not null,
  email varchar(50) unique,
  password varchar(50),
  phone int,
  role varchar(50)
);

create table Vehicles(
  vehicle_id serial primary key,
  name varchar(50) not null,
  type varchar(50),
  model int,
  registration_number varchar(50) unique,
  rental_price int,
  status varchar(50)
);

create table Bookings(
  booking_id serial primary key,
  user_id int references Users(user_id),
  vehicle_id int references Vehicles(vehicle_id),
  start_date date,
  end_date date check (end_date > start_date),
  status varchar(50),
  total_cost int
);


alter table users
alter column phone type varchar(20)

--================================================================
-- insertion of values
--================================================================

insert into users(name,email,phone,role)
values
('Alice', 'alice@example.com', '1234567890', 'Customer'),
('Bob', 'bob@example.com', '0987654321', 'Admin'),
('Charlie', 'charlie@example.com', '1122334455', 'Customer'),
('Diana', 'diana@example.com', '2233445566', 'Customer'),
('Ethan', 'ethan@example.com', '3344556677', 'Customer'),
('Fiona', 'fiona@example.com', '4455667788', 'Manager'),
('George', 'george@example.com', '5566778899', 'Customer');

insert into vehicles(name,type,model,registration_number,rental_price,status)
values
('Toyota Corolla', 'car', 2022, 'ABC-123', 50, 'available'),
('Honda Civic', 'car', 2021, 'DEF-456', 60, 'rented'),
('Yamaha R15', 'bike', 2023, 'GHI-789', 30, 'available'),
('Ford F-150', 'truck', 2020, 'JKL-012', 100, 'maintenance'),
('Tesla Model 3', 'car', 2023, 'MNO-345', 120, 'available'),
('Suzuki Gixxer', 'bike', 2022, 'PQR-678', 35, 'rented'),
('Nissan X-Trail', 'car', 2021, 'STU-901', 80, 'available');

insert into bookings(user_id,vehicle_id,start_date,end_date,status,total_cost)
values
(1, 2, '2023-10-01', '2023-10-05', 'completed', 240),
(1, 2, '2023-11-01', '2023-11-03', 'completed', 120),
(3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60),
(1, 1, '2023-12-10', '2023-12-12', 'pending', 100),
(4, 3, '2023-12-05', '2023-12-07', 'completed', 60),
(5, 5, '2023-12-08', '2023-12-10', 'confirmed', 240),
(7, 7, '2023-12-15', '2023-12-18', 'pending', 240),
(3, 6, '2023-12-20', '2023-12-22', 'completed', 70);

--================================================================
-- Queries
--================================================================


--===============================================================
--  Retrieve booking information along with Customer name and Vehicle name.
--===============================================================

select booking_id,users.name as customer_name,vehicles.name as vehicle_name,start_date,end_date,bookings.status from bookings
join users on bookings.user_id = users.user_id
join vehicles on bookings.vehicle_id = vehicles.vehicle_id


--===============================================================
--Find all vehicles that have never been booked.
--===============================================================


select vehicle_id,name,type,model,registration_number,rental_price,vehicles.status from vehicles
where not exists (
  select 1 from bookings
  where bookings.vehicle_id = vehicles.vehicle_id
) 


--===============================================================
--Retrieve all available vehicles of a specific type (e.g. cars).
--===============================================================

select * from vehicles
where type = 'car'


--===============================================================  
--Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
--===============================================================

select vehicles.name,count(bookings.booking_id) as total_bookings from vehicles
join bookings on vehicles.vehicle_id = bookings.vehicle_id
group by vehicles.vehicle_id,vehicles.name
having count(bookings.booking_id) > 2