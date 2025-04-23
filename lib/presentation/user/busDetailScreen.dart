import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trackmybus/constants/endpoints.dart';
import 'package:trackmybus/presentation/user/sendFeedback.dart';
import 'package:trackmybus/presentation/user/viewNotification.dart';

class BusDetailsScreen extends StatefulWidget {
  final String busName;
  // List of stops with timings
  final String busId;

  const BusDetailsScreen({
    super.key,
    required this.busName,

    required this.busId,
  });

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  final Dio dio = Dio();
  Timer? timer;
  LatLng busLocation = LatLng(12.9716, 77.5946); // Default location
  List<Map<String, dynamic>> stops = [
    {"stop": "Stop 1", "time": "08:00 AM"},
    {"stop": "Stop 2", "time": "08:30 AM"},
    {"stop": "Stop 3", "time": "09:00 AM"},
    {"stop": "Stop 4", "time": "09:30 AM"},
    {"stop": "Stop 5", "time": "10:00 AM"},
  ];
  @override
  void initState() {
    super.initState();
    fetchStops();
    // timer = Timer.periodic(const Duration(seconds: 3), (timer) {
    fetchBusLocation();
    // });
    // fetchBusLocation();
  }

  Future<void> fetchBusLocation() async {
    try {
      final response = await dio.get('$baseurl/stops/${widget.busId}/');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          busLocation = LatLng(
            response.data['latitude'],
            response.data['longitude'],
          );
        });
      }
    } catch (e) {
      print("Error fetching bus location: $e");
    }
  }

  Future<void> fetchStops() async {
    try {
      final response = await dio.get('$baseurl/stops/${widget.busId}/');
      if (response.statusCode == 200) {
        setState(() {
          stops = List<Map<String, dynamic>>.from(response.data);
        });
      }
    } catch (e) {
      print("Error fetching stops: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.busName),
        backgroundColor: const Color.fromARGB(184, 40, 79, 36),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => NotificationsScreen(busid: widget.busId),
                ),
              );
              // Show notifications
            },
          ),
          IconButton(
            icon:  Icon(Icons.feedback),
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen(id:widget.busId)),
                );
            }),

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Bus Stops Section
              ExpansionTile(
                leading: const Icon(Icons.directions_bus, color: Colors.green),
                title: Text(
                  'Stop info',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  ...stops.map(
                    (e) => ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      title: Text(e['stop_name'] ?? ""),
                      subtitle: Text("Arrival Time: ${e['arriving_time']}"),
                    ),
                  ),
                ],
              ),

              // Live Location Map
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 300,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: busLocation,
                        initialZoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: busLocation,
                              child: Icon(
                                Icons.directions_bus,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(184, 40, 79, 36),
        onPressed: fetchBusLocation,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
