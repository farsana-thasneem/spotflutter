// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class FeedbackScreen extends StatefulWidget {
//   @override
//   _FeedbackScreenState createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen> {
//   double _rating = 0.0;
//   final TextEditingController _feedbackController = TextEditingController();

//   void _submitFeedback() {
//     String feedback = _feedbackController.text;
//     if (_rating == 0.0 || feedback.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please provide a rating and feedback")),
//       );
//       return;
//     }

//     // Handle feedback submission
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("Thank you for your feedback!")));

//     // Clear the fields
//     setState(() {
//       _rating = 0.0;
//       _feedbackController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feedback', style: TextStyle(color: Colors.black)),
//         backgroundColor: Color.fromARGB(184, 40, 79, 36),
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Rate your experience",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Center(
//               child: RatingBar.builder(
//                 initialRating: _rating,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 itemBuilder:
//                     (context, _) => Icon(Icons.star, color: Colors.amber),
//                 onRatingUpdate: (rating) {
//                   setState(() {
//                     _rating = rating;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Write your feedback",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _feedbackController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Enter your feedback...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _submitFeedback,
//                 child: Text(
//                   'Submit Feedback',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(184, 40, 79, 36),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:trackmybus/constants/endpoints.dart';  // Import Dio package

class FeedbackScreen extends StatefulWidget {
  final id;

  const FeedbackScreen({super.key,this.id});
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0.0;
  final TextEditingController _feedbackController = TextEditingController();
  final Dio _dio = Dio();  // Initialize Dio instance

  // API endpoint for feedback submission
  // final String _apiUrl = ;

  // Submit feedback method with Dio
  void _submitFeedback() async {
    String feedback = _feedbackController.text;

    if (_rating == 0.0 || feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a rating and feedback")),
      );
      return;
    }

    try {
      // Prepare the data to send
      final Map<String, dynamic> data = {
        'bus_id':widget.id,
        'rating': _rating,
        'feedback': feedback,
        'LoginID':loginId
      };

      // Send the POST request using Dio
      final response = await _dio.post(
        '$baseurl/Feedbackapi',
        data: data,
      );

      if (response.statusCode == 200||response.statusCode==201) {
        // Success - feedback submitted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Thank you for your feedback!")),
        );
        
        // Clear the fields
        setState(() {
          _rating = 0.0;
          _feedbackController.clear();
        });
      } else {
        // Handle error in API response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit feedback. Please try again.")),
        );
      }
    } catch (e) {
      // Handle Dio error (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(184, 40, 79, 36),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rate your experience",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Write your feedback",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter your feedback...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                child: Text(
                  'Submit Feedback',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(184, 40, 79, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
