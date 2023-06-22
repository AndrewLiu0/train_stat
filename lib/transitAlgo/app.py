from flask import Flask, request
from flask_api import status, exceptions
from parse import calculate_travel_time

app = Flask(__name__)

@app.route('/calculate_time', methods=['POST'])
def calculate_time():
    try:
        origin = request.json['origin']
        destination = request.json['destination']
        travel_time = calculate_travel_time(origin, destination)
        return {'travel_time': travel_time}, status.HTTP_200_OK
    except Exception as e:
        return {'error': str(e)}, status.HTTP_400_BAD_REQUEST

if __name__ == '__main__':
    app.run()
