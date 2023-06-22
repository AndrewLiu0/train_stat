import csv
from datetime import datetime, timedelta
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt

# fields needed for algorithm generation
start_name = '34 St-Penn Station'
end_name = 'Chambers St'

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

def full_time():
    final_time = calculate_travel_time(start_station_id,end_station_id) + timedelta(minutes=generate_delay())

    # Extract individual components of travel time
    hours = final_time.seconds // 3600
    minutes = (final_time.seconds % 3600) // 60
    seconds = final_time.seconds % 60

    # print(f"Travel time from {id_to_name[start_station_id]} to {id_to_name[end_station_id]}:")
    # print(f"Travel time: {hours} hours, {minutes} minutes, {seconds} seconds")
    return seconds + minutes*60 + hours*3600
    
# Example usage
start_station_id = '701S'  # should be flutter input
end_station_id = '726S'  # should be flutter input



print(calculate_travel_time(start_station_id, end_station_id))

# travelsimulation = []
# for i in range(100):
#     travel_time = full_time()
#     travelsimulation.append(travel_time/60)
# plt.hist(travelsimulation, bins=20, density=True)
# plt.xlabel('Minutes')
# plt.ylabel('Frequency')

# # plt.xlim(0, 10)
# plt.show()
