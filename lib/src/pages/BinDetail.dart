import 'package:empty_my_bin/src/Bin.dart';
import 'package:flutter/material.dart';

class BinDetail extends StatelessWidget {
  BinDetail(this.bin, {Key key}) : super(key: key);
  final Bin bin;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(bin.name),
      ),
    );
  }
}
