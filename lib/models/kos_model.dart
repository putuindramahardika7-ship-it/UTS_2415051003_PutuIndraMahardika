class Kos {
  final String id;
  final String name;
  final String location;
  final int pricePerMonth;
  final String imageUrl;
  final List<String> facilities;
  final String description;

  Kos({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerMonth,
    required this.imageUrl,
    required this.facilities,
    required this.description,
  });

  factory Kos.fromJson(Map<String, dynamic> json) {
    return Kos(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      pricePerMonth: json['pricePerMonth'] is int
          ? json['pricePerMonth']
          : int.tryParse(json['pricePerMonth']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'pricePerMonth': pricePerMonth,
      'imageUrl': imageUrl,
      'facilities': facilities,
      'description': description,
    };
  }
}