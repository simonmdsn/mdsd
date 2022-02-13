import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../bin/state_machine.dart';
import '../bin/state.dart';
import '../bin/transition.dart';



void main() {

  test( 'emptyMachine', () {
    final sm = StateMachine();
    final m = sm.build();

    expect(true, m.states.isEmpty);
  });

  test( 'states', () {
    final sm = StateMachine();
  final m = sm.
  state("state 1").
  state("state 2").
  state("state 3").
  build();
  List<State> states = m.states;
  expect(3, states.length);
  expect(true,  states.any((state) => state.name == 'state 1'));
  expect(true,  states.any((state) => state.name == 'state 2'));
  expect(true,  states.any((state) => state.name == 'state 3'));
  });

  test( 'initialFirstState', () {
    final sm = StateMachine();
  final m = sm.
  state("state 1").initial().
  state("state 2").
  state("state 3").
  build();

  expect("state 1", m.initialState.name);
  });

  test( 'initialState', () {
    final sm = StateMachine();
  final m = sm.
  state("state 1").
  state("state 2").initial().
  state("state 3").
  build();

  expect("state 2", m.initialState.name);
  });

  test( 'getState', () {
    final sm = StateMachine();
  final m = sm.
  state("state 1").
  state("state 2").initial().
  state("state 3").
  build();
  expect("state 2", m.states.firstWhere((element) => element.name == 'state 2').name);
  });

  test( 'noTransitions', () {
    final sm = StateMachine();
  final m = sm.
  state("state 1").
  build();

  State state = m.states.firstWhere((state) => state.name == 'state 1');
  List<Transition> transitions = state.transitions;
  expect(true,transitions.isEmpty);
  });

  test( 'transitions', () {
    final sm = StateMachine();
  final m = sm.
  state("state 1").
  when("change to 2").to("state 2").
  when("change to 3").to("state 3").
  state("state 2").
  when("change to 3").to("state 3").
  state("state 3").
  build();
  State state = m.states.firstWhere((state) => state.name == "state 1");
  List<Transition> transitions = state.transitions;
  expect(2, transitions.length);
  expect(true,transitions.any((transition) => transition.event == "change to 2"));
  expect("state 2", state.transitions.firstWhere((transition) => transition.event == "change to 2").targetState!.name);
  expect(true,transitions.any((transition) => transition.event == "change to 3"));
  expect("state 3", state.transitions.firstWhere((trans) => trans.event == "change to 3").targetState!.name);

  state = m.states.firstWhere((state) => state.name == "state 2");
  transitions = state.transitions;
  expect(1, transitions.length);
  expect(true,transitions.any((transition) => transition.event == "change to 3"));
  expect("state 3", state.transitions.firstWhere((state) => state.event == "change to 3").targetState!.name);
  });

  test( 'noVariables', () {
    final sm = StateMachine();
    final m = sm.build();
  expect(0, m.integers.length);
  });

  test( 'addVariable', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  build();
  expect(1, m.integers.length);
  expect(true,m.integers.containsKey("var"));
  expect(false, m.integers.containsKey("var 2"));
  });

  test( 'transitionSetVariable', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("SET").to("state 2").set("var", 42).
  state("state 2").
  build();
  Transition transition = m.states.firstWhere((state) => state.name == "state 1").transitions.first;
  expect(true,transition.operation == Operation.set);
  expect(false, transition.operation == Operation.increment);
  expect(false, transition.operation == Operation.decrement);
  expect("var", transition.operationVariableName);
  });

  test( 'transitionIncrementVariable', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("SET").to("state 2").increment("var").
  state("state 2").
  build();
  Transition transition = m.states.firstWhere((state) => state.name == "state 1").transitions.first;
  expect(false, transition.operation == Operation.set);
  expect(true,transition.operation == Operation.increment);
  expect(false, transition.operation == Operation.decrement);
  expect("var", transition.operationVariableName);
  });

  test( 'transitionDecrementVariable', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("SET").to("state 2").decrement("var").
  state("state 2").
  build();
  Transition transition = m.states.firstWhere((state) => state.name == "state 1").transitions.first;
  expect(false, transition.operation == Operation.set);
  expect(false, transition.operation == Operation.increment);
  expect(true,transition.operation == Operation.decrement);
  expect("var", transition.operationVariableName);
  });

  test( 'transitionIfVariableEqual', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("GO").to("state 2").ifEquals("var", 42).
  state("state 2").
  build();
  State state = m.states.firstWhere((state) => state.name =="state 1");

  Transition transition = state.transitions.first;
  expect(true,transition.condition != null);
  expect("var", transition.conditionalVariableName);
  expect(42, transition.conditionValue);
  expect(true,transition.condition == Condition.equal);
  expect(false, transition.condition == Condition.greater);
  expect(false, transition.condition == Condition.less);
  });

  test( 'transitionIfVariableGreaterThan', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("GO").to("state 2").ifGreaterThan("var", 42).
  state("state 2").
  build();
  State state = m.states.firstWhere((state) => state.name == "state 1");

  Transition transition = state.transitions.first;
  expect(true,transition.condition != null);
  expect("var", transition.conditionalVariableName);
  expect(42, transition.conditionValue);
  expect(false, transition.condition == Condition.equal);
  expect(true,transition.condition == Condition.greater);
  expect(false, transition.condition == Condition.less);
  });

  test( 'transitionIfVariableLessThan', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("GO").to("state 2").ifLessThan("var", 42).
  state("state 2").
  build();
  State state = m.states.firstWhere((state) => state.name == "state 1");

  Transition transition = state.transitions.first;
  expect(true,transition.condition != null);
  expect("var", transition.conditionalVariableName);
  expect(42, transition.conditionValue);
  expect(false, transition.condition == Condition.equal);
  expect(false, transition.condition == Condition.greater);
  expect(true,transition.condition == Condition.less);
  });

  test( 'transitionIfVariableEqualsAndSet', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("GO").to("state 2").set("var", 10).ifEquals("var", 42).
  state("state 2").
  build();
  State state = m.states.firstWhere((state) => state.name == "state 1");

  Transition transition = state.transitions.first;
  expect(true,transition.condition != null);
  expect(true,transition.operation == Operation.set);
  });

  test( 'transitionIfVariableGreaterAndIncrement', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("GO").to("state 2").increment("var").ifGreaterThan("var", 42).
  state("state 2").
  build();
  State state = m.states.firstWhere((state) => state.name == "state 1");

  Transition transition = state.transitions.first;
  expect(true,transition.condition != null);
  expect(true,transition.operation == Operation.increment);
  });

  test( 'transitionIfVariableLessAndDecrement', () {
    final sm = StateMachine();
  final m = sm.
  integer("var").
  state("state 1").
  when("GO").to("state 2").decrement("var").ifLessThan("var", 42).
  state("state 2").
  build();
  State state = m.states.firstWhere((state) => state.name == "state 1");

  Transition transition = state.transitions.first;
  expect(true,transition.condition != null);
  expect(true,transition.operation == Operation.decrement);
  });

}