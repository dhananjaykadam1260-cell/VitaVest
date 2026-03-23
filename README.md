mysql> CREATE TABLE emergency_contacts (
    ->     id INT AUTO_INCREMENT PRIMARY KEY,
    ->     user_id INT NOT NULL,
    ->     name VARCHAR(100) NOT NULL,
    ->     phone VARCHAR(20) NOT NULL,
    ->     relationship VARCHAR(50),
    ->     email VARCHAR(100),
    ->     FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    -> );
Query OK, 0 rows affected (0.09 sec)

mysql> CREATE TABLE wellness_logs (
    ->     id          INT AUTO_INCREMENT PRIMARY KEY,
    ->     user_id     INT NOT NULL,
    ->     log_type    ENUM('steps','study','exercise','calories') NOT NULL,
    ->     value       INT NOT NULL DEFAULT 0,
    ->     logged_at   DATETIME NOT NULL,
    ->     FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    -> );
Query OK, 0 rows affected (0.06 sec)
