import 'package:get/get.dart';
import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/data_store/get_storage_helper.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/ui/home/repository/home_repository.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_bloc.dart';
import 'package:kpn_pos_application/ui/login/repository/login_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register SharedPreferenceHelper as a singleton
    Get.put<SharedPreferenceHelper>(SharedPreferenceHelper());
    Get.put<GetStorageHelper>(GetStorageHelper());


    // Register ApiHelper as a singleton
    Get.put<ApiHelper>(
        ApiHelper(ApiConstants.baseUrl, Get.find<SharedPreferenceHelper>()));

    //repo
    Get.put<LoginRepository>(LoginRepository(Get.find<ApiHelper>()));
    Get.put<HomeRepository>(HomeRepository(Get.find<ApiHelper>()));

    /*// Register LoginBloc as a singleton
    Get.put<LoginBloc>(LoginBloc(
        Get.find<LoginRepository>(), Get.find<SharedPreferenceHelper>()));*/
    // Register HomeController as a singleton
    Get.put<HomeController>(
        HomeController(Get.find<HomeRepository>(), Get.find<ApiHelper>(), Get.find<SharedPreferenceHelper>()));
  }
}
