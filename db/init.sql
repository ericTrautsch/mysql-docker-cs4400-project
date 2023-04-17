create database warehouse;
use warehouse;

-- Drop tables if they exist
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Part;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS StorageArea;
DROP TABLE IF EXISTS Incoming;
DROP TABLE IF EXISTS Outgoing;
DROP TABLE IF EXISTS Inventory;

-- Create tables
CREATE TABLE Customer (
  /*customer_id INTEGER AUTO_INCREMENT PRIMARY KEY,*/
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  phone VARCHAR(20) NOT NULL
);

INSERT INTO Customer (name, address, phone)
VALUES
  ('John Smith', '123 Main St', '555-1234'),
  ('Jane Doe', '456 Oak St', '555-5678'),
  ('Bob Johnson', '789 Elm St', '555-9012'),
  ('Alice Lee', '234 Maple St', '555-3456'),
  ('Tom Wilson', '567 Pine St', '555-7890');
/*
CREATE TABLE Employee (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  office_number INT NOT NULL
);

CREATE TABLE Part (
  part_id INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  size_multiplier FLOAT NOT NULL
);

CREATE TABLE Supplier (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  phone VARCHAR(20) NOT NULL
);

CREATE TABLE StorageArea (
  storage_area_id INT AUTO_INCREMENT PRIMARY KEY,
  area VARCHAR(255) NOT NULL,
  capacity FLOAT NOT NULL
);

CREATE TABLE Incoming (
  incoming_id INT AUTO_INCREMENT PRIMARY KEY,
  part_id INT NOT NULL,
  employee_id INT NOT NULL,
  supplier_id INT NOT NULL,
  storage_area_id INT NOT NULL,
  date_received DATE NOT NULL,
  cost_per_unit FLOAT NOT NULL,
  quantity INT NOT NULL,
  ordered_on DATE NOT NULL,
  received_on DATE NOT NULL,
  FOREIGN KEY (part_id) REFERENCES Part(part_id),
  FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
  FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
  FOREIGN KEY (storage_area_id) REFERENCES StorageArea(storage_area_id)
);

CREATE TABLE Outgoing (
  outgoing_id INT AUTO_INCREMENT PRIMARY KEY,
  part_id INT NOT NULL,
  customer_id INT NOT NULL,
  employee_id INT NOT NULL,
  storage_area_id INT NOT NULL,
  date_completed DATE NOT NULL,
  date_placed DATE NOT NULL,
  cost_per_unit FLOAT NOT NULL,
  quantity INT NOT NULL,
  shipping_cost FLOAT NOT NULL,
  FOREIGN KEY (part_id) REFERENCES Part(part_id),
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
  FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
  FOREIGN KEY (storage_area_id) REFERENCES StorageArea(storage_area_id)
);

CREATE TABLE Inventory (
  part_id INT NOT NULL,
  storage_area_id INT NOT NULL,
  cost_per_unit FLOAT NOT NULL,
  quantity INT NOT NULL,
  FOREIGN KEY (part_id) REFERENCES Part(part_id),
  FOREIGN KEY (storage_area_id) REFERENCES StorageArea(storage_area_id),
  PRIMARY KEY (part_id, storage_area_id)
);

-- Insert data into Part table
INSERT INTO Part (description, size_multiplier) VALUES 
    ('Widget A', 1.2),
    ('Widget B', 1.5),
    ('Gizmo X', 1.0),
    ('Gizmo Y', 1.2),
    ('Thingamajig Z', 2.0);

-- Insert data into StorageArea table
INSERT INTO StorageArea (area, capacity) VALUES 
    ('Warehouse A', 1000),
    ('Warehouse B', 2000),
    ('Warehouse C', 3000),
    ('Warehouse D', 4000),
    ('Warehouse E', 5000);

-- Insert data into Supplier table
INSERT INTO Supplier (name, address, phone) VALUES 
    ('ABC Manufacturing', '123 Main St', '555-1234'),
    ('XYZ Industrial', '456 Oak Ave', '555-5678'),
    ('Acme Corporation', '789 Elm St', '555-9012'),
    ('Globex Corporation', '234 Maple Ave', '555-3456'),
    ('Initech Industries', '567 Pine St', '555-7890');

-- Insert data into Employee table
INSERT INTO Employee (first_name, last_name, office_num) VALUES 
    ('John', 'Doe', 100),
    ('Jane', 'Smith', 101),
    ('Bob', 'Johnson', 102),
    ('Samantha', 'Lee', 103),
    ('David', 'Brown', 104);

-- Insert data into Inventory table
INSERT INTO Inventory (pid, sid, cpu, quantity) VALUES 
    (1, 1, 10.0, 100),
    (1, 2, 15.0, 200),
    (2, 3, 20.0, 300),
    (3, 4, 25.0, 400),
    (4, 5, 30.0, 500);

-- Insert data into Outgoing table
INSERT INTO Outgoing (cid, eid, sid, pid, completed_on, placed_on, quantity, cpu, spu, outgoing_location) VALUES 
    (1, 1, 1, 1, '2022-01-01', '2021-12-31', 50, 12.0, 15.0, 'Dock A'),
    (2, 2, 2, 1, '2022-02-01', '2022-01-31', 100, 12.0, 15.0, 'Dock B'),
    (3, 3, 3, 2, '2022-03-01', '2022-02-28', 150, 20.0, 25.0, 'Dock C'),
    (4, 4, 4, 3, '2022-04-01', '2022-03-31', 200, 25.0, 30.0, 'Dock D'),
    (5, 5, 5, 4, '2022-05-01', '2022-04-30', 250, 30.0, 35.0, 'Dock E');

-- Inserting data into Incoming table
INSERT INTO Incoming (pid, eid, supplier_id, sid, date, cpu, quantity, ordered_on, received_on)
VALUES
  (1, 2, 1, 1, '2022-03-15', 20, 500, '2022-03-01', '2022-03-16'),
  (2, 4, 2, 2, '2022-04-10', 15, 300, '2022-04-01', '2022-04-12'),
  (3, 3, 3, 3, '2022-02-28', 25, 200, '2022-02-15', '2022-03-01'),
  (4, 1, 2, 2, '2022-01-25', 10, 400, '2022-01-10', '2022-01-27'),
  (5, 5, 1, 3, '2022-03-20', 30, 600, '2022-03-05', '2022-03-22');


*/