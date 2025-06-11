CREATE TABLE Countries (
    CountryId INTEGER PRIMARY KEY AUTOINCREMENT,
    CountryName TEXT NOT NULL UNIQUE
);

CREATE TABLE Cities (
    CityId INTEGER PRIMARY KEY AUTOINCREMENT,
    CityName TEXT NOT NULL,
    CountryId INTEGER,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
);

CREATE TABLE Buyers (
    BuyerId INTEGER PRIMARY KEY AUTOINCREMENT,
    FullName TEXT NOT NULL,
    BirthDate TEXT NOT NULL,
    Gender TEXT CHECK (Gender IN ('M', 'F')) NOT NULL,
    Email TEXT NOT NULL UNIQUE,
    CountryId INTEGER,
    CityId INTEGER,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId),
    FOREIGN KEY (CityId) REFERENCES Cities(CityId)
);

CREATE TABLE Sections (
    SectionId INTEGER PRIMARY KEY AUTOINCREMENT,
    SectionName TEXT NOT NULL UNIQUE
);

CREATE TABLE BuyerSections (
    BuyerId INTEGER,
    SectionId INTEGER,
    PRIMARY KEY (BuyerId, SectionId),
    FOREIGN KEY (BuyerId) REFERENCES Buyers(BuyerId),
    FOREIGN KEY (SectionId) REFERENCES Sections(SectionId)
);

CREATE TABLE Promotions (
    PromoId INTEGER PRIMARY KEY AUTOINCREMENT,
    PromoName TEXT NOT NULL,
    SectionId INTEGER NOT NULL,
    CountryId INTEGER NOT NULL,
    StartDate TEXT NOT NULL,
    EndDate TEXT NOT NULL,
    FOREIGN KEY (SectionId) REFERENCES Sections(SectionId),
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
);

INSERT INTO Countries (CountryName) VALUES ('Україна'), ('Польща');

INSERT INTO Cities (CityName, CountryId) VALUES
('Київ', 1), ('Львів', 1), ('Варшава', 2);

INSERT INTO Sections (SectionName) VALUES
('Мобільні телефони'),
('Ноутбуки'),
('Кухонна техніка');

INSERT INTO Promotions (PromoName, SectionId, CountryId, StartDate, EndDate) VALUES
('Знижки на смартфони', 1, 1, '2025-06-01', '2025-06-30'),
('Ноутбуки зі знижкою', 2, 2, '2025-06-10', '2025-07-10');
