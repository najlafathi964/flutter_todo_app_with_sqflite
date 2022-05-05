import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components.dart';
import '../shared/cubit/bloc_states.dart';
import '../shared/cubit/cubit.dart';

class done extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _done() ;
  }

}
class _done extends State <done>{
  @override
  Widget build(BuildContext context) {
    var tasksList = TodoCubit.get(context).doneTasks ;

    return tasksBuilder(tasksList);

  }

}