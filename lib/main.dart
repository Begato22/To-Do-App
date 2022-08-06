import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/layouts/home.dart';
import 'package:to_do/shared/bloc/bloc.dart';
import 'package:to_do/shared/bloc/bloc_observer.dart';

import 'shared/bloc/states.dart';

void main() {
  MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeLayout(),
        // home: BlocProvider(
        //   create: (BuildContext context) => AppCubit()..createDatabase(),
        //   child: BlocConsumer<AppCubit, AppStates>(
        //     builder: (context, state) {
        //       return HomeLayout();
        //     },
        //     listener: (context, state) {},
        //   ),
        // ),
      ),
    );
  }
}
