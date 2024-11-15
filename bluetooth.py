import asyncio
import json
import random
from bleak import BleakServer
from bleak.backends.characteristic import BleakGATTCharacteristic
from bleak.backends.service import BleakGATTService

# Define UUIDs for our service and characteristic
BP_SERVICE_UUID = "12345678-1234-5678-1234-56789abc0010"
BP_CHARACTERISTIC_UUID = "12345678-1234-5678-1234-56789abc0011"

class BPMonitorServer:
    def __init__(self):
        self.server = None
        self.connected_clients = set()
        self.bp_characteristic = None

    async def start(self):
        # Create the GATT service
        bp_service = BleakGATTService(BP_SERVICE_UUID)
        
        # Create the BP characteristic
        self.bp_characteristic = BleakGATTCharacteristic(
            uuid=BP_CHARACTERISTIC_UUID,
            service_uuid=BP_SERVICE_UUID,
            properties=["read", "notify"],
            value=bytes(json.dumps({"systolic": 120, "diastolic": 80}), 'utf-8')
        )
        bp_service.add_characteristic(self.bp_characteristic)

        # Create and start the server
        self.server = BleakServer()
        self.server.services.add_service(bp_service)
        
        await self.server.start()
        print(f"Server started. Address: {self.server.address}")

    async def update_bp(self):
        while True:
            try:
                # Generate random BP values
                systolic = random.randint(90, 140)
                diastolic = random.randint(60, 90)
                
                # Create JSON data
                data = json.dumps({
                    "systolic": systolic,
                    "diastolic": diastolic
                })
                
                # Update characteristic value
                value = bytes(data, 'utf-8')
                await self.bp_characteristic.set_value(value)
                
                print(f"Updated BP: Systolic {systolic}, Diastolic {diastolic}")
                await asyncio.sleep(1)
                
            except Exception as e:
                print(f"Error updating BP: {e}")
                await asyncio.sleep(1)

    async def stop(self):
        if self.server:
            await self.server.stop()
            print("Server stopped")

async def main():
    server = BPMonitorServer()
    
    try:
        await server.start()
        print("BP Monitor server is running. Press Ctrl+C to stop.")
        
        # Start updating BP values
        await server.update_bp()
        
    except KeyboardInterrupt:
        print("\nShutting down...")
    finally:
        await server.stop()

if __name__ == "__main__":
    # Set up logging
    import logging
    logging.basicConfig(level=logging.INFO)
    
    # Run the server
    asyncio.run(main())