import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';

import 'logout_button.dart';

class HomeAppBar extends StatefulWidget {
  final Widget titleWidget;
  final HomeController homeController;
  final bool showBackButton;

  const HomeAppBar(
      {super.key,
      required this.homeController,
      required this.titleWidget,
      this.showBackButton = false});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  late HomeController homeController;

  //bool isOnline = false;

  @override
  void initState() {
    super.initState();
    if (mounted == true) {
      homeController = widget.homeController;
      homeController.healthCheckApiCall();
    }
    print(
        "API healthCheckApiCall initState:  ${homeController.isOnline.value}");
  }

  @override
  Widget build(BuildContext context) {
    print(
        "API healthCheckApiCall initState:  ${homeController.isOnline.value}");
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.grey.shade100,
      title: Row(
        children: [
          widget.showBackButton == true
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: ImageIcon(
                      size: 16, AssetImage('assets/images/ic_cancel.png')))
              : SizedBox(),
          widget.titleWidget,
          Spacer(),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    '${homeController.userDetails.value.fullName}| ${homeController.selectedOutlet.value}',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: CustomColors.black),
                    // style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
                SizedBox(height: 5),
                Obx(() => Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {},
                          // onTap: () {
                          //   setState(() {
                          //     isOnline = !isOnline;
                          //   });
                          // },
                          child: Row(
                            children: [
                              ImageIcon(
                                size: 20,
                                color: homeController.isOnline.value == true
                                    ? CustomColors.green
                                    : CustomColors.red,
                                homeController.isOnline.value == true
                                    ? AssetImage('assets/images/ic_online.png')
                                    : AssetImage(
                                        'assets/images/ic_offline.png'),
                              ),
                              SizedBox(width: 5),
                              Text(
                                homeController.isOnline.value == true
                                    ? 'ONLINE'
                                    : "OFFLINE",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: homeController.isOnline.value ==
                                                true
                                            ? CustomColors.green
                                            : CustomColors.red),
                                //  style: TextStyle(color: Colors.green, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Obx(
                          () => Text(
                            homeController.selectedTerminal.value,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: CustomColors.black),
                            //  style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          LogoutButton()
        ],
      ),
      toolbarHeight: kToolbarHeight,
    );
  }
}
