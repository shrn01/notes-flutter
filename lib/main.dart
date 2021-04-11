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
        onPressed: () {
          print(NoteProvider.getNotesList());
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

class NotesList extends StatelessWidget {
  NotesList({
    Key key,
  }) : super(key: key);

  final Map<dynamic, dynamic> notes = {
    0: {
      'head': "Dobby",
      'body':
          "\"Such a beautiful place... to be with friends.\" It's difficult to not get a bit misty-eyed recalling the moment when Dobby the house-elf said those words in Deathly Hallows Part 1, which were among his last. When we met Dobby, admittedly, he was pretty annoying. ",
    },
    1: {
      'head': "Luna",
      'body':
          "\"I know she's insane, but it's in a good way.\" Ron Weasley's characterization of Luna Lovegood is precisely what makes this \"Looney\" Ravenclaw girl such a delight. She's an offbeat type with an interest in the macabre. And really, it's not surprising that she's a little strange when you consider that her mother died in a tragic magical accident when ",
    },
    2: {
      'head': "Sirius",
      'body':
          "\"Have you seen this wizard?\" \"Approach with extreme caution!\" \"Notify immediately by owl the Ministry of Magic.\" So read the wanted posters plastered everywhere in the wizarding world upon Sirius Black's escape from Azkaban prison,",
    },
    3: {
      'head': "Hermione",
      'body':
          "Hermione Granger, Harry Potter and Ron Weasley's best girl-pal, is so much more than just a token throw-in for female readers/viewers to identify with. In fact, she narrowly edges out Ron for second place on our list.",
    }
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, i) {
          return Note(head: notes[i]['head'], body: notes[i]['body']);
        });
  }
}

class Note extends StatelessWidget {
  Note({
    Key key,
    @required this.head,
    this.body,
  }) : super(key: key);
  final head;
  final body;
  final bodyStyle = TextStyle(
    fontSize: 18.0,
  );
  final headStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    var random = Random();
    var red = random.nextInt(80) + 170;
    var green = random.nextInt(80) + 170;
    var blue = random.nextInt(80) + 170;
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
        color: Color.fromRGBO(red, green, blue, 1.0),
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

  Color background = Colors.white;
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
                print(title);
                print(body);
                print(background);
                NoteModel note = NoteModel(
                  title,
                  body,
                  background,
                );
                print(note);
                print(note.toMap());
                if (title != '' && body != '') {
                  NoteProvider.insert(note.toMap());
                }
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.archive_outlined),
                onPressed: () {},
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
