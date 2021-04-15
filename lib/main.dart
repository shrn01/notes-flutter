import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'data.dart';
import 'components/addnote.dart';
import 'components/edit.dart';
import 'components/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/add': (context) => AddNote(),
        '/edit': (context) => EditNote(
              arguments: ModalRoute.of(context).settings.arguments,
            ),
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
  bool isList = true;
  Future<List<Map<dynamic, dynamic>>> notez = NoteProvider.getNotes();
  Future<List<Map<dynamic, dynamic>>> archived = NoteProvider.getArchived();
  refresh() {
    setState(() {
      notez = NoteProvider.getNotes();
      archived = NoteProvider.getArchived();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        actions: [
          IconButton(
              icon: isList ? Icon(Icons.list) : Icon(Icons.grid_on_rounded),
              onPressed: () {
                setState(() {
                  isList = !isList;
                });
              }),
          IconButton(
              icon: Icon(
                Icons.info_outline,
              ),
              onPressed: () {
                showAboutDialog(
                    applicationIcon: Icon(
                      Icons.notes,
                      size: 40.0,
                    ),
                    applicationName: "Notes",
                    context: context,
                    applicationVersion: '1.0.1',
                    children: <Widget>[Text("Made with <3 by shrn")]);
              })
        ],
        centerTitle: true,
        title: Text(
          "Notes",
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive,
            ),
            label: "Archived",
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
        elevation: 4.0,
        backgroundColor: Colors.white,
        heroTag: 'addNote',
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          // print(returned);
          refresh();
        },
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            NotesList(
              isList: isList,
              notez: notez,
              refresh: refresh,
            ),
            NotesList(
              isList: isList,
              notez: archived,
              refresh: refresh,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class NotesList extends StatefulWidget {
  NotesList({
    Key key,
    this.isList,
    this.notez,
    this.refresh,
  }) : super(key: key);
  bool isList;
  final notez;
  final Function() refresh;
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 0.0,
      ),
      child: FutureBuilder(
        future: widget.notez,
        builder: (context, snapshot) {
          // print(snapshot.data);
          if (snapshot.hasData) {
            List myList = snapshot.data;
            // print(snapshot.data);
            if (myList.length != 0) {
              if (!widget.isList)
                return ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: 15.0,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    // print(snapshot.data);
                    return Note(
                      id: snapshot.data[i]['id'],
                      head: snapshot.data[i]['title'],
                      body: snapshot.data[i]['body'],
                      color: snapshot.data[i]['noteColor'],
                      isArchived: snapshot.data[i]['isArchived'],
                      refresh: widget.refresh,
                    );
                  },
                );
              else
                return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.only(
                    bottom: 15.0,
                  ),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  itemCount: snapshot.data.length,
                  staggeredTileBuilder: (int index) {
                    return StaggeredTile.fit(1);
                  },
                  itemBuilder: (context, i) {
                    return Note(
                      id: snapshot.data[i]['id'],
                      head: snapshot.data[i]['title'],
                      body: snapshot.data[i]['body'],
                      color: snapshot.data[i]['noteColor'],
                      isArchived: snapshot.data[i]['isArchived'],
                      refresh: widget.refresh,
                    );
                  },
                );
            } else {
              return Container(
                child: Center(
                  child: Text("Feels Pretty Empty here!"),
                ),
              );
            }
          } else
            return Container(
              child: Center(
                child: Text("Loading"),
              ),
            );
        },
      ),
    );
  }
}
