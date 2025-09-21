import 'package:campusconnect/data/datasources/student_data_source.dart';
import 'package:campusconnect/data/models/student_model.dart';
import 'package:campusconnect/domain/entities/student_entity.dart';

abstract class StudentRepository {
  Future<StudentEntity> getStudentProfile(String studentId);
  Future<void> updateStudentProfile(StudentEntity student);
}

class StudentRepositoryImpl implements StudentRepository {
  final StudentDataSource dataSource;

  StudentRepositoryImpl({required this.dataSource});

  @override
  Future<StudentEntity> getStudentProfile(String studentId) async {
    return await dataSource.getStudentProfile(studentId);
  }

  @override
  Future<void> updateStudentProfile(StudentEntity student) async {
    await dataSource.updateStudentProfile(StudentModel(
      id: student.id,
      name: student.name,
      course: student.course,
      semester: student.semester,
      profilePictureUrl: student.profilePictureUrl,
    ));
  }
}