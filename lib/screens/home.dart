import 'dart:async';

import 'package:dodo_todo/screens/Notes.dart';
import 'package:dodo_todo/screens/TodoList.dart';
import 'package:flutter/material.dart';
import 'package:dodo_todo/constants.dart';
import 'package:dodo_todo/components/TodoListItem.dart';
import 'package:dodo_todo/classes/list_storage.dart';
import 'package:dodo_todo/classes/commons.dart';

class HomeView extends StatefulWidget {
  final ListStorage file;
  Map<String, dynamic> items = {};

  HomeView({@required this.file});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  _rearrangeItems() {
    Map<String, dynamic> temp = Map<String, dynamic>.from(widget.items);
    widget.items.clear();
    int i = 0;
    temp.forEach((k, v) {
      widget.items[i.toString()] = v;
      i++;
    });
  }

  Widget buildTile(BuildContext context, int index) {
    print(widget.items[index.toString()]);
    if (widget.items[index.toString()]['type'] == notes) {
      return GridTile(
        title: widget.items[index.toString()]['title'],
        content: widget.items[index.toString()]['content'],
        type: widget.items[index.toString()]['type'],
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailView(
                listTitle: widget.items[index.toString()]['title'],
                contentRaw: widget.items[index.toString()]['content'],
                type: widget.items[index.toString()]['type']);
          })).then((temp) {
            if ((temp['title'].trim().length == 0 || temp['title'] == null) &&
                (temp['content'].trim().length == 0 ||
                    temp['content'] == null)) {
              setState(() {
                widget.items.remove(index.toString());
                _rearrangeItems();
              });
            } else {
              widget.items[index.toString()] = temp;
              widget.file.writeItems(widget.items);
            }
          });
        },
        onDelete: () {
          setState(() {
            widget.items.remove(index.toString());
            _rearrangeItems();
            print('writing:');
            print(widget.items);
            widget.file.writeItems(widget.items);
          });
        },
      );
    } else if (widget.items[index.toString()]['type'] == todos) {
      return GridTile(
        title: widget.items[index.toString()]['title'],
        content: widget.items[index.toString()]['content'],
        type: widget.items[index.toString()]['type'],
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailView(
                listTitle: widget.items[index.toString()]['title'],
                contentRaw: widget.items[index.toString()]['content'],
                type: widget.items[index.toString()]['type']);
          })).then((temp) {
            if (temp == false) {
            } else {
              if ((temp['title'].trim().length == 0 || temp['title'] == null) &&
                  (temp['content'].length == 0 || temp['content'] == null)) {
                setState(() {
                  widget.items.remove(index.toString());
                  _rearrangeItems();
                });
              } else {
                print('writing:');
                print(widget.items);
                widget.items[index.toString()] = temp;
                widget.file.writeItems(widget.items);
              }
            }
          });
        },
        onDelete: () {
          setState(() {
            print('deleting $index');
            print('items: ');
            print(widget.items);
            print(widget.items[index.toString()]);
            print(widget.items[index]);
            widget.items.remove(index.toString());
            _rearrangeItems();
            print(widget.items);
            widget.file.writeItems(widget.items);
          });
        },
      );
    }
  }

  Widget buildBody() {
    if (widget.items.length > 0) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1,
        ),
        padding: EdgeInsets.all(15.0),
        itemBuilder: buildTile,
        itemCount: widget.items.length,
      );
    } else {
      return Center(
        child: Container(
          child: Text(
            'Notes you add appear here.',
            style: kNothingHereStyle,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.file.getItems().then((Map jsonData) {
      setState(() {
        widget.items = jsonData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DoDo', style: kListTitleStyle),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        // GridView.builder(
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     crossAxisSpacing: 10.0,
        //     mainAxisSpacing: 10.0,
        //     childAspectRatio: 1,
        //   ),
        //   padding: EdgeInsets.all(15.0),
        //   itemBuilder: buildTile,
        //   itemCount: widget.items.length,
        // ),
        buildBody(),
        Positioned(
            bottom: 40.0,
            right: 40.0,
            child: FloatingActionButton(
              backgroundColor: kAccentColor,
              child: Icon(
                Icons.add,
                color: kAccentForegroundColor,
                size: 35.0,
              ),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailView(listTitle: '', contentRaw: '', type: notes);
                })).then((temp) {
                  if (temp == false) {
                  } else {
                    if ((temp['title'].trim().length == 0 ||
                            temp['title'] == null) &&
                        (temp['content'].trim().length == 0 ||
                            temp['content'] == null)) {
                    } else {
                      widget.items[widget.items.length.toString()] = temp;
                      widget.file.writeItems(widget.items);
                    }
                  }
                });
              },
            ))
      ]),
    );
  }
}

