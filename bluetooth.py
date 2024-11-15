from bluetooth import BluetoothSocket, RFCOMM, PORT_ANY, SERIAL_PORT_CLASS, SERIAL_PORT_PROFILE, advertise_service
import json
import time
import random  # For simulating sensor data

def start_bluetooth_server():
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
    return server_sock

def main():
    server_sock = start_bluetooth_server()
    
    try:
        while True:
            print("Waiting for a connection...")
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
                    print(f"Sending data: {json_data}")
                    client_sock.send(json_data.encode())
                    
                    # Wait for 1 second before sending next reading
                    time.sleep(1)
                    
            except IOError as e:
                print(f"Error: {e}")
                print("Client disconnected")
                client_sock.close()
                
    except KeyboardInterrupt:
        print("\nShutting down server...")
    finally:
        server_sock.close()
        print("Server closed")

if __name__ == "__main__":
    main()