import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
class User {
  int id;
  String userCode;

 bool isBusAtStation = false;
  bool isBusPassedBy = false;
  IconData icon = Icons.location_on;
  
  User({
    required this.id,
    required this.userCode,
  
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userCode: json['userCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userCode': userCode,
    };
  }
}