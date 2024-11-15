import socket
import json
import time
import random
import subprocess

def get_bluetooth_address():
    """Get the Bluetooth address of the local device"""
    try:
        # Run hciconfig command and capture output
        result = subprocess.check_output(['hciconfig']).decode('utf-8')
        # Find the BD Address line
        for line in result.split('\n'):
            if 'BD Address:' in line:
                # Extract and return the address
                return line.split('BD Address: ')[1].split(' ')[0]
    except:
        return "00:00:00:00:00:00"  # Return default address if failed

def create_bluetooth_socket():
    # Get the local Bluetooth address
    bd_addr = get_bluetooth_address()
    print(f"Using Bluetooth address: {bd_addr}")
    
    server_sock = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM)
    server_sock.bind((bd_addr, 1))  # Use port 1 for RFCOMM
    server_sock.listen(1)
    return server_sock

def main():
    print("Starting Bluetooth BP Sensor...")
    
    try:
        server_sock = create_bluetooth_socket()
        print("Waiting for connection...")
        
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
    except Exception as e:
        print(f"Failed to start server: {e}")
    finally:
        try:
            server_sock.close()
        except:
            pass

if __name__ == "__main__":
    main()