import 'dart:math';
import '../data.dart';

import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  Color getColor() {
    var random = Random();
    var red = random.nextInt(80) + 170;
    var green = random.nextInt(80) + 170;
    var blue = random.nextInt(80) + 170;

    // print(Color.fromRGBO(red, green, blue, 1.0));
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  Color background = Colors.grey[200];
  String title = '';
  String body = '';

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
    return Container(
      child: Hero(
        tag: "addNote",
        child: WillPopScope(
          onWillPop: () {
            NoteModel note = NoteModel(
              title,
              body,
              background,
            );
            if (title != '' && body != '') {
              NoteProvider.insert(note.toMap());
            }
            return Future<bool>.value(true);
          },
          child: Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  NoteModel note = NoteModel(
                    title,
                    body,
                    background,
                  );
                  if (title != '' && body != '') {
                    NoteProvider.insert(note.toMap());
                  }
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () async {
                    var confirm = await getConfirmation(context);
                    if (confirm) Navigator.pop(context);
                  },
                ),
              ],
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              centerTitle: true,
              elevation: 0.0,
              title: Text(
                'Add',
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
                            onChanged: (text) {
                              title = text;
                            },
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
                            onChanged: (text) {
                              body = text;
                            },
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
