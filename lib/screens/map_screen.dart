import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart' as path_import;
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

import 'BottomNavBar.dart';
import 'login_screen/login_screen.dart';
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
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }



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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
     appBar :AppBar(
       elevation: 1, // Ajoutez une ombre
       backgroundColor: Colors.white, // Fond transparent
       title: Text(
         'BusTracking',
         style: TextStyle(
           fontFamily: 'MontserratAlternates',
           fontWeight: FontWeight.normal,
           fontSize: 17,
           color: Colors.lightBlueAccent,
         ),
       ),
       centerTitle: true,
       actions: <Widget>[
         IconButton(
           icon: Icon(
             Icons.settings,
             color: Colors.lightBlueAccent,
             size: 24.0,
           ),
           onPressed: () {
             Navigator.of(context).pushReplacement(
                 MaterialPageRoute(
                   builder: (_) => LoginScreen()
                 ));

           },
         ),
       ],
     )

      ,

      backgroundColor: Colors.transparent,
      body: Stack(
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
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(backgroundColor: Colors.lightBlue, child: const Icon(Icons.home), elevation: 0.1, onPressed: () {}),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        IconButton(
                          icon: Icon(
                            Icons.directions_bus,
                            color: currentIndex == 1 ? Colors.blue : Colors.grey.shade400,
                          ),
                          onPressed: _goToBusPosition,
                        ),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.person_pin_circle,
                            color: currentIndex == 1 ? Colors.blue : Colors.grey.shade400,
                          ),
                          onPressed: _goToMyPosition,),

                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    path_import.Path path = path_import.Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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