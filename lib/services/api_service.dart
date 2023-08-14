import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Bus.dart';
import '../models/Station.dart';
import '../models/User.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';




class ApiService {
  static Future<List<Station>> getListStationByCircuitId(int id) async {
    var baseUrl = "http://localhost:8080/Circuit/StationsbyCircuitId/$id";
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
    var baseurl = "http://localhost:8080/Bus/getPositionById/$id";
    var response = await http.get(Uri.parse(baseurl));
    final data = jsonDecode(response.body);
    print("hello bus positionnnnnnnnnnnnnnnnnnnnnnnn");
    print(data);
    double lat = data['lat'];
    double long = data['long'];
    return {'lat': lat, 'long': long};
  }

    
  

  static Future<Bus> getBusbyUserId(id) async {
   var baseurl = "http://localhost:8080/User/busbyiduser/$id";
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

 static Future<User> getUserByUser(userCode) async {
   var baseurl = "http://localhost:8080/User/Code/$userCode";
    var response = await http.get(Uri.parse(baseurl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("USEEEEEEEEEEEEEER");
      print(data);

      User user = User.fromJson(data); // Assuming you have a fromJson constructor in your User class
      return user;
    } else {
      print("Erreur de requête - Statut ${response.statusCode}");
      throw Exception("Erreur de requête");
    }
  }

   static  Future<List<LatLng>> getRoutePoints() async {
    //   static  Future<List<LatLng>> getRoutePoints(List pointValues) async {

 /*   List<String> formattedPairs = [];
    for (int i = 0; i < pointValues.length; i += 2) {
    double lat = pointValues[i];
    double lon = pointValues[i + 1];
    formattedPairs.add('$lat,$lon');
}
String point = formattedPairs.join(';');
    var baseurl="http://router.project-osrm.org/route/v1/driving/$point?steps=true&annotations=true&geometries=geojson&overview=full";*/
                   
                     List<Location> start_l = await locationFromAddress(
                      "Boulangerie Pâtisserie Ranim, Avenue Habib Bougatfa, El Bassatine, Le Bardo, Tunis, Gouvernorat Tunis, 2000, Tunisie"
);
                      List<Location> end_l = await locationFromAddress("Rue du Lac Biwa, Difaf al Boukhaïra, El Bouhaira, Délégation Cité El Khadra, Tunis, Gouvernorat Tunis, 1055, Tunisie");
                                      
                      var v1 = start_l[0].latitude;
                      var v2 = start_l[0].longitude;
                      var v3 = end_l[0].latitude;
                      var v4 = end_l[0].longitude;
                      
                      var baseurl = 'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full';
  
    var response = await http.get(Uri.parse(baseurl));
    
    if (response.statusCode == 200) {
      final routeData = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      print('iam heeeeeeeeeeeeeeeeeeeeeeeeeere');
      print(routeData);
      

      List<LatLng> routePoints = [];
      
       for(int i=0; i< routeData.length; i++){
                          var reep = routeData[i].toString();
                          reep = reep.replaceAll("[","");
                          reep = reep.replaceAll("]","");
                          var lat1 = reep.split(',');
                          var long1 = reep.split(",");
                          routePoints.add(LatLng( double.parse(lat1[1]), double.parse(long1[0])));
                        }
            print('i get ittttttttttttttttttttttttttt');
      return routePoints;
    } else {
      throw Exception('Failed to fetch route points');
    }
  }
}


