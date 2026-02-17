import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rescufy/domain/entities/user.dart';
import 'package:rescufy/domain/entities/user_role.dart';

class UserModel extends User {
  final String? token;

  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.phone,
    super.profileImage,
    super.createdAt,
    this.token,
  });

  // ---- ROLE MAPPER ----
  static UserRole _mapRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'paramedic':
        return UserRole.paramedic;
      case 'admin':
        return UserRole.admin;
      case 'user':
      default:
        return UserRole.user;
    }
  }

  // ---- VALIDATE MOBILE LOGIN ----
  void validateMobileLogin() {
    if (role.isAdmin) {
      throw AdminLoginNotAllowedException(
        'Admin accounts cannot login from mobile app. Please use the web dashboard.',
      );
    }
  }

  // ---- FROM TOKEN ----
  factory UserModel.fromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);

      final roleString =
          decodedToken['role'] ??
          decodedToken['Role'] ??
          decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

      final user = UserModel(
        id:
            decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
            decodedToken['userId'] ??
            '',
        email:
            decodedToken['Email'] ??
            decodedToken['email'] ??
            decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
            '',
        name: decodedToken['FullName'] ?? decodedToken['name'] ?? '',
        role: _mapRole(roleString),
        phone: decodedToken['phone'] ?? decodedToken['phoneNumber'],
        profileImage: decodedToken['profileImage'],
        createdAt: decodedToken['createdAt'] != null
            ? DateTime.tryParse(decodedToken['createdAt'])
            : null,
        token: token,
      );

      // Validate that admins can't login
      user.validateMobileLogin();

      return user;
    } catch (e) {
      if (e is AdminLoginNotAllowedException) {
        rethrow;
      }
      throw Exception('Failed to decode token: $e');
    }
  }

  // ---- FROM JSON ----
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      role: _mapRole(json['role']),
      phone: json['phone'],
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      token: json['token'],
    );

    // Validate that admins can't login
    user.validateMobileLogin();

    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
      'token': token,
    };
  }

  // Helper to copy with new values
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
    );
  }
}

// ---- CUSTOM EXCEPTION ----
class AdminLoginNotAllowedException implements Exception {
  final String message;

  AdminLoginNotAllowedException(this.message);

  @override
  String toString() => message;
}
