import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:taskplanner_demos/screens/add_list.dart';

class addNewList extends StatelessWidget {
  const addNewList({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SliverToBoxAdapter(
        child: Center(
          child: InkWell(
            onTap: () async{
              final refresh2 = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddList(),
                ),
              );

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
                  color: Colors.white60,
                ),
                // Optional: Add subtle shadow
                color: Colors.transparent,
              ),

              child: DottedBorder(
                options: RectDottedBorderOptions(
                  color: Colors.blueGrey,
                  dashPattern: [20, 8],
                  strokeWidth: 2,
                  padding: EdgeInsets.all(16),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("Add a new list....",
                              style: TextStyle(
                                fontSize: screenHeight*0.025,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth*0.02,
                          ),
                        ],
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
        ),
        );
  }
}
