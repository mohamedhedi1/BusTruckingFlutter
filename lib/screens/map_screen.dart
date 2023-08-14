import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/Bus.dart';
import '../services/api_service.dart';
import '../models/Station.dart';
import '../services/location_service.dart';
import '../screens/userscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';




class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng busPosition = LatLng(35.83168535761309, 10.233006581002806);
  LatLng  myPosition = LatLng(35.83168535761309, 10.233006581002806);
 // late LatLng myPosition ;
  List<Station> stationList = [];
   bool isNightTime = false;
   final dayTileUrl = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  final nightTileUrl = "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png";
  final MapController mapController = MapController();
  List<LatLng> busPath = [];
  bool initialPositionReceived = false; 
  LatLng previousBusPosition = LatLng(0, 0); // List to store bus path points
  late Bus bus;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
final Geolocator geolocator = Geolocator();
  
  


  @override
  void initState() {
    super.initState();
    LocationService.getMyPosition().then((myPositionResult) {
      setState(() {
        myPosition = myPositionResult;
      });
    });
    ApiService.getListStationByCircuitId(1).then((list) {
      setState(() {
        stationList = list as List<Station>;
      });
    });
    
    final currentTime = TimeOfDay.now();
    if (currentTime.hour >= 22 || currentTime.hour <= 10) {
      setState(() {
        isNightTime = true;
      });
    }

   // startUpdatingMarkerPosition();

    //tester bus by userid
    ApiService.getBusbyUserId(1).then((data){
      setState(() {
        bus = data;
       // circuitId = data.circuit.id;

      });
    });

  }

  void startUpdatingMarkerPosition() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      Map<String, double> positionData = await ApiService.getPositionById(1);
      setState(() {
        busPosition = LatLng(positionData['lat']!, positionData['long']!);
      });
    
      setState(() {});
      
    setState(() {
        if (!initialPositionReceived) {
          busPath.add(busPosition); // Add the initial position to the list
          initialPositionReceived = true;
        } else {
          busPath.add(busPosition); // Add subsequent positions to the list
        }
      });
    });
  }

TileLayer _getTileLayerOptions() {
    final tileUrl = isNightTime ? nightTileUrl : dayTileUrl;

    return TileLayer(
      urlTemplate: tileUrl,
      subdomains: ['a', 'b', 'c'],
    );
  }
  void _goToMyPosition() {
    if (myPosition != null) {
      mapController.move(myPosition, 15.0);
    }
  }
 void _goToBusPosition() {
    if (busPosition != null) {
      mapController.move(busPosition, 25.0);
    }
  }
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Moving Marker ',
      home: Scaffold(
          appBar: AppBar(
    title: Text(
      'Track order',
      style: TextStyle(
         fontFamily: 'MontserratAlternates', 
    fontWeight: FontWeight.normal,
    fontSize: 17,
        color: Colors.black, 
      ),
    ),
    centerTitle: true,
    backgroundColor: Color.fromARGB(255, 254, 254, 254),
    elevation: 0,
  ),
   body: Container(
  decoration: BoxDecoration(
    /*color: Color.fromARGB(223, 204, 221, 15),// Set the background color here
    border: Border.all(color: const Color.fromARGB(255, 192, 7, 7).withOpacity(0.3)),*/
    borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
  ),
    child: ClipRRect(
    borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
      child: Stack(
        children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: busPosition,
            zoom:10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 30.0,
                  height: 30.0,
                  point: busPosition,
                  builder: (ctx) =>
                      Container(child: Icon(Icons.directions_bus, size: 17, color: Colors.red)),
                ),
                Marker(
                  width: 60.0,
                  height: 60.0,
                  point: myPosition,
                  builder: (ctx) =>
                      Container(child: Icon(Icons.person_pin_circle, size: 19, color: Colors.blue)),
                ),
                for (var station in stationList)
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(station.latitudePosition, station.longitudePosition),
                    builder: (ctx) =>
                        Container(child: Icon(Icons.location_on, size: 20, color: Colors.green)),
                  ),
              ],
            ),
             PolylineLayer(
          polylines: [
            Polyline(
              points: busPath,
              color: Color.fromARGB(255, 182, 15, 32),
              strokeWidth: 4.0,
            ),
          ],
        ),
          ],
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.1,
          minChildSize: 0.1,
          maxChildSize: 0.6,
          builder: (BuildContext context, ScrollController scrollController) {
            return UserInfoSheet(); // Replace with your user info widget
          },
        ),
        Positioned(
  top: 32.0, // Adjust this value to move the compass icon down
  right: 16.0,
  child: GestureDetector(
    onTap: () {
      mapController.rotate(0.0); // Reset the map rotation
    },
    child: Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.explore,
        color: Colors.black,
        size: 24.0,
      ),
    ),
  ),
),
        Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _goToMyPosition,
              child: Icon(Icons.my_location),
              backgroundColor: Colors.blue,
              tooltip: 'Go to My Position',
            ),
          ),
          
        Positioned(
          bottom: 80.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: _goToBusPosition, 
            child: Icon(Icons.directions_bus),
            backgroundColor: Color.fromARGB(255, 7, 38, 163), 
            tooltip: 'Go to Bus Position',
          ),
            ),
        ],
      ),
    ),
      ),
  ),
  );
  }
}