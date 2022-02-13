import 'transition.dart';

class State {
  final String name;

  final List<Transition> transitions = [];

  State({required this.name});
}
