import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trackmybus/constants/endpoints.dart';
import 'package:trackmybus/presentation/auth/register.dart';
import 'package:trackmybus/presentation/driver/driverbottomnavigation.dart';
import 'package:trackmybus/presentation/user/UserHomeScreen.dart';

String? loginedUsername;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  final TextEditingController _usernameController = TextEditingController(
  );
  final TextEditingController _passwordController = TextEditingController(
  );

  Future<void> _performLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    try {
      final response = await Dio().post(
        '$baseurl/LoginPage',
        data: {'username': username, 'password': password},
      );
      print(response.data);
      if (response.statusCode == 200 && response.data['message'] == 'success') {
        loginedUsername = username;
        final data = response.data;
        loginId = data['login_id'].toString();
        userType = data['user_type'];

        if (userType == 'Passenger') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SelectLocationScreen()),
          );
        } else if (userType == 'Driver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DriverNavigation()),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Unknown user type')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.data['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 224, 199),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved AppBar Section
            Stack(
              children: [
                ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 270,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://cms.trackon-gps.com/media/vehicles/school-bus-tracker.webp',
                        ),
                        fit: BoxFit.cover,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(184, 121, 185, 114),
                          const Color.fromARGB(179, 27, 64, 25),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Login Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 144, 178, 142),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 144, 178, 142),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(184, 121, 185, 114),
                          const Color.fromARGB(179, 27, 64, 25),
                        ], // Gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: TextField(
                      controller: _usernameController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ), // White icon for contrast
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ), // White text
                        filled: true,
                        fillColor:
                            Colors.transparent, // Make sure gradient is visible
                        border: InputBorder.none, // Removes the default border
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ), // White text inside field
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(184, 121, 185, 114),
                          const Color.fromARGB(179, 27, 64, 25),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      cursorColor: Colors.white,
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: const Color.fromARGB(179, 27, 64, 25),
                      ),
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DriverNavigation(),
                        //   ),
                        // );
                        _performLogin();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: const Color.fromARGB(184, 41, 74, 38),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: const Color.fromARGB(184, 40, 79, 36),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for Curved AppBar
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
