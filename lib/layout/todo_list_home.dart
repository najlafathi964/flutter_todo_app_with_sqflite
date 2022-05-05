import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_sqflite/shared/cubit/cubit.dart';

import '../shared/cubit/bloc_states.dart';

class todo_list_home extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  TextEditingController titelController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child:
          BlocConsumer<TodoCubit, TodoStates>(listener: (context, TodoStates) {
        if (TodoStates is AppInsertToDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, TodoStates) {
        TodoCubit cubit = TodoCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Center(child: Text(cubit.title[cubit.currentIndex])),
          ),
          body: TodoStates is! AppGetDatabaseLoadingState
              ? cubit.screens[cubit.currentIndex]
              : Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isButtonSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(titelController.text,
                        timeController.text, dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: titelController,
                                        keyboardType: TextInputType.text,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return ' Titel must not be empty ';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelText: "Task Title",
                                            prefixIcon: Icon(Icons.title),
                                            border: OutlineInputBorder()),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: timeController,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return ' Time must not be empty ';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelText: "Task Time ",
                                            prefixIcon: Icon(
                                                Icons.watch_later_outlined),
                                            border: OutlineInputBorder()),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: dateController,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2022-05-15'))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return ' Date must not be empty ';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelText: "Task Date",
                                            prefixIcon: Icon(
                                                Icons.watch_later_outlined),
                                            border: OutlineInputBorder()),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fab_icon)),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changIndex(index);

            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: "Done"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: "Archived")
            ],
          ),
        );
      }),
    );
  }
}
