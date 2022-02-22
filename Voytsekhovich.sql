-- ������ �����
CREATE OR ALTER VIEW View_ListHouse
AS
SELECT        LivingComplex.NameLC, Street.NameStreet, House.HouseNumber, StatusBuilding.NameStatusBuilding, 
COUNT(case when Apartment.IDSaleStatus = 1 then ' ' end) AS '���������', 
COUNT(case when Apartment.IDSaleStatus = 2 then 1 end) AS '�� �������' FROM House 
INNER JOIN LivingComplex	ON House.IDLivingComplex = LivingComplex.ID
INNER JOIN Street			ON House.StreetID = Street.ID
INNER JOIN StatusBuilding	ON LivingComplex.StatusBuildingID = StatusBuilding.ID 
INNER JOIN Apartment		ON Apartment.IDHouse = House.ID
WHERE LivingComplex.IsDeleted != 1 and House.IsDeleted != 1
GROUP BY LivingComplex.NameLC, Street.NameStreet, StatusBuilding.NameStatusBuilding, House.HouseNumber
GO

SELECT * FROM View_ListHouse
GO

-- ������ �������� ����������
CREATE OR ALTER VIEW View_LivingComplexList
AS
SELECT LivingComplex.NameLC, StatusBuilding.NameStatusBuilding AS 'Status of building', 
COUNT(House.ID) AS 'Count house in LC', 
City.NameCity FROM LivingComplex
INNER JOIN House			ON House.IDLivingComplex = LivingComplex.ID
INNER JOIN StatusBuilding	ON LivingComplex.StatusBuildingID = StatusBuilding.ID 
INNER JOIN City				ON City.ID = LivingComplex.CityID
WHERE LivingComplex.IsDeleted != 1 and House.IsDeleted != 1
GROUP BY NameLC, NameStatusBuilding, NameCity
GO

SELECT * FROM View_LivingComplexList 
GO

-- ��������� ��
CREATE OR ALTER VIEW View_InterfaceLC
AS
SELECT LivingComplex.NameLC, LivingComplex.AddCostLC ,StatusBuilding.NameStatusBuilding, LivingComplex.ConstructionCostLC, City.NameCity FROM LivingComplex
INNER JOIN StatusBuilding	ON LivingComplex.StatusBuildingID = StatusBuilding.ID 
INNER JOIN City				ON City.ID = LivingComplex.CityID
WHERE LivingComplex.IsDeleted != 1
GO

SELECT * FROM View_InterfaceLC
GO

-- ������ �������
CREATE OR ALTER VIEW View_ApartmentList
AS
SELECT LivingComplex.NameLC, CONCAT('��.', Street.NameStreet, ' �.', House.HouseNumber, ' ��.', Apartment.NumberAp) AS 'Address', Apartment.Area,
Apartment.CountRoom, Apartment.Entrance, Apartment.Storey, SaleStatus.NameStatus FROM Apartment
INNER JOIN HOUSE			ON House.ID = Apartment.IDHouse
INNER JOIN SaleStatus		ON SaleStatus.ID = Apartment.IDSaleStatus
INNER JOIN LivingComplex	ON LivingComplex.ID = House.IDLivingComplex
INNER JOIN Street			ON Street.ID = House.StreetID
WHERE LivingComplex.IsDeleted != 1 and House.IsDeleted != 1
GO

SELECT * FROM View_ApartmentList
GO

-- ��������� ��������
CREATE OR ALTER VIEW View_ApartmentInterface
AS
SELECT LivingComplex.NameLC, CONCAT('��.', Street.NameStreet, ' �.', House.HouseNumber, ' ��.', Apartment.NumberAp) AS 'Address', Apartment.Area,
Apartment.CountRoom, Apartment.Entrance, Apartment.Storey, SaleStatus.NameStatus, Apartment.AddCostAp, Apartment.ConstraintAp FROM Apartment
INNER JOIN HOUSE			ON House.ID = Apartment.IDHouse
INNER JOIN SaleStatus		ON SaleStatus.ID = Apartment.IDSaleStatus
INNER JOIN LivingComplex	ON LivingComplex.ID = House.IDLivingComplex
INNER JOIN Street			ON Street.ID = House.StreetID 
WHERE LivingComplex.IsDeleted != 1 and House.IsDeleted != 1
GO

SELECT * FROM View_ApartmentInterface
GO
--������ �������� - ��������
CREATE OR ALTER TRIGGER TG_IsDeletedApartment
ON Apartment
INSTEAD OF DELETE
AS
BEGIN
DECLARE @Counter int = (SELECT ID FROM deleted)
			UPDATE Apartment SET IsDeleted = 'True'
		WHERE ID=@Counter
	PRINT '�������� ������ �������'
