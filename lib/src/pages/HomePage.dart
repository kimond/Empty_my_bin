import 'dart:async';

import 'package:empty_my_bin/src/Bin.dart';
import 'package:empty_my_bin/src/widgets/BinTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _binRef = FirebaseDatabase.instance.reference().child('bins');

  Future<Null> _createBin() async {
    await _ensureLoggedIn();
    Bin newBin = new Bin('new bin', false);
    _binRef.push().set(newBin.toJson());
  }

  Future<Null> _deleteBin(String key) async {
    await _ensureLoggedIn();
    _binRef.child(key).remove();
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
      await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
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
                    onDelete: _deleteBin
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _createBin,
        tooltip: 'Create bin',
        child: new Icon(Icons.add),
      ),
    );
  }
}

