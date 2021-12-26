

-- Cleaning Data using SQL Queries

Select * 
From  PortfolioProjects..NashvilleHousing
----------------------------------------------------



-- Standardize Date Format

Select SaleDateConverted, CONVERT(date,SaleDate)
From  PortfolioProjects..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

--IF IT DOESN´T UPDATE PROPERLY

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)


----------------------------------------------------

-- Populate Property Address data

Select *
From  PortfolioProjects..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From  PortfolioProjects..NashvilleHousing a
JOIN  PortfolioProjects..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From  PortfolioProjects..NashvilleHousing a
JOIN  PortfolioProjects..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




----------------------------------------------------


Select PropertyAddress
From  PortfolioProjects..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) as Address


From  PortfolioProjects..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))




Select OwnerAddress
From  PortfolioProjects..NashvilleHousing

Select 
PARSENAME(Replace (OwnerAddress,',','.'),3)
,PARSENAME(Replace (OwnerAddress,',','.'),2)
,PARSENAME(Replace (OwnerAddress,',','.'),1)
from PortfolioProjects..NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace (OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace (OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace (OwnerAddress,',','.'),1)






----------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct SoldAsVacant, count(SoldAsVacant) as Total
From  PortfolioProjects..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
From  PortfolioProjects..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END




----------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num


from PortfolioProjects..NashvilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
where row_num > 1



----------------------------------------------------


-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

