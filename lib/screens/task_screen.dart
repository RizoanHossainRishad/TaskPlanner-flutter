import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskplanner_demos/model_classes/taskmodel.dart';
import 'package:taskplanner_demos/screens/add_new_task_templateButton.dart';

import '../helper_funcs/task_helper.dart';
import 'add_task.dart';

class task_screen extends StatefulWidget {
  int catID;
  int? color;
  task_screen({super.key, required this.catID, required this.color});
  @override
  State<task_screen> createState() => _task_screenState();
}

class _task_screenState extends State<task_screen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<List<Task>>(
        future: DBTaskHelper.readTask(widget.catID),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (!snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(screenWidth),
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text("Loading..."),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return snapshot.data!.isEmpty
              ? CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(screenWidth),
                    AddNewTaskButton(catID: widget.catID),
                    SliverToBoxAdapter(
                      child: Container(
                        height: screenHeight * 0.09,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.02,
                          ),
                          border: BoxBorder.all(
                            color: Colors.green.withOpacity(0.6),
                            width: screenWidth * 0.005,
                          ),
                        ),
                        margin: EdgeInsets.only(
                          top: screenHeight * 0.01,
                          left: screenWidth * 0.03,
                          right: screenWidth * 0.03,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.01),
                            Icon(Icons.hourglass_empty),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              "No Task is assigned to this List yet!!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(screenHeight),
                    AddNewTaskButton(catID: widget.catID),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final task = snapshot.data?[index];
                        return Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.009,
                              horizontal: screenWidth * 0.02,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.02,
                              ),
                              // ✅ FIXED: Correct border syntax
                              border: Border.all(
                                width: screenWidth * 0.006,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              // Optional: Add subtle shadow
                              color: Colors.white,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    task!.id.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(task.name),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "${task.time.format(context)}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          DateFormat(
                                            'dd/MM/yy',
                                          ).format(task.date),
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: [Text(task.category)]),
                                ],
                              ),
                              trailing: Checkbox(
                                value: task.isDone,
                                onChanged: (value) {
                                  DBTaskHelper.toggleTask(task).then((_) {
                                    setState(() {});
                                  });
                                },
                              ),
                              onTap: () async {
                                final refresh = await Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (_) => AddTask(
                                          task: Task(
                                            id: task.id,
                                            name: task.name,
                                            listId: task.listId,
                                            description: task.description,
                                            category: task.category,
                                            date: task.date,
                                            time: task.time,
                                          ),
                                          catID: task.id,
                                        ),
                                      ),
                                    );
                                if (refresh) {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        );
                      }, childCount: snapshot.data!.length),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(double screenHeight) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: Colors.blueGrey
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(
                MediaQuery.of(context).size.height * 0.2,
              ),
              bottomLeft: Radius.circular(
                MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(widget.color!), // Deep blue
                Color(widget.color!), // Lighter blue
              ],
            ),
          ),
          child:  Padding(
            padding: EdgeInsets.all( MediaQuery.of(context).size.width*0.1 ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  child: IconButton(
                    style: ButtonStyle(
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      setState(() {});
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28,
                      shadows: [
                        Shadow(
                          // bottomLeft
                          offset: Offset(-1.5, -1.5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Shadow(
                          // bottomRight
                          offset: Offset(1.5, -1.5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Shadow(
                          // topRight
                          offset: Offset(1.5, 1.5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Shadow(
                          // topLeft
                          offset: Offset(-1.5, 1.5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],

                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Tasks",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      shadows: shadowStyleBold(),
                    ),
                  ),
                ),
                // Add button
                Container(
                  decoration: BoxDecoration(

                  ),
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () async {
                      final refresh = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddTask(catID: widget.catID),
                        ),
                      );
                      if (refresh == true) {
                        setState(() {});
                      }
                    },
                    icon: Icon(Icons.add, color: Colors.white, size: 28,shadows: [
                      Shadow(
                        // bottomLeft
                        offset: Offset(-1.5, -1.5),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Shadow(
                        // bottomRight
                        offset: Offset(1.5, -1.5),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Shadow(
                        // topRight
                        offset: Offset(1.5, 1.5),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Shadow(
                        // topLeft
                        offset: Offset(-1.5, 1.5),
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
      backgroundColor: /*Color(widget.color!), // Deep blue*/ Colors.transparent,
      expandedHeight: MediaQuery.of(context).size.height * 0.15,
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(screenHeight * 0.05),
        ),
      ),
    );
  }

  // Custom painter for the curved bottom
}

class CurvedHeaderPainter extends CustomPainter {
  int? color;

  CurvedHeaderPainter(int i) {
    this.color = i;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(color!)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

List<Shadow> shadowStyleBold() {
  return [
    Shadow(
      // bottomLeft
      offset: Offset(-1.5, -1.5),
      color: Colors.black.withOpacity(0.5),
    ),
    Shadow(
      // bottomRight
      offset: Offset(1.5, -1.5),
      color: Colors.black.withOpacity(0.5),
    ),
    Shadow(
      // topRight
      offset: Offset(1.5, 1.5),
      color: Colors.black.withOpacity(0.5),
    ),
    Shadow(
      // topLeft
      offset: Offset(-1.5, 1.5),
      color: Colors.black.withOpacity(0.5),
    ),
  ];
}