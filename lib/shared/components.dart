// import 'package:flutter/material.dart';
// Widget defualtTextFormFeild ({
//   required TextEditingController controller ,
//   required TextInputType type ,
//   Function? onSubmit ,
//   Function? onChange ,
//   Function? onTap ,
//   bool? isPassword ,
//   required Function validate ,
//   required String label ,
//   required IconData prefix ,
//   IconData? suffix ,
//   Function? suffixPressed ,
//   bool isClickable = true ,
// }){
//   return TextFormField(
//     controller: controller ,
//       keyboardType: type ,
//     obscureText: isPassword!,
//     enabled: isClickable,
//     onFieldSubmitted: onSubmit,
//     onChanged: onChange,
//     onTap: onTap,
//     validator: validate,
//     decoration: InputDecoration (
//       labelText: label ,
//       prefixIcon: Icon(prefix) ,
//       suffixIcon: suffix != null ? IconButton(onPressed: suffixPressed, icon: Icon ( suffix)) : null  ,
//       border: OutlineInputBorder()
//
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_sqflite/shared/cubit/cubit.dart';

import 'cubit/bloc_states.dart';

Widget buildTaskItem(Map model, BuildContext context) => Dismissible(
      key: Key(model["id"].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(model["time"]),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model["title"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(model["date"], style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updatData(status: "done", id: model['id']);
              },
              icon: Icon(Icons.check_box),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updatData(status: "archived", id: model['id']);
              },
              icon: Icon(Icons.archive),
              color: Colors.black45,
            )
          ],
        ),
      ),
      onDismissed: (direction) {
        TodoCubit.get(context).deleteData(id: model["id"]);
      },
    );
Widget tasksBuilder ( List<Map> tasksList){
  return BlocConsumer<TodoCubit , TodoStates >(
      listener: (context , TodoStates){},
      builder: (context , TodoStates) {
        return (tasksList.length > 0) ?
        ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasksList[index] , context),
          separatorBuilder: (context, index) =>
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
          itemCount: tasksList.length,
        )  : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu , size: 90,color: Colors.grey,) ,
              Text ("No Task Yey , Please Add Some Tasks" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold , color: Colors.grey),)
            ],
          ),
        ) ;
      }
  ) ;
}
