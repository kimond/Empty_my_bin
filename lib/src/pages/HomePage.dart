import 'dart:async';

import 'package:empty_my_bin/src/Bin.dart';
import 'package:empty_my_bin/src/utils/auth.dart';
import 'package:empty_my_bin/src/widgets/AddBinDialog.dart';
import 'package:empty_my_bin/src/widgets/BinTile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _binRef = FirebaseDatabase.instance.reference().child('bins');


  void _openAddBinDialog() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AddBinDialog();
        },
        fullscreenDialog: true
    ));
  }

  Future<Null> _deleteBin(String key) async {
    await ensureLoggedIn();
    _binRef.child(key).remove();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Empty my bin'),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: _binRef,
              itemBuilder: (_, DataSnapshot snapshot, Animation animation, int index) {
                return new BinTile(
                    snapshot: snapshot,
                    animation: animation,
                    onDelete: _deleteBin,
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openAddBinDialog,
        tooltip: 'Create bin',
        child: new Icon(Icons.add),
      ),
    );
  }
}

