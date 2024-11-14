import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SensorReading {
  final DateTime timestamp;
  final String value;
  final String unit;
  final bool isNormal;
  
  SensorReading({
    required this.timestamp,
    required this.value,
    required this.unit,
    required this.isNormal,
  });
}

class PreviousScansContent extends StatefulWidget {
  const PreviousScansContent({super.key});

  @override
  State<PreviousScansContent> createState() => _PreviousScansContentState();
}

class _PreviousScansContentState extends State<PreviousScansContent> {
  String selectedSensor = 'Blood Pressure';
  
  // Dummy data
  final Map<String, List<SensorReading>> readings = {
    'Blood Pressure': [
      SensorReading(
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        value: '120/80',
        unit: 'mmHg',
        isNormal: true,
      ),
      SensorReading(
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        value: '125/85',
        unit: 'mmHg',
        isNormal: false,
      ),
      // Add more readings...
    ],
    'Blood Glucose': [
      SensorReading(
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        value: '95',
        unit: 'mg/dL',
        isNormal: true,
      ),
      SensorReading(
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        value: '110',
        unit: 'mg/dL',
        isNormal: false,
      ),
      // Add more readings...
    ],
    'SPO2': [
      SensorReading(
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        value: '98',
        unit: '%',
        isNormal: true,
      ),
      SensorReading(
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        value: '95',
        unit: '%',
        isNormal: true,
      ),
      // Add more readings...
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSensor,
                isExpanded: true,
                items: readings.keys.map((String sensor) {
                  return DropdownMenuItem<String>(
                    value: sensor,
                    child: Text(
                      sensor,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedSensor = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: readings[selectedSensor]?.length ?? 0,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final reading = readings[selectedSensor]![index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMM dd, yyyy - HH:mm')
                                  .format(reading.timestamp),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '${reading.value} ${reading.unit}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: reading.isNormal
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    reading.isNormal ? 'Normal' : 'Abnormal',
                                    style: TextStyle(
                                      color: reading.isNormal
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}