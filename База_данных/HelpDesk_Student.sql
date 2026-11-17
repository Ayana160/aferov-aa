-- База данных HelpDesk
-- Практическая работа №9

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'HelpDesk_Student')
BEGIN
    ALTER DATABASE HelpDesk_Student SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HelpDesk_Student;
END
GO

CREATE DATABASE HelpDesk_Student;
GO

USE HelpDesk_Student;
GO

-- Таблица Roles
CREATE TABLE Roles (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Таблица Categories
CREATE TABLE Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- Таблица Priorities
CREATE TABLE Priorities (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Таблица Statuses
CREATE TABLE Statuses (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Таблица Users
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Login NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    FullName NVARCHAR(150) NOT NULL,
    RoleId INT NOT NULL,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(Id)
);
GO

-- Таблица Tickets
CREATE TABLE Tickets (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Description NVARCHAR(500) NOT NULL,
    CategoryId INT NOT NULL,
    PriorityId INT NOT NULL,
    StatusId INT NOT NULL,
    UserId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Tickets_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    CONSTRAINT FK_Tickets_Priorities FOREIGN KEY (PriorityId) REFERENCES Priorities(Id),
    CONSTRAINT FK_Tickets_Statuses FOREIGN KEY (StatusId) REFERENCES Statuses(Id),
    CONSTRAINT FK_Tickets_Users FOREIGN KEY (UserId) REFERENCES Users(Id)
);
GO

-- Данные: Roles
INSERT INTO Roles (Name) VALUES (N'Администратор');
INSERT INTO Roles (Name) VALUES (N'Специалист поддержки');
INSERT INTO Roles (Name) VALUES (N'Пользователь');
GO

-- Данные: Categories
INSERT INTO Categories (Name) VALUES (N'Оборудование');
INSERT INTO Categories (Name) VALUES (N'Программное обеспечение');
INSERT INTO Categories (Name) VALUES (N'Сеть');
INSERT INTO Categories (Name) VALUES (N'Учётная запись');
INSERT INTO Categories (Name) VALUES (N'Периферия');
INSERT INTO Categories (Name) VALUES (N'Другое');
GO

-- Данные: Priorities
INSERT INTO Priorities (Name) VALUES (N'Низкий');
INSERT INTO Priorities (Name) VALUES (N'Средний');
INSERT INTO Priorities (Name) VALUES (N'Высокий');
GO

-- Данные: Statuses
INSERT INTO Statuses (Name) VALUES (N'Новая');
INSERT INTO Statuses (Name) VALUES (N'В работе');
INSERT INTO Statuses (Name) VALUES (N'Выполнена');
INSERT INTO Statuses (Name) VALUES (N'Отклонена');
GO

-- Данные: Users (временные заглушки паролей)
INSERT INTO Users (Login, Password, FullName, RoleId) VALUES (N'admin', N'TEMP_ADMIN', N'Администратор системы', 1);
INSERT INTO Users (Login, Password, FullName, RoleId) VALUES (N'support', N'TEMP_SUPPORT', N'Специалист поддержки', 2);
INSERT INTO Users (Login, Password, FullName, RoleId) VALUES (N'user1', N'TEMP_USER', N'Иванов Иван Иванович', 3);
GO

-- Данные: Tickets
INSERT INTO Tickets (Description, CategoryId, PriorityId, StatusId, UserId, CreatedAt)
VALUES (N'Нет доступа к интернету в кабинете 204', 3, 3, 1, 3, DATEADD(day, -2, GETDATE()));

INSERT INTO Tickets (Description, CategoryId, PriorityId, StatusId, UserId, CreatedAt)
VALUES (N'Ошибка при запуске Word', 2, 2, 2, 3, DATEADD(day, -5, GETDATE()));

INSERT INTO Tickets (Description, CategoryId, PriorityId, StatusId, UserId, CreatedAt)
VALUES (N'Не работает принтер на 3 этаже', 1, 3, 1, 3, DATEADD(day, -1, GETDATE()));

INSERT INTO Tickets (Description, CategoryId, PriorityId, StatusId, UserId, CreatedAt)
VALUES (N'Забыл пароль от учётки', 4, 1, 3, 3, DATEADD(day, -10, GETDATE()));

INSERT INTO Tickets (Description, CategoryId, PriorityId, StatusId, UserId, CreatedAt)
VALUES (N'Не работает мышь на рабочем месте', 5, 2, 4, 3, DATEADD(day, -3, GETDATE()));

INSERT INTO Tickets (Description, CategoryId, PriorityId, StatusId, UserId, CreatedAt)
VALUES (N'Медленный интернет в актовом зале', 3, 2, 2, 3, DATEADD(day, -4, GETDATE()));

INSERT INTO Tickets (Description, CategoryId, PriorityId, StatusId, UserId, CreatedAt)
VALUES (N'Замена картриджа в принтере', 1, 1, 3, 3, DATEADD(day, -7, GETDATE()));
GO

-- Проверочный JOIN-запрос
SELECT 
    t.Id AS [№],
    c.Name AS [Категория],
    t.Description AS [Описание],
    p.Name AS [Приоритет],
    s.Name AS [Статус],
    u.FullName AS [Пользователь],
    t.CreatedAt AS [Дата]
FROM Tickets t
INNER JOIN Categories c ON t.CategoryId = c.Id
INNER JOIN Priorities p ON t.PriorityId = p.Id
INNER JOIN Statuses s ON t.StatusId = s.Id
INNER JOIN Users u ON t.UserId = u.Id
ORDER BY t.Id;
GO
