import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.black,
      ),
      initialRoute: '/add',
      routes: {
        '/': (context) => Home(),
        '/add': (context) => AddNote(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Note.js",
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "Settings",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'addNote',
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          Navigator.pushNamed(context, '/add');
        },
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            NotesList(),
            Center(
              child: Text("In Settings"),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class NotesList extends StatelessWidget {
  NotesList({
    Key key,
  }) : super(key: key);

  Future<List<Map<dynamic, dynamic>>> notez = NoteProvider.getNotes();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: notez,
      builder: (context, snapshot) {
        // print(snapshot.data);
        if (snapshot.hasData)
          return ListView.builder(
            itemCount: snapshot.data.length + 1,
            itemBuilder: (context, i) {
              if (i < snapshot.data.length) {
                return Note(
                  head: snapshot.data[i]['title'],
                  body: snapshot.data[i]['body'],
                  color: Color(snapshot.data[i]['noteColor']),
                );
              } else {
                return InkWell(
                  child: SizedBox(
                    height: 30.0,
                    child: Container(
                      child: Center(
                        child: Text("Archived"),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        else
          return Container(
            child: Center(
              child: Text("Loading"),
            ),
          );
      },
    );
  }
}

class Note extends StatelessWidget {
  Note({
    Key key,
    @required this.head,
    this.body,
    this.color,
  }) : super(key: key);

  final head;
  final body;
  final color;
  final bodyStyle = TextStyle(
    fontSize: 18.0,
  );
  final headStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 3),
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // if(head){
          Text(
            head,
            textAlign: TextAlign.left,
            style: headStyle,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            body,
            textAlign: TextAlign.justify,
            style: bodyStyle,
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        color: color,
      ),
    );
  }
}

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
      getColor(),
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
        child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                // print(title);
                // print(body);
                // print(background);
                NoteModel note = NoteModel(
                  title,
                  body,
                  background,
                );
                // print(note);
                // print(note.toMap());
                if (title != '' && body != '') {
                  NoteProvider.insert(note.toMap());
                }
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  // NoteProvider.delete();
                },
              ),
              IconButton(
                icon: Icon(Icons.archive_outlined),
                onPressed: () {
                  // NoteProvider.update();
                },
              )
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
                          decoration: InputDecoration(
                            hintText: 'Title',
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
    );
  }
}
