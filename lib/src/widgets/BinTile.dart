import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

@override
class BinTile extends StatelessWidget {
  BinTile({this.snapshot, this.animation, this.onDelete});

  final DataSnapshot snapshot;
  final Animation animation;
  final ValueChanged<String> onDelete;

  void _handleDelete() {
    onDelete(snapshot.key);
  }

  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor:
        new CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: new ListTile(
          title: new Text(snapshot.value['name']),
          trailing: new IconButton(icon: new Icon(Icons.delete, color: Colors.red,), onPressed: _handleDelete),
          onTap: () {
            Navigator.pushNamed(context, '/bin-detail');
          },
        ));
  }
}
