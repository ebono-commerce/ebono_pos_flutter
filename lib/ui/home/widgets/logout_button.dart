import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/data_store/get_storage_helper.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/login/bloc/login_bloc.dart';
import 'package:ebono_pos/ui/login/bloc/login_event.dart';
import 'package:ebono_pos/ui/login/bloc/login_state.dart';
import 'package:ebono_pos/ui/login/repository/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LogoutButton extends StatefulWidget {
   const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {

  final loginBloc = LoginBloc(
      Get.find<LoginRepository>(), Get.find<SharedPreferenceHelper>(), Get.find<GetStorageHelper>(), Get.find<HiveStorageHelper>());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Get.snackbar("Logout", 'Success');
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
    );
  }

  Widget logoutButton(BuildContext context, VoidCallback onLogoutPressed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      child: TextButton.icon(
        onPressed: (){
          onLogoutPressed();
        },
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
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: CustomColors.red)),
        ),
      ),
    );
  }
}
