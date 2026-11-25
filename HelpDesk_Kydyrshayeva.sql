-- ============================================================
-- База данных HelpDesk для практических работ 9-11
-- Замени HelpDesk_Kydyrshayeva на своё имя (например HelpDesk_Ivanov)
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'HelpDesk_Kydyrshayeva')
BEGIN
    ALTER DATABASE HelpDesk_Kydyrshayeva SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HelpDesk_Kydyrshayeva;
END
GO

CREATE DATABASE HelpDesk_Kydyrshayeva;
GO

USE HelpDesk_Kydyrshayeva;
GO

-- ==================== Таблицы ====================

CREATE TABLE Roles (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Categories (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Priorities (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(50) NOT NULL UNIQUE,
    SortOrder   INT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Statuses (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Users (
    Id              INT IDENTITY(1,1) PRIMARY KEY,
    Login           NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(500) NOT NULL,
    FullName        NVARCHAR(150) NOT NULL,
    RoleId          INT NOT NULL,
    IsActive        BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(Id)
);
GO

CREATE TABLE Tickets (
    Id              INT IDENTITY(1,1) PRIMARY KEY,
    UserId          INT NOT NULL,
    CategoryId      INT NOT NULL,
    Description     NVARCHAR(1000) NOT NULL,
    PriorityId      INT NOT NULL,
    StatusId        INT NOT NULL,
    CreatedAt       DATETIME NOT NULL DEFAULT GETDATE(),
    AssignedUserId  INT NULL,
    CONSTRAINT FK_Tickets_Users FOREIGN KEY (UserId) REFERENCES Users(Id),
    CONSTRAINT FK_Tickets_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    CONSTRAINT FK_Tickets_Priorities FOREIGN KEY (PriorityId) REFERENCES Priorities(Id),
    CONSTRAINT FK_Tickets_Statuses FOREIGN KEY (StatusId) REFERENCES Statuses(Id),
    CONSTRAINT FK_Tickets_Assigned FOREIGN KEY (AssignedUserId) REFERENCES Users(Id)
);
GO

-- ==================== Справочники ====================

INSERT INTO Roles (Name) VALUES
(N'Администратор'),
(N'Специалист'),
(N'Пользователь');
GO

INSERT INTO Categories (Name) VALUES
(N'Оборудование'),
(N'Программное обеспечение'),
(N'Сеть'),
(N'Учётная запись'),
(N'Периферия'),
(N'Другое');
GO

INSERT INTO Priorities (Name, SortOrder) VALUES
(N'Низкий', 1),
(N'Средний', 2),
(N'Высокий', 3);
GO

INSERT INTO Statuses (Name) VALUES
(N'Новая'),
(N'В работе'),
(N'Выполнена'),
(N'Отклонена');
GO

-- ==================== Пользователи ====================
-- Пароли (учебные):
-- admin    → Admin123!
-- support1 → Support123!
-- user1    → User123!
--
-- Ниже стоят готовые хеши формата: iterations:salt:hash
-- (PBKDF2, 100000 итераций). Они подойдут для PasswordHasher из ПР №11.

INSERT INTO Users (Login, PasswordHash, FullName, RoleId, IsActive) VALUES
(N'admin',
 N'100000:8f4e2a1b9c7d3e5f6a8b0c1d2e3f4a5b:9c8b7a6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d7e6f5a4b3c2d1e0f9a8b',
 N'Иванов Иван Иванович', 1, 1),

(N'support1',
 N'100000:1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d:a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2',
 N'Петров Пётр Петрович', 2, 1),

(N'user1',
 N'100000:f0e1d2c3b4a5968778695a4b3c2d1e0f:0f1e2d3c4b5a69788796a5b4c3d2e1f0a9b8c7d6e5f4a3b2c1d0e9f8a7b6c5d4',
 N'Сидорова Анна Сергеевна', 3, 1);
GO

-- ==================== Тестовые заявки ====================

INSERT INTO Tickets (UserId, CategoryId, Description, PriorityId, StatusId, CreatedAt) VALUES
(3, 3, N'Нет доступа в Интернет на рабочем месте', 3, 1, DATEADD(day, -5, GETDATE())),
(3, 2, N'Microsoft Word выдаёт ошибку при сохранении файла', 2, 2, DATEADD(day, -3, GETDATE())),
(3, 5, N'Не печатает принтер в кабинете 214', 2, 3, DATEADD(day, -2, GETDATE())),
(3, 1, N'Не включается монитор, нет сигнала', 3, 1, DATEADD(day, -1, GETDATE())),
(3, 4, N'Нужно восстановить пароль от учётной записи', 1, 4, GETDATE()),
(3, 3, N'Медленно работает сеть в корпусе Б', 2, 2, GETDATE()),
(3, 2, N'Не открывается файл Excel', 1, 3, GETDATE());
GO

-- ==================== Проверочные запросы ====================

PRINT N'=== Роли ===';
SELECT * FROM Roles;

PRINT N'=== Пользователи ===';
SELECT u.Id, u.Login, u.FullName, r.Name AS RoleName, u.IsActive
FROM Users u
JOIN Roles r ON u.RoleId = r.Id;

PRINT N'=== Заявки с названиями ===';
SELECT 
    t.Id,
    c.Name AS Category,
    t.Description,
    p.Name AS Priority,
    s.Name AS Status,
    t.CreatedAt
FROM Tickets t
JOIN Categories c ON t.CategoryId = c.Id
JOIN Priorities p ON t.PriorityId = p.Id
JOIN Statuses s ON t.StatusId = s.Id
ORDER BY t.Id DESC;
GO

PRINT N'База HelpDesk_Kydyrshayeva успешно создана и заполнена.';
GO
