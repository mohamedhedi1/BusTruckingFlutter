
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/api_service.dart';
import '../../../utils/constants.dart';
import '../../map_screen.dart';
import '../../password_screen/password_screen.dart';



class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  TextEditingController matriculeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool matriculeError = false;
  bool passwordError = false;
  bool formSubmitted = false;

  Widget inputField(String hint, IconData iconData) {
    String errorMsg = '';

    if (formSubmitted) {
      if (hint == 'Cuid') {
        if (matriculeController.text.isEmpty) {
          errorMsg = 'Matricule is required';
        } else if (matriculeController.text.length <= 6) {
          errorMsg = 'Matricule must be minimum 6 characters long';
        }
      } else if (hint == 'Password') {
        if (passwordController.text.isEmpty) {
          errorMsg = 'Password is required';
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: hint == 'Cuid'
                ? matriculeController
                : passwordController,
            obscureText: hint == 'Password',
            textAlignVertical: TextAlignVertical.bottom,
            onChanged: (text) {
              if (formSubmitted) {
                setState(() {
                  matriculeError = false;
                  passwordError = false;
                });
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: kInputFieldFillColor, // Use the color from constants.dart
              hintText: hint,
              prefixIcon: Icon(iconData),
              errorText: errorMsg.isNotEmpty ? errorMsg : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 0,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(width: 16), // Add some space between the line and the image
          Image.asset(
            'assets/images/sofrecom.png',
            height: 60, // Adjust the height of the image as per your requirement
          ),
          const SizedBox(width: 16), // Add some space between the image and the line
          Flexible(
            child: Container(
              height: 0,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PasswordScreen()));
        },
        child: const Text(
          'Change Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 130),
                logos(),
                inputField('Cuid', Ionicons.person_outline),
                inputField('Password', Ionicons.lock_closed_outline),
                loginButton('Log In'),
                forgotPassword(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton(String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 16),
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            formSubmitted = true;
            matriculeError =
                matriculeController.text.isEmpty || matriculeController.text.length <= 6;
            passwordError = passwordController.text.isEmpty;
          });

          if (matriculeError || passwordError) {
            // Show login error message
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter valid Matricule and Password.'),
              backgroundColor: Colors.red,
            ));
          } else {
            // Perform login here
            final success = await ApiService.login(
              context,
              matriculeController.text,
              passwordController.text,
            );
            if (success == false) {
              // Login failed
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Login failed. Please check your credentials.'),
                backgroundColor: Colors.red,
              ));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          backgroundColor: kSecondaryColor, // Use the color from constants.dart
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}