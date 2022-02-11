extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class Machine {
  final List<State> states = [];

  /// essentially variables?
  final Map<String, int> integers = {};
  late State initialState;

  Machine();

  /// TODO not the prettiest factory method?
  /// Does [initialState] need to be late?
  factory Machine.withInitialState(State state) {
    final machine = Machine();
    machine.initialState = state;
    return machine;
  }

  bool hasInteger(String string) => integers.containsKey(string);

  State getState(String string) => states.firstWhere((p0) => p0.name == string);

  int numberOfIntegers() => integers.length;
}

class State {
  final String name;

  final List<Transition> transitions = [];

  State({required this.name});

  //factory State.noTransitions(dynamic name) => State(name, []);

  Transition? transitionByEvent(String event) =>
      transitions.firstWhereOrNull((element) => element.event == event);
}

enum Operation { set, increment, decrement }

enum Condition {
  equal,
  greater,
  less,
}

class Transition {
  final String event;
  late State? targetState;
  late Operation? operation;
  late Condition? condition;
  late String? conditionalVariableName;
  late int? conditionValue;

  Transition({
    required this.event,
    this.targetState,
    this.operation,
    this.condition,
    this.conditionalVariableName,
    this.conditionValue,
  });

  bool hasOperation() => operation != null;

  bool hasSetOperation() => operation == Operation.set;

  bool hasIncrementOperation() => operation == Operation.increment;

  bool hasDecrementOperation() => operation == Operation.decrement;

  bool isConditional() => condition != null;

  bool isConditionEqual() => condition == Condition.equal;

  bool isConditionGreaterThan() => condition == Condition.greater;

  bool isConditionLessThan() => condition == Condition.less;

  int? conditionComparedValue() => conditionValue;
}

//TODO better error handling. I.e. throw error if trying to access undeclared variable
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
    final newState = State(name: state);
    machine.states.add(newState);
    latestState = newState;
    return this;
  }

  // TODO should throw error when trying to initial?
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
    latestTransition!.targetState = stateWhere;
    return this;
  }

  /// Initializes a variable
  StateMachine integer(String string) {
    machine.integers[string] = 0;
    return this;
  }

  StateMachine set(String variableName, int integer) {
    machine.integers[variableName] = integer;
    return this;
  }

  StateMachine increment(String variableName) {
    machine.integers[variableName] = machine.integers[variableName]! + 1;
    return this;
  }

  StateMachine decrement(String variableName) {
    machine.integers[variableName] = machine.integers[variableName]! - 1;
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

class MachineInterpreter {
  late State currentState;
  late Machine machine;

  MachineInterpreter({required this.machine}) {
    currentState = machine.initialState;
  }

  factory MachineInterpreter.run(Machine machine) {
    return MachineInterpreter(machine: machine);
  }

  void processEvent(String event) {
    var where = currentState.transitions.where((element) => element.event == event);
    if(where.length == 1) {
      /// NOT CORRECT! FIXME
      currentState = where.first.targetState!;
      return;
    }
    where.firstWhere((element) => element.);

  }

  int getInteger(String string) {
    return machine.integers[string]!;
  }
}
