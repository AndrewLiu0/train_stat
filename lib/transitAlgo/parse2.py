import asyncio
import base64
import csv
from datetime import datetime, timedelta
import json
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt
import websockets

async def start_server():
    async with websockets.serve(get_inputs, "localhost", 8765):
        await asyncio.Future()

loop = asyncio.get_event_loop()
# fields needed for algorithm generation
start_name = '34 St-Penn Station' # default value? should be a empty string.
end_name = 'Chambers St' # default value for now, should be empty.
async def get_inputs(websocket, path):
    async for message in websocket:
        data = json.loads(message)
        start_name = data['location']
        end_name = data['destination']

        response = {'time': calculate_travel_time(name_to_id.get(start_name), name_to_id.get(end_name))}
        response_json = json.dumps(response)

        
        await websocket.send(response_json)
        loop.run_until_complete(start_server())
        loop.run_forever()

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
start_station_id = start_name  # should be flutter input
end_station_id = end_name  # should be flutter input

async def send_image():
    async with websockets.connect('ws://localhost:8765') as websocket:
        with open(plt, 'rb') as image_file:
          # Read the image file as bytes
            image_bytes = image_file.read()

             #Encode the image as Base64
            image_base64 = base64.b64encode(image_bytes).decode('utf-8')

             #Send the image data over the WebSocket
            await websocket.send(image_base64)

    """ m = print(calculate_travel_time(name_to_id.get(start_name), name_to_id.get(end_name)))
    async def send_input():
        async with websockets.connect('ws://localhost:8765') as websocket:
            message = m """
            #message2 = img
            #await websocket.send(message)
           # await websocket.send(message2)


# loop.run_until_complete(send_input())
# loop.run_until_complete(send_image())

travelsimulation = []
for i in range(100):
    travel_time = full_time()
    travelsimulation.append(travel_time/60)
plt.hist(travelsimulation, bins=20, density=True)
plt.xlabel('Minutes')
plt.ylabel('Frequency')
img = plt
# plt.xlim(0, 10)
plt.show()
