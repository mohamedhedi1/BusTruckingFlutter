import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Bus.dart';
import '../models/Station.dart';

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
      print("bussssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
      print(data);

      Bus bus = Bus.fromJson(data); // Assuming you have a fromJson constructor in your Bus class
      return bus;
    } else {
      print("Erreur de requête - Statut ${response.statusCode}");
      throw Exception("Erreur de requête");
    }
  }






}
