import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/data_store/get_storage_helper.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/login/repository/login_repository.dart';
import 'package:ebono_pos/ui/payment_summary/repository/PaymentRepository.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register SharedPreferenceHelper as a singleton
    Get.put<SharedPreferenceHelper>(SharedPreferenceHelper());
    Get.put<GetStorageHelper>(GetStorageHelper());
    Get.put<HiveStorageHelper>(HiveStorageHelper());

    // Register ApiHelper as a singleton
    Get.put<ApiHelper>(
        ApiHelper(ApiConstants.baseUrl, Get.find<SharedPreferenceHelper>(), Get.find<GetStorageHelper>(), Get.find<HiveStorageHelper>()));

    //repo
    Get.put<LoginRepository>(LoginRepository(Get.find<ApiHelper>()));
    Get.put<HomeRepository>(HomeRepository(Get.find<ApiHelper>()));
    Get.put<PaymentRepository>(PaymentRepository(Get.find<ApiHelper>()));

    /*// Register LoginBloc as a singleton
    Get.put<LoginBloc>(LoginBloc(
        Get.find<LoginRepository>(), Get.find<SharedPreferenceHelper>()));*/
    // Register HomeController as a singleton

    Get.lazyPut<HomeController>(() => HomeController(Get.find<HomeRepository>(),
        Get.find<SharedPreferenceHelper>(), Get.find<GetStorageHelper>(), Get.find<HiveStorageHelper>()));
  }
}
