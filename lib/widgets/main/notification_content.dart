import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BPMonitor extends StatefulWidget {
  const BPMonitor({Key? key}) : super(key: key);

  @override
  State<BPMonitor> createState() => BPMonitorState();
}

class BPMonitorState extends State<BPMonitor> {
  BluetoothConnection? connection;
  double systolic = 0;
  double diastolic = 0;
  List<BluetoothDevice> devices = [];
  bool isScanning = false;
  
  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() async {
    setState(() {
      isScanning = true;
      devices.clear();
    });

    try {
      // Request Bluetooth permission
      bool? isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (isEnabled != true) {
        await FlutterBluetoothSerial.instance.requestEnable();
      }

      // Start discovery
      FlutterBluetoothSerial.instance.startDiscovery().listen(
        (BluetoothDiscoveryResult result) {
          // Add device if it's not already in the list
          if (!devices.contains(result.device)) {
            setState(() {
              devices.add(result.device);
            });
          }
        },
        onDone: () {
          setState(() {
            isScanning = false;
          });
        },
        onError: (error) {
          print('Error during discovery: $error');
          setState(() {
            isScanning = false;
          });
        },
      );
    } catch (e) {
      print('Error starting scan: $e');
      setState(() {
        isScanning = false;
      });
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to ${device.name}');

      connection!.input!.listen((Uint8List data) {
        String dataString = String.fromCharCodes(data);
        Map<String, dynamic> sensorData = json.decode(dataString);
        
        setState(() {
          systolic = sensorData['systolic'].toDouble();
          diastolic = sensorData['diastolic'].toDouble();
        });
      }).onDone(() {
        print('Disconnected by remote request');
      });
    } catch (e) {
      print('Error connecting to device: $e');
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
            onPressed: isScanning ? null : startScan,
          ),
        ],
      ),
      body: Column(
        children: [
          // Device List
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.address),
                  trailing: ElevatedButton(
                    child: const Text('Connect'),
                    onPressed: () => connectToDevice(device),
                  ),
                );
              },
            ),
          ),
          // BP Display
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: systolic / 200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Text('Systolic: ${systolic.round()}'),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    value: diastolic / 120,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 20),
                  Text('Diastolic: ${diastolic.round()}'),
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
    connection?.dispose();
    super.dispose();
  }
}