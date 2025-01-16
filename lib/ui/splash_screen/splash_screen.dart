import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/common_widgets/version_widget.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var prefs = Get.find<SharedPreferenceHelper>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCloseAlert(context);
    });
  }

  Future<void> _checkLoginStatus() async {
    // Simulate a splash delay
    await Future.delayed(Duration(seconds: 1));

    // Check if the user is logged in
    final isLoggedIn = await prefs.getLoginStatus() ?? false;

    // Navigate to the appropriate screen
    if (isLoggedIn) {
      Get.offNamed(PageRoutes.home);
    } else {
      Get.offNamed(PageRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              'assets/images/pos_logo.svg',
              semanticsLabel: 'logo,',
              width: 175,
              height: 175,
            ),
            SizedBox(height: 20,),
            VersionWidget(fontSize: 20,)
          ],
        ),
      ),
    );
  }
}
