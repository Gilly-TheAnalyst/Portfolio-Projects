-------------------------------------------------------------------------------------------------------------------------------------------------------

--CLEANING DATA IN SQL QUERIES

SELECT *
FROM [Portfolio Project - SQL].DBO.NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------------------------

--STANDARDIZE DATE FORMAT

SELECT SaleDate, CONVERT(DATE, SALEDATE)
FROM [Portfolio Project - SQL].DBO.NashvilleHousing

SELECT SaleDateConverted, CONVERT(DATE, SALEDATE)
FROM [Portfolio Project - SQL].DBO.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SALEDATE)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SALEDATE)

-------------------------------------------------------------------------------------------------------------------------------------------------------

--POPULATE PROPERT ADDRESS DATA

SELECT *
FROM [Portfolio Project - SQL].DBO.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM [Portfolio Project - SQL].DBO.NashvilleHousing
ORDER BY ParcelID

SELECT PropertyAddress
FROM [Portfolio Project - SQL].DBO.NashvilleHousing
WHERE PropertyAddress IS NULL


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Portfolio Project - SQL].DBO.NashvilleHousing A
JOIN [Portfolio Project - SQL].DBO.NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


UPDATE A 
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Portfolio Project - SQL].DBO.NashvilleHousing A
JOIN [Portfolio Project - SQL].DBO.NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

-------------------------------------------------------------------------------------------------------------------------------------------------------

--BREAKING OUT ADDRESS INTO INDIVDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM [Portfolio Project - SQL].DBO.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS ADDRESS
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS ADDRESS

FROM [Portfolio Project - SQL].DBO.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM [Portfolio Project - SQL].DBO.NashvilleHousing


SELECT OwnerAddress
FROM [Portfolio Project - SQL].DBO.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [Portfolio Project - SQL].DBO.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
FROM [Portfolio Project - SQL].DBO.NashvilleHousing


-------------------------------------------------------------------------------------------------------------------------------------------------------

--CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project - SQL].DBO.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM [Portfolio Project - SQL].DBO.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

-------------------------------------------------------------------------------------------------------------------------------------------------------

--REMOVE DUPLICATES

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
				
FROM [Portfolio Project - SQL].DBO.NashvilleHousing
ORDER BY ParcelID


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
				
FROM [Portfolio Project - SQL].DBO.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
				
FROM [Portfolio Project - SQL].DBO.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1


-------------------------------------------------------------------------------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

SELECT *
FROM [Portfolio Project - SQL].DBO.NashvilleHousing

ALTER TABLE [Portfolio Project - SQL].DBO.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate