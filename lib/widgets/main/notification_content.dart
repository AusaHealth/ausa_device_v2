import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BPMonitor extends StatefulWidget {
  const BPMonitor({Key? key}) : super(key: key);

  @override
  State<BPMonitor> createState() => BPMonitorState();
}

class BPMonitorState extends State<BPMonitor> {
  double systolic = 0;
  double diastolic = 0;
  String status = "Initializing...";
  StreamSubscription? dataSubscription;
  StreamSubscription? scanSubscription;
  BluetoothDevice? connectedDevice;
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  
  // Your device's MAC address
  final String targetDeviceId = "DC:A6:32:9E:57";

  @override
  void initState() {
    super.initState();
    // Start initial scan
    startScan();
  }

  Future<void> startScan() async {
    if (isScanning) return;

    setState(() {
      scanResults.clear();
      isScanning = true;
      status = "Scanning for BP Monitor...";
    });

    try {
      // Start scanning with specific settings
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),  // Longer scan time
        androidUsesFineLocation: false,
      );

      scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          for (var result in results) {
            print('Device found:');
            print('  Name: ${result.device.platformName}');
            print('  ID: ${result.device.remoteId}');
            print('  RSSI: ${result.rssi}');
            print('  Connectable: ${result.advertisementData.connectable}');
            
            // Check if this is our target device
            if (result.device.remoteId.toString().toUpperCase().replaceAll(':', '') == 
                targetDeviceId.replaceAll(':', '').toUpperCase()) {
              print('Found our target device!');
              // Stop scan and connect immediately
              stopScan();
              connectToDevice(result.device);
              return;
            }
          }
          
          setState(() {
            // Filter to show only connectable devices
            scanResults = results.where((result) => 
              result.advertisementData.connectable &&
              result.device.platformName.isNotEmpty
            ).toList();
          });
        },
        onError: (e) {
          print('Scan error: $e');
          setState(() {
            status = "Scan error: $e";
            isScanning = false;
          });
        },
      );

    } catch (e) {
      print('Error starting scan: $e');
      setState(() {
        isScanning = false;
        status = "Error starting scan: $e";
      });
    }
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      print('Error stopping scan: $e');
    }
    
    setState(() {
      isScanning = false;
      status = scanResults.isEmpty ? "No devices found" : "Scan complete";
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      setState(() {
        status = "Connecting...";
      });

      await device.connect(
        timeout: const Duration(seconds: 35),  // Increased timeout
        autoConnect: true,  // Enable auto reconnection
      );
      
      connectedDevice = device;
      setState(() {
        status = "Connected to ${device.platformName}";
      });

      await listenToDevice();

    } catch (e) {
      print('Connection error: $e');
      setState(() {
        status = "Connection error: $e";
      });
    }
  }

  Future<void> listenToDevice() async {
    if (connectedDevice == null) return;

    try {
      setState(() {
        status = "Discovering services...";
      });

      List<BluetoothService> services = await connectedDevice!.discoverServices();
      print('Found ${services.length} services');

      for (var service in services) {
        print('Service UUID: ${service.uuid}');
        
        for (var characteristic in service.characteristics) {
          print('  Characteristic UUID: ${characteristic.uuid}');
          print('  Properties: ');
          print('    Read: ${characteristic.properties.read}');
          print('    Write: ${characteristic.properties.write}');
          print('    Notify: ${characteristic.properties.notify}');
          print('    Indicate: ${characteristic.properties.indicate}');
          
          if (characteristic.properties.notify) {
            print('Setting up notifications for characteristic: ${characteristic.uuid}');
            
            await characteristic.setNotifyValue(true);
            
            dataSubscription?.cancel();
            dataSubscription = characteristic.lastValueStream.listen(
              (value) {
                print('Received raw data: ${value.toString()}');
                if (value.isNotEmpty) {
                  try {
                    String dataString = String.fromCharCodes(value);
                    print('Decoded string: $dataString');
                    
                    Map<String, dynamic> data = json.decode(dataString);
                    print('Parsed JSON: $data');
                    
                    setState(() {
                      systolic = (data['systolic'] ?? 0).toDouble();
                      diastolic = (data['diastolic'] ?? 0).toDouble();
                      status = "Receiving data";
                    });
                  } catch (e) {
                    print('Error processing data: $e');
                  }
                }
              },
              onError: (error) {
                print('Data error: $error');
              },
            );
          }
        }
      }
    } catch (e) {
      print('Service discovery error: $e');
      setState(() {
        status = "Service discovery error: $e";
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
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (isScanning)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          ),
          
          // Device list or BP Display
          Expanded(
            child: connectedDevice == null
                ? ListView.builder(
                    itemCount: scanResults.length,
                    itemBuilder: (context, index) {
                      final result = scanResults[index];
                      final device = result.device;
                      
                      return ListTile(
                        title: Text(device.platformName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${device.remoteId}'),
                            Text('Signal: ${result.rssi} dBm'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          child: const Text('Connect'),
                          onPressed: () => connectToDevice(device),
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBPDisplay(
                          title: 'Systolic',
                          value: systolic,
                          maxValue: 200,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 40),
                        _buildBPDisplay(
                          title: 'Diastolic',
                          value: diastolic,
                          maxValue: 120,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBPDisplay({
    required String title,
    required double value,
    required double maxValue,
    required Color color,
  }) {
    bool isNormal = title == 'Systolic' 
        ? (value >= 90 && value <= 140)
        : (value >= 60 && value <= 90);

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(
                value: value / maxValue,
                strokeWidth: 15,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.round().toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'mmHg',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isNormal ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isNormal ? 'Normal' : 'Attention',
            style: TextStyle(
              color: isNormal ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    dataSubscription?.cancel();
    super.dispose();
  }
}