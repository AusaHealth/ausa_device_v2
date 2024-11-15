import socket
import json
import time
import random

def create_bluetooth_socket():
    server_sock = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM)
    server_sock.bind(("", 1))  # Use port 1 for RFCOMM
    server_sock.listen(1)
    return server_sock

def main():
    server_sock = create_bluetooth_socket()
    print("Waiting for connection...")
    
    try:
        while True:
            client_sock, address = server_sock.accept()
            print(f"Accepted connection from {address}")
            
            try:
                while True:
                    # Generate BP data
                    bp_data = {
                        "systolic": random.randint(90, 140),
                        "diastolic": random.randint(60, 90)
                    }
                    
                    # Convert to JSON and send
                    json_data = json.dumps(bp_data)
                    print(f"Sending data: {json_data}")
                    client_sock.send(json_data.encode())
                    time.sleep(1)
                    
            except Exception as e:
                print(f"Error: {e}")
                client_sock.close()
                
    except KeyboardInterrupt:
        print("\nShutting down...")
    finally:
        server_sock.close()

if __name__ == "__main__":
    main()