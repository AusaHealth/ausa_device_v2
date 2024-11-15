import subprocess
import json
import time
import random
import os

def get_connected_devices():
    """Check for connected Bluetooth devices"""
    try:
        result = subprocess.check_output(['bluetoothctl', 'devices'], text=True)
        return len(result.strip().split('\n')) > 0
    except:
        return False

def get_bt_address():
    """Get the Bluetooth address of the Pi"""
    try:
        result = subprocess.check_output(['hciconfig'], text=True)
        for line in result.split('\n'):
            if 'BD Address' in line:
                return line.split('Address: ')[1].split(' ')[0]
    except:
        return "Unknown"
    return "Unknown"

def setup_bluetooth():
    """Setup Bluetooth with a distinctive name"""
    # Reset Bluetooth interface
    os.system('sudo hciconfig hci0 down')
    os.system('sudo hciconfig hci0 up')
    
    # Set a distinctive device name
    DEVICE_NAME = "BP_MONITOR_PI"
    os.system(f'sudo hciconfig hci0 name "{DEVICE_NAME}"')
    
    # Make device discoverable
    os.system('sudo hciconfig hci0 piscan')
    
    # Get and print device info
    bt_address = get_bt_address()
    print(f"\nDevice Details:")
    print(f"Name: {DEVICE_NAME}")
    print(f"Bluetooth Address: {bt_address}")
    print("\nBluetooth setup complete")
    
    return DEVICE_NAME

def check_connection_status():
    """Check if any device is connected using bluetoothctl"""
    try:
        # Get list of connected devices
        result = subprocess.check_output(['bluetoothctl', 'info'], text=True)
        return "Connected: yes" in result
    except:
        return False

def main():
    print("Starting BP Monitor Setup...")
    device_name = setup_bluetooth()
    print("\nWaiting for connections...")
    
    last_status = False  # Track last connection status
    last_values = {'systolic': 0, 'diastolic': 0}  # Track last sent values
    
    try:
        while True:
            is_connected = check_connection_status()
            
            if is_connected:
                if not last_status:  # Just connected
                    print("\nDevice connected! Starting data transmission...")
                
                # Generate new values only when connected
                systolic = random.randint(90, 140)
                diastolic = random.randint(60, 90)
                
                # Only print if values changed
                if systolic != last_values['systolic'] or diastolic != last_values['diastolic']:
                    print(f"\rSending - Systolic: {systolic}, Diastolic: {diastolic}", end='', flush=True)
                    last_values['systolic'] = systolic
                    last_values['diastolic'] = diastolic
            else:
                if last_status:  # Just disconnected
                    print("\nDevice disconnected. Waiting for new connection...")
                    print(f"Looking for this device on your iPad as: {device_name}")
            
            last_status = is_connected
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\n\nStopping...")
    finally:
        os.system('sudo hciconfig hci0 down')
        os.system('sudo hciconfig hci0 up')
        print("Stopped")

def setup_prerequisites():
    """Check and setup required permissions and tools"""
    try:
        # Check if bluetoothctl is available
        subprocess.check_output(['which', 'bluetoothctl'])
    except:
        print("bluetoothctl not found. Installing bluetooth tools...")
        os.system('sudo apt-get update')
        os.system('sudo apt-get install -y bluetooth bluez')
    
    # Ensure bluetooth service is running
    os.system('sudo systemctl start bluetooth')
    
    # Add current user to bluetooth group
    os.system('sudo usermod -a -G bluetooth $USER')
    
    print("Prerequisites check completed")

if __name__ == "__main__":
    setup_prerequisites()
    main()