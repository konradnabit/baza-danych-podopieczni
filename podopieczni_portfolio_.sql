-- #########################################################
-- Baza danych: podopieczni (wersja do portfolio) wszystkie dane, telefony, maile, adresy są przypadkowe
-- Opis: System do zarządzania podopiecznymi trenera personalnego stworzony na własne potrzeby.
-- #########################################################


CREATE DATABASE podopieczni CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci;
USE podopieczni;

-- #########################################################
-- Tabela: dane_osobowe
-- Przechowuje podstawowe informacje o podopiecznych
-- #########################################################
CREATE TABLE dane_osobowe (
  ID_podopiecznego INT AUTO_INCREMENT PRIMARY KEY, -- unikalny identyfikator
  imie VARCHAR(50) NOT NULL,                      -- imię
  nazwisko VARCHAR(50) NOT NULL,                  -- nazwisko
  plec ENUM('M','K') NOT NULL,                    -- płeć: M = mężczyzna, K = kobieta
  wiek INT NOT NULL,                              -- wiek w latach
  waga INT,                                       -- waga w kg
  wzrost INT NOT NULL                             -- wzrost w cm
) ENGINE=InnoDB;

-- #########################################################
-- Tabela: dane_kontaktowe
-- Przechowuje dane kontaktowe podopiecznych
-- cyfra będaca w () po varchar, oznacza limit znaków jaki może być zastosowany do wpisania danych
-- table ukazuje również relacje między kluczem głównym z tabeli dane_osobowe, będącego tutaj kluczem obcym.
-- zastosowanie funkcji on delete cascade, powoduje, że po usunięciu id podopiecznego z tabeli dane osobowe, zniknie
-- ono również tutaj.
-- #########################################################
CREATE TABLE dane_kontaktowe (
  ID_podopiecznego INT NOT NULL,
  adres_email VARCHAR(100) NOT NULL,
  nr_tel VARCHAR(20),
  miasto VARCHAR(50) NOT NULL,
  ulica VARCHAR(50) NOT NULL,
  nr_domu VARCHAR(10) NOT NULL,
  FOREIGN KEY (ID_podopiecznego) REFERENCES dane_osobowe(ID_podopiecznego) ON DELETE CASCADE
) ENGINE=InnoDB;

-- #########################################################
-- Tabela: cele
-- Przechowuje cele treningowe podopiecznych
-- Zastosowanie ENUM, sprawia, że możliwe jest ustawienie tylko jednego z 3 podanych statusów.
-- Domyślnym jest w trakcie. Statusy z poza funkcji enum nie są akceptowane
-- #########################################################
CREATE TABLE cele (
  ID_celu INT AUTO_INCREMENT PRIMARY KEY,
  ID_podopiecznego INT NOT NULL,
  opis_celu VARCHAR(255),
  status ENUM('Osiągnięty','W trakcie','Nieosiągnięty') DEFAULT 'W trakcie',
  data_ustawienia DATE,
  data_osiagniecia DATE,
  FOREIGN KEY (ID_podopiecznego) REFERENCES dane_osobowe(ID_podopiecznego) ON DELETE CASCADE
) ENGINE=InnoDB;

-- #########################################################
-- Tabela: treningi
-- Rejestruje treningi podopiecznych
-- #########################################################
CREATE TABLE treningi (
  ID_treningu INT AUTO_INCREMENT PRIMARY KEY,
  ID_podopiecznego INT NOT NULL,
  data_treningu DATE NOT NULL,
  rodzaj_treningu VARCHAR(50),
  czas_trwania INT, -- w minutach
  FOREIGN KEY (ID_podopiecznego) REFERENCES dane_osobowe(ID_podopiecznego) ON DELETE CASCADE
) ENGINE=InnoDB;

-- #########################################################
-- Tabela: platnosci
-- Przechowuje informacje o płatnościach podopiecznych
-- decimal do 2 miejsc po przecinku, ma tutaj zastosowanie w przypadku groszy.
-- #########################################################
CREATE TABLE platnosci (
  ID_platnosci INT AUTO_INCREMENT PRIMARY KEY,
  ID_podopiecznego INT NOT NULL,
  kwota DECIMAL(10,2),
  data_platnosci DATE,
  metoda_platnosci ENUM('Gotówka','Karta','Przelew'),
  FOREIGN KEY (ID_podopiecznego) REFERENCES dane_osobowe(ID_podopiecznego) ON DELETE CASCADE
) ENGINE=InnoDB;

