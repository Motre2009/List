CREATE TABLE Countries (
    CountryId INTEGER PRIMARY KEY AUTOINCREMENT,
    CountryName NVARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Cities (
    CityId INTEGER PRIMARY KEY AUTOINCREMENT,
    CityName NVARCHAR(50) NOT NULL,
    CountryId INTEGER NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
);

CREATE TABLE Buyers (
    BuyerId INTEGER PRIMARY KEY AUTOINCREMENT,
    FullName NVARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender NVARCHAR(10),
    Email NVARCHAR(100) UNIQUE NOT NULL,
    CountryId INTEGER,
    CityId INTEGER,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId),
    FOREIGN KEY (CityId) REFERENCES Cities(CityId)
);

CREATE TABLE Sections (
    SectionId INTEGER PRIMARY KEY AUTOINCREMENT,
    SectionName NVARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE BuyerInterests (
    BuyerId INTEGER NOT NULL,
    SectionId INTEGER NOT NULL,
    PRIMARY KEY (BuyerId, SectionId),
    FOREIGN KEY (BuyerId) REFERENCES Buyers(BuyerId),
    FOREIGN KEY (SectionId) REFERENCES Sections(SectionId)
);

CREATE TABLE Promotions (
    PromoId INTEGER PRIMARY KEY AUTOINCREMENT,
    PromoName NVARCHAR(100) NOT NULL,
    Description TEXT,
    SectionId INTEGER NOT NULL,
    CountryId INTEGER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (SectionId) REFERENCES Sections(SectionId),
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
);


INSERT INTO Countries (CountryName) VALUES ('Україна'), ('Польща');

INSERT INTO Cities (CityName, CountryId) VALUES
('Київ', 1),
('Львів', 1),
('Варшава', 2);

INSERT INTO Buyers (FullName, BirthDate, Gender, Email, CountryId, CityId) VALUES
('Іван Петренко', '1990-03-12', 'Чоловік', 'ivan@example.com', 1, 2),
('Олена Іваненко', '1985-08-25', 'Жінка', 'olena@example.com', 1, 1);

INSERT INTO Sections (SectionName) VALUES
('Мобільні телефони'),
('Ноутбуки'),
('Кухонна техніка');

INSERT INTO BuyerInterests (BuyerId, SectionId) VALUES
(1, 1),
(1, 2),
(2, 3);

INSERT INTO Promotions (PromoName, Description, SectionId, CountryId, StartDate, EndDate) VALUES
('Знижка на iPhone 15', '10% знижка на всі iPhone 15', 1, 1, '2025-06-10', '2025-06-30'),
('Акція на блендери', 'До 30% знижки на блендери Bosch', 3, 1, '2025-06-01', '2025-06-20');