END
GO
--������ �������� - �������� ���������
CREATE OR ALTER TRIGGER TG_IsDeletedLivingComplex
ON LivingComplex
INSTEAD OF DELETE
AS
BEGIN
DECLARE @Counter int = (SELECT ID FROM deleted)
			UPDATE LivingComplex SET IsDeleted = 'True'
		WHERE ID=@Counter
	PRINT '�������� ������ �������'
END
GO
-- ������ �������� - ����
CREATE OR ALTER TRIGGER TG_IsDeletedHouse
ON House
INSTEAD OF DELETE
AS
BEGIN
DECLARE @Counter int = (SELECT ID FROM deleted)
			UPDATE House SET IsDeleted = 'True'
		WHERE ID=@Counter
	PRINT '�������� ������ �������'
END
GO

--����������� ���������� ���������
ALTER TABLE Apartment ADD CHECK (Apartment.AddCostAp >= 0)
GO
ALTER TABLE House ADD CHECK (House.AddCostHouse >= 0)
GO
ALTER TABLE LivingComplex ADD CHECK (LivingComplex.AddCostLC >= 0)
GO

--����������� ���� �� �������������
ALTER TABLE Apartment ADD CHECK (Apartment.ConstraintAp >= 0)
GO
ALTER TABLE House ADD CHECK (House.ConstructionCostHouse >= 0)
GO
ALTER TABLE LivingComplex ADD CHECK (LivingComplex.ConstructionCostLC >= 0)
GO

-- ����������� ����� ����� ��������
ALTER TABLE Apartment ADD CHECK (Apartment.NumberAp > 0)
GO
--������� �������� ��������������� �����
ALTER TABLE Apartment ADD CHECK (Apartment.Area > 0)
GO
--���������� ������ ����������� �����
ALTER TABLE Apartment ADD CHECK (Apartment.CountRoom > 0)
GO
--������ ������ ����������� �����
ALTER TABLE Apartment ADD CHECK (Apartment.Entrance > 0)
GO
--���� ����������� �����
ALTER TABLE Apartment ADD CHECK (Apartment.Storey > 0)
GO
--������ ������� ��� ��������(������)
ALTER TABLE Apartment ADD CHECK (Apartment.IDSaleStatus = 1 or Apartment.IDSaleStatus = 2)
GO
-- 104 � 105
--))

--������������ ��������� �������� ������ �������� �� ���������, 
--���� ��� ��������� � �������� ���������, ������ �������� �����

CREATE OR ALTER TRIGGER TRIGGER_StausLivingComplex
ON Apartment
FOR INSERT, UPDATE
AS
	IF ((SELECT IDSaleStatus FROM inserted) = 1)
	BEGIN
		IF((SELECT LivingComplex.StatusBuildingID FROM LivingComplex WHERE LivingComplex.ID = 
		(SELECT LivingComplex.ID FROM House WHERE House.ID = 
		(SELECT House.ID FROM Apartment WHERE Apartment.ID = 
		(SELECT inserted.ID FROM inserted)))) = 2)
		BEGIN
			DECLARE @idErrorApartmentNumber INT = (SELECT NumberAp FROM inserted)
			DECLARE @NameErrorLC nvarchar(80) = 
			(SELECT LivingComplex.NameLC FROM LivingComplex WHERE LivingComplex.ID = 
			(SELECT LivingComplex.ID FROM House WHERE House.ID = 
			(SELECT House.ID FROM Apartment WHERE Apartment.ID = 
			(SELECT ID FROM inserted))))

			PRINT CONCAT('���������� �������� ������ ������� �������� ', @idErrorApartmentNumber, 
			' �� sold, �.� ������ ������������� ��������� ���������', @NameErrorLC, ' - plan')
			ROLLBACK TRAN
			END
END
GO

UPDATE Apartment SET IDSaleStatus = 1 WHERE Apartment.ID = 38
GO

CREATE OR ALTER TRIGGER TRIGGER_LCApartment
ON LivingComplex
FOR INSERT, UPDATE
AS
	IF ((SELECT ID FROM inserted) = 2)
	BEGIN
		IF(EXISTS (SELECT (Apartment.ID) FROM Apartment JOIN House ON Apartment.IDHouse = House.ID
					WHERE IDSaleStatus = 1 AND IDLivingComplex =
					(SELECT IDLivingComplex FROM inserted)))
		BEGIN
			DECLARE @idErrorLivingComplex NVARCHAR(80) = (SELECT NameLC from inserted)

			PRINT CONCAT('���������� �������� ������ ������������� ', @idErrorLivingComplex, 
			' �� plan, �.� � ���� �� ���� ��������� ��������')
			ROLLBACK TRAN
			END
