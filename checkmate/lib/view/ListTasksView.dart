import 'package:checkmate/library/globals.dart' as globals;
import 'package:checkmate/widget/ListTasksByTabWidget.dart';
import 'package:flutter/material.dart';

import '../widget/ListAllTasksWidget.dart';

class ListTasksView extends StatefulWidget {
  const ListTasksView({Key? key}) : super(key: key);

  @override
  ListTasksViewState createState() => ListTasksViewState();
}

class ListTasksViewState extends State<ListTasksView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text("La liste des tâches"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Toutes les tâches"),
              Tab(text: "Aujourd'hui"),
              Tab(text: "Demain"),
              Tab(text: "Cette semaine"),
              Tab(text: "La semaine prochaine"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListAllTasksWidget(),
            ListTasksByTabWidget(tabKey: globals.today),
            ListTasksByTabWidget(tabKey: globals.tomorrow),
            ListTasksByTabWidget(tabKey: globals.thisWeek),
            ListTasksByTabWidget(tabKey: globals.nextWeek),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'addTask');
          },
        ),
      ),
    );
  }
}
