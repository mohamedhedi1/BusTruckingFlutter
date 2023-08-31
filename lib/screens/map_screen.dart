import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/Bus.dart';
import '../models/User.dart';
import '../services/api_service.dart';
import '../models/Station.dart';
import '../services/location_service.dart';
import '../screens/userscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/*FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
 */





class MapScreen extends StatefulWidget {
  final User user;
  final String access_token;
  MapScreen(this.user, this.access_token);


  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {



  LatLng busPosition = LatLng(0, 0);
  LatLng  myPosition = LatLng(0, 0);
  List<Station> stationList = [];
  final MapController mapController = MapController();
  List<LatLng> busPath = [];
    List<LatLng> movingbus = [];
  bool initialPositionReceived = false;
  LatLng previousBusPosition = LatLng(0, 0); // List to store bus path points
  late Bus bus;
  final Geolocator geolocator = Geolocator();
  int id=0;
  List<LatLng> movingbuspath = [];

  bool notifieddistance = false;







  @override
  void initState() {
    super.initState();
    LocationService.getMyPosition().then((myPositionResult) {
      setState(() {
        myPosition = myPositionResult;
      });
    });
    ApiService.getListStationByCircuitId(widget.user.bus?.circuit?.id ?? 0, widget.access_token).then((list) {
      setState(() {
        stationList = list as List<Station>;
        print("liste statiooooooonsssssssssssss");
        print(stationList);

        ApiService.getRoutePoints(stationList).then((list) {
          setState(() {
            busPath = list as List<LatLng>;
          });
        });
      });
    });
    startUpdatingMarkerPosition(widget.access_token);
    //sendNotification();

  }





  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Rayon de la Terre en kilomètres

    final double dLat = (lat2 - lat1) * pi / 180.0;
    final double dLon = (lon2 - lon1) * pi / 180.0;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180.0) * cos(lat2 * pi / 180.0) *
            sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadius * c;

    return distance;
  }


 void startUpdatingMarkerPosition(access_token) {
    Timer.periodic(Duration(seconds: 1), (timer) async {
       ApiService.getBusbyUserId(widget.user.id ,access_token).then((data){
      setState(() {
        bus = data;

      });
    });
      Map<String, double> positionData = await ApiService.getPositionById(bus.id,widget.access_token);
      setState(() {
        busPosition = LatLng(positionData['lat']!, positionData['long']!);
      });

      setState(() {});

    setState(() {
        if (!initialPositionReceived) {
          movingbuspath.add(busPosition);
          initialPositionReceived = true;
        } else {
          movingbuspath.add(busPosition);
        }
      });
    });
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
      'BusTracking',
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
            zoom:2.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 150.0,
                  height: 150.0,
                  point: busPosition,
                  builder: (ctx) =>
                      Container(child: Icon(Icons.directions_bus, size: 17, color: Colors.red)),
                ),
                Marker(
                  width: 130.0,
                  height:130.0,
                  point: myPosition,
                  builder: (ctx) =>
                      Container(child: Icon(Icons.person_pin_circle, size: 19, color: Colors.blue)),
                ),
                for (var station in stationList)
                  Marker(
                    width: 150.0,
                    height: 150.0,
                    point: LatLng(station.latitudePosition, station.longitudePosition),
                    builder: (ctx) =>

            Container(child: Icon(Icons.circle, size: 20, color: Colors.green)),
          ),

              ],
            ),
       /*      Positioned(
            bottom: 150.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: PointForPolyline,
              child: Icon(Icons.directions),
              backgroundColor: Colors.blue,
              tooltip: 'Get Road',

            ),
          ),*/

             PolylineLayer(
              polylineCulling: false,
              polylines: [
                      Polyline(
                        points:busPath
          ,
                        color: Color.fromARGB(173, 165, 158, 158),
                        strokeWidth: 4.0,
                      ),
                    ],
             ),
                  PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                      Polyline(
                        points:movingbuspath
                        ,
                        color: Color.fromARGB(255, 154, 4, 21),
                        strokeWidth: 4.0,
                      ),
                    ],
                  )
          ],
        ),
        DraggableScrollableSheet(
          initialChildSize:0.12,
          minChildSize: 0.1,
          maxChildSize: 0.9,
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



/*
  void sendNotification() async {
    double distance = calculateDistance(
        bus.latitude, bus.longitude, myPosition.latitude, myPosition.longitude);

    if (distance < 1.0 && !notifieddistance) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id', // ID du canal de notification
        'Channel Name', // Nom du canal
        'Channel Description', // Description du canal
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0, // ID de la notification
        'Bus Arrival', // Titre de la notification
        'The bus arrives in 5min', // Contenu de la notification
        platformChannelSpecifics,
        payload: 'notification',
      );

      setState(() {
        notifieddistance = true;
      });
    }
  }
  */