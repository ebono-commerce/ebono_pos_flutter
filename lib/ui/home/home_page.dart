import 'dart:async';

import 'package:ebono_pos/cubit/connectivity_cubit.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/order_on_hold.dart';
import 'package:ebono_pos/ui/home/orders_section.dart';
import 'package:ebono_pos/ui/home/register_section.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/home/widgets/home_app_bar.dart';
import 'package:ebono_pos/ui/home/widgets/text_button_widget.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/ui/returns/returns_view.dart';
import 'package:ebono_pos/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String port;
  late HomeController homeController;
  late ThemeData theme;
  late ReturnsBloc returnsBloc;
  bool isConnected = true;
  double preferredHeight = kToolbarHeight;
  final networkCubit = Get.find<NetworkCubit>();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        checkConnectivityStatus(networkCubit.state.status);
      }
    });
  }

  void checkConnectivityStatus(ConnectivityStatus status) {
    if (status == ConnectivityStatus.connected) {
      // If connected, set immediately and start a timer to reduce height after animation
      Timer(Duration(seconds: 1), () {
        setState(() {
          isConnected = true;
          // Trigger UI update after the timer completes
        });
        // After the animation completes, update the preferredHeight to 0
        Timer(Duration(milliseconds: 1010), () {
          setState(() {
            preferredHeight = kToolbarHeight;
          });
        });
      });
    } else {
      // If disconnected, set after a delay
      Timer(Duration(seconds: 1), () {
        setState(() {
          isConnected = false;
          preferredHeight += 30;
        });
      });
    }

    // Trigger UI update immediately if connected
    if (status == ConnectivityStatus.connected) {
      setState(() {}); // Update UI immediately
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return BlocConsumer<NetworkCubit, InternetStatus>(
      listener: (context, state) {
        checkConnectivityStatus(state.status);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(preferredHeight),
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              height: isConnected ? kToolbarHeight : kToolbarHeight + 30,
              color: state.status == ConnectivityStatus.connected
                  ? Colors.green
                  : Colors.grey.shade600,
              child: Column(
                children: [
                  HomeAppBar(
                    titleWidget: Obx(() => Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(width: 10),
                            TextButtonWidget(
                              selectedTabButton:
                                  homeController.selectedTabButton.value,
                              buttonIndex: 1,
                              onPressed: () {
                                homeController.selectedTabButton.value = 1;
                              },
                              title: "Register",
                            ),
                            SizedBox(width: 10),
                            TextButtonWidget(
                              selectedTabButton:
                                  homeController.selectedTabButton.value,
                              buttonIndex: 2,
                              onPressed: () {
                                homeController.selectedTabButton.value = 2;
                              },
                              title: "Order",
                            ),
                            SizedBox(width: 10),
                            TextButtonWidget(
                              selectedTabButton:
                                  homeController.selectedTabButton.value,
                              buttonIndex: 3,
                              onPressed: () {
                                homeController.selectedTabButton.value = 3;
                              },
                              title: "Orders on hold",
                            ),
                            SizedBox(width: 10),
                            TextButtonWidget(
                              selectedTabButton:
                                  homeController.selectedTabButton.value,
                              buttonIndex: 4,
                              onPressed: () {
                                if (homeController.selectedTabButton.value ==
                                    4) {
                                  homeController.isReturnViewReset.value = true;
                                } else {
                                  homeController.selectedTabButton.value = 4;
                                }
                              },
                              title: "Returns",
                            ),
                            SizedBox(width: 10),
                          ],
                        )),
                  ),
                  // Animated container to show the internet connectivity status
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    height: isConnected ? 0 : 30,
                    color: state.status == ConnectivityStatus.connected
                        ? Colors.green
                        : Colors.grey.shade600,
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.sizeOf(context).width,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: isConnected ? 0.0 : 1.0,
                        duration: Duration(seconds: 1),
                        child: Text(
                          isConnected
                              ? 'Connected to Internet'
                              : 'No Internet Connection',
                          style: TextStyle(
                              color: isConnected
                                  ? Colors.white
                                  : Colors.grey.shade200,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      },
    );
  }
}
