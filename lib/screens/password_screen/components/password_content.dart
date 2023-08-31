
import 'package:bus_app_flutter/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/api_service.dart';
import '../../../utils/constants.dart';
import '../../map_screen.dart';



class PasswordContent extends StatefulWidget {
  const PasswordContent({Key? key}) : super(key: key);

  @override
  State<PasswordContent> createState() => _PasswordContentState();
}

class _PasswordContentState extends State<PasswordContent> {
  TextEditingController cuidController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool matriculeError = false;
  bool passwordError = false;
  bool formSubmitted = false;

  Widget inputField(String hint, IconData iconData) {
    String errorMsg = '';

    if (formSubmitted) {
      if (hint == 'Cuid') {
        if (cuidController.text.isEmpty) {
          errorMsg = 'Cuid is required';
        } else if (cuidController.text.length < 8) {
          errorMsg = 'Cuid must be minimum 8 characters long';
        }
      } else if (hint.contains('Password')) {
        if (currentPasswordController.text.isEmpty) {
          errorMsg = 'Password is required';
        }
      }else if (hint == 'comparePassword') {
        if (newPasswordController.text != confirmPasswordController.text) {
          errorMsg = 'Passwords do not match';
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
                ? cuidController
                : hint == 'Current Password'
                ? currentPasswordController
                : hint == 'New Password'
                ? newPasswordController
                : confirmPasswordController,
            obscureText: hint.contains('Password'),
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
              fillColor: kInputFieldFillColor,
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
  Widget login() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: const Text(
          'Sign In?',
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
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 130),
                logos(),
                inputField('Cuid', Ionicons.person_outline),
                inputField('Current Password', Ionicons.lock_closed_outline),
                inputField('New Password', Ionicons.lock_closed_outline),
                inputField('Confirm Password', Ionicons.lock_closed_outline),
                loginButton('Reset Password'),
                login(),

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
                cuidController.text.isEmpty || cuidController.text.length <= 7;
            passwordError = currentPasswordController.text.isEmpty ;

          });


          if (matriculeError || passwordError) {
            // Show login error message
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter valid Cuid and Password.'),
              backgroundColor: Colors.red,
            ));
          }else  if (newPasswordController.text != confirmPasswordController.text || newPasswordController.text.isEmpty  || confirmPasswordController.text.isEmpty) {

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Passwords do not match.'),
              backgroundColor: Colors.red,
            ));}

          else {
            // Perform login here
            final success = await ApiService.changePassword(
              context,
              cuidController.text,
              currentPasswordController.text,
                newPasswordController.text



            );
            if (success == false) {
              // Login failed
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Change password failed. Please check your data!'),
                backgroundColor: Colors.red,
              ));
            }else
              {

                //redirect
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              }

          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          backgroundColor: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}