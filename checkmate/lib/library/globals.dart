import 'package:flutter/material.dart';

const List<MaterialColor> primaries = <MaterialColor>[
  Colors.pink,
];

const late = 'late';
const today = 'today';
const tomorrow = 'tomorrow';
const thisWeek = 'thisWeek';
const nextWeek = 'nextWeek';
const thisMonth = 'thisMonth';
const later = 'later';
const Map<String, String> taskCategoryNames = {
  late: 'Late',
  today: 'Today',
  tomorrow: 'Tomorrow',
  thisWeek: 'This week',
  nextWeek: 'Next Week',
  thisMonth: 'This month',
  later: 'Later'
};

// Shared Preferences Keys
const todoTasksKey = "todotasks";
const doneTasksKey = "donetasks";
