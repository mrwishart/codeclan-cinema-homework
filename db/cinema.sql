DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  -- Expect that price would be no more than £99
  price DECIMAL(4,2)
);

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  -- Assume anyone with more than £10 million will buy their own private cinema
  wallet DECIMAL(9,2)
);

CREATE TABLE tickets (
  id SERIAL8 PRIMARY KEY,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE
);
