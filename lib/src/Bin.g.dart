// GENERATED CODE - DO NOT MODIFY BY HAND

part of empty_my_bin.src.bin;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Bin _$BinFromJson(Map<String, dynamic> json) =>
    new Bin(json['name'] as String, json['isFull'] as bool);

abstract class _$BinSerializerMixin {
  String get name;
  bool get isFull;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'isFull': isFull};
}
