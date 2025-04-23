import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:trackmybus/constants/endpoints.dart';
import 'package:trackmybus/presentation/auth/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female', 'Other'];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();

  Future<void> _registerUser() async {
    final String name = _nameController.text;
    final String age = _ageController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    final String address = _addressController.text;
    final String emergencyContact = _emergencyContactController.text;

    Map ddd = {
      'full_name': name,
      'nationality': age,
      'username': email,
      'email': email,
      'phone_number': phone,
      'password': password,
      'address': address,
      'date_of_birth': emergencyContact,
      'gender': _selectedGender,
    };
    print(ddd);

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a gender")));
      return;
    }

    if (name.isEmpty ||
        age.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        address.isEmpty ||
        emergencyContact.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("All fields are required")));
      return;
    }

    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(name)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Name must contain only letters")));
      return;
    }

    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid email format")));
      return;
    }

    if (!RegExp(r"^\d{10}$").hasMatch(phone)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Phone must be 10 digits")));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    // try {
    //   DateTime dob = DateTime.parse(age);
    //   DateTime today = DateTime.now();
    //   if (dob.isAfter(today)) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Date of birth cannot be in the future")),
    //     );
    //     return;
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Invalid date format for date of birth")),
    //   );
    //   return;
    // }

    try {
      final response = await Dio().post(
        '$baseurl/UserReg',
        data: {
          'full_name': name,
          'nationality': age,
          'username': email,
          'email': email,
          'phone_number': phone,
          'password': password,
          'address': address,
          'date_of_birth': emergencyContact,
          'gender': _selectedGender,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Registration successful")));
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration failed: ${response.data['message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 224, 199),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                Positioned(
                  top: 4,
                  left: 15,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 81, 122, 78),
                    ),
                  ),
                  Text(
                    "Create an account to continue...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 144, 178, 142),
                    ),
                  ),
                  SizedBox(height: 20),
                  // _buildImagePicker(),
                  SizedBox(height: 20),
                  _buildTextField("Full Name", Icons.person),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Nationality",
                    Icons.location_city,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16),
                  _buildGenderDropdown(),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Email",
                    Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Phone Number",
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  _buildPasswordField("Password", _isPasswordVisible, () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  }),
                  SizedBox(height: 16),
                  _buildPasswordField(
                    "Confirm Password",
                    _isConfirmPasswordVisible,
                    () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField("Address", Icons.location_on),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Date of Birth",
                    Icons.calendar_month,
                    keyboardType: TextInputType.text,
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
                        _registerUser();
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: const Color.fromARGB(184, 41, 74, 38),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
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

  Widget _buildTextField(
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
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
        controller:
            label == "Full Name"
                ? _nameController
                : label == "Nationality"
                ? _ageController
                : label == "Email"
                ? _emailController
                : label == "Phone Number"
                ? _phoneController
                : label == "Address"
                ? _addressController
                : label == "Date of Birth"
                ? _emergencyContactController
                : null,
        cursorColor: Colors.white,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green),
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Container(
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
        controller:
            label == "Password"
                ? _passwordController
                : _confirmPasswordController,
        cursorColor: Colors.white,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.lock, color: Colors.green),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.green,
            ),
            onPressed: toggleVisibility,
          ),
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
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
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Gender",
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.person, color: Colors.green),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          filled: true,
          fillColor: Colors.transparent,
        ),
        value: _selectedGender,
        items:
            _genders.map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }
}

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
