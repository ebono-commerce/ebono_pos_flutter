import 'package:get/get.dart';
import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_bloc.dart';
import 'package:kpn_pos_application/ui/login/repository/login_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register SharedPreferenceHelper as a singleton
    Get.put<SharedPreferenceHelper>(SharedPreferenceHelper());

    // Register ApiHelper as a singleton
    Get.put<ApiHelper>(ApiHelper(ApiConstants.baseUrl, Get.find<SharedPreferenceHelper>()));

    //repo
    Get.put<LoginRepository>(LoginRepository(Get.find<ApiHelper>()));

    // Register LoginBloc as a singleton
    Get.put<LoginBloc>(LoginBloc(Get.find<LoginRepository>()));
  }
}
