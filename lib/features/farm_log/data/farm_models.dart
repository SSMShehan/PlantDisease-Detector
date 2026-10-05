class FieldBlock {
  final String id;
  final String userId;
  final String name;
  final String crop;
  final String area;
  final int healthScore;
  final String status;
  final String? imageUrl;

  FieldBlock({
    required this.id,
    required this.userId,
    required this.name,
    required this.crop,
    required this.area,
    required this.healthScore,
    required this.status,
    this.imageUrl,
  });

  factory FieldBlock.fromJson(Map<String, dynamic> json) {
    return FieldBlock(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      crop: json['crop'] as String,
      area: json['area'] as String,
      healthScore: json['health_score'] as int,
      status: json['status'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'crop': crop,
      'area': area,
      'health_score': healthScore,
      'status': status,
      'image_url': imageUrl,
    };
  }
}

class FarmTask {
  final String id;
  final String userId;
  final String label;
  final String dueDate;
  final String priority;
  final bool isDone;

  FarmTask({
    required this.id,
    required this.userId,
    required this.label,
    required this.dueDate,
    required this.priority,
    this.isDone = false,
  });

  factory FarmTask.fromJson(Map<String, dynamic> json) {
    return FarmTask(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      label: json['label'] as String,
      dueDate: json['due_date'] as String,
      priority: json['priority'] as String,
      isDone: json['is_done'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'label': label,
      'due_date': dueDate,
      'priority': priority,
      'is_done': isDone,
    };
  }

  FarmTask copyWith({
    String? id,
    String? userId,
    String? label,
    String? dueDate,
    String? priority,
    bool? isDone,
  }) {
    return FarmTask(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
    );
  }
}

class YieldEntry {
  final String id;
  final String userId;
  final DateTime date;
  final String cropName;
  final String fieldId;
  final int yieldAmount;

  YieldEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.cropName,
    required this.fieldId,
    required this.yieldAmount,
  });

  factory YieldEntry.fromJson(Map<String, dynamic> json) {
    return YieldEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      cropName: json['crop_name'] as String,
      fieldId: json['field_id'] as String,
      yieldAmount: json['yield_amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'crop_name': cropName,
      'field_id': fieldId,
      'yield_amount': yieldAmount,
    };
  }
}
