import 'package:flutter/material.dart';
import 'package:trackmybus/constants/endpoints.dart';
import 'package:trackmybus/presentation/user/busDetailScreen.dart';
import 'package:dio/dio.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key, this.from});
  final String? from;

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  List<Map<String, dynamic>> buses = []; // Updated to handle nested data
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchBuses() async {
    try {
      final response = await Dio().get('$baseurl/buses/${widget.from}');
      if (response.statusCode == 200) {
        setState(() {
          buses = List<Map<String, dynamic>>.from(response.data);
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredBuses =
        buses.where((bus) {
          return bus["bus_name"].toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              (bus["route_details"]["source"] ?? "")
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              (bus["route_details"]["destination"] ?? "")
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Track my Bus"),
        backgroundColor: const Color.fromARGB(184, 40, 79, 36),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by bus name or route...",
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Bus List
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : hasError
                      ? const Center(
                        child: Text(
                          "Failed to load buses",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                      : filteredBuses.isEmpty
                      ? const Center(
                        child: Text(
                          "No buses found",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredBuses.length,
                        itemBuilder: (context, index) {
                          var bus = filteredBuses[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: const Icon(
                                Icons.directions_bus,
                                color: Color.fromARGB(184, 40, 79, 36),
                                size: 30,
                              ),
                              title: Text(
                                bus["bus_name"] ?? "Unknown Bus",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Route: ${bus["route_details"]["source"]} - ${bus["route_details"]["destination"]}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.black54,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BusDetailsScreen(
                                          busName: bus["bus_name"],
                                          busId: bus["id"].toString(),
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
