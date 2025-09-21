import 'package:flutter/material.dart';
import 'package:campusconnect/presentation/widgets/event_card.dart';

class EventsFragmentContent extends StatelessWidget {
  const EventsFragmentContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF187fc4),
            child: const Text(
              'Events Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Sourgammy', // ✅ Only heading mein font family
              ),
            ),
          ),

          // Events List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                EventCard(
                  title: 'Flutter Workshop',
                  date: 'Oct 15, 2024',
                  time: '03:00 PM - 05:00 PM',
                  description: 'Learn Flutter development with hands-on workshop',
                ),
                EventCard(
                  title: 'Mid-term Exams',
                  date: 'Oct 20-25, 2024',
                  time: '09:00 AM - 12:00 PM',
                  description: 'Mid-term examination schedule',
                ),
                EventCard(
                  title: 'Tech Fest',
                  date: 'Nov 5-7, 2024',
                  time: '10:00 AM - 06:00 PM',
                  description: 'Annual technical festival with competitions',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        backgroundColor: const Color(0xFF187fc4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          style: TextStyle(
            fontFamily: 'Sourgammy', // ✅ Heading mein font family
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(), // ✅ Default font
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date (MM/DD/YYYY)',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(), // ✅ Default font
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(), // ✅ Default font
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              style: const TextStyle(), // ✅ Default font
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'), // ✅ Default font
          ),
          ElevatedButton(
            onPressed: () {
              // Add event logic here
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF187fc4),
            ),
            child: const Text('Add Event'), // ✅ Default font
          ),
        ],
      ),
    );
  }
}