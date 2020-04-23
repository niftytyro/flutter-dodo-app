import 'package:flutter/material.dart';

class CheckBoxTodoItem extends StatefulWidget {
  final List item;
  final bool isFocused;
  final Function onChecked;
  final Function onRemove;
  TextEditingController _controller;

  CheckBoxTodoItem({
    @required this.item,
    @required this.onChecked,
    @required this.isFocused,
    @required this.onRemove,
  });

  @override
  _CheckBoxTodoItemState createState() => _CheckBoxTodoItemState();
}

class _CheckBoxTodoItemState extends State<CheckBoxTodoItem> {
  @override
  Widget build(BuildContext context) {
    widget._controller = TextEditingController(text: widget.item[0]);
    return SizedBox(
      width: double.infinity,
      height: 35.0,
      child: CheckboxListTile(
        activeColor: Colors.grey,
        checkColor: Colors.grey[900],
        value: widget.item[1],
        onChanged: widget.onChecked,
        title: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: widget._controller,
                autofocus: widget.isFocused,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (val) {
                  widget.item[0] = val;
                },
                style: TextStyle(
                  color: widget.item[1] ? Colors.grey : Colors.white,
                  decoration: widget.item[1]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontSize: 18.5,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onRemove,
              child: Container(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 2.0, 5.0),
                  child: Icon(Icons.clear)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}

class CheckBoxTileTodoItem extends StatefulWidget {
  final List item;
  final Function onChecked;

  CheckBoxTileTodoItem({
    @required this.item,
    @required this.onChecked,
  });

  @override
  _CheckBoxTileTodoItemState createState() => _CheckBoxTileTodoItemState();
}

class _CheckBoxTileTodoItemState extends State<CheckBoxTileTodoItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.item);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 2.0, 2.0, 2.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 0.0,
            height: 30.0,
            child: Checkbox(
              value: widget.item[1],
              onChanged: widget.onChecked,
              checkColor: Colors.grey[900],
              activeColor: Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                widget.item[0],
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  color: widget.item[1] ? Colors.grey : Colors.white,
                  decoration: widget.item[1]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontSize: 15.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
