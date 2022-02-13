import 'state.dart';

class Transition {
  final String event;
  late State? targetState;
  late Operation? operation;
  late int? operationValue;
  late String? operationVariableName;
  late Condition? condition;
  late String? conditionalVariableName;
  late int? conditionValue;

  Transition({
    required this.event,
    this.targetState,
    this.operation,
    this.operationValue,
    this.operationVariableName,
    this.condition,
    this.conditionalVariableName,
    this.conditionValue,
  });
}

enum Operation {
  set,
  increment,
  decrement,
}

enum Condition {
  equal,
  greater,
  less,
}
