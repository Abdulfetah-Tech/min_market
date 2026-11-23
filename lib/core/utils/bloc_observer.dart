// BLoC observer for structured logging and debugging

import 'package:bloc/bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppBlocObserver extends BlocObserver {
  final Talker _talker;

  AppBlocObserver(this._talker);

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _talker.debug('BLoC Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _talker.info(
      'BLoC Event: ${bloc.runtimeType} -> ${event.runtimeType}',
      event,
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _talker.debug(
      'BLoC State Change: ${bloc.runtimeType}',
      {
        'currentState': change.currentState.runtimeType.toString(),
        'nextState': change.nextState.runtimeType.toString(),
      },
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _talker.debug(
      'BLoC Transition: ${bloc.runtimeType}',
      {
        'event': transition.event.runtimeType.toString(),
        'currentState': transition.currentState.runtimeType.toString(),
        'nextState': transition.nextState.runtimeType.toString(),
      },
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _talker.error(
      'BLoC Error: ${bloc.runtimeType}',
      error,
      stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _talker.debug('BLoC Closed: ${bloc.runtimeType}');
  }
}