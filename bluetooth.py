import os
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib
import random

BLUEZ_SERVICE_NAME = "org.bluez"
ADAPTER_INTERFACE = "org.bluez.Adapter1"
GATT_MANAGER_INTERFACE = "org.bluez.GattManager1"
GATT_SERVICE_INTERFACE = "org.bluez.GattService1"
GATT_CHARACTERISTIC_INTERFACE = "org.bluez.GattCharacteristic1"

SERVICE_UUID = "00001810-0000-1000-8000-00805f9b34fb"  # Blood Pressure Service
CHARACTERISTIC_UUID = "00002a35-0000-1000-8000-00805f9b34fb"  # Blood Pressure Measurement

class BloodPressureCharacteristic(dbus.service.Object):
    def __init__(self, bus, index, service):
        self.path = f"{service.path}/char{index}"
        self.bus = bus
        self.service = service
        self.value = self.generate_bp_reading()
        super().__init__(bus, self.path)

    def generate_bp_reading(self):
        systolic = random.randint(110, 140)
        diastolic = random.randint(70, 90)
        mean_arterial_pressure = (systolic + 2 * diastolic) // 3
        print(f"Generated BP: {systolic}/{diastolic}")
        return [
            0x01,  # Flags (unit in mmHg)
            systolic & 0xFF,
            systolic >> 8,
            diastolic & 0xFF,
            diastolic >> 8,
            mean_arterial_pressure & 0xFF,
            mean_arterial_pressure >> 8,
        ]

    @dbus.service.method(GATT_CHARACTERISTIC_INTERFACE,
                         in_signature="", out_signature="ay")
    def ReadValue(self, options):
        print("Sending BP reading...")
        return dbus.Array(self.value, signature="y")

class BloodPressureService(dbus.service.Object):
    def __init__(self, bus, index):
        self.path = f"/org/bluez/example/service{index}"
        self.bus = bus
        self.characteristics = []
        super().__init__(bus, self.path)

        self.add_characteristic(BloodPressureCharacteristic(bus, 0, self))

    def add_characteristic(self, characteristic):
        self.characteristics.append(characteristic)

class Application(dbus.service.Object):
    def __init__(self, bus):
        self.path = "/"
        self.services = []
        super().__init__(bus, self.path)

        self.add_service(BloodPressureService(bus, 0))

    def add_service(self, service):
        self.services.append(service)

def main():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    bus = dbus.SystemBus()
    adapter_path = "/org/bluez/hci0"

    # Enable BLE advertising
    properties = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, adapter_path),
                                "org.freedesktop.DBus.Properties")
    properties.Set(ADAPTER_INTERFACE, "Powered", dbus.Boolean(True))

    app = Application(bus)

    # Register GATT server
    service_manager = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, adapter_path),
                                      GATT_MANAGER_INTERFACE)
    service_manager.RegisterApplication(app.get_path(), {}, reply_handler=lambda: print("GATT server registered"),
                                        error_handler=lambda e: print("Failed to register GATT server:", e))

    print("Blood Pressure Monitor is ready!")
    try:
        GLib.MainLoop().run()
    except KeyboardInterrupt:
        print("Exiting...")

if __name__ == "__main__":
    main()
