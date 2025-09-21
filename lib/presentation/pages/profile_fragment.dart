import 'package:flutter/material.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../data/datasources/student_data_source.dart';
import '../../domain/entities/student_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/text_styles.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  late StudentRepository _studentRepository;
  late Future<StudentEntity> _studentFuture;

  @override
  void initState() {
    super.initState();
    _studentRepository = StudentRepositoryImpl(
      dataSource: StudentDataSourceImpl(),
    );
    // Using a sample student ID - replace with actual user ID
    _studentFuture = _studentRepository.getStudentProfile("FA21-BCS-154");
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Profile", style: TextStyles.heading()),
        content: const Text("Edit functionality would be implemented here"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<StudentEntity>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading profile"));
          } else if (snapshot.hasData) {
            final student = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileHeader(student),
                  const SizedBox(height: 32),
                  _buildInfoSection("Student Details", [
                    _buildInfoItem("Name", student.name),
                    _buildInfoItem("Course", student.course),
                    _buildInfoItem("Semester", student.semester),
                    _buildInfoItem("Student ID", "FA21-BCS-154"),
                  ]),
                  const SizedBox(height: 24),
                  _buildSettingsSection(),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No profile data available"));
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(StudentEntity student) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(student.profilePictureUrl),
          backgroundColor: AppColors.secondary,
        ),
        const SizedBox(height: 16),
        Text(
          student.name,
          style: TextStyles.heading(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          "${student.course} • ${student.semester}",
          style: TextStyles.body(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _editProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.heading(fontSize: 20)),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyles.body(color: AppColors.textDark,)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyles.body()),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Settings", style: TextStyles.heading(fontSize: 20)),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSettingsItem("Set Attendance Criteria", Icons.calendar_today),
              _buildSettingsItem("My Files", Icons.folder),
              _buildSettingsItem("Work Profile", Icons.work),
              _buildSettingsItem("Rate Us", Icons.star),
              _buildSettingsItem("Contact Us", Icons.contact_mail),
              _buildSettingsItem("About", Icons.info),
              _buildSettingsItem("Log Out", Icons.logout, isLogout: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : null,
          fontWeight: isLogout ? FontWeight.bold : null,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle settings item tap
        if (isLogout) {
          // Handle logout
          _showLogoutDialog();
        }
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log Out", style: TextStyles.heading()),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout functionality
            },
            child: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}