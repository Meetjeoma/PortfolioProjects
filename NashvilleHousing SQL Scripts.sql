/*
--Cleaning Data in SQL
*/
--SELECT *
--FROM PortfolioProject..NashvilleHousing
-------------------------------------------------------------------------


----CHANGING THE DATE FORMAT

SELECT SaleDateConverted, CONVERT(DATE,Saledate)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = CONVERT(DATE,Saledate)


--POPULATE PROPERTY ADDRESS DATA

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
Where PropertyAddress is null

SELECT *
FROM PortfolioProject..NashvilleHousing
--Where PropertyAddress is null

SELECT *
FROM PortfolioProject..NashvilleHousing
Order by ParcelID

sELECT a.parcelid, a.propertyaddress, b.propertyaddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
	where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
	where a.PropertyAddress is null


--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing 

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing 

ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing 
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



SELECT *
FROM PortfolioProject..NashvilleHousing

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE NashvilleHousing 
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



--CHANGE Y AND N TO YES AND NO


SELECT DISTINCT(SoldASVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldASVacant
ORDER BY SoldASVacant

SELECT SoldASVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


----------REMOVE DUPLICATES AND UNUSED COLUMNS

WITH RowNumCTE as(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					uniqueID
					) row_num
FROM PortfolioProject..NashvilleHousing)
--Order By ParcelID
Select *
From RowNumCTE
where row_num > 1
ORDER BY propertyaddress


-------DELETING UNUSED COLUMNS

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


SELECT*
FROM PortfolioProject..NashvilleHousing
