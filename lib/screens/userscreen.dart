import 'dart:async';
import 'package:bus_app_flutter/models/User.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';



class UserInfoSheet extends StatefulWidget {
  final User user;
  const UserInfoSheet(this.user, {super.key});



  @override
  State<UserInfoSheet> createState() => _UserInfoSheet();
}

class _UserInfoSheet extends State<UserInfoSheet> {

    String nom = "";


   @override
  void initState() {
    super.initState();

    nom = "${widget.user.prenom} ${widget.user.nom}";
   /* ApiService.userByCode("azertyui","").then((data){
      setState(() {

        user = data;
        nom = "${user.prenom} ${user.nom}";
        print(user.nom);

      });
    }); */
  }
   @override
   Widget build(BuildContext context) {
     return Card(
       elevation: 5.0,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(20.0),
           topRight: Radius.circular(20.0),
         ),
       ),
       child: Container(
         padding: EdgeInsets.all(16.0),
         width: 300.0, // Augmentez la largeur du Card
         height: 300.0, // Augmentez la hauteur du Card
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 CircleAvatar(
                   radius: 25,
                   backgroundImage: AssetImage('assets/userImage.jpg'),
                 ),
                 SizedBox(width: 8.0),
                 Text(
                   nom,
                   style: TextStyle(
                     fontSize: 24,
                     fontWeight: FontWeight.bold,
                     color: Colors.black26,
                     letterSpacing: 1.5,
                     fontStyle: FontStyle.italic,
                   ),
                 ),
               ],
             ),
             SizedBox(height: 16.0),

           ],
         ),
       ),
     );
   }

   Widget _buildImageBox(String imagePath) {
     return Card(
       elevation: 5.0,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(10.0),
       ),
       child: Container(
         width: 100.0, // Personnalisez la largeur de la boîte
         height: 100.0, // Personnalisez la hauteur de la boîte
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10.0),
           boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.2),
               blurRadius: 5.0,
             ),
           ],
         ),
         child: Image.asset(
           imagePath, // Chemin de l'image
           fit: BoxFit.cover, // Ajustez l'image pour couvrir la boîte
         ),
       ),
     );
   }


}