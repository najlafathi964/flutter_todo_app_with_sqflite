import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_sqflite/modules/archived.dart';
import 'package:todo_list_sqflite/modules/done.dart';
import 'package:todo_list_sqflite/modules/tasks.dart';
import 'package:todo_list_sqflite/shared/cubit/bloc_states.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(AppInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> screens = [tasks(), done(), archived()];
  List<String> title = ["Tasks Screen", "Done Screen", "Archived Screen"];
  Database? database;
  List<Map> newTasks = [] ;
  List<Map> doneTasks = [] ;
  List<Map> archivedTasks = [] ;

  bool isButtonSheetShown = false;

  IconData fab_icon = Icons.edit;




  void changIndex (int index){
    currentIndex = index ;
    emit(AppChangeButtomNavBarState());
  }


  void createDatabase() {
    openDatabase("todo.db", version: 1,
        onCreate: (Database database, int version) {
          print("database created");

          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
              .then((value) {
            print("table created");
          }).catchError((error) {
            print("database created error ${error.toString()}");
          });
        }, onOpen: (database) {
          getDataFromDatabase(database);
        }).then((value) {
            database = value;
            emit(AppCreateDatabaseState()) ;

          });

  }

   insertToDatabase(
       String? title,
         String? time,
         String? date) async {
    print (database);
     await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT  INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database!);
      }).catchError((error) {
        print('${error.toString()} error in insert ');
      });
    });

  }


  void getDataFromDatabase(Database? database)  {
    newTasks = [] ;
    doneTasks = [] ;
    archivedTasks = [] ;
    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element) {
        if(element['status'] == 'new') {
          newTasks.add(element);
        } else if(element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }

      });
      emit(AppGetFromDatabaseState());
    });

  }

  void updatData ({required String status , required int id }) async {
     database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?' , ['$status',id]).then((value){
       getDataFromDatabase(database);
       emit(AppUpdateDataBaseState()) ;
     });
  }

  void deleteData ({ required int id }) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?' , [id]).then((value){
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState()) ;
    });
  }

  void changeBottomSheetState ({ required bool isShow , required IconData icon}){
    isButtonSheetShown = isShow;
    fab_icon = icon;
    emit(AppChangeBottomSheetState());
  }
}
