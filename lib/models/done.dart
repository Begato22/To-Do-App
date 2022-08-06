import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/bloc/bloc.dart';
import 'package:to_do/shared/bloc/states.dart';
import 'package:to_do/shared/components/components.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => ListView.separated(
          itemBuilder: (context, index) =>
              buildTaskItem(AppCubit.get(context).doneTasks[index], context),
          separatorBuilder: (context, index) => const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
          itemCount: AppCubit.get(context).doneTasks.length),
    );
  }
}