class GridTile extends StatefulWidget {
  final String title;
  final dynamic content;
  final String type;
  final Function onTap;
  final Function onDelete;

  GridTile(
      {@required this.title,
      @required this.content,
      @required this.type,
      @required this.onTap,
      @required this.onDelete});

  @override
  _GridTileState createState() => _GridTileState();
}

class _GridTileState extends State<GridTile> {
  Widget listItem(BuildContext context, int index) {
    return CheckBoxTileTodoItem(
        item: widget.content[index],
        onChecked: (val) {
          widget.content[index][1] = !widget.content[index][1];
        });
  }

  Widget getContent() {
    if (widget.type == notes) {
      return Expanded(
        child: Container(
          alignment: Alignment.topLeft,
          child: Text(
            widget.content,
            style: kTileContentStyle,
            softWrap: true,
            maxLines: 4,
            overflow: TextOverflow.fade,
          ),
        ),
      );
    } else {
      print(widget.content);
      // return Container(child: Text('Testing'));
      return Container(
        alignment: Alignment.topLeft,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.content.length > 3 ? 3 : widget.content.length,
          itemBuilder: listItem,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade800),
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.title,
                    style: kTileTitleStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 24,
                  child: IconButton(
                      icon: Icon(Icons.clear), onPressed: widget.onDelete),
                ),
              ],
            ),
            getContent(),
          ],
        ),
      ),
    );
  }
}

class DetailView extends StatefulWidget {
  String listTitle;
  Commons content;
  bool isNotes;

  DetailView({this.listTitle, String type, dynamic contentRaw}) {
    this.content = Commons(data: contentRaw, type: type);
    this.isNotes = content.type == notes ? true : false;
  }

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  Widget getBody() {
    print(widget.content.type);
    if (widget.isNotes) {
      widget.content.type = notes;
      print('I am notes');
      if (!(widget.content.data is String)) {
        print('not string');
        String temp = '';
        for (int i = 0; i < widget.content.data.length; i++) {
          temp += widget.content.data[i][0] + '\n';
        }
        widget.content.data = temp;
      }
      print('string');
      return NotesView(content: widget.content);
    } else if (!(widget.isNotes)) {
      widget.content.type = todos;
      print(widget.content.data);
      if (widget.content.data is String) {
        print('is string');
        widget.content.data = widget.content.data.split('\n');
        List temp = [];
        for (int i = 0; i < widget.content.data.length; i++) {
          temp.add([widget.content.data[i], false]);
        }
        int i = 0;
        while (i < temp.length) {
          if (temp[i][0].length == 0) {
            temp.removeAt(i);
          } else {
            i++;
          }
        }
        widget.content.data = temp;
        print(widget.content.data);
      }
      print('is not string');
      return TodoList(content: widget.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Title inside:' + widget.listTitle);
        print('Content inside:');
        Navigator.pop(context, {
          'title': widget.listTitle,
          'content': widget.content.data,
          'type': widget.content.type,
        });
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            scrollPadding: EdgeInsets.all(5.0),
            controller: TextEditingController()..text = widget.listTitle,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              widget.listTitle = val;
            },
            maxLines: 1,
            cursorColor: Colors.white,
            style: kListTitleStyle,
            decoration: InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            SizedBox(width: 8.0),
            Transform.scale(
              scale: 1.75,
              child: SizedBox(
                width: 35,
                height: 50,
                child: Switch(
                  value: widget.isNotes,
                  onChanged: (val) {
                    setState(() {
                      print(widget.isNotes);
                      widget.isNotes = val;
                      print(widget.isNotes);
                    });
                  },
                  activeColor: kPrimaryColor,
                  inactiveThumbColor: kPrimaryColor,
                  activeTrackColor: kAccentColor2,
                  inactiveTrackColor: kAccentColor,
                  inactiveThumbImage: AssetImage('images/thumb_list.png'),
                  activeThumbImage: AssetImage('images/thumb_notes.png'),
                ),
              ),
            ),
            SizedBox(width: 5.0),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.content.type = todos;
                  Navigator.pop(context, {
                    'title': '',
                    'content': '',
                    'type': widget.content.type
                  });
                }),
          ],
        ),
        body: getBody(),
      ),
    );
  }
}
