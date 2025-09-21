import 'package:flutter/material.dart';

class TimetableCard extends StatelessWidget {
  const TimetableCard({Key? key}) : super(key: key);

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
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sourgammy',
                color: Color(0xFF187fc4),
              ),
            ),
            const SizedBox(height: 12),
            _buildTimeTableEntry('03:30 PM - 04:00 PM', 'Java', 'B101'),
            _buildTimeTableEntry('04:00 PM - 05:00 PM', 'DSA Algo', 'B102'),
            _buildTimeTableEntry('05:00 PM - 06:00 PM', 'DBMS', 'B102'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTableEntry(String time, String subject, String room) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Sourgammy',
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              subject,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sourgammy',
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF187fc4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                room,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Sourgammy',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}