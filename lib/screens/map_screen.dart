import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/Station.dart'; //


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng busPosition = LatLng(35.83168535761309, 10.233006581002806);
  LatLng myPosition = LatLng(36, 10);
  List<Station> stationList = [];

  @override
  void initState() {
    super.initState();


   ApiService.getListStationByCircuitId(1).then((list) {
      setState(() {
        stationList = list as List<Station>;
      });
    });
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Bus location"),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: busPosition,
          zoom: 8.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
        ],
      ),
    );
  }
}
