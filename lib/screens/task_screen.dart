import 'package:flutter/material.dart';
import 'package:taskplanner_demos/model_classes/taskmodel.dart';

import '../helper_funcs/task_helper.dart';
import 'add_task.dart';

class task_screen extends StatefulWidget {
  int catID;
  task_screen({super.key, required this.catID});

  @override
  State<task_screen> createState() => _task_screenState();
}

class _task_screenState extends State<task_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tasks"),
            IconButton(
              onPressed: () async {
                final refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTask(catID: widget.catID),
                  ),
                );
                if (refresh) {
                  setState(() {});
                }
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Task>>(
        future: DBTaskHelper.readTask(widget.catID),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Loading..."),
                ],
              ),
            );
          }

          return snapshot.data!.isEmpty
              ? Center(child: Text("No Tasks is added yet"))
              : ListView(
                  children: snapshot.data!.map((tasks) {
                    return Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            tasks.id.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(tasks.name),
                        subtitle: Text("${tasks.id}"),
                        trailing: Checkbox(
                          value: tasks.isDone,
                            onChanged: (value) {
                              DBTaskHelper.toggleTask(tasks).then((_) {
                                setState(() {});
                              });
                            }


                        ),
                        onTap: () async {
                          final refresh = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddTask(
                                task: Task(
                                  id: tasks.id,
                                  name: tasks.name,
                                  listId: tasks.listId,
                                  description: tasks.description,
                                  category: tasks.category,
                                  date: tasks.date,
                                  time: tasks.time,
                                ),
                                catID: tasks.id,
                              ),
                            ),
                          );
                          if (refresh) {
                            setState(() {});
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
        },
      ),
    );
  }
}