-- #########################################################
-- Przykładowe dane
-- #########################################################
INSERT INTO dane_osobowe (imie, nazwisko, plec, wiek, waga, wzrost) VALUES
('Adam','Kowalski','M',34,87,186),
('Katarzyna','Nowak','K',17,64,170),
('Piotr','Andrzejewski','M',27,98,188),
('Mariusz','Kacperski','M',59,105,176),
('Anna','Wardzynska','K',37,60,170),
('Renata','Sikorska','K',43,78,165),
('Hubert','Lipski','M',25,90,192),
('Bartosz','Karolewski','M',68,78,184),
('Jan','Kowalski','M',30,80,180);

INSERT INTO dane_kontaktowe VALUES
(1,'adam.kowalski@gmail.com','609-883-245','Warszawa','Lipowa','12'),
(2,'katarzyna.nowak@onet.pl','789-546-217','Kraków','Dębowa','8'),
(3,'piotr.andrzejewski@gmail.com','689-541-235','Gdańsk','Słoneczna','5'),
(4,'mariusz.kacperski@wp.pl','782-365-497','Wrocław','Kwiatowa','20'),
(5,'anna.czajka@gmail.com','894-565-277','Poznań','Leśna','15'),
(6,'renata.sikorska@onet.pl','647-859-632','Lublin','Brzozowa','3'),
(7,'hubert.lipski@gmail.com','432-698-754','Katowice','Różana','7'),
(8,'bartosz.karolewski@wp.pl','987-546-311','Szczecin','Fiołkowa','11'),
(9,'jan.kowalski@gmail.com','601-234-567','Warszawa','Brzozowa','10');

INSERT INTO cele (ID_podopiecznego, opis_celu, status, data_ustawienia, data_osiagniecia) VALUES
(1,'Zrzucić 5 kg','W trakcie','2025-08-01',NULL),
(2,'Poprawić gibkość','Osiągnięty','2025-07-01','2025-08-01'),
(3,'Biegać 5 km bez przerwy','W trakcie','2025-08-01',NULL),
(4,'Zwiększyć siłę','W trakcie','2025-08-01',NULL),
(5,'Zbudować masę','W trakcie','2025-08-02',NULL),
(6,'Poprawić wydolność','Nieosiągnięty','2025-07-15',NULL),
(7,'Zbudować masę mięśniową','W trakcie','2025-08-01',NULL),
(8,'Poprawić kondycję','W trakcie','2025-08-02',NULL);

INSERT INTO treningi (ID_podopiecznego, data_treningu, rodzaj_treningu, czas_trwania) VALUES
(1,'2025-08-01','siłowy',60),
(2,'2025-08-02','rozciąganie',45),
(3,'2025-08-01','crossfit',30),
(4,'2025-08-03','siłowy',50),
(5,'2025-08-02','aerobowy',40),
(6,'2025-08-01','bieganie',35),
(7,'2025-08-03','siłowy',55),
(8,'2025-08-02','rowerek',45);

INSERT INTO platnosci (ID_podopiecznego, kwota, data_platnosci, metoda_platnosci) VALUES
(1,150.00,'2025-08-01','Gotówka'),
(2,217.00,'2025-08-02','Karta'),
(3,238.00,'2025-08-01','Przelew'),
(4,350.00,'2025-08-03','Karta'),
(5,221.00,'2025-08-02','Gotówka'),
(6,209.00,'2025-08-01','Przelew'),
(7,270.00,'2025-08-03','Karta'),
(8,145.00,'2025-08-02','Gotówka');

-- #########################################################
-- Przykładowe zapytania SELECT
-- #########################################################

-- Lista wszystkich podopiecznych z miastem i celem
SELECT o.imie, o.nazwisko, k.miasto, c.opis_celu, c.status
FROM dane_osobowe o
JOIN dane_kontaktowe k ON o.ID_podopiecznego = k.ID_podopiecznego
LEFT JOIN cele c ON o.ID_podopiecznego = c.ID_podopiecznego;

-- Suma płatności każdego podopiecznego
SELECT o.imie, o.nazwisko, SUM(p.kwota) AS suma_platnosci
FROM dane_osobowe o
JOIN platnosci p ON o.ID_podopiecznego = p.ID_podopiecznego
GROUP BY o.ID_podopiecznego;

-- Raport treningów: liczba treningów i łączny czas dla każdego podopiecznego
SELECT o.imie, o.nazwisko, COUNT(t.ID_treningu) AS liczba_treningow, SUM(t.czas_trwania) AS laczny_czas
FROM dane_osobowe o
JOIN treningi t ON o.ID_podopiecznego = t.ID_podopiecznego
GROUP BY o.ID_podopiecznego;

-- #########################################################
-- Poniższe SELECT-y pokazują: funkcje agregujące, LEFT/RIGHT JOIN,
-- podzapytania, CONCAT, GROUP BY, ORDER BY, COALESCE.
-- #########################################################

