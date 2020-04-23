import 'package:dodo_todo/constants.dart';
import 'package:flutter/material.dart';
import 'package:dodo_todo/components/TodoListItem.dart';
import 'package:dodo_todo/classes/commons.dart';

class TodoList extends StatefulWidget {
  Commons content;
  int _focusedIndex = -1;

  TodoList({@required this.content});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Widget ListItem(BuildContext context, int index) {
    return CheckBoxTodoItem(
      item: widget.content.data[index],
      isFocused: index == widget._focusedIndex,
      onChecked: (val) {
        setState(() {
          widget.content.data[index][1] = !widget.content.data[index][1];
        });
      },
      onRemove: () {
        setState(() {
          print("Deleting" + index.toString());
          print(widget.content.data[index]);
          print(widget.content);
          widget.content.data.removeAt(index);
          print(widget.content);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('inside listView:');
    print(widget.content.data);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: widget.content.data.length,
            itemBuilder: ListItem,
          ),
          Positioned(
            right: 40.0,
            bottom: 40.0,
            child: FloatingActionButton(
              backgroundColor: kAccentColor,
              child: Icon(
                Icons.add,
                color: kAccentForegroundColor,
                size: 35.0,
              ),
              onPressed: () {
                FocusScopeNode node = FocusScope.of(context);
                node.requestFocus();
                if (node.hasFocus) {
                  node.unfocus();
                }
                setState(() {
                  widget._focusedIndex = widget.content.data.length;
                  widget.content.data.add(['', false]);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
