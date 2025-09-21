import 'package:campusconnect/data/models/student_model.dart';

abstract class StudentDataSource {
  Future<StudentModel> getStudentProfile(String studentId);
  Future<void> updateStudentProfile(StudentModel student);
}

class StudentDataSourceImpl implements StudentDataSource {
  @override
  Future<StudentModel> getStudentProfile(String studentId) async {
    // Implementation to fetch from API/local storage
    // This is a mock implementation
    await Future.delayed(Duration(seconds: 1));
    return StudentModel(
      id: studentId,
      name: "Hamza",
      course: "Computer Science",
      semester: "5th Semester",
      profilePictureUrl: "https://example.com/profile.jpg",
    );
  }

  @override
  Future<void> updateStudentProfile(StudentModel student) async {
    // Implementation to update profile
    await Future.delayed(Duration(seconds: 1));
    print("Profile updated: ${student.toJson()}");
  }
}