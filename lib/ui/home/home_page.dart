import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/ui/home/order_on_hold.dart';
import 'package:kpn_pos_application/ui/home/orders_section.dart';
import 'package:kpn_pos_application/ui/home/register_section.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_bloc.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_event.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_state.dart';
import 'package:kpn_pos_application/ui/login/repository/login_repository.dart';
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
  late String port;

  final String model = 'alfa';
  final int rate = 9600;
  final int timeout = 1000;
  late WeightController weightController;

  late HomeController homeController;
  late ThemeData theme;
  final loginBloc = LoginBloc(
      Get.find<LoginRepository>(), Get.find<SharedPreferenceHelper>());

  @override
  void initState() {
    super.initState();
    if (mounted == true) {
      homeController = Get.find<HomeController>();
      weightController = Get.put(
          WeightController(homeController.portName, model, rate, timeout));
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
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
            Flexible(
              child: GetBuilder<HomeController>(
                  builder: (controller) => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.userDetails.fullName}| ${controller.selectedOutlet}',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: CustomColors.black),
                        // style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isOnline = !isOnline;
                              });
                            },
                            child: Row(
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
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            controller.selectedTerminal,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: CustomColors.black),
                            //  style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),),
            ),

            BlocProvider(
              create: (context) => loginBloc,
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  Get.snackbar("Logout", 'Success');
                  if (state is LogoutSuccess) {
                    Get.offAllNamed(PageRoutes.login);
                  } else if (state is LogoutFailure) {
                    Get.snackbar("Logout Error", state.error);
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return logoutButton(context, () {
                      loginBloc.add(LogoutButtonPressed(''));
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        toolbarHeight: kToolbarHeight,
      ),
      body: Center(
        child: _selectedButton == 1
            ? RegisterSection()
            : _selectedButton == 2
                ? OrdersSection(weightController, homeController)
                : _selectedButton == 3
                    ? OrderOnHold()
                    : Container(),
      ),
    );
  }

  Widget logoutButton(BuildContext context, VoidCallback onLogoutPressed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      child: TextButton.icon(
        onPressed: onLogoutPressed,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.red, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.logout,
            color: CustomColors.red,
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text('LOGOUT',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: CustomColors.red)),
        ),
      ),
    );
  }
}
