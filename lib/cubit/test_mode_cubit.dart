import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TestModeCubit extends Cubit<bool> {
  final SharedPreferenceHelper _sharedPreferenceHelper;

  TestModeCubit()
      : _sharedPreferenceHelper = Get.find<SharedPreferenceHelper>(),
        super(false) {
    _loadTestModeStatus(); // Load initial state from SharedPreferences
  }

  void _loadTestModeStatus() async {
    final status = await _sharedPreferenceHelper.isTestModeEnabled();
    emit(status);
  }

  void toggle() {
    final newState = !state;
    _sharedPreferenceHelper.saveTestModeStatus(newState);
    emit(newState);
  }
}
