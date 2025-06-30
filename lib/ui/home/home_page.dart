import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/order_on_hold.dart';
import 'package:ebono_pos/ui/home/orders_section.dart';
import 'package:ebono_pos/ui/home/register_section.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/home/widgets/authorisation_required_widget.dart';
import 'package:ebono_pos/ui/home/widgets/home_app_bar.dart';
import 'package:ebono_pos/ui/home/widgets/text_button_widget.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/ui/returns/returns_view.dart';
import 'package:ebono_pos/utils/auth_modes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int _selectedButton = 2;

  // bool isOnline = false;
  late String port;
  late HomeController homeController;
  late ThemeData theme;
  late ReturnsBloc returnsBloc;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      try {
        returnsBloc = ReturnsBloc(Get.find());
        homeController = Get.find<HomeController>();
        print("HomeController initialized.");
      } catch (e) {
        print("HomeController not found: $e");
        homeController = Get.put<HomeController>(HomeController(
            Get.find<HomeRepository>(),
            Get.find<SharedPreferenceHelper>(),
            Get.find<HiveStorageHelper>()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: HomeAppBar(
            titleWidget: Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    TextButtonWidget(
                      selectedTabButton: homeController.selectedTabButton.value,
                      buttonIndex: 1,
                      onPressed: () {
                        homeController.selectedTabButton.value = 1;
                      },
                      title: "Register",
                    ),
                    SizedBox(width: 10),
                    TextButtonWidget(
                      selectedTabButton: homeController.selectedTabButton.value,
                      buttonIndex: 2,
                      onPressed: () {
                        homeController.selectedTabButton.value = 2;
                      },
                      title: "Order",
                    ),
                    SizedBox(width: 10),
                    TextButtonWidget(
                      selectedTabButton: homeController.selectedTabButton.value,
                      buttonIndex: 3,
                      onPressed: () {
                        homeController.selectedTabButton.value = 3;
                      },
                      title: "Orders on hold",
                    ),
                    SizedBox(width: 10),
                    TextButtonWidget(
                      selectedTabButton: homeController.selectedTabButton.value,
                      buttonIndex: 4,
                      onPressed: () {
                        AuthModes returnsEnabledMode =
                            AuthModeExtension.fromString(
                                homeController.isReturnViewEnabled.value);
                        if (returnsEnabledMode == AuthModes.enabled ||
                            homeController
                                .returnsViewApproverUserId.value.isNotEmpty) {
                          if (homeController.selectedTabButton.value == 4) {
                            homeController.isReturnViewReset.value = true;
                          } else {
                            homeController.selectedTabButton.value = 4;
                          }
                        } else if (returnsEnabledMode == AuthModes.authorised) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: AuthorisationRequiredWidget(
                                  context,
                                  'RETURNS',
                                  onAuthSuccess: () {
                                    if (homeController
                                            .selectedTabButton.value ==
                                        4) {
                                      homeController.isReturnViewReset.value =
                                          true;
                                    } else {
                                      homeController.selectedTabButton.value =
                                          4;
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          Get.snackbar('Action Disabled for this account',
                              'Please contact support');
                        }
                      },
                      title: "Returns",
                    ),
                    SizedBox(width: 10),
                  ],
                )),
          )),
      body: Obx(() => Center(
            child: homeController.selectedTabButton.value == 1
                ? RegisterSection()
                : homeController.selectedTabButton.value == 2
                    ? OrdersSection()
                    : homeController.selectedTabButton.value == 3
                        ? OrderOnHold()
                        : ReturnsView(),
          )),
    );
  }
}
