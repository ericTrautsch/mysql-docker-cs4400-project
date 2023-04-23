-- Use this schema
use warehouse;

-- drop tables if they already exist
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Outgoing;
DROP TABLE IF EXISTS Incoming;
DROP TABLE IF EXISTS Part;
DROP TABLE IF EXISTS StorageArea;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Employee;


-- Create tables
CREATE TABLE Part (
  part_id INTEGER PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  weight FLOAT NOT NULL,
  manufacturer VARCHAR(255) NOT NULL,
  material_type VARCHAR(255) NOT NULL
);

-- Index on manufacturer in Part table
CREATE INDEX idx_part_manufacturer ON Part(manufacturer);

CREATE TABLE Supplier (
  supplier_id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  address VARCHAR(255) NOT NULL,
  phone VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Customer (
  customer_id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  phone VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Employee (
  employee_id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  phone VARCHAR(255) NOT NULL UNIQUE,
  office_num VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  title VARCHAR(255) NOT NULL,
  hire_date DATE NOT NULL
);

CREATE TABLE StorageArea (
  storage_area_id INTEGER PRIMARY KEY,
  area VARCHAR(255) NOT NULL UNIQUE,
  capacity INTEGER NOT NULL,
  location VARCHAR(255) NOT NULL
);

-- Index on location in StorageArea table
CREATE INDEX idx_storage_area_location ON StorageArea(location);

CREATE TABLE Inventory (
  part_id INTEGER NOT NULL,
  storage_area_id INTEGER NOT NULL,
  cost_per_unit FLOAT NOT NULL,
  quantity INTEGER NOT NULL,
  FOREIGN KEY (part_id) REFERENCES Part(part_id) ON DELETE CASCADE,
  FOREIGN KEY (storage_area_id) REFERENCES StorageArea(storage_area_id) ON DELETE CASCADE
);

CREATE TABLE Outgoing (
  customer_id INTEGER NOT NULL,
  employee_id INTEGER NOT NULL,
  storage_area_id INTEGER NOT NULL,
  part_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  profit_per_unit FLOAT NOT NULL,
  placed_on DATETIME NOT NULL,
  completed_on DATETIME,
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
  FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE CASCADE,
  FOREIGN KEY (storage_area_id) REFERENCES StorageArea(storage_area_id) ON DELETE CASCADE,
  FOREIGN KEY (part_id) REFERENCES Part(part_id) ON DELETE CASCADE
);

CREATE TABLE Incoming (
  part_id INTEGER NOT NULL,
  storage_area_id INTEGER NOT NULL,
  employee_id INTEGER NOT NULL,
  supplier_id INTEGER NOT NULL,
  cost_per_unit FLOAT NOT NULL,
  quantity INTEGER NOT NULL,
  ordered_on DATETIME NOT NULL,
  received_on DATETIME,
  FOREIGN KEY (part_id) REFERENCES Part(part_id) ON DELETE CASCADE,
  FOREIGN KEY (storage_area_id) REFERENCES StorageArea(storage_area_id) ON DELETE CASCADE,
  FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE CASCADE,
  FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON DELETE CASCADE
);


-- Create Triggers
-- Trigger 1: Update Inventory quantity when a new Incoming row is added
DELIMITER //
CREATE TRIGGER update_inventory_on_incoming_insert
AFTER INSERT ON Incoming
FOR EACH ROW
BEGIN
  UPDATE Inventory
  SET quantity = quantity + NEW.quantity
  WHERE part_id = NEW.part_id AND storage_area_id = NEW.storage_area_id;
END; //
DELIMITER ;

-- Trigger 2: Update Inventory quantity when a new Outgoing row is added
DELIMITER //
CREATE TRIGGER update_inventory_on_outgoing_insert
AFTER INSERT ON Outgoing
FOR EACH ROW
BEGIN
  UPDATE Inventory
  SET quantity = quantity - NEW.quantity
  WHERE part_id = NEW.part_id AND storage_area_id = NEW.storage_area_id;
END; //
DELIMITER ;

DROP VIEW IF EXISTS inventory_summary;
DROP VIEW IF EXISTS customer_sales_summary;

-- Create views
-- View 1: Total quantity and value of each part in the inventory
CREATE VIEW inventory_summary AS
SELECT
  i.part_id,
  p.description,
  p.manufacturer,
  p.material_type,
  SUM(i.quantity) AS total_quantity,
  SUM(i.quantity * i.cost_per_unit) AS total_value
FROM
  Inventory i
  JOIN Part p ON i.part_id = p.part_id
GROUP BY
  i.part_id,
  p.description,
  p.manufacturer,
  p.material_type;

-- View 2: Total sales and profit for each customer
CREATE VIEW customer_sales_summary AS
SELECT
  o.customer_id,
  c.name AS customer_name,
  SUM(o.quantity) AS total_sales,
  SUM(o.quantity * o.profit_per_unit) AS total_profit
FROM
  Outgoing o
  JOIN Customer c ON o.customer_id = c.customer_id
GROUP BY
  o.customer_id,
  c.name;

-- Drop already-existing proceedures
DROP PROCEDURE IF EXISTS get_low_stock_parts;
DROP PROCEDURE IF EXISTS get_customer_sales_report;


-- Create proceedures
-- Procedure 1: Get parts with a total quantity less than the specified value
DELIMITER //
CREATE PROCEDURE get_low_stock_parts(IN minimum_quantity INT)
BEGIN
  SELECT
    p.part_id,
    p.description,
    p.manufacturer,
    p.material_type,
    SUM(i.quantity) AS total_quantity
  FROM
    Inventory i
    JOIN Part p ON i.part_id = p.part_id
  GROUP BY
    p.part_id,
    p.description,
    p.manufacturer,
    p.material_type
  HAVING
    total_quantity < minimum_quantity;
END; //
DELIMITER ;

-- Procedure 2: Generate a report of total sales and profits per customer for a specified date range
DELIMITER //
CREATE PROCEDURE get_customer_sales_report(IN start_date DATE, IN end_date DATE)
BEGIN
  SELECT
    o.customer_id,
    c.name AS customer_name,
    SUM(o.quantity) AS total_sales,
    SUM(o.quantity * o.profit_per_unit) AS total_profit
  FROM
    Outgoing o
    JOIN Customer c ON o.customer_id = c.customer_id
  WHERE
    o.placed_on BETWEEN start_date AND end_date
  GROUP BY
    o.customer_id,
    c.name;
END; //
DELIMITER ;




-- Put sample data in the tables


-- Insert into Part
INSERT INTO Part (part_id, description, weight, manufacturer, material_type)
VALUES (1, 'Aircraft Engine', 1500, 'EngineCorp', 'Metal'),
       (2, 'Landing Gear', 250, 'GearInc', 'Aluminum'),
       (3, 'Fuel Tank', 100, 'TankCo', 'Composite'),
       (4, 'Avionics System', 50, 'AvionicsTech', 'Electronics'),
       (5, 'Wing Flap', 75, 'FlapWorks', 'Composite');

-- Insert into Supplier
INSERT INTO Supplier (supplier_id, name, address, phone, email)
VALUES (1, 'Supplier One', '123 Main St, Anytown', '555-111-1234', 'supplierone@email.com'),
       (2, 'Supplier Two', '456 Oak St, Anytown', '555-222-2345', 'suppliertwo@email.com'),
       (3, 'Supplier Three', '789 Elm St, Anytown', '555-333-3456', 'supplierthree@email.com'),
       (4, 'Supplier Four', '321 Maple St, Anytown', '555-444-4567', 'supplierfour@email.com'),
       (5, 'Supplier Five', '654 Pine St, Anytown', '555-555-5678', 'supplierfive@email.com');

-- Insert into Customer
INSERT INTO Customer (customer_id, name, address, phone, email)
VALUES (1, 'Customer One', '987 Cedar St, Anytown', '555-123-9876', 'customerone@email.com'),
       (2, 'Customer Two', '654 Spruce St, Anytown', '555-234-8765', 'customertwo@email.com'),
       (3, 'Customer Three', '321 Birch St, Anytown', '555-345-7654', 'customerthree@email.com'),
       (4, 'Customer Four', '198 Willow St, Anytown', '555-456-6543', 'customerfour@email.com'),
       (5, 'Customer Five', '567 Poplar St, Anytown', '555-567-5432', 'customerfive@email.com');

-- Insert into Employee
INSERT INTO Employee (employee_id, name, address, phone, office_num, email, title, hire_date)
VALUES (1, 'John Doe', '111 First St, Anytown', '555-321-0987', 'A1', 'johndoe@email.com', 'Manager', '2022-01-01'),
       (2, 'Jane Smith', '222 Second St, Anytown', '555-432-1987', 'A2', 'janesmith@email.com', 'Sales', '2022-02-15'),
       (3, 'Jim Brown', '333 Third St, Anytown', '555-543-2987', 'A3', 'jimbrown@email.com', 'Warehouse Worker', '2022-03-01'),
       (4, 'Sue Green', '444 Fourth St, Anytown', '555-654-3987', 'A4', 'suegreen@email.com', 'Warehouse Worker', '2022-04-15'),
       (5, 'Tom White', '555 Fifth St, Anytown', '555-765-4987', 'A5', 'tomwhite@email.com', 'Sales', '2022-05-01');

-- Insert into StorageArea
INSERT INTO StorageArea (storage_area_id, area, capacity, location)
VALUES (1, 'A1', 1000, 'North'),
       (2, 'A2', 1200, 'North'),
       (3, 'B1', 1500, 'South'),
       (4, 'B2', 800, 'South'),
       (5, 'C1', 500, 'East');

-- Insert into Inventory
INSERT INTO Inventory (part_id, storage_area_id, cost_per_unit, quantity)
VALUES (1, 1, 15000, 10),
       (2, 1, 3000, 20),
       (3, 2, 2000, 15),
       (4, 3, 5000, 12),
       (5, 4, 1000, 25);

-- Insert into Outgoing
INSERT INTO Outgoing (customer_id, employee_id, storage_area_id, part_id, quantity, profit_per_unit, placed_on, completed_on)
VALUES (1, 2, 1, 1, 2, 2000, '2023-04-01 10:00:00', '2023-04-02 12:30:00'),
       (2, 5, 1, 2, 5, 500, '2023-04-10 14:30:00', '2023-04-11 16:45:00'),
       (3, 2, 2, 3, 3, 800, '2023-04-15 09:00:00', '2023-04-16 10:15:00'),
       (4, 5, 3, 4, 1, 1000, '2023-04-20 13:30:00', '2023-04-21 15:00:00'),
       (5, 2, 4, 5, 10, 200, '2023-04-22 11:00:00', '2023-04-23 12:00:00');

-- Insert into Incoming
INSERT INTO Incoming (part_id, storage_area_id, employee_id, supplier_id, cost_per_unit, quantity, ordered_on, received_on)
VALUES (1, 1, 3, 1, 13000, 5, '2023-03-01 10:00:00', '2023-03-10 12:30:00'),
       (2, 1, 3, 2, 2500, 10, '2023-03-15 14:30:00', '2023-03-20 16:45:00'),
       (3, 2, 4, 3, 1800, 8, '2023-03-25 09:00:00', '2023-03-28 10:15:00'),
       (4, 3, 4, 4, 4500, 6, '2023-04-05 13:30:00', '2023-04-10 15:00:00'),
       (5, 4, 3, 5, 800, 15, '2023-04-12 11:00:00', '2023-04-18 12:00:00');
