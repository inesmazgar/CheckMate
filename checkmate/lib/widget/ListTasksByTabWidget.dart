import 'package:checkmate/provider/TaskModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Task.dart';

class ListTasksByTabWidget extends StatelessWidget {
  final String tabKey;
  const ListTasksByTabWidget({Key? key, required this.tabKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: model.todoTasks[tabKey]?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFE2E2E2),
                    border: Border.all(
                      color: const Color(0xFFE2E2E2),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(model.todoTasks[tabKey]![index].title),
                  subtitle:
                      Text(model.todoTasks[tabKey]![index].deadline.toString()),
                  leading: Checkbox(
                    value: model.todoTasks[tabKey]![index].status,
                    onChanged: (bool? isChecked) {
                      if (isChecked!) {
                        Task task =
                            model.todoTasks[tabKey]![index]; // Corrected
                        model.markAsChecked(tabKey, index);
                        Future.delayed(const Duration(seconds: 1),
                            () => model.markAsDone(tabKey, task));
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
