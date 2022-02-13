
import 'state.dart';

class Machine {
  final List<State> states = [];
  final Map<String, int> integers = {};
  late State initialState;

  Machine();
}
