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
      description: json['description'],
      isSelfCase: json['is_self_case'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      peopleCount: json['people_count'],
    );
  }
}
