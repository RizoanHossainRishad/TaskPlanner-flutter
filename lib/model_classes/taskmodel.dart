import 'package:flutter/material.dart';

class Task {
  int id;
  String name;           // Unique ID for each task
  String listId;       // ID of the list this task belongs to
  String description;  // Task details
  String category;     // Fixed options from dropdown
  DateTime date;       // Task date
  TimeOfDay time;         // Task time in HH:mm format
  bool isDone;         // Checkbox status

  Task({
    required this.id,
    required this.name,
    required this.listId,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    this.isDone = false,
  });
  void toggleDone(){
    isDone=!isDone;
  }
  // Convert Task to JSON
  //Jokhon jabe tokhon map akare jabe
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'listId': listId,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'isDone': isDone,
    };
  }

  // Create Task from JSON
  //jokhon ashbe tokhon Class er object akare ashbe
  factory Task.fromJson(Map<String, dynamic> json) {
    // Handle possible null or invalid time
    final timeString = json['time']?.toString() ?? '00:00';
    final timeParts = timeString.split(':');
    final hour = int.tryParse(timeParts.isNotEmpty ? timeParts[0] : '0') ?? 0;
    final minute = int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0;

    return Task(
      id: json['id'],
      name: json['name'],
      listId: json['listId'],
      description: json['description'],
      category: json['category'],
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      time: TimeOfDay(hour: hour, minute: minute),
      isDone: json['isDone'] == 1,
    );
  }


}
