import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String description;

  const EventCard({
    Key? key,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Delete Button - FIXED
            Row(
              children: [
                Expanded( // ✅ Expanded use karo taki title overflow na ho
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sourgammy',
                    ),
                    maxLines: 2, // ✅ Max 2 lines
                    overflow: TextOverflow.ellipsis, // ✅ ... if overflow
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {},
                  padding: EdgeInsets.zero, // ✅ Padding remove
                  constraints: const BoxConstraints(), // ✅ Constraints remove
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date and Time - FIXED
            Wrap( // ✅ Wrap use karo instead of Row
              spacing: 16,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description - FIXED
            Text(
              description,
              style: const TextStyle(fontSize: 14),
              maxLines: 3, // ✅ Max lines limit
              overflow: TextOverflow.ellipsis, // ✅ ... if overflow
            ),
            const SizedBox(height: 12),

            // Buttons - FIXED
            Wrap( // ✅ Wrap for small screens
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF187fc4),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}