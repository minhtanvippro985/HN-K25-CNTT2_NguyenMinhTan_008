CREATE DATABASE HOTELBOOKER;
USE HOTELBOOKER;


CREATE TABLE Guests(
	guest_id VARCHAR(5) PRIMARY KEY NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE, 
    phone VARCHAR(15) NOT NULL UNIQUE 

);

CREATE TABLE RoomTypes(
	type_id VARCHAR(5) PRIMARY KEY NOT NULL,
    type_name VARCHAR(100) UNIQUE
);

CREATE TABLE Rooms(
	room_id VARCHAR(5) PRIMARY KEY NOT NULL,
    room_name VARCHAR(100) NOT NULL UNIQUE ,
    type_id VARCHAR(5) ,
    price_per_night DECIMAL(10,2) NOT NULL,
    capacity INT ,
    foreign key (type_id) references RoomTypes(type_id)
);


CREATE TABLE Reservations(
	reservation_id INT PRIMARY KEY NOT NULL auto_increment,
    guest_id VARCHAR(5), 
    room_id VARCHAR(5),
    status VARCHAR(20),  -- 'Booked' , 'Checked' , 'Cancelled' 
	check_in_date DATE NOT NULL ,
    foreign key (guest_id) references Guests(guest_id),
    foreign key (room_Id) references Rooms(room_id)
);


INSERT INTO Guests(guest_id ,full_name ,email, phone) VALUES
('G01','Lê Văn Tám','tam.lv@gmail.com','0901111111'),
('G02','Bùi Thị Lan','lan.lbt@gmail.com','0902222222'),
('G03','Đỗ Huữ Trọng','tr.dh@gmail.com','0903333333'),
('G04','Lý Thanh Hà','ha.lt@gmail.com','0904444444'),
('G05','Trương Vĩnh Ký','ky.tv@gmail.com','0905555555'),
('G06','Lê Đức Nam','trr.llaa@gmail.com','090655555'),
('G07','Lê Sao','m@gmail.com','0905555557');


INSERT INTO RoomTypes(type_id,type_name) VALUES 
('T01','Standard'),
('T02','Superior'),
('T03','Deluxe'),
('T04','Suite');


INSERT INTO Rooms(room_id,room_name,type_id,price_per_night,capacity) VALUES 
('R01','Phòng 101','T01',500000,2),
('R02','Phòng 102','T01',500000,2),
('R03','Phòng 201','T02',800000,2),
('R04','Phòng 301','T03',1200000,3),
('R05','Phòng 401','T04',2500000,4),
('R06','Phòng 501','T04',500000,2),
('R07','Phòng 601','T01',950000 ,3),
('R08','Phòng 607',NULL,950000 ,3); 

INSERT INTO Reservations(reservation_id, guest_id , room_id , status,check_in_date) VALUES
(1,'G01','R01','Booked','2025-10-01'),
(2,'G02','R03','Checked-in','2025-10-02'),
(3,'G01','R02','Checked-in','2025-10-03'),
(4,'G04','R05','Cancelled','2025-10-04'),
(5,'G05','R01','Booked','2025-10-05');

-- check truy van 
SELECT*FROM Rooms;

--   cap nhat capacity va gia phong 401
UPDATE ROOMS
SET capacity = capacity + 2 , price_per_night = price_per_night * 0.05
WHERE room_id ='R05';


--  Xoa tat ca ban ghi cancelled va truoc ngay '2025-10-03'
DELETE FROM Reservations
WHERE status = 'Cancelled'
AND check_in_date < '2025-10-03';


-- Truy van co ban

-- co trong tam 800k - 2tr va cap > 2
SELECT room_id,room_name,price_per_night 
FROM Rooms 
WHERE (price_per_night BETWEEN 800000 AND 2000000) 
AND capacity > 2 ;

--  thong tin ho ten co ho le

SELECT full_name , email 
FROM Guests
WHERE full_name LIKE 'Lê%';

-- order giam dan
SELECT reservation_id , guest_id , check_in_date
FROM Reservations 
ORDER BY check_in_date DESC;

-- 3 phong dat nhat 
SELECT room_name,price_per_night,capacity 
FROM Rooms
ORDER BY price_per_night DESC
LIMIT 3;

-- phan trang

SELECT room_name,capacity 
FROM Rooms 
LIMIT 2
OFFSET 2;


-- TRUY VAN NANG CAO!!!

-- Truy status booked
SELECT R.reservation_id , G.full_name , R.check_in_date , R.status
	FROM Guests G
INNER JOIN Reservations R ON  G.guest_id = R.guest_id AND R.status = 'Booked';

-- Liet ke tat ca cac loai phong , 
-- ke ca phong chua co loai nao
SELECT R.room_name , RT.type_name
	FROM Rooms R
LEFT JOIN RoomTypes RT ON R.type_id = RT.type_id;

-- Tong so luot dat theo tung trang thai
SELECT status , COUNT(status) AS 'Total reserves'
	FROM Reservations
GROUP BY status;

-- LAY THONG TIN CHI TIET CO GIA
-- MOI DEM NHO HON GTRI TRUNG BINH
SELECT room_id , room_name , price_per_night 
FROM Rooms
WHERE price_per_night < 
(SELECT AVG(price_per_night) AS avg_price FROM Rooms);

-- hien thi full_name va phone cua khac tung dat phong 101
SELECT G.full_name , G.phone 
FROM Guests G
JOIN Reservations R ON  G.guest_id = R.guest_id 
AND room_id = 'R01';

