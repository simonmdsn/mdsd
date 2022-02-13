import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../bin/machine_interpreter.dart';
import '../bin/state_machine.dart';

void main() {
  late MachineInterpreter interpreter;

  test('start init state', () {
    final sm = StateMachine();
    final m = sm.state('state 1').initial()
                .state('state 2').build();
    interpreter = MachineInterpreter.run(m);
    expect('state 1', interpreter.currentState.name);
  });

  test('event no transition', () {
    final sm = StateMachine();
    final m = sm.state('state 1').initial()
                .when('FIRE').to('state 2')
                .state('state 2').build();
    interpreter = MachineInterpreter.run(m);
    expect('state 1', interpreter.currentState.name);
  });

  test('event transition', () {
    final sm = StateMachine();
    final m = sm.state('state 1').initial()
        .when('FIRE').to('state 2')
        .state('state 2').build();
    interpreter = MachineInterpreter.run(m);
    interpreter.processEvent('FIRE');
    expect('state 2', interpreter.currentState.name);
  });

  test('list of events', () {
    final sm = StateMachine();
    final m = sm.state('state 1').initial()
          .when('ON').to('state 2')
        .state('state 2')
          .when('GO').to('state 3')
        .state('state 3')
        .build();
    interpreter = MachineInterpreter.run(m);
    interpreter.processEvent('ON');
    interpreter.processEvent('GO');
    expect('state 3', interpreter.currentState.name);
  });

  test('choose transition', () {
    final sm = StateMachine();
    final m = sm.state('state 1').initial()
          .when('FIRE2').to('state 2')
          .when('FIRE3').to('state 3')
          .when('FIRE4').to('state 4')
        .state('state 2')
        .state('state 3')
        .state('state 4')
        .build();
    interpreter = MachineInterpreter.run(m);
    interpreter.processEvent('FIRE3');
    expect('state 3', interpreter.currentState.name);
  });

  test('init variable', () {
    final sm = StateMachine();
    final m = sm.
            integer('var').
            state('state 1').initial().
            build();

    interpreter = MachineInterpreter.run(m);
    expect(0, interpreter.getInteger('var'));
  });

  test('transition set variable', () {
    final sm = StateMachine();
    final m = sm.integer("var").
      state("state 1").initial().
      when("SET").to("state 2").set("var", 42).
      state("state 2").
      build();
    interpreter = MachineInterpreter.run(m);
    interpreter.processEvent("SET");
    expect(42, interpreter.getInteger("var"));
  });

  test('transition increment variable', () {
    final sm = StateMachine();
    final m = sm.integer("var").
      state("state 1").initial().
      when("SET").to("state 2").increment("var").
      state("state 2").
      build();

    interpreter = MachineInterpreter.run(m);
    interpreter.processEvent("SET");
    expect(1, interpreter.getInteger("var"));
  });

  test( 'transitionDecrementVariable', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("SET").to("state 2").decrement("var").
  state("state 2").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("SET");
  expect(-1, interpreter.getInteger("var"));
  });

  test( 'transitionIfVariableEqual', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").set("var", 42).
  state("state 2").
  when("GO").to("state 3").ifEquals("var", 42).
  state("state 3").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  interpreter.processEvent("GO");
  expect("state 3", interpreter.currentState.name);
  });

  test( 'transitionIfVariableNotEqual', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").set("var", 42).
  state("state 2").
  when("GO").to("state 3").ifEquals("var", 40).
  state("state 3").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  interpreter.processEvent("GO");
  expect("state 2", interpreter.currentState.name);
  });

  test( 'transitionIfVariableGreaterThan', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").set("var", 42).
  state("state 2").
  when("GO").to("state 3").ifGreaterThan("var", 40).
  state("state 3").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  interpreter.processEvent("GO");
  expect("state 3", interpreter.currentState.name);
  });

  test( 'transitionIfVariableNotGreaterThan', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").set("var", 42).
  state("state 2").
  when("GO").to("state 3").ifGreaterThan("var", 42).
  state("state 3").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  interpreter.processEvent("GO");
  expect("state 2", interpreter.currentState.name);
  });

  test( 'transitionIfVariableLessThan', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").set("var", 42).
  state("state 2").
  when("GO").to("state 3").ifLessThan("var", 45).
  state("state 3").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  interpreter.processEvent("GO");
  expect("state 3", interpreter.currentState.name);
  });

  test( 'transitionIfVariableNotLessThan', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").set("var", 42).
  state("state 2").
  when("GO").to("state 3").ifLessThan("var", 42).
  state("state 3").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  interpreter.processEvent("GO");
  expect("state 2", interpreter.currentState.name);
  });

  test( 'transitionIfVariableEqualsAndSet', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").set("var", 42).ifEquals("var", 0).
  state("state 2").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  expect(42, interpreter.getInteger("var"));
  });

  test( 'transitionIfVariableGreaterAndIncrement', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").increment("var").ifGreaterThan("var", -1).
  state("state 2").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  expect(1, interpreter.getInteger("var"));
  });

  test( 'transitionIfVariableLessAndDecrement', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").decrement("var").ifLessThan("var", 1).
  state("state 2").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  expect(-1, interpreter.getInteger("var"));
  });

  test( 'transitionOrder', () {
    final sm = StateMachine();
    final m = sm.
  integer("var").
  state("state 1").initial().
  when("GO").to("state 2").increment("var").
  when("GO").to("state 2").decrement("var").
  state("state 2").
  build();
  interpreter = MachineInterpreter.run(m);
  interpreter.processEvent("GO");
  expect(1, interpreter.getInteger("var"));
  });

}
