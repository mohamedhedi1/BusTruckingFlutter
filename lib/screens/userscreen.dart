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
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10.0,
        ),
      ],
    ),
    child: Row( // Use Row instead of Column
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: 
          AssetImage('assets/userImage.jpg'), 
        ),
        SizedBox(width: 8.0),
        Text(
          usercode,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
}