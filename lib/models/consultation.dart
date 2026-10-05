// ─────────────────────────────────────────────────────────────────────────────
// Consultation — Model for officer-farmer case sessions
// ─────────────────────────────────────────────────────────────────────────────
class Consultation {
  final String id;
  final String? scanId;
  final String farmerId;
  final String? officerId;
  final String status; // pending | open | resolved
  final String? diseaseName;
  final String? severity;
  final String? imageUrl;
  final String? location;
  final String? notes;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  // Joined fields (from profiles table)
  final String? farmerName;
  final String? farmerAvatar;
  final String? officerName;

  const Consultation({
    required this.id,
    this.scanId,
    required this.farmerId,
    this.officerId,
    required this.status,
    this.diseaseName,
    this.severity,
    this.imageUrl,
    this.location,
    this.notes,
    required this.createdAt,
    this.resolvedAt,
    this.farmerName,
    this.farmerAvatar,
    this.officerName,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    // Handle nested profile join (farmer)
    final farmerProfile = json['farmer_profile'] as Map<String, dynamic>?;
    final officerProfile = json['officer_profile'] as Map<String, dynamic>?;

    return Consultation(
      id: json['id'] as String,
      scanId: json['scan_id'] as String?,
      farmerId: json['farmer_id'] as String,
      officerId: json['officer_id'] as String?,
      status: json['status'] as String? ?? 'pending',
      diseaseName: json['disease_name'] as String?,
      severity: json['severity'] as String?,
      imageUrl: json['image_url'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      farmerName: farmerProfile?['full_name'] as String?,
      farmerAvatar: farmerProfile?['avatar_url'] as String?,
      officerName: officerProfile?['full_name'] as String?,
    );
  }

  bool get isUrgent => severity == 'high';
  bool get isResolved => status == 'resolved';
  bool get isPending => status == 'pending';
  bool get isOpen => status == 'open';

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ConsultationMessage — Model for individual chat messages
// ─────────────────────────────────────────────────────────────────────────────
class ConsultationMessage {
  final String id;
  final String consultationId;
  final String? senderId;
  final String senderRole; // farmer | officer
  final String content;
  final DateTime createdAt;

  // Joined field
  final String? senderName;
  final String? senderAvatar;

  const ConsultationMessage({
    required this.id,
    required this.consultationId,
    this.senderId,
    required this.senderRole,
    required this.content,
    required this.createdAt,
    this.senderName,
    this.senderAvatar,
  });

  factory ConsultationMessage.fromJson(Map<String, dynamic> json) {
    final senderProfile = json['sender_profile'] as Map<String, dynamic>?;

    return ConsultationMessage(
      id: json['id'] as String,
      consultationId: json['consultation_id'] as String,
      senderId: json['sender_id'] as String?,
      senderRole: json['sender_role'] as String? ?? 'farmer',
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      senderName: senderProfile?['full_name'] as String?,
      senderAvatar: senderProfile?['avatar_url'] as String?,
    );
  }

  bool get isFromOfficer => senderRole == 'officer';

  String get timeString {
    final m = createdAt.minute.toString().padLeft(2, '0');
    final period = createdAt.hour < 12 ? 'AM' : 'PM';
    final hour = createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour;
    return '$hour:$m $period';
  }
}
