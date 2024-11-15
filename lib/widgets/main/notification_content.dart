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
      if (await FlutterBluePlus.isSupported == false) {
        setState(() {
          connectionStatus = "Bluetooth not supported";
        });
        return;
      }

      if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on) {
        setState(() {
          connectionStatus = "Ready to scan";
        });
        startScan();  // Auto-start scan
      } else {
        setState(() {
          connectionStatus = "Please turn on Bluetooth";
        });
      }
    } catch (e) {
      print('Bluetooth initialization error: $e');
      setState(() {
        connectionStatus = "Error: $e";
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
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidUsesFineLocation: false,
      );

      scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          // Filter and sort results
          final filteredResults = results.where((result) {
            final name = result.device.platformName.toLowerCase();
            // Look for our specific device name or partial matches
            return name.contains('bp') || 
                   name.contains('monitor') || 
                   name.contains('pi');
          }).toList();

          // Sort by RSSI (signal strength)
          filteredResults.sort((a, b) => b.rssi.compareTo(a.rssi));

          setState(() {
            scanResults = filteredResults;
          });

          // Print detailed info for debugging
          for (final result in results) {
            print('Found device:'
                '\nName: ${result.device.platformName}'
                '\nID: ${result.device.remoteId}'
                '\nRSSI: ${result.rssi}'
                '\nManufacturer Data: ${result.advertisementData.manufacturerData}'
                '\nService UUIDs: ${result.advertisementData.serviceUuids}'
                '\n-------------------');
          }
        },
        onError: (error) {
          print('Scan error: $error');
          setState(() {
            connectionStatus = "Scan error: $error";
            isScanning = false;
          });
        },
      );

      // After scan timeout
      await Future.delayed(const Duration(seconds: 10));
      await stopScan();

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
    } finally {
      setState(() {
        isScanning = false;
        connectionStatus = "Scan complete";
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
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                Text(
                  connectionStatus,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Looking for device named "BP_MONITOR_PI"',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final result = scanResults[index];
                final device = result.device;
                final name = device.platformName;
                final rssi = result.rssi;

                return Card(
                  child: ListTile(
                    title: Text(name.isEmpty ? 'Unknown Device' : name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${device.remoteId}'),
                        Text('Signal Strength: $rssi dBm'),
                        Text('Distance: ${_estimateDistance(rssi)} meters'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _getRssiColor(rssi),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          child: const Text('CONNECT'),
                          onPressed: () async {
                            try {
                              await device.connect();
                              setState(() {
                                connectionStatus = "Connected to ${device.platformName}";
                              });
                            } catch (e) {
                              print('Connection error: $e');
                              setState(() {
                                connectionStatus = "Connection failed: $e";
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getRssiColor(int rssi) {
    if (rssi >= -60) return Colors.green;
    if (rssi >= -70) return Colors.yellow;
    return Colors.red;
  }

  String _estimateDistance(int rssi) {
    // Very rough distance estimation
    if (rssi >= -60) return '< 1';
    if (rssi >= -70) return '1-3';
    if (rssi >= -80) return '3-5';
    return '> 5';
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    super.dispose();
  }
}