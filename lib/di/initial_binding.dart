import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/data_store/get_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/orders_on_hold/repository/orders_on_hold_repository.dart';
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

    // Register ApiHelper as a singleton
    Get.put<ApiHelper>(
        ApiHelper(ApiConstants.baseUrl, Get.find<SharedPreferenceHelper>()));

    //repo
    Get.put<LoginRepository>(LoginRepository(Get.find<ApiHelper>()));
    Get.put<HomeRepository>(HomeRepository(Get.find<ApiHelper>()));
    Get.put<PaymentRepository>(PaymentRepository(Get.find<ApiHelper>()));
    Get.put<OrdersOnHoldRepository>(
        OrdersOnHoldRepository(Get.find<ApiHelper>()));

    /*// Register LoginBloc as a singleton
    Get.put<LoginBloc>(LoginBloc(
        Get.find<LoginRepository>(), Get.find<SharedPreferenceHelper>()));*/
    // Register HomeController as a singleton
    /*Get.put<HomeController>(
        HomeController(Get.find<HomeRepository>(), Get.find<SharedPreferenceHelper>()));*/
  }
}
