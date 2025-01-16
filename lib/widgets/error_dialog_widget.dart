import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String errorMessage;
  const ErrorDialogWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: SvgPicture.asset(
                'assets/images/ic_close.svg',
                width: 80,
                height: 80,
              ),
            ),
            SizedBox(height: 30),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.back(),
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
