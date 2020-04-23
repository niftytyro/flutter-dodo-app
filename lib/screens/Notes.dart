import 'package:dodo_todo/classes/commons.dart';
import 'package:flutter/material.dart';
import 'package:dodo_todo/constants.dart';

class NotesView extends StatefulWidget {
  Commons content;

  NotesView({@required this.content});

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        controller: TextEditingController()..text = widget.content.data,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (val) {
          widget.content.data = val;
        },
        style: kNotesContentStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
