## Owner(s)

Lucas Allman

## Usage

This code is used to create a table in the database that will store the data from the `s3://nyc-tlc/trip data/` bucket. The table will be called `taxi_data` and will be stored in the `taxi` database. The table will have the following columns:
1. `vendor_id` - The ID of the vendor that provided the data
2. `pickup_datetime` - The date and time of the pickup
3. `dropoff_datetime` - The date and time of the dropoff
4. `passenger_count` - The number of passengers in the taxi

## Dependencies

This code requires the following libraries:
- `boto3`
- `pandas`
- `pyarrow`
- `s3fs`

## Scheduled

The code runs `once daily` at `00:00 UTC`.

Scheduled Task Name: `Get Taxi Data`

## Down Stream

The output of this code is a table in the `taxi` database that will be used by the `Taxi Analysis` PowerBI report.
The report is located [here](https://app.powerbi.com/groups/me/reports/3e3e3e3e-3e3e-3e3e-3e3e-3e3e3e3e3e3e)

## End Date
The code will run indefinitely.
Review after 12 months `(2023-07-01)`

