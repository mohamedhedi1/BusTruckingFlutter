import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
class Station {
  int id;
  String station;
  double longitudePosition;
  double latitudePosition;
  CircuitDetails circuit;

 bool isBusAtStation = false;
  bool isBusPassedBy = false;
  IconData icon = Icons.location_on;
  
  Station({
    required this.id,
    required this.station,
    required this.longitudePosition,
    required this.latitudePosition,
    required this.circuit,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      station: json['station'],
      longitudePosition: json['longitude_position'],
      latitudePosition: json['latitude_position'],
      circuit: CircuitDetails.fromJson(json['circuit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station': station,
      'longitude_position': longitudePosition,
      'latitude_position': latitudePosition,
      'circuit': circuit.toJson(),
    };
  }
}

class CircuitDetails {
  int id;
  String nom;

  CircuitDetails({
    required this.id,
    required this.nom,
  });

  factory CircuitDetails.fromJson(Map<String, dynamic> json) {
    return CircuitDetails(
      id: json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}