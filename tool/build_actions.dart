import 'package:build_runner/build_runner.dart';
import 'package:json_serializable/generators.dart';
import 'package:source_gen/source_gen.dart';

final List<BuildAction> buildActions = [
  new BuildAction(
      new PartBuilder(const [
        const JsonSerializableGenerator(),
      ]),
      'empty_my_bin',
      inputs: const ['lib/src/*.dart'])
];