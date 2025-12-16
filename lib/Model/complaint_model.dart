class Location {
  final String latitude;
  final String longitude;
  final String place;

  Location({
    required this.latitude,
    required this.longitude,
    required this.place,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
    );
  }
}

class Attachment {
  final int id;
  final int complaintId;
  final String filePath;
  final String fileName;
  final String mimeType;
  final String fileSize;

  Attachment({
    required this.id,
    required this.complaintId,
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] ?? 0,
      complaintId: json['complaint_id'] ?? 0,
      filePath: json['file_path']?.toString() ?? '',
      fileName: json['file_name']?.toString() ?? '',
      mimeType: json['mime_type']?.toString() ?? '',
      fileSize: json['file_size']?.toString() ?? '',
    );
  }
}

class Complaint {
  final int id;
  final String description;
  final String status;
  final String referenceNumber;
  final Location? location;
  final String type;
  final int userId;
  final int governmentEntityId;
  final String createdAt;
  final List<Attachment>? attachments;

  Complaint({
    required this.id,
    required this.description,
    required this.status,
    required this.referenceNumber,
    this.location,
    required this.type,
    required this.userId,
    required this.governmentEntityId,
    required this.createdAt,
    this.attachments,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    Location? loc;
    if (json['location'] != null && json['location'] is Map<String, dynamic>) {
      loc = Location.fromJson(json['location']);
    }

    List<Attachment>? attach;
    if (json['attachments'] != null && json['attachments'] is List) {
      attach = (json['attachments'] as List)
          .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return Complaint(
      id: json['id'] ?? 0,
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      referenceNumber: json['reference_number']?.toString() ?? '',
      location: loc,
      type: json['type']?.toString() ?? '',
      userId: json['user_id'] ?? 0,
      governmentEntityId: json['government_entity_id'] ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      attachments: attach,
    );
  }
}
