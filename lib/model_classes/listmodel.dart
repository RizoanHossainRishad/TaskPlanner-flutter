import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:taskplanner_demos/model_classes/taskmodel.dart';

class ListModel {
  int? id;
  String namedid;
  int colorValue; // store as int instead of Color for DB compatibility

  ListModel({
    this.id,
    required this.namedid,
    required Color color,
  }) : colorValue = color.value ;

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namedid': namedid,
      'colorValue': colorValue,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      
      id: map['id'],
      namedid: map['namedid'],
      color: Color(map['colorValue']),
    );
  }
}
