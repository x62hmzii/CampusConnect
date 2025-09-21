class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String description;
  final bool isRegistered;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    this.isRegistered = false,
  });

  // Convert to Map for local storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'description': description,
      'isRegistered': isRegistered,
    };
  }

  // Create from Map for local storage
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      time: map['time'],
      description: map['description'],
      isRegistered: map['isRegistered'] ?? false,
    );
  }
}