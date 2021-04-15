import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  Note({
    Key key,
    this.id,
    @required this.head,
    this.body,
    this.color,
    this.isArchived,
    this.refresh,
  }) : super(key: key);

  final isArchived;
  final id;
  final head;
  final body;
  final color;
  final Function() refresh;
  final bodyStyle = TextStyle(
    fontSize: 16.0,
  );
  final headStyle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    // print(isArchived);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      padding: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, '/edit', arguments: {
            'title': head,
            'body': body,
            'color': color,
            'id': id,
            'isArchived': isArchived,
          });
          refresh();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              head,
              textAlign: TextAlign.left,
              style: headStyle,
            ),
            SizedBox(
              height: 6.0,
            ),
            Text(
              body,
              textAlign: TextAlign.justify,
              style: bodyStyle,
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        color: Color(color),
      ),
    );
  }
}
