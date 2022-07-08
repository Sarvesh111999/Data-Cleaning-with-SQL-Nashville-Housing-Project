--Cleaning Data in SQL queries

select * from DataCleaningNashville..[NashvilleHousing ] 	

select * from DataCleaningNashville.dbo.[NashvilleHousing ]


--Standerize Date Format

select SaleDateConverted, Convert(Date, SaleDate) from DataCleaningNashville.dbo.[NashvilleHousing ]
Update [NashvilleHousing ]
SET SaleDate = Convert(Date, SaleDate)

ALTER TABLE [NashvilleHousing ]
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)




--Populate Property Address Data

select PropertyAddress from DataCleaningNashville.dbo.[NashvilleHousing ]
--where PropertyAddress is null
Order by ParcelID 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from DataCleaningNashville.dbo.[NashvilleHousing ] a
JOIN DataCleaningNashville.dbo.[NashvilleHousing ] b
        on a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from DataCleaningNashville.dbo.[NashvilleHousing ] a
JOIN DataCleaningNashville.dbo.[NashvilleHousing ] b
        on a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is NULL






-- Breaking out Address into Individual Columns (Address, City, State)



select PropertyAddress from DataCleaningNashville..[NashvilleHousing ] 	

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
, LEN(PropertyAddress)
From DataCleaningNashville.dbo.[NashvilleHousing ]


ALTER TABLE [NashvilleHousing ]
Add PropertySplitAddress Nvarchar(255)
     

Update [NashvilleHousing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE [NashvilleHousing ]
Add PropertySplitCity Nvarchar(255)

Update [NashvilleHousing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


select * from DataCleaningNashville..[NashvilleHousing ] 	







select OwnerAddress from DataCleaningNashville..[NashvilleHousing ] 	

select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
     from DataCleaningNashville..[NashvilleHousing ] 



ALTER TABLE [NashvilleHousing ]
Add OwnerSplitAddress Nvarchar(255)
     
Update [NashvilleHousing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE [NashvilleHousing ]
Add OwnerSplitCity Nvarchar(255)

Update [NashvilleHousing ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE [NashvilleHousing ]
Add OwnerSplitState Nvarchar(255)

Update [NashvilleHousing ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select * from DataCleaningNashville..[NashvilleHousing ] 	






-- Change Y and N to Yes and No in "Sold as Vacant" field


select Distinct(SoldAsVacant), Count(SoldAsVacant)
from DataCleaningNashville..[NashvilleHousing ]
group by SoldAsVacant
order by 2


Select SoldAsVacant, CASE when SoldAsVacant = 'Y' then 'Yes'
                          when SoldAsVacant = 'N' then 'No'
						  Else SoldAsVacant
						  End
from DataCleaningNashville..[NashvilleHousing ]

Update [NashvilleHousing ]
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
                          when SoldAsVacant = 'N' then 'No'
						  Else SoldAsVacant
						  End






-- Remove Duplicate 


WITH RowNUmCTE as(
         select Row_Number() Over(
                    Partition BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
					  
					         Order by UniqueID ) Row_Num, *

          from DataCleaningNashville..[NashvilleHousing ]
           --Order by ParcelID 
                    )
select * from RowNUmCTE 
      where Row_Num > 1
	  



WITH RowNUmCTE as(
         select Row_Number() Over(
                    Partition BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
					  
					         Order by UniqueID ) Row_Num, *

          from DataCleaningNashville..[NashvilleHousing ]
           --Order by ParcelID 
                    )
Delete from RowNUmCTE 
      where Row_Num > 1







-- Delete Unused Column

select * from DataCleaningNashville..[NashvilleHousing ]


ALTER TABLE DataCleaningNashville..[NashvilleHousing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE DataCleaningNashville..[NashvilleHousing ]
DROP COLUMN SaleDate 








