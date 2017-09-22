import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
  List<Bin> _bins = [];
  final _binRef = FirebaseDatabase.instance.reference().child('bins');

  Future<Null> _createBin() async {
    await _ensureLoggedIn();
    Bin newBin = new Bin('new bin', false);
    _binRef.push().set(newBin.toJson());
    setState(() {
      _bins.add(newBin);
    });
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

  Future<Null> _deleteBin(Bin bin) async {
    await _ensureLoggedIn();
    setState(() {
      _bins.remove(bin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView.builder(
        itemCount: _bins.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
              trailing: new IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete the bin',
                onPressed: () {
                  _deleteBin(_bins[index]);
                },
              ),
              title: new Text(_bins[index].name));
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _createBin,
        tooltip: 'Create bin',
        child: new Icon(Icons.add),
      ),
    );
  }
}
