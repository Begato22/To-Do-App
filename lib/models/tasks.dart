import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/bloc/bloc.dart';
import 'package:to_do/shared/bloc/states.dart';
import 'package:to_do/shared/components/components.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var tasks = AppCubit.get(context).tasks;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => ListView.separated(
          itemBuilder: (context, index) =>
              buildTaskItem(AppCubit.get(context).newTasks[index], context),
          separatorBuilder: (context, index) => const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
          itemCount: AppCubit.get(context).newTasks.length),
    );
  }
}
