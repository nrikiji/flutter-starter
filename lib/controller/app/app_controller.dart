import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_start_app/controller/app/app_state.dart';

class AppController extends StateNotifier<AppState> with LocatorMixin {
  AppController() : super(AppState(initialized: false)) {
    state = state.copyWith.call(initialized: true);
  }
}
