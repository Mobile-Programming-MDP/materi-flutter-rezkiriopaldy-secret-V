class AccidentReportModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final String imageBase64;
  final DateTime createdAt;

  AccidentReportModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageBase64,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'imageBase64': imageBase64,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AccidentReportModel.fromMap(Map<String, dynamic> map) {
    return AccidentReportModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      imageBase64: map['imageBase64'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}