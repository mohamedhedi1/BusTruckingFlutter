import 'package:flutter/foundation.dart';
import 'Bus.dart';

class User {
  final int id;
  final String userCode;
  final String? nom;
  final String? prenom;
  final String password;
  final String role;
  final Bus? bus;
  final bool enabled;
  final bool accountNonExpired;
  final bool credentialsNonExpired;
  final List<Authority> authorities;
  final String username;
  final bool accountNonLocked;

  User({
    required this.id,
    required this.userCode,
    this.nom,
    this.prenom,
    required this.password,
    required this.role,
    this.bus,
    required this.enabled,
    required this.accountNonExpired,
    required this.credentialsNonExpired,
    required this.authorities,
    required this.username,
    required this.accountNonLocked,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userCode: json['userCode'],
      nom: json['nom'],
      prenom: json['prenom'],
      password: json['password'],
      role: json['role'],
      bus: json['bus'] != null ? Bus.fromJson(json['bus']) : null,
      enabled: json['enabled'],
      accountNonExpired: json['accountNonExpired'],
      credentialsNonExpired: json['credentialsNonExpired'],
      authorities: (json['authorities'] as List)
          .map((authority) => Authority.fromJson(authority))
          .toList(),
      username: json['username'],
      accountNonLocked: json['accountNonLocked'],
    );
  }

  static Role _parseRole(String roleString) {
    if (roleString == 'USER') {
      return Role.USER;
    } else {
      // Gérez les autres rôles ici si nécessaire
      throw Exception('Unknown role: $roleString');
    }
  }
}

enum Role {
  USER,
  ADMIN
  // Ajoutez d'autres rôles ici si nécessaire
}



class Authority {
  final String authority;

  Authority({required this.authority});

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      authority: json['authority'],
    );
  }
}
