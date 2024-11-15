import subprocess
import json
import time
import random

def setup_bluetooth():
    # Reset Bluetooth interface
    subprocess.run(['sudo', 'hciconfig', 'hci0', 'down'])
    subprocess.run(['sudo', 'hciconfig', 'hci0', 'up'])
    
    # Set device name
    subprocess.run(['sudo', 'hciconfig', 'hci0', 'name', 'BP Monitor'])
    
    # Make device discoverable
    subprocess.run(['sudo', 'hciconfig', 'hci0', 'piscan'])
    
    print("Bluetooth setup complete")

def main():
    setup_bluetooth()
    print("BP Monitor started. Press Ctrl+C to stop.")
    
    try:
        while True:
            # Generate random BP values
            systolic = random.randint(90, 140)
            diastolic = random.randint(60, 90)
            
            print(f"BP Values - Systolic: {systolic}, Diastolic: {diastolic}")
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\nStopping...")
    finally:
        # Reset Bluetooth interface
        subprocess.run(['sudo', 'hciconfig', 'hci0', 'down'])
        subprocess.run(['sudo', 'hciconfig', 'hci0', 'up'])
        print("Stopped")

if __name__ == "__main__":
    main()