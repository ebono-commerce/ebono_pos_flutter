import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/order_on_hold.dart';
import 'package:ebono_pos/ui/home/orders_section.dart';
import 'package:ebono_pos/ui/home/register_section.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/home/widgets/home_app_bar.dart';
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

  @override
  void initState() {
    super.initState();
    if (mounted) {
      try {
        homeController = Get.find<HomeController>();
        print("HomeController initialized.");
      } catch (e) {
        print("HomeController not found: $e");
        homeController =  Get.put<HomeController>( HomeController(Get.find<HomeRepository>(),
            Get.find<SharedPreferenceHelper>(), Get.find<HiveStorageHelper>()));
      }
    } }
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
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        backgroundColor:
                            homeController.selectedTabButton.value == 1
                                ? Colors.white
                                : Colors.grey.shade100,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          homeController.selectedTabButton.value = 1;
                          print(
                              "selectedTabButton H: ${homeController.selectedTabButton.value}");
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Register',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(),
                            //   style: TextStyle(color: Colors.black),
                          ),
                          homeController.selectedTabButton.value == 1
                              ? Container(
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 8,
                                  height: 8,
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        backgroundColor:
                            homeController.selectedTabButton.value == 2
                                ? Colors.white
                                : Colors.grey.shade100,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          homeController.selectedTabButton.value = 2;
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Order',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(),
                            // style: TextStyle(color: Colors.black),
                          ),
                          homeController.selectedTabButton.value == 2
                              ? Container(
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 8,
                                  height: 8,
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        backgroundColor:
                            homeController.selectedTabButton.value == 3
                                ? Colors.white
                                : Colors.grey.shade100,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          homeController.selectedTabButton.value = 3;
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Orders on hold',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(),
                            //  style: TextStyle(color: Colors.black),
                          ),
                          homeController.selectedTabButton.value == 3
                              ? Container(
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 8,
                                  height: 8,
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
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
                        : Container(),
          )),
    );
  }
}
