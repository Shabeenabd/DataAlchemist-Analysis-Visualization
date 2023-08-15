-- SQL QUERIES IN THE PROCESS OF DATA CLEANING 

-- creating database
create database housing;

-- creating table
use housing;
create table housing_data(
UniqueID integer,
ParcelID varchar(30),
LandUse	varchar(20),
PropertyAddress	varchar(40),
SaleDate varchar(20),
SalePrice integer,
LegalReference varchar(20),
	SoldAsVacant	varchar(20),
    OwnerName	varchar(20),
    OwnerAddress	varchar(40),
    Acreage	float,
    TaxDistrict	varchar(30),
    LandValue	integer,
    BuildingValue	integer,
    TotalValue	integer,
    YearBuilt	year,
    Bedrooms	tinyint,
    FullBath	tinyint,
HalfBath tinyint);


-- importing housing data into the table using local infile
 show variables like 'local_infile';

 set global local_infile=1;

 use housing; 
 load data local infile 'C:\\Users\\muham\\Desktop\\Nashville Housing Data for Data Cleaning .csv'
into table housing_data
fields terminated by';'
ignore 1 rows;


---------------------------------------------------------------------------------------
-- checking column_name and data_type of the colimns
select column_name,data_type from information_schema.columns where table_schema='housing' and table_name='housing_data';


---------------------------------------------------------------------------------------
-- configuring mysql to enable easy update
SET SQL_SAFE_UPDATES=0;

-- changing emtpty field as null
update housing_data
set PropertyAddress=nullif(PropertyAddress,'')
where PropertyAddress='' ;



---------------------------------------------------------------------------------------
-- Standardize Date Format
Select saleDateConverted, CONVERT(SaleDate,Date)
From housing_data;

Update housing_data
SET SaleDate = CONVERT(SaleDate,Date);

-- If it doesn't Update properly

ALTER TABLE housing_data
Add SaleDateConverted Date;

Update housing_data
SET SaleDateConverted = CONVERT(SaleDate,Date);
---------------------------------------------------------------------------------------

-- filling missing data using join method

update housing_data as a
inner join housing_data as b
on a.ParcelID= b.ParcelID and a.UniqueID<>b.UniqueID
set a.PropertyAddress=ifnull(a.PropertyAddress,b.PropertyAddress)
 where a.PropertyAddress is null;
 ---------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- splitting address column into 2 columns
-- adding new column for address

alter table housing_data
add column address varchar(40);

-- adding new column for city
alter table housing_data
add column city varchar(20);

-- splitting data
update housing_data
set address= substring(propertyaddress,1,position(',' in propertyaddress)-1);

update housing_data
set city=substring(propertyaddress,position(',' in propertyaddress)+1);


---------------------------------------------------------------------------------------
-- changing column positions

alter table housing_data
modify column address varchar(40) after landuse;

alter table housing_data
modify column city varchar(20) after address;

---------------------------------------------------------------------------------------


-- removing old column after splitting

alter table housing_data
drop column propertyaddress;

-- deleting invalid and error data

delete from housing_data
where uniqueid=0 and fullbath is  null;

-- deleting incorrect data

delete from housing_data
where soldasvacant<>'y' and soldasvacant<>'n' and soldasvacant<>'No' and soldasvacant<>'yes';


---------------------------------------------------------------------------------------

-- checking different data values

select soldasvacant  ,count(soldasvacant)
from housing_data
group by soldasvacant  ;

-- configring data value into standard uniform format

update housing_data
 set soldasvacant =case 
	when soldasvacant  ='y' then 'Yes'
	when  soldasvacant  ='n' then 'No'
	else soldasvacant  
	end ;


---------------------------------------------------------------------------------

-- remove duplicates

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

From housing_data
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;



---------------------------------------------------------------------------------


-- Delete Unused Columns



Select *
From  housing_data;


ALTER TABLE housing_data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

--------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------




