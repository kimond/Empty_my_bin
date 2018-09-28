library empty_my_bin.src.bin;

import 'package:json_annotation/json_annotation.dart';

part 'Bin.g.dart';

@JsonSerializable()
class Bin extends Object with _$BinSerializerMixin {
  String name;
  bool isFull;
  String imageUrl;

  Bin(this.name, this.isFull, this.imageUrl);

  factory Bin.fromJson(Map<String, dynamic> json) => _$BinFromJson(json);
}
