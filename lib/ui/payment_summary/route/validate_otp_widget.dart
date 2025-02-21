import 'dart:async';

import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_bloc.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_event.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  int _remainingTime = 30; // Initial timer value
  Timer? _timer;
  bool isResendOTPBtnEnabled = false;
  int resendOTPCount = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (!couponCodeFocusNode.hasFocus) {
      couponCodeFocusNode.requestFocus();
    }

    couponCodeFocusNode.addListener(() {
      final numericValue =
      _numPadController.text.replaceAll(RegExp(r'[^0-9]'), '');
      setState(() {
        if(numericValue.length > 4){
        _numPadController.text = numericValue.substring(0,4);
        }else{
          _numPadController.text = numericValue;
        }
      });
    });

    _numPadController.addListener(() {
      final numericValue =
      _numPadController.text.replaceAll(RegExp(r'[^0-9]'), '');
      setState(() {
        if(numericValue.length > 4){
          otpController.text = numericValue.substring(0,4);
        }else{
          otpController.text = numericValue;
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    setState(() {
      _remainingTime = 30; // Reset the timer to 30 seconds
      isResendOTPBtnEnabled = false;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _stopTimer();
            _executeLogic(); // Execute your logic here
          }
        });
      }
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _executeLogic() {
    // Your logic when the timer reaches 0
    setState(() {
      isResendOTPBtnEnabled = true;
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
            homeController.isOTPError.value = true;
            // Get.snackbar("Charge Wallet error", state.errorMessage ?? "");
            _formKey.currentState?.validate();
          }
        },
        child:
            BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                top: 18,
                right: 18,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    width: 400,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Enter Wallet OTP",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "4 digit OTP has been sent to ",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.greyFont,
                                ),
                              ),
                              TextSpan(
                                text: homeController
                                    .customerResponse.value.phoneNumber!.number,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.black,
                                ),
                              ),
                            ]),
                          ),
                          if (resendOTPCount > 2) ...[
                            const SizedBox(height: 10),
                            Text(
                              "Max OTP Limit Reached",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.red,
                              ),
                            )
                          ],
                          SizedBox(height: 15),
                          _buildTextField(
                            label: "Enter OTP",
                            controller: otpController,
                            focusNode: couponCodeFocusNode,
                            onChanged: (value) => value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter OTP";
                              }
                              if (value.length != 4) {
                                return "OTP must be 4 digits";
                              }
                              if (homeController.isOTPError.value) {
                                return paymentBloc.state.errorMessage
                                        ?.split('|')
                                        .last ??
                                    "Invalid OTP";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildCustomButton(
                            onPressed: () {
                              homeController.isOTPError.value = false;
                              if (_formKey.currentState?.validate() == true) {
                                paymentBloc
                                    .add(WalletChargeEvent(otpController.text));
                              }
                            },
                            isBtnEnabled:
                                paymentBloc.state.isVerifyOTPLoading == false,
                            buttonText: "Verify",
                            isLoading: paymentBloc.state.isVerifyOTPLoading,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 15),
                          _buildCustomButton(
                            onPressed: () {
                              if (resendOTPCount <= 3) {
                                setState(() => resendOTPCount++);
                                if (resendOTPCount <= 2) {
                                  paymentBloc.add(WalletAuthenticationEvent(
                                    isResendOTP: true,
                                  ));
                                  _startTimer();
                                }
                              }
                            },
                            isLoading: paymentBloc.state.isResendOTPLoading,
                            isBtnEnabled: isResendOTPBtnEnabled &&
                                resendOTPCount < 3 &&
                                paymentBloc.state.isResendOTPLoading == false,
                            buttonText:
                                "Resend OTP ${_formatTime(_remainingTime).compareTo("00:00") == 0 ? "" : _formatTime(_remainingTime)}",
                            enableBackground: false,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 900,
                    child: CustomQwertyPad(
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

  Widget _buildCustomButton({
    String buttonText = "Verify",
    required Function()? onPressed,
    bool isBtnEnabled = true,
    bool enableBackground = true,
    bool isLoading = false,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: ElevatedButton(
        onPressed: isBtnEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  isBtnEnabled ? CustomColors.primaryColor : CustomColors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:
              enableBackground ? CustomColors.keyBoardBgColor : Colors.white,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : Text(
                  buttonText,
                  style: TextStyle(
                    color: isBtnEnabled
                        ? CustomColors.primaryColor
                        : CustomColors.greyFont,
                    fontSize: 14,
                    fontWeight: fontWeight,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onChanged,
    String? Function(String? value)? validator,
    bool readOnly = false,
    Widget? suffixIcon,
    bool isEnabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: isEnabled,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        readOnly: readOnly,
        validator: validator,
        maxLength: 4,
        decoration: _buildInputDecoration(label, suffixIcon),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, Widget? suffixIcon) {
    return InputDecoration(
      fillColor: Colors.white,
      counterText: '',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      label: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
