/* 
Create new table “divvy_tripdata_2021” table 
*/

CREATE TABLE divvy_tripdata_2021 
(
ride_id varchar(50) not null,
rideable_type varchar(50) null,
started_at datetime null,
ended_at datetime null,
ride_length varchar(50) null,
start_station_name varchar(max) null,
start_station_id varchar(max) null,
end_station_name varchar(max) null,
end_station_id varchar(max) null,
start_lat float null,
start_lng float null,
end_lat float null,
end_lng float null,
member_casual varchar(50) null,
day_of_week varchar(50) null,
text_day_of_week varchar(50) null,
	PRIMARY KEY (ride_id)
);

/* 
Combine all 12 months of 2021 divvy tripdata by insert them into new “divvy_tripdata_2021” table 
*/

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202101-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202102-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202103-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202104-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202105-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202106-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202107-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202108-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202109-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202110-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202111-divvy-tripdata];

INSERT INTO [dbo].[divvy_tripdata_2021]
SELECT * FROM [dbo].[202112-divvy-tripdata];

/* 
Run new “divvy_tripdata_2021” table to see 12-month records
*/

SELECT *
FROM [dbo].[divvy_tripdata_2021];

/* 
Show all fields and add "ride length" column
Filter out null values and "base - 2132 w hubbard warehouse" from start_station_name
Filter out negative "ride length" values
*/

SELECT *, DATEDIFF(second,[started_at],[ended_at]) AS 'ride_length'
FROM [dbo].[divvy_tripdata_2021]
WHERE [start_station_name] <> 'Base - 2132 W Hubbard Warehouse'
AND
[start_station_name] IS NOT NULL
AND
DATEDIFF(second,[started_at],[ended_at])>=0
;
