import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/common_widgets/version_widget.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:ebono_pos/utils/helper.dart';
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
  String detectedPort = "Detecting weighing scale...";
  bool isDetecting = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detectWeighingScale();
      showCloseAlert(context);
    });
  }

  Future<void> _detectWeighingScale() async {
    try {
      final port = await detectWeighingPort();
      setState(() {
        detectedPort = port;
        isDetecting = false;
      });

      print("PORT RESULT: $port");

      Get.snackbar(
        'Scale Detection',
        port.contains('No weighing')
            ? 'No scale found'
            : 'Found scale on $port',
        duration: const Duration(seconds: 3),
        backgroundColor: port.contains('No weighing')
            ? Colors.orange.withOpacity(0.8)
            : Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        detectedPort = "Error detecting port: $e";
        isDetecting = false;
      });
    } finally {
      _checkLoginStatus();
    }
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
            SizedBox(
              height: 20,
            ),
            VersionWidget(
              fontSize: 20,
            )
          ],
        ),
      ),
    );
  }
}
