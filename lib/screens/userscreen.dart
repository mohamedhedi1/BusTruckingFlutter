import 'dart:async';
import 'package:bus_app_flutter/models/User.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/userscreen.dart';
import '../models/User.dart';


class UserInfoSheet extends StatefulWidget {
  const UserInfoSheet({super.key});

  @override
  State<UserInfoSheet> createState() => _UserInfoSheet();
}

class _UserInfoSheet extends State<UserInfoSheet> {
   late User user;
    String usercode = "";

   @override
  void initState() {
    super.initState();
    ApiService.getUserByUser("UHUKILF553").then((data){
      setState(() {
        user = data;
        usercode = data.userCode;

      });
    });
 /*void startUpdatingMarkerPosition() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      Map<String, double> positionData = await ApiService.getPositionById(1);
        busPosition = LatLng(positionData['lat']!, positionData['long']!);
      setState(() {});
    
    });
  }*/


  }
  
@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Rounded top edges
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 125, 128, 185),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'User Information',
          style: TextStyle(
          fontFamily: 'MontserratAlternates', // Use the defined font family
          fontWeight: FontWeight.bold, // Use the desired font weight
          fontSize: 18, // Adjust the font size
),
        ),
        SizedBox(height: 8),
        Expanded(
          child: ListView(
            shrinkWrap: true, // Allow content to scroll if necessary
            children: [
              SizedBox(height: 8),
              Center( // Center the user code text
                child: Text(
                  usercode,
                  style: TextStyle(
                    fontSize: 24, // Adjust the font size
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic, // Apply italic font style
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(usercode),
              SizedBox(height: 8),
              Text('Bus Name: Bus123'),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    ),
  );
}
}
 