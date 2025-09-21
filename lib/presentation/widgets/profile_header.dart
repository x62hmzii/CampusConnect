import 'package:campusconnect/core/constants/app_colors.dart';
import 'package:campusconnect/core/utils/text_styles.dart';
import 'package:campusconnect/domain/entities/student_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final StudentEntity student;
  final VoidCallback onEditPressed;

  const ProfileHeader({
    Key? key,
    required this.student,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(student.profilePictureUrl),
          backgroundColor: AppColors.secondary,
        ),
        SizedBox(height: 16),
        Text(
          student.name,
          style: TextStyles.heading(fontSize: 24),
        ),
        SizedBox(height: 8),
        Text(
          "${student.course} • ${student.semester}",
          style: TextStyles.body(),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: onEditPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}