import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/login/bloc/login_bloc.dart';
import 'package:ebono_pos/ui/login/bloc/login_event.dart';
import 'package:ebono_pos/ui/login/bloc/login_state.dart';
import 'package:ebono_pos/ui/login/repository/login_repository.dart';
import 'package:ebono_pos/ui/payment_summary/weighing_scale_service.dart';
import 'package:ebono_pos/utils/auth_modes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key, this.buttonWidth});
  final double? buttonWidth;
  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final loginBloc = LoginBloc(Get.find<LoginRepository>(),
      Get.find<SharedPreferenceHelper>(), Get.find<HiveStorageHelper>());

  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Get.snackbar("Logout", 'Success');
            if (Get.isRegistered<WeighingScaleService>()) {
              Get.delete<WeighingScaleService>();
            }
            Get.offAllNamed(PageRoutes.login);
          } else if (state is LogoutFailure) {
            Get.snackbar("Logout Error", state.error);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return logoutButton(context, () {
              AuthModes isMandateRegisterCloseOnLogoutEnabled =
                  AuthModeExtension.fromString(homeController
                      .isMandateRegisterCloseOnLogoutEnabled.value);
              if (homeController.registerId.value.isNotEmpty &&
                  isMandateRegisterCloseOnLogoutEnabled == AuthModes.enabled) {
                Get.dialog(
                  AlertDialog(
                    title: Text('Are you sure you want to logout?'),
                    content: Text(
                        'Register is not closed, please close the register and logout\n'),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: CustomColors.keyBoardBgColor,
                              ),
                              child: Text(
                                "No, Cancel",
                                style: TextStyle(
                                    color: CustomColors.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                homeController.selectedTabButton.value = 1;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: CustomColors.secondaryColor,
                              ),
                              child: Text(
                                "Yes, Logout",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).then((_) {
                  homeController.notifyDialogClosed();
                });
              } else {
                loginBloc.add(LogoutButtonPressed(''));
              }
            });
          },
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context, VoidCallback onLogoutPressed) {
    return TextButton.icon(
      onPressed: () {
        onLogoutPressed();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(widget.buttonWidth ?? 150, 50),
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
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: CustomColors.red)),
      ),
    );
  }
}
