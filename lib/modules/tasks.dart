import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_sqflite/shared/consitants.dart';
import 'package:todo_list_sqflite/shared/cubit/bloc_states.dart';
import 'package:todo_list_sqflite/shared/cubit/cubit.dart';

import '../shared/components.dart';

class tasks extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _tasks() ;
  }

}
class _tasks extends State <tasks>{

  @override
  Widget build(BuildContext context) {
    var tasksList = TodoCubit.get(context).newTasks ;

    return tasksBuilder(tasksList) ;
  }

}