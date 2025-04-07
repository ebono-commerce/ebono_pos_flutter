import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logout_button.dart';

class HomeAppBar extends StatefulWidget {
  final Widget titleWidget;
  final bool showBackButton;

  const HomeAppBar(
      {super.key, required this.titleWidget, this.showBackButton = false});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    print(
        "API healthCheckApiCall initState:  ${homeController.isOnline.value}");
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.grey.shade100,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          widget.showBackButton == true
              ? IconButton(
                  onPressed: () {
                    Get.back();
                    Logger.logButtonPress(button: 'Closed Payment Summery');
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
                Row(
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
                          Obx(() => ImageIcon(
                                size: 20,
                                color: homeController.isOnline.value == true
                                    ? CustomColors.green
                                    : CustomColors.red,
                                homeController.isOnline.value == true
                                    ? AssetImage('assets/images/ic_online.png')
                                    : AssetImage(
                                        'assets/images/ic_offline.png'),
                              )),
                          SizedBox(width: 5),
                          Obx(() => Text(
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
                              )),
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
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: LogoutButton(
              buttonWidth: widget.showBackButton ? 140 : null ),
        )
      ],

      toolbarHeight: kToolbarHeight,
    );
  }
}
