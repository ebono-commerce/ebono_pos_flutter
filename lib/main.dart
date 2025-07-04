import 'dart:async';

import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/navigation/navigation.dart';
import 'package:ebono_pos/theme/theme_data.dart';
import 'package:ebono_pos/utils/SDP.dart';
import 'package:ebono_pos/utils/logger.dart';
import 'package:ebono_pos/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'cubit/training_mode_cubit.dart';
import 'di/initial_binding.dart';
import 'navigation/page_routes.dart';

bool showCustomError = false;

void main() async {
  runZonedGuarded(() async {
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
    });

    await HiveStorageHelper.init();
    await Logger.init();

    if (showCustomError) {
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return CustomErrorWidget(details: details);
      };
    }

    runApp(
      BlocProvider(
        create: (_) => TrainingModeCubit(),
        child: const MyApp(),
      ),
    );

    // Use immersiveSticky to hide all system UI overlays
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Add specific UI overlay settings for Linux touch screens
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
  }, (error, stackTrace) {
    if (String.fromEnvironment('ENV') != 'prod') {
      Get.snackbar('Root Error', '${error.toString()} $stackTrace');
      print("err: $error $stackTrace");
    }
    Logger.logException(
      eventType: 'EXCEPTION: ROOT',
      error: error.toString(),
      stackTrace: stackTrace.toString(),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SDP.init(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PageRoutes.splashScreen,
      theme: themeData(context),
      initialBinding: InitialBinding(),
      getPages: getPages(),

      // Inject your Training Mode Notch here
      builder: (context, child) {
        return BlocBuilder<TrainingModeCubit, bool>(
          builder: (context, isTestModeEnabled) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isTestModeEnabled
                      ? Color(0xFFFA0E64)
                      : Colors.transparent,
                  width: 8,
                ), // Red border
              ),
              child: Stack(
                children: [
                  child!, // The actual app
                  Visibility(
                    visible: isTestModeEnabled,
                    child: Positioned(
                      top: 0,
                      // left: 10,
                      left: MediaQuery.sizeOf(context).width * 0.68,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 5,
                            top: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFA0E64),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: const Text(
                            'Training Mode',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
