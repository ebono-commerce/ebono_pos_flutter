import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/navigation/navigation.dart';
import 'package:kpn_pos_application/theme/theme_data.dart';
import 'package:kpn_pos_application/utils/SDP.dart';

import 'di/initial_binding.dart';
import 'navigation/page_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    return GetMaterialApp(
      initialRoute: PageRoutes.home,
      theme: themeData(context),
      initialBinding: InitialBinding(),
      getPages: getPages(),
    );
  }
}
