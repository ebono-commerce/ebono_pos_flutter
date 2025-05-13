import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/navigation/navigation.dart';
import 'package:ebono_pos/theme/theme_data.dart';
import 'package:ebono_pos/utils/SDP.dart';
import 'package:ebono_pos/utils/logger.dart';
import 'package:ebono_pos/utils/window_listener.dart';
import 'package:ebono_pos/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.setFullScreen(true);
  //   await windowManager.show();
  // });

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setFullScreen(true);
    await windowManager.show();

    // Add a listener to monitor and restore full screen mode
    windowManager.addListener(CustomWindowListener(
      onWindowResized: () async {
        bool isFullScreen = await windowManager.isFullScreen();
        await Future.delayed(Duration(seconds: 2)).then((_) async {
          if (!isFullScreen) {
            await windowManager.setFullScreen(true);
          }
        });
      },
      onWindowFocus: () async {
        bool isFullScreen = await windowManager.isFullScreen();
        if (!isFullScreen) {
          await windowManager.setFullScreen(true);
        }
      },
    ));
  });

  await HiveStorageHelper.init();
  await Logger.init();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(details: details);
  };

  runApp(const MyApp());
}

/*void getHiveDirectory() async {
  final directory = await getApplicationSupportDirectory();
  print("Hive Directory: ${directory.path}");
}*/

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
