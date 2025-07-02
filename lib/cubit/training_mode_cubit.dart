import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TrainingModeCubit extends Cubit<bool> {
  final SharedPreferenceHelper _sharedPreferenceHelper;

  TrainingModeCubit()
      : _sharedPreferenceHelper = Get.find<SharedPreferenceHelper>(),
        super(false) {
    loadTestModeStatus(); // Load initial state from SharedPreferences
  }

  void loadTestModeStatus() async {
    // final status = await _sharedPreferenceHelper.isTestModeEnabled();
    // print("testmode: sp: $status");
    // emit(status);
    print("trainingMode: $state");
    await _sharedPreferenceHelper.saveTestModeStatus(state);
  }

  void toggle() async {
    // final status = await _sharedPreferenceHelper.isTestModeEnabled();
    // print("called $status");
    // emit(!status);
    // print("new status ${!status}");
    // await _sharedPreferenceHelper.saveTestModeStatus(!status);

    bool isTrainingModeEnabled = state;
    print("current state: $isTrainingModeEnabled");

    emit(!isTrainingModeEnabled);
    print("new state: $state");

    await _sharedPreferenceHelper.saveTestModeStatus(!isTrainingModeEnabled);
  }
}
