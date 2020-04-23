import 'package:flutter/material.dart';
import 'package:dodo_todo/screens/home.dart';
import 'package:dodo_todo/classes/list_storage.dart';
import 'package:dodo_todo/constants.dart';

void main() {
  runApp(DodoApp(
    storage: ListStorage(),
  ));
}

class DodoApp extends StatelessWidget {
  final ListStorage storage;

  DodoApp({@required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(file: storage),
      title: 'DoDo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kPrimaryColor,
      ),
    );
  }
}
