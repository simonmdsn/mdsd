import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'assignment_1.dart';

void main() {
  late MachineInterpreter interpreter;

  setUp(() {
    final stateMachine = StateMachine();
    final int numberOfTracks = 10;
    final m = stateMachine
        .integer("track")
        .state("STOP")
        .initial()
        .when("PLAY")
        .to("PLAYING")
        .set("track", 1)
        .ifEquals("track", 0)
        .when("PLAY")
        .to("PLAYING")
        .state("PLAYING")
        .when("STOP")
        .to("STOP")
        .when("PAUSE")
        .to("PAUSED")
        .when("TRACK_END")
        .to("STOP")
        .ifEquals("track", numberOfTracks)
        .when("TRACK_END")
        .to("PLAYING")
        .increment("track")
        .state("PAUSED")
        .when("STOP")
        .to("STOP")
        .when("PLAY")
        .to("PLAYING")
        .when("FORWARD")
        .to("PAUSED")
        .increment("track")
        .ifLessThan("track", numberOfTracks + 1)
        .when("BACK")
        .to("PAUSED")
        .decrement("track")
        .ifGreaterThan("track", 1)
        .build();

    interpreter = MachineInterpreter.run(m);
  });

  test('Play music test', () {
    interpreter.processEvent('PLAY');
    expect(1, interpreter.getInteger("track"));
		expect("PLAYING", interpreter.currentState.name);
		
		interpreter.processEvent("TRACK_END");
		expect(2, interpreter.getInteger("track"));
		expect("PLAYING", interpreter.currentState.name);
		
		interpreter.processEvent("STOP");
		expect(2, interpreter.getInteger("track"));
		expect("STOP", interpreter.currentState.name);
		
		interpreter.processEvent("PLAY");
		expect(2, interpreter.getInteger("track"));
		expect("PLAYING", interpreter.currentState.name);
		
		interpreter.processEvent("PAUSE");
		expect(2, interpreter.getInteger("track"));
		expect("PAUSED", interpreter.currentState.name);
		

		interpreter.processEvent("BACK");
		expect(1, interpreter.getInteger("track"));
		expect("PAUSED", interpreter.currentState.name);
		
		interpreter.processEvent("FORWARD");
		expect(2, interpreter.getInteger("track"));
		expect("PAUSED", interpreter.currentState.name);
		
		interpreter.processEvent("FORWARD");
		interpreter.processEvent("FORWARD");
		interpreter.processEvent("FORWARD");
		interpreter.processEvent("FORWARD");
		interpreter.processEvent("FORWARD");
		interpreter.processEvent("FORWARD");
		interpreter.processEvent("FORWARD");
		interpreter.processEvent("FORWARD");
		expect(10, interpreter.getInteger("track"));
		expect("PAUSED", interpreter.currentState.name);
		
		interpreter.processEvent("PLAY");
		expect(10, interpreter.getInteger("track"));
		expect("PLAYING", interpreter.currentState.name);
		
		interpreter.processEvent("TRACK_END");
		expect(10, interpreter.getInteger("track"));
		expect("STOP", interpreter.currentState.name);

  });
}
