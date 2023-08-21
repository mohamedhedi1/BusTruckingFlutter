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
    String nom = "";


   @override
  void initState() {
    super.initState();

    ApiService.userByCode("azertyui","").then((data){
      setState(() {

        user = data;
        nom = "${user.prenom} ${user.nom}";
        print(user.nom);

      });
    });
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
          radius: 25,
          backgroundImage: 
          AssetImage('assets/userImage.jpg'), 
        ),
        SizedBox(width: 8.0),
        Text(
          nom,
          style: TextStyle(
            fontSize: 24, // Augmentez la taille de la police pour un impact visuel plus fort
            fontWeight: FontWeight.bold,
            color: Colors.black26, // Changez la couleur du texte
            letterSpacing: 1.5, // Ajoutez de l'espacement entre les lettres
            fontStyle: FontStyle.italic, // Utilisez une police italique
          ),
        ),
      ],
    ),
  );
}
}