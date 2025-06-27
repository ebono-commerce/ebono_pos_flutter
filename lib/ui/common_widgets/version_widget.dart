import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionWidget extends StatelessWidget {
  final double fontSize;

  const VersionWidget({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final sharedPrefs = Get.find<SharedPreferenceHelper>();
    String environment = String.fromEnvironment('ENV', defaultValue: 'prod');

    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([
        PackageInfo.fromPlatform(),
        sharedPrefs.pointingTo(),
      ]).then((values) => {
            'packageInfo': values[0] as PackageInfo,
            'pointingTo': values[1] as String,
          }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('');
        } else if (snapshot.hasError) {
          return Text('');
        } else if (snapshot.hasData) {
          final packageInfo = snapshot.data!['packageInfo'] as PackageInfo;
          final pointingTo = snapshot.data!['pointingTo'] as String;
          final version = packageInfo.version;
          return Text(
            '(SAVOmart $environment $pointingTo - $version)',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: fontSize),
          );
        } else {
          return Text('');
        }
      },
    );
  }
}
