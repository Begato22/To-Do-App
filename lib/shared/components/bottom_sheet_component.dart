// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'components.dart';
import 'package:intl/intl.dart';

class BottomSheetComponent extends StatelessWidget {
  BottomSheetComponent({Key? key, required this.formKey}) : super(key: key);

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
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
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 10),
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
                          context: context, initialTime: TimeOfDay.now())
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
    );
  }
}
