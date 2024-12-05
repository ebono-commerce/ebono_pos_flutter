import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:get/get.dart';

bool isValidOfferId(String offerId) {
  return offerId.length == 8 ||
      offerId.length == 10 ||
      offerId.length == 12 ||
      offerId.length == 13;
}

showCloseAlert(BuildContext context, {bool isAlertShowing = false}) {
  var alertShowing = isAlertShowing;

  ThemeData theme = Theme.of(context);

  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    print('closing window  $alertShowing');
    if (alertShowing) return false;
    alertShowing = true;

    return await Get.dialog(
      AlertDialog(title: const Text('Do you really want to quit?'), actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: CustomColors.primaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(14),
            ),
            backgroundColor: CustomColors.keyBoardBgColor,
          ),
          onPressed: () {
            alertShowing = false;
            Get.back(result: true);
          },
          child: Text(
            'Yes',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: commonElevatedButtonStyle(
              theme: theme,
              textStyle: theme.textTheme.bodyMedium,
              padding: EdgeInsets.all(12)),
          child: Text(
            'No',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            alertShowing = false;
            Get.back();
          },
        ),
      ]),
      barrierDismissible: true,
    );
  });
}

bool isValidPhoneNumber(String phoneNumber) {
  final pattern = r'^[0-9]{10}$';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(phoneNumber);
}
