import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'verification_screen.dart';
import 'sign_up_page.dart'; // Import your SignUpPage

class SignInPageWeb extends StatefulWidget {
  @override
  _SignInPageWebState createState() => _SignInPageWebState();
}

class _SignInPageWebState extends State<SignInPageWeb> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userData = querySnapshot.docs.first;
          String userID = userData.id;
          String role = userData['role'];

          // Check the role and navigate accordingly
          if (role == 'admin') {
            Navigator.pushReplacementNamed(
              context,
              '/real-time-energy',
              arguments: {
                'userID': userID,
                'firstName': userData['firstName'],
                'lastName': userData['lastName'],
              },
            );
          } else if (role == 'user') {
            Navigator.pushReplacementNamed(
              context,
              '/real-time-energy',
              arguments: {
                'userID': userID,
                'firstName': userData['firstName'],
                'lastName': userData['lastName'],
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Unknown role'),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid username or password'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _forgotPassword() async {
    final _phoneNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Enter your phone number to reset your password:'),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String phoneNumber = _phoneNumberController.text;

                try {
                  String tempPassword = _generateTemporaryPassword();
                  await _sendTemporaryPassword(phoneNumber, tempPassword);
                  await _updatePasswordInFirestore(phoneNumber, tempPassword);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Temporary password sent to your phone number.'),
                    backgroundColor: Colors.green,
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error sending temporary password: $e'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text('Send Temporary Password'),
            ),
          ],
        );
      },
    );
  }

  String _generateTemporaryPassword() {
    const length = 8;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    final password = List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
    return password;
  }

  Future<void> _sendTemporaryPassword(String phoneNumber, String tempPassword) async {
    String apiUrl = 'https://api.mtn.com/sms/send';
    Map<String, dynamic> requestData = {
      'phone_number': phoneNumber,
      'message': 'Your temporary password is: $tempPassword. Please change it after logging in.',
    };

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('api_username:api_password'));

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send SMS: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send SMS: $e');
    }
  }

  Future<void> _updatePasswordInFirestore(String phoneNumber, String tempPassword) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first;
      String userID = userData.id;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update({'password': tempPassword});
    } else {
      throw Exception('No user found with the provided phone number');
    }
  }

  Future<String> _sendVerificationCode(String phoneNumber) async {
    String apiUrl = 'https://api.mtn.com/sms/send';
    Map<String, dynamic> requestData = {
      'phone_number': phoneNumber,
      'message': 'Your verification code is: 123456',
    };

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('api_username:api_password'));

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        return '123456';
      } else {
        throw Exception('Failed to send SMS: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send SMS: $e');
    }
  }

  void _navigateToVerificationScreen(String phoneNumber, String verificationCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(
          phoneNumber: phoneNumber,
          verificationCode: verificationCode,
        ),
      ),
    );
  }

  void _changePassword() {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Enter your current password and new password:'),
              SizedBox(height: 10),
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  String currentPassword = _currentPasswordController.text;
                  String newPassword = _newPasswordController.text;
                  await _updatePassword(currentPassword, newPassword);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error changing password: $e'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text('Change Password'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePassword(String currentPassword, String newPassword) async {
    final username = _usernameController.text;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: currentPassword)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first;
      String userID = userData.id;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update({'password': newPassword});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password updated successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      throw Exception('Invalid current password');
    }
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()), // Navigate to the sign-up page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signIn(context),
                    child: Text('Sign In'),
                  ),
                  TextButton(
                    onPressed: _forgotPassword,
                    child: Text('Forgot Password?'),
                  ),
                  TextButton(
                    onPressed: _changePassword,
                    child: Text('Change Password'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'), // Button to navigate to sign-up page
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
