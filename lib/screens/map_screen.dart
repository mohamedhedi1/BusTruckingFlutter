import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/Station.dart';
import '../services/location_service.dart';
import '../screens/userscreen.dart';


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

    startUpdatingMarkerPosition();
  }

  void startUpdatingMarkerPosition() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      Map<String, double> positionData = await ApiService.getPositionById(1);
      setState(() {
        busPosition = LatLng(positionData['lat']!, positionData['long']!);
      });
      /*checkIfBusAtStation();
      checkIfBusPassesByStation();*/
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
/*void checkIfBusAtStation() {
    for (var station in stationList) {
      station.isBusAtStation = busPosition == LatLng(station.latitudePosition, station.longitudePosition);
    }
  }

  void checkIfBusPassesByStation() {
    for (var station in stationList) {
      if (!station.isBusPassedBy &&
          ((previousBusPosition.latitude < station.latitudePosition &&
                  busPosition.latitude >= station.latitudePosition) ||
              (previousBusPosition.latitude >= station.latitudePosition &&
                  busPosition.latitude < station.latitudePosition))) {
        setState(() {
          station.isBusPassedBy = true;
          station.icon = Icons.location_off;
        });
      }
    }
    previousBusPosition = busPosition;
  }*/
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
      mapController.move(busPosition, 15.0);
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: busPosition,
            zoom: 1.0,
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
              color: Colors.blue,
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
            onPressed: _goToBusPosition, // Replace with appropriate function
            child: Icon(Icons.directions_bus), // Use the bus icon
            backgroundColor: Colors.green, // Customize the color as needed
            tooltip: 'Go to Bus Position',
          ),
            ),
        ],
      ),
    );
  }
}