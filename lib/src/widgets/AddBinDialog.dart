import 'dart:async';

import 'package:empty_my_bin/src/Bin.dart';
import 'package:empty_my_bin/src/utils/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddBinDialog extends StatefulWidget {
  @override
  AddBinDialogState createState() => new AddBinDialogState();
}

class AddBinDialogState extends State<AddBinDialog> {
  final _binRef = FirebaseDatabase.instance.reference().child('bins');

  final TextEditingController _binNameController = new TextEditingController();

  Future<Null> _createBin() async {
    await ensureLoggedIn();
    String binName = _binNameController.text;
    Bin newBin = new Bin(binName, false);
    _binRef.push().set(newBin.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('New bin'),
          actions: [
            new FlatButton(
                onPressed: () {
                  _createBin();
                  Navigator.of(context).pop();
                },
                child: new Text('SAVE',
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white))),
          ],
        ),
        body: new Container(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new TextField(
                controller: _binNameController,
                decoration: new InputDecoration(hintText: 'Type the bin name'),
              )
            ],
          ),
        ));
  }
}
