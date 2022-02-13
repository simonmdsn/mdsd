import 'extensions.dart';
import 'machine.dart';
import 'state.dart';
import 'transition.dart';

class StateMachine {
  final Machine machine = Machine();
  State? latestState;
  Transition? latestTransition;

  Machine build() {
    return machine;
  }

  StateMachine state(String state) {
    var stateWhere = machine.states.firstWhereOrNull((p0) => p0.name == state);
    if (stateWhere == null) {
      stateWhere = State(name: state);
      machine.states.add(stateWhere);
    }
    latestState = stateWhere;
    return this;
  }

  StateMachine initial() {
    machine.initialState = machine.states.last;
    return this;
  }

  StateMachine when(String state) {
    var transition = Transition(event: state, targetState: null);
    latestState!.transitions.add(transition);
    latestTransition = transition;
    return this;
  }

  StateMachine to(String state) {
    var stateWhere = machine.states.firstWhereOrNull((p0) => p0.name == state);
    if (stateWhere == null) {
      stateWhere = State(name: state);
      machine.states.add(stateWhere);
    }
    latestTransition!.targetState = stateWhere;
    return this;
  }

  StateMachine integer(String string) {
    machine.integers[string] = 0;
    return this;
  }

  StateMachine set(String variableName, int integer) {
    latestTransition!.operation = Operation.set;
    latestTransition!.operationValue = integer;
    latestTransition!.operationVariableName = variableName;
    return this;
  }

  StateMachine increment(String variableName) {
    latestTransition!.operation = Operation.increment;
    latestTransition!.operationVariableName = variableName;
    return this;
  }

  StateMachine decrement(String variableName) {
    latestTransition!.operation = Operation.decrement;
    latestTransition!.operationVariableName = variableName;
    return this;
  }

  StateMachine ifEquals(String name, int comparison) {
    latestTransition!.conditionalVariableName = name;
    latestTransition!.conditionValue = comparison;
    latestTransition!.condition = Condition.equal;
    return this;
  }

  StateMachine ifGreaterThan(String name, int comparison) {
    latestTransition!.conditionalVariableName = name;
    latestTransition!.conditionValue = comparison;
    latestTransition!.condition = Condition.greater;
    return this;
  }

  StateMachine ifLessThan(String name, int comparison) {
    latestTransition!.conditionalVariableName = name;
    latestTransition!.conditionValue = comparison;
    latestTransition!.condition = Condition.less;
    return this;
  }
}