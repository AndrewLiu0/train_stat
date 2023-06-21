import csv
from datetime import datetime

import asyncio
import websockets

async def get_input():
    async with websockets.connect('wss://echo.websocket.events') as websocket:
        while True:
            start = await websocket.recv()
            end = await websocket.recv() # this should be the order in which the two messages are sent in to the server? needs looking into

#loop = asyncio.get_event_loop()
#loop.run_until_complete(send_input())

def calculate_travel_time(start_station_id, end_station_id):

    # organied into a list of dictionaries
    # the list represents the row and correpsonding fields in the dictionary are searchable

    # read stop_times.txt file, 

    # Read stop_times.txt file
    with open('stop_times.txt', 'r') as file:
        stop_times_reader = csv.DictReader(file)
        stop_times_data = list(stop_times_reader)

    # Read stops.txt file
    with open('stops.txt', 'r') as file:
        stops_reader = csv.DictReader(file)
        stops_data = list(stops_reader)

    # Create a dictionary to map stop_id to stop_name
    stop_name_mapping = {stop['stop_id']: stop['stop_name']
                         for stop in stops_data}
    
    # export to csv file 
    name_to_id = {v: k for k, v in stop_name_mapping.items()}

    keys = name_to_id.keys()
    with open('station_name_to_id.csv','w',newline = '') as file:
        writer = csv.DictWriter(file,fieldnames=keys)
        writer.writeheader()
        writer.writerow(name_to_id)



    
    # export to csv file 
    name_to_id = {v: k for k, v in stop_name_mapping.items()}

    keys = name_to_id.keys()
    with open('station_name_to_id.csv','w',newline = '') as file:
        writer = csv.DictWriter(file,fieldnames=keys)
        writer.writeheader()
        writer.writerow(name_to_id)




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
        print(
            f"Travel time from {stop_name_mapping[start_station_id]} to {stop_name_mapping[end_station_id]}:")
        print(f"Travel time: {travel_time}")
    else:
        print("Unable to calculate travel time for the specified stations.")


# Example usage
start_station_id = 'A02S'  # Replace with the desired start station ID
end_station_id = 'H11S'  # Replace with the desired end station ID

double d = calculate_travel_time(start_station_id, end_station_id)


async def send_input():
    async with websockets.connect('ws://localhost:8765') as websocket:
        while True:
            message = d
            await websocket.send(message)

loop = asyncio.get_event_loop()
loop.run_until_complete(send_input())
