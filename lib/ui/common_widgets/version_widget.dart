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
    String environment =
        const String.fromEnvironment('ENV', defaultValue: 'stage');

    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([
        PackageInfo.fromPlatform(),
        sharedPrefs.pointingTo(),
      ]).then((values) => {
            'packageInfo': values[0] as PackageInfo,
            'pointingTo': values[1] as String,
          }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final packageInfo = snapshot.data!['packageInfo'] as PackageInfo;
        final pointingTo = snapshot.data!['pointingTo'] as String;

        return Text(
          '(SAVOmart $environment $pointingTo - ${packageInfo.version})',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: fontSize),
        );
      },
    );
  }
}
