import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/navigation/navigation.dart';
import 'package:ebono_pos/theme/theme_data.dart';
import 'package:ebono_pos/utils/SDP.dart';
import 'package:ebono_pos/utils/logger.dart';
import 'package:ebono_pos/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'di/initial_binding.dart';
import 'navigation/page_routes.dart';

bool showCustomError = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden, // Hide the title bar
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setFullScreen(true);
    await windowManager.show();

    // // Add a listener to monitor and restore full screen mode
    // windowManager.addListener(CustomWindowListener(onWindowResized: () async {
    //   Get.snackbar('BLUR', 'window resize');
    //   bool isFullScreen = await windowManager.isFullScreen();
    //   if (!isFullScreen) {
    //     await windowManager.setFullScreen(true);
    //   }
    // }, onWindowFocus: () async {
    //   Get.snackbar('BLUR', 'window focus');
    //   // Immediately attempt to restore fullscreen without delay
    //   await windowManager.setFullScreen(true);
    // },
    //     // Add this new handler for blur events
    //     onWindowBlur: () async {
    //   Get.snackbar('BLUR', 'window blur');
    //   // Schedule a check to restore fullscreen after blur
    //   Timer(const Duration(milliseconds: 2), () async {
    //     await windowManager.setFullScreen(true);
    //   });
    // }, onWindowRestore: () async {
    //   Get.snackbar('BLUR', 'window restore');
    //   // Schedule a check to restore fullscreen after blur
    //   Timer(const Duration(milliseconds: 2), () async {
    //     await windowManager.setFullScreen(true);
    //   });
    // }));
  });

  await HiveStorageHelper.init();
  await Logger.init();

  if (showCustomError) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return CustomErrorWidget(details: details);
    };
  }

  runApp(const MyApp());

  // Use immersiveSticky to hide all system UI overlays
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Add specific UI overlay settings for Linux touch screens
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: PageRoutes.splashScreen,
        theme: themeData(context),
        initialBinding: InitialBinding(),
        getPages: getPages(),
      ),
    );
  }
}
