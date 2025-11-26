CREATE TABLE students(
    student_id INT PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER CHECK (age >= 0),
    email TEXT UNIQUE
);