-- Q1) AGREGACJA + GROUP BY + ORDER BY
-- Suma płatności, liczba transakcji i średnia kwota dla każdego podopiecznego.
-- Pokazuje podstawową analitykę finansową.
SELECT o.ID_podopiecznego,
       CONCAT(o.imie, ' ', o.nazwisko) AS podopieczny,
       SUM(p.kwota) AS suma_platnosci,
       COUNT(*) AS liczba_transakcji,
       ROUND(AVG(p.kwota), 2) AS srednia_transakcja
FROM dane_osobowe o
JOIN platnosci p ON p.ID_podopiecznego = o.ID_podopiecznego
GROUP BY o.ID_podopiecznego
ORDER BY suma_platnosci DESC;

-- Q2) LEFT JOIN + CONCAT + ORDER BY
-- Lista WSZYSTKICH podopiecznych wraz z miastem i celem.
-- Osoby bez celu mają 'Brak celu' (COALESCE).
SELECT o.ID_podopiecznego,
       CONCAT(o.imie, ' ', o.nazwisko, ' (', k.miasto, ')') AS osoba_miasto,
       COALESCE(c.opis_celu, 'Brak celu') AS cel,
       COALESCE(c.status, 'Brak') AS status
FROM dane_osobowe o
LEFT JOIN dane_kontaktowe k ON k.ID_podopiecznego = o.ID_podopiecznego
LEFT JOIN cele c ON c.ID_podopiecznego = o.ID_podopiecznego
ORDER BY o.nazwisko, o.imie;

-- Q3) RIGHT JOIN (+ LEFT JOIN) – wykrywanie braków danych
-- Osoby, które NIE mają żadnego treningu w systemie.
SELECT o.ID_podopiecznego,
       CONCAT(o.imie, ' ', o.nazwisko) AS podopieczny,
       k.miasto
FROM treningi t
RIGHT JOIN dane_osobowe o ON t.ID_podopiecznego = o.ID_podopiecznego
LEFT JOIN dane_kontaktowe k ON k.ID_podopiecznego = o.ID_podopiecznego
WHERE t.ID_treningu IS NULL
ORDER BY o.nazwisko, o.imie;

-- Q4) LEFT JOIN + AGREGACJA
-- Ostatnia data treningu, łączny czas (w min) i liczba treningów dla każdego podopiecznego.
-- W dalszym raporcie można użyć COALESCE dla wartości NULL (osoby bez treningów).
SELECT o.ID_podopiecznego,
       CONCAT(o.imie, ' ', o.nazwisko) AS podopieczny,
       MAX(t.data_treningu) AS ostatni_trening,
       COALESCE(SUM(t.czas_trwania), 0) AS laczny_czas_min,
       COUNT(t.ID_treningu) AS liczba_treningow
FROM dane_osobowe o
LEFT JOIN treningi t ON t.ID_podopiecznego = o.ID_podopiecznego
GROUP BY o.ID_podopiecznego
ORDER BY (MAX(t.data_treningu) IS NULL), MAX(t.data_treningu) DESC;

-- Q5) PODZAPYTANIE (subquery) + ORDER BY
-- Podopieczni, których łączna kwota płatności jest powyżej ŚREDNIEJ łącznej kwoty
-- wśród osób, które płaciły. Używamy podzapytania zgrupowanych sum i ich średniej.
SELECT z.ID_podopiecznego, z.podopieczny, z.suma_platnosci
FROM (
    SELECT o.ID_podopiecznego,
           CONCAT(o.imie, ' ', o.nazwisko) AS podopieczny,
           SUM(p.kwota) AS suma_platnosci
    FROM dane_osobowe o
    JOIN platnosci p ON p.ID_podopiecznego = o.ID_podopiecznego
    GROUP BY o.ID_podopiecznego
) AS z
WHERE z.suma_platnosci > (
    SELECT AVG(suma_osoby)
    FROM (
        SELECT SUM(kwota) AS suma_osoby
        FROM platnosci
        GROUP BY ID_podopiecznego
    ) AS s
)
ORDER BY z.suma_platnosci DESC;

-- Q6) CONCAT + ORDER BY
-- "Książka kontaktowa" – złączenie danych osobowych i kontaktowych
-- oraz przygotowanie czytelnego pola tekstowego z kontaktem.
SELECT CONCAT(o.imie, ' ', o.nazwisko) AS osoba,
       CONCAT('tel: ', k.nr_tel, ' | email: ', k.adres_email) AS kontakt,
       k.miasto
FROM dane_osobowe o
JOIN dane_kontaktowe k ON k.ID_podopiecznego = o.ID_podopiecznego
ORDER BY k.miasto, o.nazwisko, o.imie;
