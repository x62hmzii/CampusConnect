import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String filePath;

  @HiveField(4)
  final String fileName;

  @HiveField(5)
  final String fileType;

  @HiveField(6)
  final String degree;

  @HiveField(7)
  final String department;

  @HiveField(8)
  final String semester;

  @HiveField(9)
  final String subject;

  @HiveField(10)
  final DateTime uploadDate;

  @HiveField(11)
  final String uploadedBy;

  NoteModel({
    String? id,
    required this.title,
    required this.description,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    required this.degree,
    required this.department,
    required this.semester,
    required this.subject,
    required this.uploadDate,
    required this.uploadedBy,
  }) : id = id ?? const Uuid().v4();
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'filePath': filePath,
      'fileName': fileName,
      'fileType': fileType,
      'degree': degree,
      'department': department,
      'semester': semester,
      'subject': subject,
      'uploadDate': uploadDate.toIso8601String(),
      'uploadedBy': uploadedBy,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      filePath: map['filePath'],
      fileName: map['fileName'],
      fileType: map['fileType'],
      degree: map['degree'],
      department: map['department'],
      semester: map['semester'],
      subject: map['subject'],
      uploadDate: DateTime.parse(map['uploadDate']),
      uploadedBy: map['uploadedBy'],
    );
  }
}