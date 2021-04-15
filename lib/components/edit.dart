import 'dart:math';
import '../data.dart';

import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  EditNote({this.arguments});
  final arguments;
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Color getColor() {
    var random = Random();
    var red = random.nextInt(80) + 170;
    var green = random.nextInt(80) + 170;
    var blue = random.nextInt(80) + 170;

    // print(Color.fromRGBO(red, green, blue, 1.0));
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  Color background = Colors.grey[200];
  String title;
  String body;
  int id;
  int isArchived;
  TextEditingController titleController;
  TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    title = widget.arguments['title'];
    background = Color(widget.arguments['color']);
    body = widget.arguments['body'];
    id = widget.arguments['id'];
    isArchived = widget.arguments['isArchived'];
    titleController =
        TextEditingController.fromValue(TextEditingValue(text: title));
    bodyController =
        TextEditingController.fromValue(TextEditingValue(text: body));
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> myColors = [
      Colors.grey[200],
      getColor(),
      getColor(),
      getColor(),
      getColor(),
      getColor(),
      getColor(),
      getColor(),
    ];
    return WillPopScope(
      onWillPop: () {
        if (titleController.text != '' && bodyController.text != '') {
          Map<String, dynamic> note = {};
          note['title'] = titleController.text;
          note['body'] = bodyController.text;
          note['noteColor'] = background.value;
          note['id'] = id;
          note['isArchived'] = isArchived;
          NoteProvider.update(note);
        }
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Container(
        child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                if (titleController.text != '' && bodyController.text != '') {
                  Map<String, dynamic> note = {};
                  note['title'] = titleController.text;
                  note['body'] = bodyController.text;
                  note['noteColor'] = background.value;
                  note['id'] = id;
                  note['isArchived'] = isArchived;
                  NoteProvider.update(note);
                }
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () async {
                  var confirm = await getConfirmation(context);
                  if (confirm) {
                    NoteProvider.delete(id);
                    // print(id);
                    Navigator.pop(context);
                  }
                },
              ),
              IconButton(
                icon: isArchived == 1
                    ? Icon(Icons.unarchive_outlined)
                    : Icon(Icons.archive_outlined),
                onPressed: () {
                  isArchived = isArchived ^ 1;
                  Map<String, dynamic> note = {};
                  note['title'] = titleController.text;
                  note['body'] = bodyController.text;
                  note['noteColor'] = background.value;
                  note['id'] = id;
                  note['isArchived'] = isArchived;
                  NoteProvider.update(note);
                  Navigator.pop(context);
                },
              )
            ],
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              'Edit',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 0.0),
                    child: ListView(
                      children: [
                        TextField(
                          controller: titleController,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: bodyController,
                          decoration: InputDecoration(
                            hintText: 'Body',
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      for (var myColor in myColors)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                background = myColor;
                                // print(background);
                              });
                            },
                            child: Container(
                              color: myColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getConfirmation(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delete?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('It can\'t be recovered later'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No')),
            ],
          );
        });
  }
}
