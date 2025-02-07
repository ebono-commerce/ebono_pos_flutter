import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_bloc.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_event.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ValidateOtpWidget extends StatefulWidget {
  final BuildContext dialogContext;

  const ValidateOtpWidget(this.dialogContext, {super.key});

  @override
  State<ValidateOtpWidget> createState() => _ValidateOtpWidgetState();
}

class _ValidateOtpWidgetState extends State<ValidateOtpWidget> {
  HomeController homeController = Get.find<HomeController>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController _numPadController = TextEditingController();
  final FocusNode couponCodeFocusNode = FocusNode();
  late ThemeData theme;

  PaymentBloc paymentBloc = Get.find<PaymentBloc>();

  @override
  void initState() {
    super.initState();

    if (!couponCodeFocusNode.hasFocus) {
      couponCodeFocusNode.requestFocus();
    }

    couponCodeFocusNode.addListener(() {
      setState(() {
        _numPadController.text = otpController.text;
      });
    });

    _numPadController.addListener(() {
      setState(() {
        otpController.text = _numPadController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return BlocProvider.value(
      value: paymentBloc,
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (BuildContext context, PaymentState state) {
          if (state.isWalletChargeSuccess) {
            paymentBloc.add(WalletIdealEvent());
            Navigator.pop(widget.dialogContext);
          }
          if (state.isWalletChargeError) {
            Get.snackbar("Charge Wallet error", state.errorMessage ?? "");
          }
        },
        child:
            BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          "Enter Wallet OTP",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "enter the Otp send to customer",
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: CustomColors.greyFont,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CommonTextField(
                                labelText: "Customer Otp",
                                controller: otpController,
                                focusNode: couponCodeFocusNode,
                                onValueChanged: (value) => value,
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
                  SizedBox(
                    width: 400,
                    child: CustomNumPad(
                      textController: _numPadController,
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
              ),
              const SizedBox(height: 30),
            ],
          );
        }),
      ),
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
          paymentBloc.add(WalletChargeEvent(otpController.text));
        },
        child: Text(
          "Submit",
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
