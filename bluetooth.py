import json
import time
from bluetooth import *
import random  # For simulating sensor data

# Create a Bluetooth server socket
server_sock = BluetoothSocket(RFCOMM)
server_sock.bind(("", PORT_ANY))
server_sock.listen(1)

# Get the port the server is listening on
port = server_sock.getsockname()[1]

# Advertise the service
uuid = "94f39d29-7d6d-437d-973b-fba39e49d4ee"  # Arbitrary UUID
advertise_service(server_sock, "PiSensor",
                 service_id=uuid,
                 service_classes=[uuid, SERIAL_PORT_CLASS],
                 profiles=[SERIAL_PORT_PROFILE])

print(f"Waiting for connection on RFCOMM channel {port}")

while True:
    client_sock, client_info = server_sock.accept()
    print(f"Accepted connection from {client_info}")

    try:
        while True:
            # Simulate BP sensor data
            sensor_data = {
                "systolic": random.randint(90, 140),
                "diastolic": random.randint(60, 90)
            }
            
            # Convert to JSON and send
            json_data = json.dumps(sensor_data)
            client_sock.send(json_data.encode())
            
            # Wait for 1 second before sending next reading
            time.sleep(1)
            
    except IOError:
        print("Client disconnected")
        client_sock.close()

server_sock.close()