import 'package:empty_my_bin/src/Bin.dart';
import 'package:empty_my_bin/src/pages/BinDetail.dart';
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
            Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                Bin bin = new Bin.fromJson(snapshot.value);
                return new BinDetail(bin);
              }
            ));
          },
        ));
  }
}
