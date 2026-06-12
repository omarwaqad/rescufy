class EmergencyRequestModel {
  final String description;
  final bool isSelfCase;
  final double latitude;
  final double longitude;
  final String address;
  final String? peopleCount;

  EmergencyRequestModel({
    required this.description,
    required this.isSelfCase,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.peopleCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'is_self_case': isSelfCase,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'people_count': peopleCount,
    };
  }

  factory EmergencyRequestModel.fromJson(Map<String, dynamic> json) {
    return EmergencyRequestModel(
      description: json['description']?.toString() ?? '',
      isSelfCase: _readBool(json['is_self_case']),
      latitude: _readDouble(json['latitude']),
      longitude: _readDouble(json['longitude']),
      address: json['address']?.toString() ?? '',
      peopleCount: json['people_count']?.toString(),
    );
  }

  static bool _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == 'yes' || normalized == '1';
  }

  static double _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
