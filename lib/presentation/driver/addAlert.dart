import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trackmybus/constants/endpoints.dart';

class AddAlertScreen extends StatefulWidget {
  const AddAlertScreen({super.key});

  @override
  State<AddAlertScreen> createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends State<AddAlertScreen> {
  // final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;

  Future<void> sendAlert() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        "$baseurl/add-alerts/",
        data: {
          // "reason": _titleController.text,
          "reason": _descriptionController.text,
          'driver_id': loginId,
        },
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alert sent successfully!")),
        );

        _descriptionController.clear();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to send alert")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Alert"),
        backgroundColor: const Color.fromARGB(184, 40, 79, 36),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Alert Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // const SizedBox(height: 10),
            // TextField(
            //   controller: _titleController,
            //   decoration: const InputDecoration(
            //     labelText: "Alert Title",
            //     border: OutlineInputBorder(),
            //     prefixIcon: Icon(Icons.warning),
            //   ),
            // ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Alert Description",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : sendAlert,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(184, 40, 79, 36),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Send Alert",
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
