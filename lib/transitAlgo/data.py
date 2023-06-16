import csv
from datetime import datetime


def calculate_travel_time(start_station_id, end_station_id);
    
    # organied into a list of dictionaries
    # the list represents the row and correpsonding fields in the dictionary are searchable

    # read stop_times.txt file, 
    with open('stop_times.txt', 'r') as file:
        stop_times_reader = csv.DictReader(file)
        stop_times_data = list(stop_times_reader)

    # Read stops.txt file
    with open('stops.txt', 'r') as file:
        stops_reader = csv.DictReader(file)
        stops_data = list(stops_reader)
    

    # Dictionary mapping stop_id to human readable stop_name
    stop_name_mapping = {stop['stop_id']: stop['stop_name']
                         for stop in stops_data}
    
    #Finding trips
    for row in stop_times_data:
        
    
