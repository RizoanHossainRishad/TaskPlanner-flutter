import 'package:flutter/material.dart';
import 'package:taskplanner_demos/helper_funcs/task_helper.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Add Tasks on Category ${widget.catID}'),
            if (widget.task != null && widget.task!.name.isNotEmpty)
              IconButton(
                onPressed: () async {
                  await DBTaskHelper.deleteTask(widget.task!.id);
                  setState(() {});
                  Navigator.of(context).pop(true);
                },
                icon: Icon(Icons.delete),
              )
            else
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Task is yet to be added!!"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.info_outline),
              ),
          ],
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
                          color: Colors.grey
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
                            style: _selectedDate == null
                                ? TextStyle(
                              fontSize: 15,
                              color: Colors.grey // style for null date
                            )
                                : TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black, // style for selected date
                            ),
                          )
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
                                ? "Set Completion time"
                                : _selectedTime!.format(context),
                            style:_selectedTime!=null?
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ):TextStyle(
                              fontSize: 15,
                              color: Colors.grey
                            )
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
              SizedBox(
                height: 30,
              ),
                ElevatedButton(
                    onPressed: ()async{
                      if(widget.task!=null){
                        await DBTaskHelper.updateTask(Task(
                          id: widget.task!.id,
                          listId: widget.catID!,
                          description:_descController.text,
                          name: widget.task!.name,
                          category: _selectedCategory!,
                          date: _selectedDate!,
                          time: _selectedTime!,
                          isDone: widget.task!.isDone,
                        ));
                        setState(() {

                        });
                        Navigator.of(context).pop(true);
                      }else{
                        await DBTaskHelper.createTasks(Task(
                          listId: widget.catID!,
                          description:_descController.text,
                          name: _nameController.text,
                          category: _selectedCategory!,
                          date: _selectedDate!,
                          time: _selectedTime!,
                        ));
                        setState(() {

                        });
                        Navigator.of(context).pop(true);
                      }

                    },
                    child: Text("Add Task")
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
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    decoration: InputDecoration(
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),
      hintText: s,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
