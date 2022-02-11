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
    latestState = stateWhere;
    return this;
  }

  // TODO should throw error when trying to overwrite initial?
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

  //TODO create new state if null?
  StateMachine to(String state) {
    var stateWhere = machine.states.firstWhereOrNull((p0) => p0.name == state);
    if(stateWhere == null) {
        stateWhere = State(name: state);
        machine.states.add(stateWhere);
    }
    latestTransition!.targetState = stateWhere;
    return this;
  }

  /// Initializes a variable
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

class MachineInterpreter {
  late State currentState;
  late Machine machine;

  MachineInterpreter({required this.machine}) {
    currentState = machine.initialState;
    machine.states.forEach((element) {print(element.name);});
  }

  factory MachineInterpreter.run(Machine machine) {
    return MachineInterpreter(machine: machine);
  }

  void processEvent(String event) {
    var where =
        currentState.transitions.where((element) => element.event == event);

    print('Current State ${currentState.name} with transistions ${currentState.transitions.map((e) => e.targetState!.name).toList()}');
    // Process first event that satisfies conditions
    final transistion = where.firstWhere((element) {
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
            conditionsSatisfied = element.conditionValue! >
                machine.integers[element.conditionalVariableName!]!;
            break;
          case Condition.less:
            conditionsSatisfied = element.conditionValue! <
                machine.integers[element.conditionalVariableName!]!;
            break;
          default:
            // FIXME
            throw Exception(
                'Somewthing went wrong when validating transistion conditions');
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
            break;
          case Operation.set:
            machine.integers[element.operationVariableName!] =
                element.operationValue!;
            break;
          default:
            // FIXME
            throw Exception('Something went wrong!');
        }
      }
      return conditionsSatisfied;
    });
    currentState = transistion.targetState!;
  }

  int getInteger(String string) {
    return machine.integers[string]!;
  }
}


void main() {

  final sm = StateMachine();
  const int numberOfTracks = 10;
  final machine = sm
              .integer('track')
              .state('STOP').initial()
                .when('PLAY').to('PLAYING').set('track', 1).ifEquals('track', 0)
                .when('PLAY').to('PLAYING')
              .state('PLAYING')
                .when('STOP').to('STOP')
                .when('PAUSE').to('PAUSED')
                .when('TRACK_END').to('STOP').ifEquals('track', numberOfTracks)
                .when('TRACK_END').to('PLAYING').increment('track')
              .state('PAUSED')
                .when('STOP').to('STOP')
                .when('PLAY').to('PLAYING')
                .when('FORWARD').to('PAUSED').increment('track').ifLessThan('track', numberOfTracks)
                .when('BACK').to('PAUSED').decrement('track').ifGreaterThan('track', 1)
              .build();
  final interpreter = MachineInterpreter.run(machine);
  print('Current state: ${interpreter.currentState.name}');
  interpreter.processEvent('PLAY');
  var integer = interpreter.getInteger('track');  
  print('New state: ${interpreter.currentState.name}, with track=$integer');
  interpreter.processEvent('STOP');
  print('Current state: ${interpreter.currentState.name}');
  interpreter.processEvent('PLAY');
  print('Current state: ${interpreter.currentState.name}');
  interpreter.processEvent('PAUSE');
  print('Current state: ${interpreter.currentState.name}');
  interpreter.processEvent('PLAY');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
  interpreter.processEvent('TRACK_END');
  print('Current state: ${interpreter.currentState.name}, with track=${interpreter.getInteger('track')}');
}