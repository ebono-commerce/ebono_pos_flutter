import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ebono_pos/navigation/navigation.dart';
import 'package:ebono_pos/theme/theme_data.dart';
import 'package:ebono_pos/utils/SDP.dart';
import 'di/initial_binding.dart';
import 'navigation/page_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    if(Platform.isLinux){
      FlutterWindowClose.setWindowShouldCloseHandler(() async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Do you really want to quit?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes')),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No')),
                  ]);
            });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    return SafeArea(
      child: GetMaterialApp(
        initialRoute: PageRoutes.splashScreen,
        theme: themeData(context),
        initialBinding: InitialBinding(),
        getPages: getPages(),
      ),
    );
  }
}
