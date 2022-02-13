import 'extensions.dart';
import 'machine.dart';
import 'state.dart';
import 'transition.dart';

class MachineInterpreter {
  late State currentState;
  late Machine machine;

  MachineInterpreter({required this.machine}) {
    currentState = machine.initialState;
    for (var element in machine.states) {
      print(element.name);
    }
  }

  factory MachineInterpreter.run(Machine machine) {
    return MachineInterpreter(machine: machine);
  }

  void processEvent(String event) {
    var where =
        currentState.transitions.where((element) => element.event == event);
    final transition = where.firstWhereOrNull((element) {
      var conditionsSatisfied = true;
      if (element.condition != null &&
          element.conditionalVariableName != null &&
          element.conditionValue != null) {
        switch (element.condition) {
          case Condition.equal:
            conditionsSatisfied = element.conditionValue! ==
                machine.integers[element.conditionalVariableName!];
            break;
          case Condition.greater:
            conditionsSatisfied =
                machine.integers[element.conditionalVariableName!]! >
                    element.conditionValue!;
            break;
          case Condition.less:
            conditionsSatisfied =
                machine.integers[element.conditionalVariableName!]! <
                    element.conditionValue!;
            break;
          default:
            throw Exception(
                'Something went wrong when validating transition conditions');
        }
      }
      if (element.operation != null && conditionsSatisfied) {
        switch (element.operation) {
          case Operation.increment:
            machine.integers[element.operationVariableName!] =
                machine.integers[element.operationVariableName]! + 1;
            break;
          case Operation.decrement:
            machine.integers[element.operationVariableName!] =
                machine.integers[element.operationVariableName]! - 1;
            print(machine.integers[element.operationVariableName]);
            break;
          case Operation.set:
            machine.integers[element.operationVariableName!] =
                element.operationValue!;
            break;
          default:
            throw Exception(
                'Something went wrong when validating transition operations');
        }
      }
      return conditionsSatisfied;
    });
    if (transition != null) {
      currentState = transition.targetState!;
    }
  }

  int getInteger(String string) {
    return machine.integers[string]!;
  }
}
