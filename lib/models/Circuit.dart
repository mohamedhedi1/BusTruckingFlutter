class Circuit {
  int id;
  String nom;
  List<Station> stations;

  Circuit({
    required this.id,
    required this.nom,
    required this.stations,
  });

  factory Circuit.fromJson(Map<String, dynamic> json) {
    return Circuit(
      id: json['id'],
      nom: json['nom'],
      stations: (json['stations'] as List)
          .map((stationJson) => Station.fromJson(stationJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'stations': stations.map((station) => station.toJson()).toList(),
    };
  }
}

class Station {
  int id;
  String station;
  double longitudePosition;
  double latitudePosition;

  Station({
    required this.id,
    required this.station,
    required this.longitudePosition,
    required this.latitudePosition,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      station: json['station'],
      longitudePosition: json['longitude_position'],
      latitudePosition: json['latitude_position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station': station,
      'longitude_position': longitudePosition,
      'latitude_position': latitudePosition,
    };
  }
}
