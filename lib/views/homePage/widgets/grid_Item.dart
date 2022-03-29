import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_note_app/views/homePage/model.dart';
import 'package:sql_note_app/views/states.dart';

import '../controller.dart';

class GridItem extends StatelessWidget {
  final Note? note;
 final  onTap;

  const GridItem({Key? key, required this.note, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onLongPress:  onTap,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.green),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Container(child: Center(child: Text(note!.title!)),color: Colors.pink,width: double.infinity,),
              Text(note!.content!),
            ],
          )
          ),
    );
  }
}
