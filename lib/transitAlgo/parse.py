
import csv
from datetime import datetime, timedelta

# read stop_times.txt file
with open('stop_times.txt', 'r') as file:
    stop_times_reader = csv.DictReader(file)
    stop_times_data = list(stop_times_reader)

# read stops.txt file
with open('stops.txt', 'r') as file:
    stops_reader = csv.DictReader(file)
    stops_data = list(stops_reader)

# Create a dictionary to map stop_id to stop_name
id_to_name = {stop['stop_id']: stop['stop_name']
                        for stop in stops_data}

name_to_id = {v: k for k, v in id_to_name.items()}

def generate_delay():
    return stats.t.rvs(df=2, loc=2.18, scale=0.90, size=1)[0]

def calculate_travel_time(start_station_id, end_station_id):
    # organized into a list of dictionaries
    # the list represents the row and correpsonding fields in the dictionary are searchable

    # Find relevant trips
    relevant_trips = []
    for row in stop_times_data:
        if row['stop_id'] == start_station_id:
            relevant_trips.append(row['trip_id'])
        elif row['stop_id'] == end_station_id:
            if row['trip_id'] in relevant_trips:
                break

    # Find the starting and ending stop times
    start_time = None
    end_time = None
    for row in stop_times_data:
        if row['trip_id'] in relevant_trips:
            if row['stop_id'] == start_station_id:
                start_time = datetime.strptime(row['arrival_time'], '%H:%M:%S')
            elif row['stop_id'] == end_station_id:
                end_time = datetime.strptime(row['arrival_time'], '%H:%M:%S')

    # Calculate travel time
    if start_time and end_time:
        travel_time = end_time - start_time
        return travel_time
    else:
        print("Unable to calculate travel time for the specified stations.")


start_station_id = '701S' 
end_station_id = '726S'  



print(calculate_travel_time(start_station_id, end_station_id))
