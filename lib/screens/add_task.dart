import 'package:flutter/material.dart';
import '../model_classes/taskmodel.dart';

class AddTask extends StatefulWidget {
  Task? task;
  int? catID;
  AddTask({super.key,this.task,this.catID});


  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _nameController=TextEditingController();
  final _descController=TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCategory;
  final List<String> categories=[
    'Work',
    'Personal',
    'Study',
    'Fun'
  ];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
@override
  void initState() {
    if(widget.task!=null){
      _nameController.text=widget.task?.name??'';
      _descController.text=widget.task?.description??'';
      _selectedDate = widget.task?.date;
      _selectedTime = widget.task?.time;
      _selectedCategory = widget.task?.category;
    }
    super.initState();
  }
  @override
  void dispose(){
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
