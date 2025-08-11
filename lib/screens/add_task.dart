import 'package:flutter/material.dart';
import '../model_classes/taskmodel.dart';

class AddTask extends StatefulWidget {
  Task? task;
  int? catID;
  AddTask({super.key, this.task, this.catID});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCategory;
  final List<String> categories = ['Work', 'Personal', 'Study', 'Fun'];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    if (widget.task != null) {
      _nameController.text = widget.task?.name ?? '';
      _descController.text = widget.task?.description ?? '';
      _selectedDate = widget.task?.date;
      _selectedTime = widget.task?.time;
      _selectedCategory = widget.task?.category;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tasks'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildTextEdit(_nameController, "Enter Task Name"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildTextEdit(_descController, "Add a Description"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.99,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      hint: Text("Select a Category!!",
                        style: TextStyle(
                        fontSize: 15,
                      ),
                      ),
                      underline: SizedBox(),
                      elevation: 0,
                      menuWidth: MediaQuery.sizeOf(context).width * 0.7,
                      value: _selectedCategory,
                      icon: Icon(Icons.arrow_downward),
                      items: categories.map(buildMenuItem).toList(),
                      style: TextStyle(color: Colors.black,

                          fontWeight: FontWeight.bold,
                          fontSize: 20,

                      ),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.99,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? "Select a Date to track!"
                                : "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              _pickDate(context), // Pass context here
                          child: Text(
                            _selectedDate == null ? "Pick Date" : "Change Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.99,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedTime == null
                                ? "Select a Time for the task to be done!"
                                : _selectedTime!.format(context),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _pickTime(context),
                          child: Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : "Change Time",

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}

Widget _buildTextEdit(TextEditingController t, String s) {
  return TextField(
    controller: t,
    decoration: InputDecoration(
      hintText: s,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
