import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trackmybus/constants/endpoints.dart';
import 'package:trackmybus/presentation/auth/login.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class ViewBlockScreen extends StatefulWidget {
  const ViewBlockScreen({super.key});

  @override
  State<ViewBlockScreen> createState() => _ViewBlockScreenState();
}

class _ViewBlockScreenState extends State<ViewBlockScreen> {
  @override
  Timer? timer;
  List<Map<String, dynamic>> blocks = [
    {"title": "Block A", "description": "Heavy traffic reported"},
    {"title": "Block B", "description": "Road under maintenance"},
    {"title": "Block C", "description": "Accident reported"},
  ];

  Future<void> sendLocationToServer() async {
    try {
      // Check location permissions
      // LocationPermission permission = await Geolocator.checkPermission();
      // if (permission == LocationPermission.denied) {
      //   permission = await Geolocator.requestPermission();
      //   if (permission == LocationPermission.denied) {
      //     throw Exception('Location permissions are denied');
      //   }
      // }

      // if (permission == LocationPermission.deniedForever) {
      //   throw Exception('Location permissions are permanently denied');
      // }

      // Get current position
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );

      // Send location to server
      final response = await Dio().post(
        '$baseurl/update_driver_location/',
        // data: {"latitude": position.latitude, "longitude": position.longitude},
        data: {
          "latitude": '11.34567',
          "longitude": '76.45678',
          'driver_id': loginId,
        },
      );

      if (response.statusCode == 200) {
        print('Location sent successfully');
      } else {
        throw Exception('Failed to send location to server');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBlockInfo() async {
    try {
      final response = await Dio().get('$baseurl/view_trafic_blocks/');
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((block) {
          return {
            "title": block["location_name"] as String,
            "description": block["congestion_level"] as String,
          };
        }).toList();
      } else {
        throw Exception('Failed to load block information');
      }
    } catch (e) {
      print('Error fetching block info: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlockInfo().then((fetchedBlocks) {
      setState(() {
        blocks = fetchedBlocks;
      });
    });
    // timer = Timer.periodic(const Duration(seconds: 3), (timer) {
    sendLocationToServer();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(184, 40, 79, 36),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    loginedUsername == null
                        ? "Driver"
                        : loginedUsername!.replaceAll('@gmail.com', ''),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    loginedUsername ?? "Driver@gmail.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.black),
              title: const Text("About"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Block Information"),
        backgroundColor: const Color.fromARGB(184, 40, 79, 36),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh logic (e.g., re-fetch data from API)
            },
          ),
        ],
      ),
      body:
          blocks.isEmpty
              ? const Center(
                child: Text(
                  "No block information available",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: blocks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.red),
                      title: Text(
                        blocks[index]["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Congestion Level ${blocks[index]["description"]!}',
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
