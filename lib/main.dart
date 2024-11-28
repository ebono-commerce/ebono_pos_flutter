import 'package:ebono_pos/navigation/navigation.dart';
import 'package:ebono_pos/theme/theme_data.dart';
import 'package:ebono_pos/utils/SDP.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_manager/window_manager.dart';

import 'di/initial_binding.dart';
import 'navigation/page_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden, // Hide the title bar
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setFullScreen(true); // Make it full-screen
    await windowManager.show();
  });
  await GetStorage.init();
  runApp(const MyApp());
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
