import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'src/Bin.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Empty My Bin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: new Text(widget.title),
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
        ));
  }
}
