import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionWidget extends StatelessWidget {
  final double fontSize;

  const VersionWidget({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('');
        } else if (snapshot.hasError) {
          return Text('');
        } else if (snapshot.hasData) {
          final packageInfo = snapshot.data!;
          final version = packageInfo.version;
          return Text(
            '(SAVOmart - $version)',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: fontSize),
          );
        } else {
          return Text('');
        }
      },
    );
  }
}
