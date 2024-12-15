
// Event for selecting a tab
abstract class NavigationEvent {}

class SelectTabEvent extends NavigationEvent {
  final int index;
  SelectTabEvent(this.index);
}