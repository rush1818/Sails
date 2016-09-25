-- DROP TABLE IF EXISTS notes ;
CREATE TABLE notes (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT
);


INSERT INTO
  notes (id, title, body)
VALUES
  (1, "Breakfast", "Milk, Bread, Butter");

-- DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  password_digest VARCHAR(255) NOT NULL,
  session_token VARCHAR(255) NOT NULL
);
