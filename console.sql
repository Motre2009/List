CREATE TABLE Customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name NVARCHAR(100),
    birth_date DATE,
    gender NVARCHAR(10),
    email NVARCHAR(100) UNIQUE,
    country NVARCHAR(50),
    city NVARCHAR(50)
);

CREATE TABLE Categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name NVARCHAR(100) UNIQUE
);

CREATE TABLE CustomerInterests (
    customer_id INT,
    category_id INT,
    PRIMARY KEY (customer_id, category_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(id),
    FOREIGN KEY (category_id) REFERENCES Categories(id)
);

CREATE TABLE Promotions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title NVARCHAR(100),
    description TEXT,
    category_id INT,
    country NVARCHAR(50),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (category_id) REFERENCES Categories(id)
);


INSERT INTO Customers (full_name, birth_date, gender, email, country, city)
VALUES
('Іван Петренко', '1990-03-12', 'Чоловік', 'ivan@example.com', 'Україна', 'Львів'),
('Олена Іваненко', '1985-08-25', 'Жінка', 'olena@example.com', 'Україна', 'Київ');

INSERT INTO Categories (name)
VALUES ('Мобільні телефони'), ('Ноутбуки'), ('Кухонна техніка');

INSERT INTO CustomerInterests (customer_id, category_id)
VALUES
(1, 1), (1, 2),
(2, 3);

INSERT INTO Promotions (title, description, category_id, country, start_date, end_date)
VALUES
('Знижка на iPhone 15', '10% знижка на всі iPhone 15', 1, 'Україна', '2025-06-10', '2025-06-30'),
('Акція на кухонні блендери', 'Знижки до 30% на блендери Bosch', 3, 'Україна', '2025-06-01', '2025-06-20');
