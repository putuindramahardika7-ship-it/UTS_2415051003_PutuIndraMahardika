class SavedKos {
  final int? id;
  final String studentId;
  final String kosId;
  final String kosName;
  final String note;
  final double rating;
  final String status; // 'planned', 'visited', 'deal'
  final String? createdAt;

  SavedKos({
    this.id,
    required this.studentId,
    required this.kosId,
    required this.kosName,
    required this.note,
    required this.rating,
    required this.status,
    this.createdAt,
  });

  factory SavedKos.fromJson(Map<String, dynamic> json) {
    return SavedKos(
      id: json['id'],
      studentId: json['student_id'] ?? '',
      kosId: json['kos_id'] ?? '',
      kosName: json['kos_name'] ?? '',
      note: json['note'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'planned',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'student_id': studentId,
      'kos_id': kosId,
      'kos_name': kosName,
      'note': note,
      'rating': rating,
      'status': status,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}