import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:empty_my_bin/src/Bin.dart';
import 'package:empty_my_bin/src/utils/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddBinDialog extends StatefulWidget {
  @override
  AddBinDialogState createState() => new AddBinDialogState();
}

class AddBinDialogState extends State<AddBinDialog> {
  final _binRef = FirebaseDatabase.instance.reference().child('bins');

  File _binImage;
  final TextEditingController _binNameController = new TextEditingController();

  Future<Null> _createBin() async {
    await ensureLoggedIn();
    String binName = _binNameController.text;
    String binImageUrl = await _uploadBinImage();
    Bin newBin = new Bin(binName, false, binImageUrl);
    _binRef.push().set(newBin.toJson());
  }

  Future<String> _uploadBinImage() async {
    if (_binImage == null) {
      return "";
    }
    int random = new Random().nextInt(100000);
    StorageReference ref =
        FirebaseStorage.instance.ref().child("bin_image_$random.jpg");
    StorageUploadTask uploadTask = ref.put(_binImage);
    Uri downloadUrl = (await uploadTask.future).downloadUrl;

    return downloadUrl.toString();
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
              _binImage == null
                  ? new IconButton(
                      icon: new Icon(Icons.photo_camera),
                      onPressed: () async {
                        _binImage = await ImagePicker.pickImage();
                      },
                    )
                  : new Image.file(_binImage, scale: 0.5,),
              new TextField(
                controller: _binNameController,
                decoration: new InputDecoration(hintText: 'Type the bin name'),
              )
            ],
          ),
        ));
  }
}
