import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/models/coupon_details.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CouponCodeWidget extends StatefulWidget {
  final CouponDetails? couponDetails;
  final BuildContext dialogContext;

  const CouponCodeWidget(
    this.dialogContext, {
    super.key,
    this.couponDetails = const CouponDetails(),
  });

  @override
  State<CouponCodeWidget> createState() => _CouponCodeWidgetState();
}

class _CouponCodeWidgetState extends State<CouponCodeWidget> {
  late ThemeData theme;
  HomeController homeController = Get.find<HomeController>();

  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode couponCodeFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool isInvalidCoupon = false;
  bool isValidCoupon = false;
  bool isNewCoupon = false;
  bool onResponse = false;
  bool isResponseReset = false;

  late CouponDetails? coupon;

  @override
  void initState() {
    super.initState();

    setState(() {
      coupon = widget.couponDetails;
    });

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

    /* 
    * if coupon is not applied due to some error, when coupon screen is opened,
    * it will show the relavent error 
    */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (mounted && coupon != null) {
          /* 
          * flag to check initial error & make api call on tap remove 
          */
          if (coupon?.isApplied! == false) {
            couponCodeController.text = coupon!.couponCode.toString();
            isInvalidCoupon = true;
            isNewCoupon = false;
            isValidCoupon = false;
            _formKey.currentState?.validate();
          } else if (coupon?.isApplied! == true) {
            couponCodeController.text = coupon!.couponCode.toString();
            isInvalidCoupon = true;
            isNewCoupon = false;
            isValidCoupon = false;
            _formKey.currentState?.validate();
          }
        } else if (mounted && coupon == null) {
          isNewCoupon = true;
          isInvalidCoupon = false;
          isValidCoupon = false;
        }
      });
    });
  }

  void updateCouponDetauls(CartResponse? cartResponse) {
    if (cartResponse?.couponDetails == null) {
      /* REMOVE COUPON */
      _formKey.currentState?.reset();
      setState(() {
        isInvalidCoupon = false;
        isNewCoupon = true;
        isValidCoupon = false;
        coupon = cartResponse?.couponDetails;
        couponCodeController.clear();
      });
    } else if (cartResponse?.couponDetails?.isApplied == false) {
      /* INVALID COUPON */
      setState(() {
        isInvalidCoupon = true;
        isNewCoupon = false;
        isValidCoupon = false;
        coupon = cartResponse?.couponDetails;
      });
      _formKey.currentState?.validate();
    } else if (cartResponse?.couponDetails?.isApplied == true) {
      /* COUPON APPLIED SUCCESS */
      setState(() {
        isInvalidCoupon = false;
        isNewCoupon = false;
        isValidCoupon = true;
        coupon = cartResponse?.couponDetails;
      });
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: 900,
          child: Row(
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
          ),
        ),
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
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Form(
                      key: _formKey,
                      child: commonTextField(
                        label: "Coupon Code",
                        controller: couponCodeController,
                        focusNode: couponCodeFocusNode,
                        readOnly: isInvalidCoupon,
                        helperText: coupon?.message,
                        helperTextStyle: theme.textTheme.titleSmall!.copyWith(
                          color: CustomColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (value) {
                          if (coupon?.couponCode != null &&
                              coupon?.isApplied! == false) {
                            return coupon?.message;
                          } else if (value!.isEmpty) {
                            return "Please Enter Coupon Code";
                          }

                          return null;
                        },
                        onValueChanged: (value) {},
                      ),
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
        onPressed: () async {
          if ((isInvalidCoupon || isValidCoupon) &&
              _formKey.currentState!.validate()) {
            await homeController
                .addOrRemoveCoupon(
              coupon: couponCodeController.text,
              isRemoveCoupon: true,
            )
                .then((cartResponse) {
              updateCouponDetauls(cartResponse);
            });
          } else if (isNewCoupon && _formKey.currentState!.validate()) {
            await homeController
                .addOrRemoveCoupon(
              coupon: couponCodeController.text,
              isRemoveCoupon: false,
            )
                .then((cartResponse) {
              updateCouponDetauls(cartResponse);
            });
          } else {
            await homeController
                .addOrRemoveCoupon(
              coupon: couponCodeController.text,
              isRemoveCoupon: true,
            )
                .then((cartResponse) {
              updateCouponDetauls(cartResponse);
            });
          }
        },
        /* 
        * if coupon if coupon object is exists, irrespective of appiled or not, we are showing to remove
        * else we are asking user to apply coupon
        */
        child: Text(
          (isInvalidCoupon || isValidCoupon) ? "Remove" : "Apply",
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
          child: Text(
            "Close",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: CustomColors.primaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
