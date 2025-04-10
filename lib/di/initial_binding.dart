import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/api/environment_config.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/login/repository/login_repository.dart';
import 'package:ebono_pos/ui/payment_summary/repository/PaymentRepository.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/ui/returns/repository/returns_repository.dart';
import 'package:ebono_pos/ui/search/repository/search_repository.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core singletons
    Get.put<SharedPreferenceHelper>(SharedPreferenceHelper());
    Get.put<HiveStorageHelper>(HiveStorageHelper());

    Get.put<ApiHelper>(ApiHelper(
      EnvironmentConfig.baseUrl,
      Get.find<SharedPreferenceHelper>(),
      Get.find<HiveStorageHelper>(),
    ));

    // Repositories first
    Get.put<HomeRepository>(HomeRepository(Get.find<ApiHelper>()));
    Get.put<LoginRepository>(LoginRepository(Get.find<ApiHelper>()));
    Get.put<PaymentRepository>(PaymentRepository(Get.find<ApiHelper>()));
    Get.put<SearchRepository>(SearchRepository(Get.find<ApiHelper>()));

    // Then controller that depends on them
    Get.put<HomeController>(HomeController(
      Get.find<HomeRepository>(),
      Get.find<SharedPreferenceHelper>(),
      Get.find<HiveStorageHelper>(),
    ));

    // Now that HomeController is available, register the repo that uses it
    Get.put<ReturnsRepository>(ReturnsRepository(
      Get.find<ApiHelper>(),
      Get.find<HomeController>(),
    ));

    // Bloc last
    Get.put<ReturnsBloc>(ReturnsBloc(Get.find<ReturnsRepository>()));
  }
}
