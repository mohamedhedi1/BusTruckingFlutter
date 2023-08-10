class Bus {
  final int id;
  final double longitude;
  final double latitude;
  final Circuit circuit;

  Bus({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.circuit,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      circuit: Circuit.fromJson(json['circuit']),
    );
  }
}

class Circuit {
  final int id;
  final String nom;

  Circuit({
    required this.id,
    required this.nom,
  });

  factory Circuit.fromJson(Map<String, dynamic> json) {
    return Circuit(
      id: json['id'],
      nom: json['nom'],
    );
  }
}
