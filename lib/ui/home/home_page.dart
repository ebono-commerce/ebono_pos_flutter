import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/ui/home/order_on_hold.dart';
import 'package:kpn_pos_application/ui/home/orders_section.dart';
import 'package:kpn_pos_application/ui/home/register_section.dart';
import 'package:kpn_pos_application/ui/payment_summary/weight_controller.dart';
import 'package:kpn_pos_application/vm/home_vm.dart';

class HomePage extends StatefulWidget {
  final HomeViewModel homeViewModel;

  const HomePage({super.key, required this.homeViewModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedButton = 2;
  bool isOnline = false;
  final String port = '/dev/ttyUSB0'; // Replace with actual port
  final String model = 'alfa';
  final int rate = 9600;
  final int timeout = 1000;
  late WeightController weightController;

  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    if (mounted == true) {
      weightController = Get.put(WeightController(port, model, rate, timeout));
      homeController = Get.put(HomeController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade100,
        title: Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    backgroundColor: _selectedButton == 1
                        ? Colors.white
                        : Colors.grey.shade100,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedButton = 1;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Register',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(),
                        //   style: TextStyle(color: Colors.black),
                      ),
                      _selectedButton == 1
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
                    backgroundColor: _selectedButton == 2
                        ? Colors.white
                        : Colors.grey.shade100,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedButton = 2;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Order',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(),
                        // style: TextStyle(color: Colors.black),
                      ),
                      _selectedButton == 2
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
                    backgroundColor: _selectedButton == 3
                        ? Colors.white
                        : Colors.grey.shade100,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedButton = 3;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Orders on hold',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(),
                        //  style: TextStyle(color: Colors.black),
                      ),
                      _selectedButton == 3
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
            ),
            Spacer(),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Name | Andheri East',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: CustomColors.black),
                    // style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isOnline = !isOnline;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ImageIcon(
                          size: 20,
                          color: isOnline == true
                              ? CustomColors.green
                              : CustomColors.red,
                          isOnline == true
                              ? AssetImage('assets/images/ic_online.png')
                              : AssetImage('assets/images/ic_offline.png'),
                        ),
                        SizedBox(width: 5),
                        Text(
                          isOnline == true ? 'ONLINE' : "OFFLINE",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  color: isOnline == true
                                      ? CustomColors.green
                                      : CustomColors.red),
                          //  style: TextStyle(color: Colors.green, fontSize: 11),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Counter 12',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: CustomColors.black),
                          //  style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        toolbarHeight: kToolbarHeight,
      ),
      body: Center(
        child: _selectedButton == 1
            ? RegisterSection(weightController, homeController)
            : _selectedButton == 2
                ? OrdersSection(weightController, homeController)
                : _selectedButton == 3
                    ? OrderOnHold()
                    : Container(),
      ),
    );
  }
}
