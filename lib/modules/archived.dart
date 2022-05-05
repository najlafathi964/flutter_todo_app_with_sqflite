import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components.dart';
import '../shared/cubit/bloc_states.dart';
import '../shared/cubit/cubit.dart';

class archived extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _archived() ;
  }

}
class _archived extends State <archived>{
  @override
  Widget build(BuildContext context) {
    var tasksList = TodoCubit.get(context).archivedTasks ;

    return tasksBuilder(tasksList);
  }

}