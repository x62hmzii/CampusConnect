import 'package:campusconnect/domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  StudentModel({
    required String id,
    required String name,
    required String course,
    required String semester,
    required String profilePictureUrl,
  }) : super(
    id: id,
    name: name,
    course: course,
    semester: semester,
    profilePictureUrl: profilePictureUrl,
  );

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      course: json['course'],
      semester: json['semester'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'semester': semester,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}