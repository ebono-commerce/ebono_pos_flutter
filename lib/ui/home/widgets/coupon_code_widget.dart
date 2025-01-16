import 'package:ebono_pos/constants/custom_colors.dart';
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
  bool isInitialErrorShown = false;

  @override
  void initState() {
    super.initState();

    /* 
    * checking condition whether the coupon code object exists or not 
    */
    if (widget.couponDetails!.couponCode != null) {
      /* 
     * appending the exisiting coupon code
    */
      couponCodeController.text = widget.couponDetails!.couponCode.toString();
    }

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
        if (mounted &&
            widget.couponDetails!.couponCode != null &&
            widget.couponDetails!.isApplied! == false) {
          /* 
          * flag to check initial error & make api call on tap remove 
          */
          isInitialErrorShown = true;
          _formKey.currentState?.validate();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
              const SizedBox(height: 10),
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
                        validator: (value) {
                          if (widget.couponDetails!.couponCode != null &&
                              widget.couponDetails!.isApplied! == false) {
                            return "${widget.couponDetails!.message!} | ${widget.couponDetails!.description!}";
                          } else if (value!.isEmpty) {
                            return "Please Enter Coupon Code";
                          }

                          return null;
                        },
                        onValueChanged: (value) => value,
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
        onPressed: () {
          /* 
          TODO: ADD / REMOVE API CALLS 
          */
          if (_formKey.currentState!.validate() && !isInitialErrorShown) {
            Navigator.pop(widget.dialogContext);
            Get.snackbar("Not yet implemented", 'Not yet implemented');
          } else if (isInitialErrorShown) {
            /* when coupon is not applied due to some reasons this will alow user to remove coupon */
            Navigator.pop(widget.dialogContext);
            Get.snackbar("Not yet implemented", 'Not yet implemented');
          }
        },
        /* 
        * if coupon if coupon object is exists, irrespective of appiled or not, we are showing to remove
        * else we are asking user to apply coupon
        */
        child: Text(
          widget.couponDetails!.couponCode != null ? "Remove" : "Apply",
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
