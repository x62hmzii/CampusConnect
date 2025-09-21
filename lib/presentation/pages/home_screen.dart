import 'package:flutter/material.dart';
import 'package:campusconnect/presentation/widgets/attendance_card.dart';
import 'package:campusconnect/presentation/widgets/announcement_card.dart';
import 'package:campusconnect/presentation/widgets/timetable_card.dart';
import 'package:campusconnect/presentation/pages/events_fragment.dart';
import 'package:campusconnect/presentation/pages/notes_fragment.dart';
import 'package:campusconnect/presentation/pages/profile_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const HomeFragment(),
    const EventsFragment(),
    const NotesFragment(),
    const ProfileFragment(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campus Connect',
          style: TextStyle(
            fontFamily: 'Sourgammy',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF187fc4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF187fc4),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Home Fragment with Announcements, Attendance, and Timetable
class HomeFragment extends StatelessWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            _buildUserProfileSection(),
            const SizedBox(height: 20),

            // Attendance Summary
            const AttendanceCard(),
            const SizedBox(height: 20),

            // Happening Now (Current Class)
            _buildHappeningNowSection(),
            const SizedBox(height: 20),

            // Announcements
            _buildAnnouncementsSection(),
            const SizedBox(height: 20),

            // Timetable Preview
            const TimetableCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFF187fc4),
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hamza Salman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sourgammy', // ✅ Heading only
              ),
            ),
            Text(
              'BSCS • FA21-BCS-154',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                // ❌ No font family here (default font)
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHappeningNowSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Happening Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sourgammy', // ✅ Heading only
                color: Color(0xFF187fc4),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              title: const Text(
                'DSA Algo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // ❌ No font family here (default font)
                ),
              ),
              subtitle: const Text(
                '04:00 PM - 05:00 PM',
                // ❌ No font family here (default font)
              ),
              trailing: Chip(
                label: const Text(
                  'B102',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: const Color(0xFF187fc4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Announcements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sourgammy', // ✅ Heading only
            color: Color(0xFF187fc4),
          ),
        ),
        const SizedBox(height: 12),
        AnnouncementCard(
          title: 'Mid-term Exams',
          description: 'Mid-term exams start October 10th. Prepare well!',
          date: 'Oct 5, 2024',
        ),
        AnnouncementCard(
          title: 'Workshop Alert',
          description: 'Flutter workshop this weekend. Register now!',
          date: 'Oct 3, 2024',
        ),
        AnnouncementCard(
          title: 'Holiday Notice',
          description: 'College will remain closed on October 15th',
          date: 'Oct 1, 2024',
        ),
      ],
    );
  }
}