import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sourgammy',
                color: Color(0xFF187fc4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttendanceCircle(60, 'Current', Colors.orange),
                _buildAttendanceCircle(75, 'Target', Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            _buildSubjectProgress('DSA Algo', 80, 4, 5),
            _buildSubjectProgress('DBMS', 33, 1, 3),
            _buildSubjectProgress('Data Structures', 50, 1, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCircle(int percentage, String label, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sourgammy',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Sourgammy',
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectProgress(String subject, int percentage, int attended, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Sourgammy',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 75 ? Colors.green : Colors.orange,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$percentage%',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: percentage >= 75 ? Colors.green : Colors.orange,
                fontFamily: 'Sourgammy',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}