END
GO

UPDATE LivingComplex SET StatusBuildingID = 2 WHERE ID = 2


--������ ��������� �������� 
CREATE OR ALTER PROC PR_ApartmentPrice
@ApartmentID int,
@AreaCost decimal(10,2)=100000,
@RoomsCost decimal(10,2)=100000,
@BaseCost decimal(10,2)=100000
AS
BEGIN
DECLARE @IDHouse int = (SELECT IDHouse FROM Apartment WHERE ID = @ApartmentID)
DECLARE @IDLc int = (SELECT IDLivingComplex FROM House WHERE ID=@IDHouse)
DECLARE @Area decimal(10,2)=(SELECT CountRoom FROM Apartment WHERE ID=@ApartmentID)
DECLARE @Rooms int = (SELECT CountRoom FROM Apartment WHERE ID=@ApartmentID)
DECLARE @ApartmentAddCost decimal(10,2) =  (SELECT AddCostAp FROM Apartment WHERE ID=@ApartmentID)
DECLARE @HouseAddCost decimal(10,2) = (SELECT AddCostHouse FROM House WHERE ID=@IDHouse)
DECLARE @LCAddCost decimal(10,2) = (SELECT AddCostLC FROM LivingComplex WHERE ID=@IDLc)
DECLARE @Result decimal(10,2) = (@Area*@AreaCost)+(@Rooms*@RoomsCost)+@ApartmentAddCost+@HouseAddCost+@LCAddCost+@BaseCost
Return @Result
END

DECLARE @Result decimal(10,2)
EXEC @Result = PR_ApartmentPrice 1
PRINT @Result
GO





-- ������� ��������� ����
CREATE OR ALTER PROC PR_HousePrice
	@IdHouse int
AS
BEGIN
IF(NOT EXISTS(SELECT ID FROM House WHERE ID = @IdHouse))
BEGIN
	PRINT '���������� ���� �� ����������'
	return 0
END

ELSE IF ((SELECT isDeleted FROM House WHERE ID = @IdHouse)=1)
BEGIN
	PRINT '��������� ��� ������'
	return 0
END

ELSE
BEGIN
DECLARE @ReturnedCost decimal(15,2) = 0;
DECLARE @MaxID int = (SELECT MAX(ID) FROM Apartment)
DECLARE @MinID int = (SELECT MIN(ID) FROM Apartment)
DECLARE @GetResult decimal(15,2) = 0

WHILE(@MinID <= @MaxID)
	BEGIN
		IF(EXISTS(SELECT ID FROM Apartment WHERE ID = @MinID AND ID = @IdHouse AND isDeleted !=1))
		BEGIN
			EXEC @GetResult = PR_ApartmentPrice @MinID
			SET @ReturnedCost = @ReturnedCost + @GetResult
			SET @GetResult = 0
			END
		SET @MinID = @MinID + 1
		END
RETURN @ReturnedCost
END
END
GO

DECLARE @ReturnedCost decimal(15,2) = 0
EXEC @ReturnedCost = PR_HousePrice 8
PRINT @ReturnedCost


-- ������� ��������� ��
CREATE OR ALTER PROC PR_LivingComplexPrice
	@IdLivingComplex int
AS
BEGIN
IF(NOT EXISTS(SELECT ID FROM LivingComplex WHERE ID = @IdLivingComplex))
BEGIN
	PRINT '���������� �� �� ����������'
	return 0
END

ELSE IF ((SELECT isDeleted FROM LivingComplex WHERE ID = @IdLivingComplex)=1)
BEGIN
	PRINT '��������� �� ������'
	return 0
END

ELSE
BEGIN
DECLARE @ReturnedCost decimal(15,2) = 0;
DECLARE @MaxID int = (SELECT MAX(ID) FROM House)
DECLARE @MinID int = (SELECT MIN(ID) FROM House)
DECLARE @GetResult decimal(15,2) = 0

WHILE(@MinID <= @MaxID)
	BEGIN
		IF(EXISTS(SELECT ID FROM House WHERE ID = @MinID AND ID = @IdLivingComplex AND isDeleted !=1))
		BEGIN
			EXEC @GetResult = PR_ApartmentPrice @MinID
			SET @ReturnedCost = @ReturnedCost + @GetResult
			SET @GetResult = 0
			END
		SET @MinID = @MinID + 1
		END
RETURN @ReturnedCost
END
END
GO

DECLARE @ReturnedCost decimal(15,2) = 0
EXEC @ReturnedCost = PR_LivingComplexPrice 1
PRINT @ReturnedCost
