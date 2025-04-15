import 'package:audioplayers/audioplayers.dart';
import 'package:ebono_pos/widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Future<void> showStopperError({
  required String errorMessage,
  bool isScanApiError = true,
}) async {
  // Add the sound playing logic before showing dialog
  final player = AudioPlayer();
  await player.play(AssetSource(
      isScanApiError ? 'audio/error.mp3' : 'audio/add_to_cart.mp3'));

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ErrorDialogWidget(
        onPressed: () => Get.back(),
        errorMessage: errorMessage,
        iconWidget: SvgPicture.asset(
          'assets/images/ic_close.svg',
          width: 80,
          height: 80,
        ),
      ),
    ),
    barrierDismissible: true,
    useSafeArea: false,
  );
}
