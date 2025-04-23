import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trackmybus/constants/endpoints.dart';
import 'package:trackmybus/presentation/auth/login.dart';
import 'package:trackmybus/presentation/user/BusListScreen.dart';
import 'package:trackmybus/presentation/user/sendFeedback.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  String? _selectedFrom;
  // String? _selectedTo;
  bool _isLoading = false;

  List<Map<String, dynamic>> locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Dio().get('$baseurl/busroutes');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          locations = List<Map<String, dynamic>>.from(response.data);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch locations")),
        );
      }
      _isLoading = false;
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() {
        _isLoading = false;
      });
    }
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
              decoration: BoxDecoration(
                color: const Color.fromARGB(184, 40, 79, 36),
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

            // ListTile(
            //   leading: const Icon(Icons.feedback, color: Colors.black),
            //   title: const Text("Feedback"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => FeedbackScreen()),
            //     );
            //   },
            // ),
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
        title: const Text("Select Locations"),
        backgroundColor: const Color.fromARGB(184, 40, 79, 36),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Your Locations",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // From Location Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedFrom,
                      hint: const Text("Select route"),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items:
                          locations.map((location) {
                            return DropdownMenuItem(
                              value:
                                  location['id']
                                      .toString(), // Ensure it's a String
                              child: Text(
                                location['source'] +
                                    ' - ' +
                                    location['destination'],
                              ),
                            );
                          }).toList(),
                      onChanged:
                          (value) => setState(() => _selectedFrom = value),
                    ),
                    const SizedBox(height: 15),

                    // To Location Dropdown
                    // DropdownButtonFormField<String>(
                    //   value: _selectedTo,
                    //   hint: const Text("Select To Location"),
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(
                    //       Icons.location_on_outlined,
                    //       color: Colors.red,
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   items:
                    //       locations.map((location) {
                    //         return DropdownMenuItem(
                    //           value:
                    //               location['route_id']
                    //                   .toString(), // Ensure it's a String
                    //           child: Text(location['stop_name']),
                    //         );
                    //       }).toList(),
                    //   onChanged: (value) => setState(() => _selectedTo = value),
                    // ),
                    // const SizedBox(height: 20),

                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedFrom == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select both locations"),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      BusListScreen(from: _selectedFrom!),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            184,
                            40,
                            79,
                            36,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Search",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
