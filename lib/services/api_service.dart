import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Bus.dart';
import '../models/Station.dart';
import '../models/User.dart';
import '../screens/map_screen.dart';

class ApiService {
  static Future<List<Station>> getListStationByCircuitId(int id) async {
    var baseUrl = "http://10.0.2.2:8080/Circuit/StationsbyCircuitId/$id";
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Station> stationList = jsonResponse
            .map((stationJson) => Station.fromJson(stationJson))
            .toList();

        print("Liste des stations :");
        print(stationList);

        // Afficher les composants de chaque station
        for (var station in stationList) {
          print("ID: ${station.id}");
          print("Station: ${station.station}");
          print("Longitude: ${station.longitudePosition}");
          print("Latitude: ${station.latitudePosition}");
          print("Circuit ID: ${station.circuit.id}");
          print("Circuit Nom: ${station.circuit.nom}");
        }

        return stationList;
      } else {
        print("Erreur de requête - Statut ${response.statusCode}");
        throw Exception("Erreur de requête");
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      throw Exception("Erreur lors de la requête");
    }
  }

  static Future<Map<String, double>> getPositionById(id) async {
    var baseurl = "http://10.0.2.2:8080/Bus/getPositionById/$id";
    var response = await http.get(Uri.parse(baseurl));
    final data = jsonDecode(response.body);
    print("hello bus position");
    print(data);
    double lat = data['lat'];
    double long = data['long'];
    return {'lat': lat, 'long': long};
  }

  static Future<Bus> getBusbyUserId(id) async {
    var baseurl = "http://10.0.2.2:8080/User/busbyiduser/$id";
    var response = await http.get(Uri.parse(baseurl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      Bus bus = Bus.fromJson(data);
      return bus;
    } else {
      print("Erreur de requête - Statut ${response.statusCode}");
      throw Exception("Erreur de requête");
    }
  }

  static Future<User> userByCode(String matricule, String accessToken) async {
    var baseUrl = "http://10.0.2.2:8080/User/Code/$matricule";

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("User data:");
        print(data);
        User user = User.fromJson(data);
        return user;

      } else {
        print("Erreur de requête - Statut ${response.statusCode}");
        throw Exception("Erreur de requête");
      }
    } catch (e) {
      print('Error $e');
      throw Exception("Erreur inattendue");
    }
  }


  static  Future<bool> login(BuildContext context, String matricule, String mdp) async {
    var  loginUrl = "http://10.0.2.2:8080/authenticate/login";
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "userCode" : matricule ,
          "password" : mdp
        }),
      );
      if (response.statusCode >= 200) {
        final data = json.decode(response.body);
        final User user = await userByCode(matricule, data['access_token']);

        print("User role:");
        print(user.role);

        print("tokeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeen");
        print( data['access_token'] );


        if (user.role== 'USER') {
          print("777777777777777777777777777777777777777777777777777777777777777777777777");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MapScreen(),
            ),
          );
          return true;
        }
          print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        return true;


      }else {
        print("hellooooooooooooooooooooooooooooooooooooooooooooo");
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      // Error occurred during login
      print('Error during login: $e');
      return false;
    }
  }




}
