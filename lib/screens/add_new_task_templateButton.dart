import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskplanner_demos/screens/task_screen.dart';

import 'add_task.dart';

/*class AddNewTaskButton extends StatelessWidget {
  int? catID;
  String? catName;
  AddNewTaskButton({super.key,required this.catID,required this.catName});

  @override

}*/

class AddNewTaskButton extends StatefulWidget {
  int? catID;
  String? catName;
  int? color;
  AddNewTaskButton({super.key,required this.catID,required this.catName,required this.color});

  @override
  State<AddNewTaskButton> createState() => _AddNewTaskButtonState();
}

class _AddNewTaskButtonState extends State<AddNewTaskButton> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SliverToBoxAdapter(
      child: Center(
        child: InkWell(
          onTap: () async{

            final refresh = await Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => AddTask(catName: widget.catName,catID: widget.catID,),
              ),
            );
            if (refresh == true) {
              setState(() {
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context)=>task_screen(catID: widget.catID!, color: widget.color, catName: widget.catName)));
              });
            }
          },
          child: Container(
            height: screenHeight * 0.09,
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.0097,
              horizontal: screenWidth * 0.025,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                screenWidth * 0.02,
              ),
              border: Border.all(
                width: screenWidth * 0.006,
                color: Colors.blueGrey.withOpacity(0.4),
              ),
              // Optional: Add subtle shadow
              color: Colors.transparent,
            ),

            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: screenHeight * 0.0097,
                horizontal: screenWidth * 0.025,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [

                        CircleAvatar(
                          backgroundColor: Colors.grey,

                        ),
                        SizedBox(
                          width: screenWidth*0.02,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("Add a new Task....",
                                style: TextStyle(
                                  fontSize: screenHeight*0.02,
                                  color: Colors.blueGrey.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Time",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(children: [Text("Task category"
                              ,style: TextStyle(
                                color: Colors.grey,
                              ),),
                            ]),
                          ],
                        ),
                        SizedBox(
                          width: screenWidth*0.02,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Icon(Icons.add_box_outlined,color: Colors.grey,))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
