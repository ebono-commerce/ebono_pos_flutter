import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';

class CouponCodeWidget extends StatefulWidget {
  final HomeController homeController;
  final BuildContext dialogContext;


  const CouponCodeWidget(this.homeController, this.dialogContext, {super.key});

  @override
  State<CouponCodeWidget> createState() =>
      _CouponCodeWidgetState();
}

class _CouponCodeWidgetState
    extends State<CouponCodeWidget> {
  late HomeController homeController;
  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode couponCodeFocusNode = FocusNode();
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    homeController = widget.homeController;

    if (!couponCodeFocusNode.hasFocus) {
      couponCodeFocusNode.requestFocus();
    }

    couponCodeFocusNode.addListener(() {
      setState(() {
        _qwertyPadController.text = couponCodeController.text;
      });
    });

    _qwertyPadController.addListener(() {
      setState(() {
        couponCodeController.text = _qwertyPadController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(width: 900,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 18),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(widget.dialogContext);
                  },
                  child: SvgPicture.asset(
                    'assets/images/ic_close.svg',
                    semanticsLabel: 'cash icon,',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),),
        SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                "Enter Coupon Code",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.black,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: commonTextField(
                      label: "Coupon Code",
                      controller: couponCodeController,
                      focusNode: couponCodeFocusNode,
                      onValueChanged: (value) =>
                      value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(flex: 1, child: applyButton()),
                  Expanded(flex: 1, child: closeButton())
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 900,
          child: CustomQwertyPad(
            textController: _qwertyPadController,
            focusNode: couponCodeFocusNode,
            onEnterPressed: (value) {
              if (!couponCodeFocusNode.hasFocus) {
                couponCodeFocusNode.requestFocus();
              } else {
                couponCodeFocusNode.unfocus();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget applyButton() {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        style: commonElevatedButtonStyle(
            theme: theme,
            textStyle: theme.textTheme.bodyMedium,
            padding: EdgeInsets.all(12)),
        onPressed: () {
          Navigator.pop(widget.dialogContext);
          Get.snackbar("Not yet implemented", 'Not yet implemented');
        },
        child: Text(
          "Apply",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget closeButton() {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(widget.dialogContext);
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: CustomColors.keyBoardBgColor,
        ),
        child: Center(
          child: Text("Close",
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }
}
