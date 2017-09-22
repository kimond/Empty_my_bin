library empty_my_bin.src.bin;

import 'package:json_serializable/annotations.dart';

part 'Bin.g.dart';

@JsonSerializable()
class Bin extends Object with _$BinSerializerMixin{
  String name;
  bool isFull;

  Bin(this.name, this.isFull);

  factory Bin.fromJson(Map<String, dynamic> json) => _$BinFromJson(json);
}
