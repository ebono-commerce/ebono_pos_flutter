import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String errorMessage;
  final Widget iconWidget;
  final VoidCallback onPressed;

  const ErrorDialogWidget({
    super.key,
    required this.errorMessage,
    required this.iconWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: MediaQuery.sizeOf(context).height * 0.41,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: onPressed,
              child: iconWidget,
            ),
            SizedBox(height: 30),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 50),
                backgroundColor: CustomColors.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('OK'),
            )
          ],
        ),
      ),
    );
  }
}
