import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

bool isValidOfferId(String offerId) {
  return offerId.length == 8 ||
      offerId.length == 10 ||
      offerId.length == 12 ||
      offerId.length == 13;
}

showCloseAlert(BuildContext context) {
  var alertShowing = false;

  ThemeData theme = Theme.of(context);

  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    print('closing window  $alertShowing');
    if (alertShowing) return false;
    alertShowing = true;

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Do you really want to quit?'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: CustomColors.primaryColor, width: 1.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: CustomColors.keyBoardBgColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    alertShowing = false;
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
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
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    alertShowing = false;
                  },
                ),
              ]);
        });
  });
}
