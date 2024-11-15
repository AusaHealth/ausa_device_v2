import asyncio
from bleak import BleakServer
import random
import struct

# Bluetooth settings
DEVICE_NAME = "BP Monitor"
SERVICE_UUID = "00001810-0000-1000-8000-00805f9b34fb"  # Blood Pressure Service UUID
CHARACTERISTIC_UUID = "00002a35-0000-1000-8000-00805f9b34fb"  # Blood Pressure Measurement

# Simulated BP readings
def generate_bp_reading():
    systolic = random.randint(110, 140)  # Random systolic between 110-140
    diastolic = random.randint(70, 90)  # Random diastolic between 70-90
    mean_arterial_pressure = (systolic + 2 * diastolic) // 3
    return systolic, diastolic, mean_arterial_pressure

# Format the BP reading into Bluetooth spec-compliant bytes
def format_bp_reading(systolic, diastolic, mean_arterial_pressure):
    flags = 0x01  # Units in mmHg
    measurement = struct.pack(
        "<BHHH",
        flags,
        systolic,
        diastolic,
        mean_arterial_pressure,
    )
    return measurement

# Bluetooth GATT server
async def start_server():
    server = BleakServer()
    server.set_device_name(DEVICE_NAME)

    @server.characteristic(CHARACTERISTIC_UUID)
    def on_read(offset: int):
        # Generate and return simulated BP readings
        systolic, diastolic, mean_arterial_pressure = generate_bp_reading()
        print(f"Sending BP reading: {systolic}/{diastolic}")
        return format_bp_reading(systolic, diastolic, mean_arterial_pressure)

    await server.start_advertising([SERVICE_UUID])
    print(f"{DEVICE_NAME} is now advertising...")

    try:
        await server.wait_for_connection()
        print("Client connected!")
        await asyncio.sleep(60)  # Keep server running for 1 minute
    finally:
        await server.stop_advertising()
        print("Server stopped.")

# Run the server
if __name__ == "__main__":
    asyncio.run(start_server())
