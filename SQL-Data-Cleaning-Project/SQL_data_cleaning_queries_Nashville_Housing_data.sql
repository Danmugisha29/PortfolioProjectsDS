
/*
 Author: Dan Mugisha
 Project : SQL Data cleaning
 Dataset: Nashville housing data 
 Skills used :  Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- Check all Nashville housing data

SELECT* 
FROM 
Nashville_housing_data

-- change date format
-- SaleDate conversion into new format
-- Add new column that will have the new sale date format

ALTER TABLE Nashville_housing_data
Add Sale_date_new_format Date;

Update Nashville_housing_data 
SET Sale_date_new_format = CONVERT(date,SaleDate)


-- Populating property address
-- Fill in missing data for Property address 
-- with the same ParcelID
-- Performed self-join operations to fill in those values.

SELECT PropertyAddress FROM 
Nashville_housing_data

SELECT a.[UniqueID ], a. ParcelID, a.PropertyAddress,
b.[UniqueID ],b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
Nashville_housing_data a
Join Nashville_housing_data b
on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 ----where a.PropertyAddress is null

Update a
SET 
PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM Nashville_housing_data a
Join Nashville_housing_data b
on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

------------------------------------------------

-- Breaking out Address into individual colummns

-- PropertyAddress split
-- Address, city

Select PropertyAddress
FROM
Nashville_housing_data

--SELECT
--SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) 
--as Address, 
--SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,
--LEN(PropertyAddress)) as City
--FROM
--Nashville_housing_data

--- Add new column : Property_address_new_format
-- column with split from previous Property_address

ALTER TABLE Nashville_housing_data
Add Property_Address_new_format nvarchar(255);

Update Nashville_housing_data 
SET 
Property_Address_new_format = 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)


--- Add new column : Property_Address_City
--- column with city that was split from PropertyAddress column

ALTER TABLE Nashville_housing_data
Add Property_Address_City nvarchar(255);

Update Nashville_housing_data 
SET 
Property_Address_City = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,
LEN(PropertyAddress))


--- OwnerAddress column split
--- Address, city, state

-- Address Split

ALTER TABLE Nashville_housing_data
Add Owner_Split_Address nvarchar(255);

Update Nashville_housing_data 
SET 
Owner_Split_Address = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

-- Owner address
-- City split

ALTER TABLE Nashville_housing_data
Add Owner_Split_City nvarchar(255);

Update Nashville_housing_data 
SET 
Owner_Split_City = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
 
 -- Owner Address
 -- State split

ALTER TABLE Nashville_housing_data
Add Owner_Split_State nvarchar(255);

Update Nashville_housing_data 
SET 
Owner_Split_State = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--- Change Y And N to Yes and No

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
from Nashville_housing_data 
GROUP by SoldAsVacant
order by 2


SELECT SoldAsVacant,
CASE when SoldAsVacant ='Y' THEN 'Yes'
     when SoldAsVacant ='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from Nashville_housing_data


Update Nashville_housing_data 
SET 
SoldAsVacant = CASE when SoldAsVacant ='Y' THEN 'Yes'
                    when SoldAsVacant ='N' THEN 'No'
	                ELSE SoldAsVacant
	                END

------------------------------------------------------
------------------------------------------------------

-- Remove duplicates
 
 With Row_Number_CTE AS
(
SELECT *,
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
					UniqueID)
					row_num
FROM
Nashville_housing_data
--order by ParcelID
)
SELECT *
FROM 
Row_Number_CTE
where row_num > 1 -- Rows that are present more than once
--order by PropertyAddress

-----------------------------------------
-----------------------------------------

SELECT* 
FROM 
Nashville_housing_data

--Delete Unused Columns

ALTER TABLE Nashville_housing_data
DROP COLUMN OwnerAddress,PropertyAddress, SaleDate, TaxDistrict