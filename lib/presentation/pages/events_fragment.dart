import 'package:flutter/material.dart';
import 'package:campusconnect/presentation/widgets/event_card.dart';

class EventsFragment extends StatelessWidget {
  const EventsFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header - FIXED
          Container(
            width: double.infinity, // ✅ Screen width ke equal
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF187fc4),
            child: const Text(
              'Events Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Sourgammy',
              ),
            ),
          ),

          // Events List - FIXED
          Expanded(
            child: SingleChildScrollView( // ✅ Scrollable banao
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 32, // ✅ Screen width minus padding
                ),
                child: const Column(
                  children: [
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
                      description: 'Mid-term examination schedule for all courses',
                    ),
                    EventCard(
                      title: 'Tech Fest 2024',
                      date: 'Nov 5-7, 2024',
                      time: '10:00 AM - 06:00 PM',
                      description: 'Annual technical festival with competitions and workshops',
                    ),
                  ],
                ),
              ),
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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9, // ✅ 90% screen width
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Event',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sourgammy',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Date (MM/DD/YYYY)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF187fc4),
                      ),
                      child: const Text('Add Event'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}