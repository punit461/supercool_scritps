You can execute these queries inside the MySQL container by following these steps:

Run the MySQL container: Start the MySQL container using the docker-compose.yaml:

bash
`docker-compose up -d`

Access the MySQL container: Use the following command to access the MySQL container's shell:

bash
`docker exec -it mysql_scool360 mysql -u test -p`

Select the database: Once inside, select the scool360 database:

sql
`USE scool360;` 

Execute the provided queries: You can now paste the table creation and data insertion queries one by one or as a batch:

sql
```
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100),
    grade INT,
    marks INT
);

CREATE TABLE fees (
    student_id INT,
    total_fees DECIMAL(10, 2),
    paid_fees DECIMAL(10, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_name, grade, marks)
VALUES 
('Alice Johnson', 10, 95),
('Bob Smith', 10, 88),
('Charlie Brown', 9, 76),
('David Lee', 9, 82),
('Eve Campbell', 11, 90);

INSERT INTO fees (student_id, total_fees, paid_fees)
VALUES 
(1, 5000.00, 5000.00),
(2, 5000.00, 3000.00),
(3, 4500.00, 4500.00),
(4, 4500.00, 4000.00),
(5, 6000.00, 6000.00);
```

Your database will now be set up with the tables and data.