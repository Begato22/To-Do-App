import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/bloc/bloc.dart';
import 'package:to_do/shared/bloc/states.dart';

Widget defultTextField({
  required String label,
  required IconData prefixIcon,
  required TextEditingController controller,
  required Function(String value) validator,
  TextInputType keyboardType = TextInputType.text,
  required Function onTap,
}) =>
    SizedBox(
      height: 80,
      child: TextFormField(
        validator: (value) => validator(value!),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          label: Text(label),
          prefixIcon: Icon(prefixIcon),
        ),
        onTap: () => onTap(),
      ),
    );
Widget buildTaskItem(Map model, context) => BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) => Dismissible(
        key: Key("$model['id']"),
        onDismissed: (DismissDirection dir) {
          AppCubit.get(context).deleteFromDatabase(model['id']);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            children: const [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text("Task was Deleted !"),
            ],
          )));
        },
        direction: DismissDirection.startToEnd,
        background: Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 8),
                Text("Delete", style: TextStyle(color: Colors.white))
              ],
            ),
          ),
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15),
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 40, child: Text(model['time'])),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model['title'].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(model['date'],
                            style: const TextStyle(color: Colors.grey))
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        AppCubit.get(context)
                            .updateIntoDatabase("done", model['id']);
                        var snackBar = SnackBar(
                          content: Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Task was Done.'),
                            ],
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: const Icon(Icons.check_box),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () {
                        AppCubit.get(context)
                            .updateIntoDatabase("archive", model['id']);
                        var snackBar = SnackBar(
                          content: Row(
                            children: const [
                              Icon(Icons.archive, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Task was Archived.'),
                            ],
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: const Icon(Icons.archive),
                      color: Colors.grey,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
