import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:task_planner_demo/model_classes/taskmodel.dart';

class ListModel {
  int? id;
  String namedid;
  int colorValue; // store as int instead of Color for DB compatibility
  List<Task>? tasks;

  ListModel({
    this.id,
    required this.namedid,
    required Color color,
    this.tasks,
  }) : colorValue = color.value ;

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namedid': namedid,
      'colorValue': colorValue,
      'tasks':tasks,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'],
      namedid: map['namedid'],
      color: Color(map['colorValue']),
      tasks: [], // will load separately from tasks table
    );
  }
}
