import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:trackmybus/constants/endpoints.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.busid});
  final busid;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
   
  ];

  Future<void> fetchNotifications() async {
    try {
      final response = await Dio().get('$baseurl/busalerts/${widget.busid}/');
      print('asas${response.data}');
      if (response.statusCode == 200 && response.data is List) {
        setState(() {
          notifications = List<Map<String, dynamic>>.from(
            response.data.map(
              (item) => {
                "title": item["reason"] ?? "No data",
                // "message": item["message"] ?? "No Message",
              },
            ),
          );
        });
      }
    } catch (e) {
      // Handle error
      print("Error fetching notifications: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color.fromARGB(184, 40, 79, 36),
      ),
      body:
          notifications.isEmpty
              ? const Center(
                child: Text(
                  "No new notifications",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(notifications[index]["title"]!),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        notifications.removeAt(index);
                      });
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.green,
                        ),
                        title: Text(
                          notifications[index]["title"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text(notifications[index]["message"]!),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
