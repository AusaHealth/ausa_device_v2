import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BPMonitor extends StatefulWidget {
  const BPMonitor({Key? key}) : super(key: key);

  @override
  State<BPMonitor> createState() => BPMonitorState();
}

class BPMonitorState extends State<BPMonitor> {
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  String connectionStatus = "Initializing...";
  double systolic = 0;
  double diastolic = 0;
  StreamSubscription<List<ScanResult>>? scanSubscription;

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    try {
      // Check if Bluetooth is supported
      if (await FlutterBluePlus.isSupported == false) {
        setState(() {
          connectionStatus = "Bluetooth not supported";
        });
        return;
      }

      // Check if Bluetooth is turned on
      if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on) {
        setState(() {
          connectionStatus = "Ready to scan";
        });
      } else {
        setState(() {
          connectionStatus = "Please turn on Bluetooth";
        });
      }

      // Listen to adapter state changes
      FlutterBluePlus.adapterState.listen((state) {
        if (state == BluetoothAdapterState.on) {
          setState(() {
            connectionStatus = "Ready to scan";
          });
        } else {
          setState(() {
            connectionStatus = "Bluetooth is off";
          });
        }
      });

    } catch (e) {
      print('Bluetooth initialization error: $e');
      setState(() {
        connectionStatus = "Error initializing Bluetooth: $e";
      });
    }
  }

  Future<void> startScan() async {
    if (isScanning) return;

    setState(() {
      scanResults = [];
      isScanning = true;
      connectionStatus = "Scanning...";
    });

    try {
      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
      );

      // Listen to scan results
      scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          setState(() {
            scanResults = results;
            print('Found ${results.length} devices');
          });
        },
        onError: (error) {
          print('Scan error: $error');
          setState(() {
            connectionStatus = "Scan error: $error";
            isScanning = false;
          });
        },
        onDone: () {
          setState(() {
            isScanning = false;
            connectionStatus = "Scan complete";
          });
        },
      );

    } catch (e) {
      print('Error during scan: $e');
      setState(() {
        isScanning = false;
        connectionStatus = "Scan failed: $e";
      });
    }
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      print('Error stopping scan: $e');
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      setState(() {
        connectionStatus = "Connecting to ${device.platformName}...";
      });

      await device.connect(timeout: const Duration(seconds: 4));
      print('Connected to ${device.platformName}');
      
      setState(() {
        connectionStatus = "Connected to ${device.platformName}";
      });

      // Discover services after connection
      print('Discovering services...');
      List<BluetoothService> services = await device.discoverServices();
      print('Discovered ${services.length} services');

      // Look for the service and characteristic we want
      for (BluetoothService service in services) {
        print('Service: ${service.uuid}');
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          print('Characteristic: ${characteristic.uuid}');
          
          // If this characteristic can notify (send data)
          if (characteristic.properties.notify) {
            print('Found notify characteristic');
            // Subscribe to notifications
            await characteristic.setNotifyValue(true);
            characteristic.lastValueStream.listen((value) {
              if (value.isNotEmpty) {
                try {
                  // Try to parse the data as string
                  String dataString = String.fromCharCodes(value);
                  print('Received data: $dataString');
                  // You might want to parse JSON here if your Pi is sending JSON
                } catch (e) {
                  print('Error processing data: $e');
                }
              }
            });
          }
        }
      }

    } catch (e) {
      print('Connection error: $e');
      setState(() {
        connectionStatus = "Connection failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BP Monitor'),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.refresh),
            onPressed: isScanning ? stopScan : startScan,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  connectionStatus,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (isScanning) 
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          // Device List
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final result = scanResults[index];
                final device = result.device;
                final name = device.platformName;
                final rssi = result.rssi;

                return ListTile(
                  title: Text(name.isNotEmpty ? name : 'Unknown Device'),
                  subtitle: Text('RSSI: $rssi\nID: ${device.remoteId}'),
                  trailing: ElevatedButton(
                    child: const Text('CONNECT'),
                    onPressed: () => connectToDevice(device),
                  ),
                );
              },
            ),
          ),
          // BP Display
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Systolic',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: systolic / 200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${systolic.round()} mmHg',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Diastolic',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: diastolic / 120,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${diastolic.round()} mmHg',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    stopScan();
    super.dispose();
  }
}