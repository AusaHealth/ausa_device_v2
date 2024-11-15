import json
import time
import random
from bluez_peripheral.gatt.service import Service
from bluez_peripheral.gatt.characteristic import characteristic, CharacteristicFlags as Flags
from bluez_peripheral.util import *
from bluez_peripheral.advert import Advertisement
from bluez_peripheral.agent import NoIoAgent
import asyncio

# Define UUIDs for our service and characteristic
BP_SERVICE_UUID = "12345678-1234-5678-1234-56789abc0010"
BP_CHARACTERISTIC_UUID = "12345678-1234-5678-1234-56789abc0011"

class BPService(Service):
    def __init__(self):
        # Initialize the service with our UUID
        super().__init__(BP_SERVICE_UUID, True)
        self.bp_data = {"systolic": 120, "diastolic": 80}

    @characteristic(BP_CHARACTERISTIC_UUID, Flags.NOTIFY | Flags.READ)
    def bp_measurement(self, options):
        # Convert the BP data to JSON and then to bytes
        return bytes(json.dumps(self.bp_data), 'utf-8')

    def update_bp(self, systolic, diastolic):
        self.bp_data = {
            "systolic": systolic,
            "diastolic": diastolic
        }
        # Notify subscribers of new data
        self.changed(self.bp_measurement)

async def main():
    # Initialize the BLE peripheral
    bus = await get_message_bus()
    
    # Create and register our BP service
    service = BPService()
    await service.register(bus)
    
    # Create an agent to handle pairing
    agent = NoIoAgent()
    await agent.register(bus)
    
    # Create an advertisement
    adapter = await Adapter.get_first(bus)
    advertisement = Advertisement(
        localName="BP Monitor",
        serviceUUIDs=[BP_SERVICE_UUID],
        appearance=0x0340,  # Generic Health Device
    )
    
    print("Starting BP Monitor Service...")
    
    try:
        # Start advertising
        await advertisement.register(bus, adapter)
        print("Advertising started. Waiting for connections...")
        
        # Main loop to update BP values
        while True:
            # Generate random BP values
            systolic = random.randint(90, 140)
            diastolic = random.randint(60, 90)
            
            # Update the service with new values
            service.update_bp(systolic, diastolic)
            print(f"Updated BP: Systolic {systolic}, Diastolic {diastolic}")
            
            # Wait before next update
            await asyncio.sleep(1)
            
    except KeyboardInterrupt:
        print("\nStopping advertisement...")
        await advertisement.unregister()
        print("Stopped")

if __name__ == "__main__":
    asyncio.run(main())