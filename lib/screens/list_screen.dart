import 'package:flutter/material.dart';
import 'package:taskplanner_demos/model_classes/listmodel.dart';
import 'package:taskplanner_demos/screens/add_list.dart';
import 'package:taskplanner_demos/screens/demoscreening.dart';

import '../helper_funcs/list_helper.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Flutter SqLite"),
            IconButton(onPressed: () async {
              final refresh2=await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddList(

              )));
              if(refresh2){
                setState(() {

                });
              }
            }, icon: Icon(Icons.add))
          ],
        ),
      ),
      body: FutureBuilder<List<ListModel>>(
          future: DBhelper.readList(),
          builder: (BuildContext context,AsyncSnapshot<List<ListModel>> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20,),
                    Text("Loading..."),

                  ],
                ),
              );
            }

            return snapshot.data!.isEmpty?Center(
              child: Text("No Categories in List yet"),
            ): ListView(

              children:snapshot.data!.map((contacts){
                return  Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(contacts.colorValue),
                      child: Text(contacts.id.toString(),style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        color: Color(contacts.colorValue)

                      ),),
                    ),
                    title: Text(contacts.namedid),
                    subtitle: Text("${contacts.id}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async{
                            final refresh=await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AddList(

                              listes: ListModel(
                                id: contacts.id,
                                namedid: contacts.namedid,
                                color: Color(contacts.colorValue),
                              ),

                            )));
                            if(refresh){
                              setState(() {

                              });
                            }
                          },),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async{
                            await DBhelper.deleteList(contacts.id!);
                            setState(() {

                            });
                          },),
                      ],
                    ),
                    onTap: () async{
                      final refresh=await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Demoscreening(
                      )));
                      if(refresh){
                        setState(() {

                        });
                      }
                    },
                  ),
                );
              }).toList(),
            );
          }
      ),


    );
  }
}
