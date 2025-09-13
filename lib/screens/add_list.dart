import 'package:flutter/material.dart';
import 'package:taskplanner_demos/model_classes/listmodel.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../helper_funcs/list_helper.dart';

class AddList extends StatefulWidget {
  ListModel? listes;
  AddList({super.key, this.listes});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final _nameIDcontroller = TextEditingController();
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  String? ColorPicked; // Nullable

  @override
  void initState() {
    if (widget.listes != null) {
      _nameIDcontroller.text = widget.listes?.namedid ?? '';
      currentColor = widget.listes!.color;
      pickerColor = widget.listes!.color;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameIDcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showColorPicker() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                setState(() => pickerColor = color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                setState(() {
                  currentColor = pickerColor;
                  ColorPicked =
                      "R:${pickerColor.red} G:${pickerColor.green} B:${pickerColor.blue}";
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                        MediaQuery.of(context).size.height * 0.09,
                      ),
                      bottomLeft: Radius.circular(
                        MediaQuery.of(context).size.height * 0.09,
                      ),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.orange, Colors.amber],
                    ),
                  ),

                  child: CustomPaint(
                    painter: CurvedHeaderPainter(),
                    child: Container(),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Add List',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.orangeAccent,
              expandedHeight: MediaQuery.of(context).size.height * 0.12,
              pinned: true,
              floating: true,
              snap: true,
            ),

            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTextField(
                        _nameIDcontroller,
                        "Enter your Task name",
                      ),
                    ),
                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        style: ButtonStyle(),
                        onPressed: showColorPicker,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ColorPicked ?? "No color picked",
                              style: TextStyle(
                                color: Color.fromRGBO(
                                  currentColor.red,
                                  currentColor.green,
                                  currentColor.blue,
                                  1,
                                ),
                              ),
                            ),

                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.2,
                              height: MediaQuery.sizeOf(context).height * 0.03,
                              decoration: BoxDecoration(
                                color: currentColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey),
                      ),
                      child: Text("Add category",style: TextStyle(
                        color: Colors.white
                      ),),
                      onPressed: () async {
                        if (widget.listes != null) {
                          await DBhelper.updateList(
                            ListModel(
                              id: widget.listes!.id,
                              namedid: _nameIDcontroller.text,
                              color: currentColor,
                            ),
                          );
                          setState(() {});
                          Navigator.of(context).pop(true);
                        } else {
                          await DBhelper.createLists(
                            ListModel(
                              namedid: _nameIDcontroller.text,
                              color: currentColor,
                            ),
                          );
                          setState(() {});
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextField _buildTextField(TextEditingController s, String hint) {
  return TextField(
    controller: s,
    maxLength: 30,
    decoration: InputDecoration(

      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

class CurvedHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke;

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
