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
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            homeController.userDetails.value.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: CustomColors.black),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      Text(
                        ' | ',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Expanded(
                        child: Obx(
                          () => Text(
                            homeController.selectedOutlet.value,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: CustomColors.black),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            Obx(
                              () {
                                Color indicationColor = Colors.green;
                                String toolTipMsg = '';
                                if (homeController.pointedTo.value == 'CLOUD') {
                                  indicationColor = Colors.green;
                                  toolTipMsg = 'Connected to Cloud';
                                } else if (homeController.pointedTo.value ==
                                    'LOCAL') {
                                  indicationColor = Colors.yellow.shade700;
                                  toolTipMsg = 'Local Billing Active';
                                } else {
                                  indicationColor = Colors.red;
                                  toolTipMsg =
                                      'Internet Connection Lost - Retry or Notify Manager';
                                }
                                return Tooltip(
                                  message: toolTipMsg,
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: ColoredBox(color: indicationColor),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Obx(
                              () => Text(
                                homeController.pointedTo.value == 'LOCAL'
                                    ? 'LOCAL'
                                    : 'CLOUD',
                                style: Theme.of(context).textTheme.labelMedium,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        ' | ',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Expanded(
                        child: Obx(
                          () => Text(
                            homeController.selectedTerminal.value,
                            style: Theme.of(context).textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer()
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: LogoutButton(buttonWidth: widget.showBackButton ? 140 : null),
        )
      ],
      toolbarHeight: kToolbarHeight,
    );
  }
}
