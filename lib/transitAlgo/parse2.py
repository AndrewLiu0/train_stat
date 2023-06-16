import csv
from datetime import datetime, timedelta
import scipy.stats as stats

def convert_minutes_to_datetime(minutes):
    # Convert minutes to timedelta object
    timedelta_obj = timedelta(minutes=minutes)

    # Get the current datetime
    current_datetime = datetime.now()

    # Add the timedelta to the current datetime
    result_datetime = current_datetime + timedelta_obj

    return result_datetime

def generate_delay():
    return stats.t.rvs(df=2, loc=2.18, scale=0.90, size=1)[0]

def calculate_travel_time(start_station_id, end_station_id):
    # organized into a list of dictionaries
    # the list represents the row and correpsonding fields in the dictionary are searchable

    # read stop_times.txt file
    with open('stop_times.txt', 'r') as file:
        stop_times_reader = csv.DictReader(file)
        stop_times_data = list(stop_times_reader)

    # read stops.txt file
    with open('stops.txt', 'r') as file:
        stops_reader = csv.DictReader(file)
        stops_data = list(stops_reader)

    # Create a dictionary to map stop_id to stop_name
    stop_name_mapping = {stop['stop_id']: stop['stop_name']
                         for stop in stops_data}

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
        travel_time += timedelta(minutes=generate_delay())

        # Extract individual components of travel time
        hours = travel_time.seconds // 3600
        minutes = (travel_time.seconds % 3600) // 60
        seconds = travel_time.seconds % 60

        print(f"Travel time from {stop_name_mapping[start_station_id]} to {stop_name_mapping[end_station_id]}:")
        print(f"Travel time: {hours} hours, {minutes} minutes, {seconds} seconds")
    else:
        print("Unable to calculate travel time for the specified stations.")

# Example usage
start_station_id = 'A02S'  # should be flutter input
end_station_id = 'H11S'  # should be flutter input

calculate_travel_time(start_station_id, end_station_id)