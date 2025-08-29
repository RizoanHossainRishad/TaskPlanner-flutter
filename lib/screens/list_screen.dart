import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:taskplanner_demos/model_classes/listmodel.dart';
import 'package:taskplanner_demos/screens/add_list.dart';
import 'package:taskplanner_demos/screens/task_screen.dart';

import '../helper_funcs/list_helper.dart';
import '../helper_funcs/task_helper.dart';
import 'addnew_list.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    Color? color;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<List<ListModel>>(
        future: DBhelper.readList(),
        builder: (BuildContext context, AsyncSnapshot<List<ListModel>> snapshot) {
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
                    SliverToBoxAdapter(
                      child: Container(
                        height: screenHeight * 0.08,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.01,
                          ),
                          border: BoxBorder.all(
                            color: Colors.green,
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
                              "No List is created yet!!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    addNewList(),
                  ],
                )
              : CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(screenWidth),

                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final contacts = snapshot.data![index];
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
                                color: /*Color(
                                  contacts.colorValue,
                                ).withOpacity(0.5)*/Colors.blueGrey.withOpacity(0.5),
                              ),
                              // Optional: Add subtle shadow
                              boxShadow: [
                                BoxShadow(
                                  color:/* Color(
                                    contacts.colorValue,
                                  ).withOpacity(0.2),*/Colors.grey.withOpacity(0.7),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: ListTile(
                              leading: Container(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.1,
                                decoration: BoxDecoration(
                                  border: BoxBorder.all(
                                    color: Colors.blueGrey.withOpacity(0.5)
                                  ),
                                  color: Color(contacts.colorValue),
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.03,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    contacts.id.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // ✅ IMPROVED: Better contrast
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                  ),
                                ),
                              ),

                              title: Text(
                                contacts.namedid,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                              subtitle: FutureBuilder<int>(
                                future: DBTaskHelper.countTask(contacts.id!),
                                builder: (context, snapshots) {
                                  if (!snapshots.hasData) {
                                    return Row(
                                      children: [
                                        Text(
                                          "Loading..",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        CircularProgressIndicator(),
                                      ],
                                    );
                                  }
                                  return snapshots.data! == 0
                                      ? Text("No Tasks")
                                      : Text(
                                          "${snapshots.data} Tasks",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.grey.shade600,
                                          ),
                                        );
                                },
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: screenWidth * 0.06,
                                    ),
                                    onPressed: () async {
                                      final refresh =
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => AddList(
                                                listes: ListModel(
                                                  id: contacts.id,
                                                  namedid: contacts.namedid,
                                                  color: Color(
                                                    contacts.colorValue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                      if (refresh) {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: screenWidth * 0.06,
                                    ),
                                    onPressed: () async {
                                      // ✅ IMPROVED: Add confirmation dialog
                                      bool? confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Delete List"),
                                          content: Text(
                                            "Are you sure you want to delete '${contacts.namedid}'?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                context,
                                                false,
                                              ),
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                context,
                                                true,
                                              ),
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await DBhelper.deleteList(
                                          contacts.id!,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final refresh = await Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            task_screen(catID: contacts.id!,color: contacts.colorValue,catName:contacts.namedid),
                                      ),
                                    );
                                if (refresh == true) {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        );
                      }, childCount: snapshot.data!.length),
                    ),

                    addNewList(),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(double screenHeight) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(

            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green, // Deep blue
                Colors.lightGreen, // Lighter blue
              ],
            ),
          ),
          child: CustomPaint(
            painter: CurvedHeaderPainter(),
            child: Container(),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hamburger menu icon
            Text(
              "All Lists",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
            // Add button
            Container(
              padding: EdgeInsets.all(8),
              child: IconButton(
                onPressed: () async {
                  final refresh2 = await Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => AddList()));
                  if (refresh2) {
                    setState(() {});
                  }
                },
                icon: Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.purple, // Deep blue
      expandedHeight: screenHeight * 0.35,
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
    );
  }

  // Custom painter for the curved bottom
}

class CurvedHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
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
