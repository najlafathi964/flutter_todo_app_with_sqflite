import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:todo_list_sqflite/layout/todo_list_home.dart';
import 'package:todo_list_sqflite/shared/cubit/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(() {
  }, blocObserver: SimpleBlocObserver());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: todo_list_home(),
  ));
}
