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
      setState(() {
        detectedPort = "Detecting FIDI USB Serial Device...";
        isDetecting = true;
      });

      final port = await detectWeighingPort();

      final bool isSuccess =
          port.contains('ttyUSB') && !port.contains('No weighing');

      setState(() {
        detectedPort = port;
        isDetecting = false;
      });

      print("PORT RESULT: $port");

      // Show snackbar with port result
      Get.snackbar(
        'Scale Detection',
        isSuccess ? 'Found scale on $port' : 'Scale detection issue: $port',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: isSuccess
            ? Colors.green.withOpacity(0.8)
            : Colors.orange.withOpacity(0.8),
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
    // Give some time to read the detection result
    await Future.delayed(Duration(seconds: 2));

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
    // Determine if port detection was successful
    final bool isSuccess = detectedPort.contains('ttyUSB') &&
        !detectedPort.contains('No weighing');

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
            SizedBox(height: 20),
            VersionWidget(fontSize: 20),
            SizedBox(height: 30),
            if (isDetecting) CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                detectedPort,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.orange,
                ),
              ),
            ),
            if (!isDetecting && !isSuccess)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Troubleshooting tips:\n'
                  '• Check device permissions (sudo chmod 777 /dev/ttyUSB0)\n'
                  '• Try unplugging and reconnecting the USB cable\n'
                  '• Make sure the scale is sending data (some scales need a button press)\n'
                  '• Try a different USB port',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
