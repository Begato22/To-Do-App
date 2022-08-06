import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/models/archive.dart';
import 'package:to_do/models/done.dart';
import 'package:to_do/models/tasks.dart';
import 'package:to_do/shared/bloc/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitiState());

  static AppCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 0;
  List screens = const [
    TaskScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List titleScreens = [
    "Your Tasks",
    "Done Tasks",
    "Archive Tasks",
  ];

  void changeNavBarItem(int index) {
    selectedIndex = index;
    emit(AppChangeNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  void createDatabase() {
    openDatabase("todo.db", version: 1,
        onCreate: (Database database, int version) async {
      // When creating the db, create the table
      database
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
          .then(
            (value) => print("table is created !"),
          )
          .catchError(
        (onError) {
          print("This err in Creating Table ${onError.toString()}");
        },
      );
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print("Database is opened !");
    }).then((value) {
      database = value;

      emit(AppCreateDatabaseState());
    });
  }

  insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) {
    database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")')
          .then(
        (value) {
          print("$value is inserted !");
          emit(AppInsertDatabaseState());

          getDataFromDatabase(database);
        },
      ).catchError(
        (onError) {
          print("err in insert operation ${onError.toString()}");
        },
      );
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    print("i use getDataFromDatabase() Now !!!!!!!");
    database
        .rawQuery('SELECT * FROM Tasks')
        .then((List<Map<String, dynamic>> value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      print("we get data after open db");
      emit(AppGetDatabaseState());
    });
  }

  void updateIntoDatabase(String status, int id) {
    database.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void deleteFromDatabase(int id) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
    });
  }

  bool isBottomSheetOpened = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet({
    required bool isShow,
    required IconData iconData,
  }) {
    isBottomSheetOpened = isShow;
    fabIcon = iconData;
    print("btCheack AppChangeBottomSheetState changed");
    emit(AppChangeBottomSheetState());
    print("btCheack AppChangeBottomSheetState changed after emit func");
  }
}
