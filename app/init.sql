
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    address VARCHAR(255),
    phone VARCHAR(255)
);

INSERT INTO Customer (name, address, phone)
VALUES
  ('John Smith', '123 Main St', '555-1234'),
  ('Jane Doe', '456 Oak St', '555-5678'),
  ('Bob Johnson', '789 Elm St', '555-9012'),
  ('Alice Lee', '234 Maple St', '555-3456'),
  ('Tom Wilson', '567 Pine St', '555-7890');
