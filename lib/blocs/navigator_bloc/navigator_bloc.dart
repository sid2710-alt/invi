// Navigation BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/blocs/navigator_bloc/navgation_state.dart';
import 'package:invi/blocs/navigator_bloc/navigator_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(selectedIndex: 0)){
    on<SelectTabEvent>((event, emit) => emit(NavigationState(selectedIndex: event.index)));
  }
}