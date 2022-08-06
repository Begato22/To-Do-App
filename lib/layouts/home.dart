// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do/shared/bloc/bloc.dart';
import 'package:to_do/shared/bloc/states.dart';

import '../shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  bool isBottomSheetOpened = false;
  IconData fabIcon = Icons.edit;

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(cubit.titleScreens[cubit.selectedIndex]),
        ),
        body: cubit.newTasks.isNotEmpty && cubit.selectedIndex == 0 || cubit.doneTasks.isNotEmpty && cubit.selectedIndex == 1 || cubit.archiveTasks.isNotEmpty && cubit.selectedIndex == 2
            ? cubit.screens[cubit.selectedIndex]
            : const Center(child: Text("No Tasks yet.")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isBottomSheetOpened) {
              if (formKey.currentState!.validate()) {
                print("btCheack hello from formKey.currentState!.validate ");
                cubit.insertIntoDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text);
                // cubit.changeBottomSheet(isShow: false, iconData: Icons.edit);
                Navigator.of(context).pop();
                setState(() {
                  isBottomSheetOpened = false;
                  fabIcon = Icons.edit;
                });
                titleController.text =
                    timeController.text = dateController.text = "";
              }
            } else {
              print("btCheack i will opem bottom sheet");
              scaffoldKey.currentState!
                  .showBottomSheet((context) => Form(
                        key: formKey,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 50, bottom: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defultTextField(
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Your Title must not be embty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {},
                                    controller: titleController,
                                    label: 'Task Title',
                                    prefixIcon: Icons.text_fields,
                                  ),
                                  const SizedBox(height: 10),
                                  defultTextField(
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Your Time must not be embty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: timeController,
                                    label: 'Task Time',
                                    prefixIcon: Icons.watch_later_outlined,
                                    keyboardType: TextInputType.datetime,
                                    onTap: () => showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) => timeController.text =
                                            value!.format(context).toString()),
                                  ),
                                  const SizedBox(height: 10),
                                  defultTextField(
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Your Date must not be embty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: dateController,
                                    label: 'Task Date',
                                    prefixIcon: Icons.calendar_month_rounded,
                                    keyboardType: TextInputType.datetime,
                                    onTap: () => showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2023))
                                        .then(
                                      (value) => dateController.text =
                                          DateFormat.yMMMMd().format(value!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .closed
                  .then((value) {
                setState(() {
                  isBottomSheetOpened = false;
                  fabIcon = Icons.edit;
                });
                print(
                    "btCheack AppChangeBottomSheetState will change the state with isShow Value:${cubit.isBottomSheetOpened}");
              });
              print("btCheack AppChangeBottomSheetState will change the state");
              setState(() {
                isBottomSheetOpened = true;
                fabIcon = Icons.add;
              });
              print(
                  "btCheack AppChangeBottomSheetState will change the state with isShow Value:${cubit.isBottomSheetOpened}");
            }
          },
          child: Icon(fabIcon),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => cubit.changeNavBarItem(value),
          currentIndex: cubit.selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: "Tasks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined),
              label: "Done",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: "Archives",
            ),
          ],
        ),
      ),
    );
  }
}
