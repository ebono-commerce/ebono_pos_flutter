import 'dart:async';

import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/extensions/string_extension.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/model/customer_details_response.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddCustomerWidget extends StatefulWidget {
  final BuildContext dialogContext;
  final bool isDialogForHoldCart;
  final bool isDialogForReturns;

  const AddCustomerWidget(
    this.dialogContext, {
    super.key,
    this.isDialogForHoldCart = false,
    this.isDialogForReturns = false,
  });

  @override
  State<AddCustomerWidget> createState() => _AddCustomerWidgetState();
}

class _AddCustomerWidgetState extends State<AddCustomerWidget> {
  HomeController homeController = Get.find<HomeController>();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final TextEditingController _otpTextController = TextEditingController();

  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();

  FocusNode? activeFocusNode;
  late ThemeData theme;

  final _formKey = GlobalKey<FormState>();

  int _remainingTime = 30; // Initial timer value
  Timer? _timer;
  bool isResendOTPBtnEnabled = false;

  @override
  void initState() {
    super.initState();

    ever(homeController.customerName, (value) {
      _controllerCustomerName.text = value.toString();
    });

    ever(homeController.customerResponse, (value) {
      if (value.phoneNumber != null) {
        if (widget.dialogContext.mounted &&
            homeController
                    .customerResponse.value.isCustomerVerificationRequired ==
                false) {
          Get.back();
        }
      }
    });

    ever(homeController.triggerCustomOTPValidation, (value) {
      if (value == true) {
        _formKey.currentState?.validate();
      }
    });

    ever(homeController.isOTPVerified, (value) {
      if (value) {
        Get.back();
      }
    });

    ever(homeController.displayOTPScreen, (value) {
      if (mounted && value == true) {
        _startTimer();
      }
    });

    if (!phoneNumberFocusNode.hasFocus) {
      phoneNumberFocusNode.requestFocus();
    }

    activeFocusNode = phoneNumberFocusNode;
    phoneNumberFocusNode.addListener(() {
      setState(() {
        if (phoneNumberFocusNode.hasFocus) {
          activeFocusNode = phoneNumberFocusNode;
        }
        _qwertyPadController.text = _controllerPhoneNumber.text;
      });
    });

    customerNameFocusNode.addListener(() {
      setState(() {
        if (customerNameFocusNode.hasFocus) {
          activeFocusNode = customerNameFocusNode;
        }
        _qwertyPadController.text = _controllerCustomerName.text;
      });
    });

    _qwertyPadController.addListener(() {
      setState(() {
        //if (_qwertyPadController.text.isNotEmpty) {
        if (activeFocusNode == phoneNumberFocusNode) {
          _controllerPhoneNumber.text = _qwertyPadController.text;
        } else if (activeFocusNode == customerNameFocusNode) {
          _controllerCustomerName.text = _qwertyPadController.text;
        } else if (activeFocusNode == otpFocusNode) {
          _otpTextController.text = _qwertyPadController.text;
        }
        //}
      });
    });

    otpFocusNode.addListener(() {
      setState(() {
        if (otpFocusNode.hasFocus) {
          activeFocusNode = otpFocusNode;
        }
        _qwertyPadController.text = _otpTextController.text;
      });
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
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.displayOTPScreen.value = false;
    });
  }

  /*@override
  void dispose() {
    _controllerPhoneNumber.dispose();
    _controllerCustomerName.dispose();
    _qwertyPadController.dispose();
    customerNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }*/

  InputDecoration _buildInputDecoration(String label, Widget? suffixIcon) {
    return InputDecoration(
      fillColor: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Obx(() {
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
                      _controllerCustomerName.clear();
                      _controllerPhoneNumber.clear();
                      _qwertyPadController.clear();
                      homeController.getCustomerDetailsResponse.value =
                          CustomerDetailsResponse();
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
            child: homeController.displayOTPScreen.value == true
                ? Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Verify With OTP",
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
                              text: homeController.phoneNumber.value,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.black,
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: "Enter OTP",
                          controller: _otpTextController,
                          focusNode: otpFocusNode,
                          onChanged: (value) =>
                              homeController.otpNumber.value = value,
                          validator: (value) {
                            if (value == null) {
                              return "Please Enter OTP";
                            }
                            if (value.length < 4 || value.length > 4) {
                              return "Please Enter Valid OTP";
                            }
                            if (homeController
                                    .triggerCustomOTPValidation.value ==
                                true) {
                              return homeController.otpErrorMessage.value;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        _buildCustomButton(
                          onPressed: () {
                            homeController.triggerCustomOTPValidation.value =
                                false;
                            if (_formKey.currentState?.validate() == true) {
                              homeController.generateORValidateOTP(
                                tiggerOTP: false,
                                isResendOTP: false,
                                phoneNumber: homeController.phoneNumber.value,
                                otp: _otpTextController.text.trim(),
                              );
                            }
                          },
                          isBtnEnabled:
                              homeController.isOTPResendingOrVerifying.value ==
                                  false,
                          buttonText: "Verify",
                          isLoading:
                              homeController.isOTPResendingOrVerifying.value ==
                                  true,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 15),
                        _buildCustomButton(
                          onPressed: () async {
                            _startTimer();
                            await homeController.generateORValidateOTP(
                              tiggerOTP: true,
                              isResendOTP: true,
                              phoneNumber: homeController.phoneNumber.value,
                              otp: '',
                            );
                          },
                          isBtnEnabled: isResendOTPBtnEnabled,
                          buttonText:
                              "Resend OTP ${_formatTime(_remainingTime).compareTo("00:00") == 0 ? "" : _formatTime(_remainingTime)}",
                          enableBackground: false,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Add customer details",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Add customer details before starting the sale",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: CustomColors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            label: "Enter Customer Mobile Number",
                            controller: _controllerPhoneNumber,
                            focusNode: phoneNumberFocusNode,
                            onChanged: (value) =>
                                homeController.phoneNumber.value = value,
                            suffixIcon: _buildSearchButton(),
                          ),
                          _buildTextField(
                            label: "Customer Name",
                            controller: _controllerCustomerName,
                            focusNode: customerNameFocusNode,
                            onChanged: (value) =>
                                homeController.customerName.value = value,
                            //readOnly: homeController.phoneNumber.isEmpty,
                            suffixIcon: _buildSelectButton(),
                          ),
                          if (homeController.getCustomerDetailsResponse.value
                                  .existingCustomer !=
                              null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                homeController.getCustomerDetailsResponse.value
                                            .existingCustomer ==
                                        true
                                    ? homeController.getCustomerDetailsResponse
                                        .value.customerStatus!
                                        .replaceAll('_', ' ')
                                        .replaceAll('PENDING', 'REQUIRED')
                                        .toTitleCase()
                                    : 'New Customer Verification Required',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: homeController
                                                  .getCustomerDetailsResponse
                                                  .value
                                                  .isCustomerVerificationRequired ==
                                              true &&
                                          homeController
                                                  .getCustomerDetailsResponse
                                                  .value
                                                  .existingCustomer ==
                                              true
                                      ? Colors.red
                                      : CustomColors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildCustomButton(
                        onPressed: () {
                          homeController.phoneNumber.value =
                              homeController.customerProxyNumber.value;
                          homeController.customerName.value =
                              homeController.customerProxyName.value;
                          homeController.isCustomerProxySelected.value = true;
                          homeController.isContionueWithOutCustomer.value =
                              true;
                          homeController.fetchCustomer();
                        },
                        isBtnEnabled: !widget.isDialogForHoldCart,
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 900,
            child: CustomQwertyPad(
              textController: _qwertyPadController,
              focusNode: activeFocusNode!,
              onValueChanged: (value) {
                if (activeFocusNode == phoneNumberFocusNode) {
                  homeController.phoneNumber.value = value;
                } else if (activeFocusNode == customerNameFocusNode) {
                  homeController.customerName.value = value;
                }
              },
              onEnterPressed: (value) {
                if (activeFocusNode == phoneNumberFocusNode) {
                  customerNameFocusNode.requestFocus();
                } else if (activeFocusNode == customerNameFocusNode) {
                  customerNameFocusNode.unfocus();
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onChanged,
    String? Function(String? value)? validator,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        readOnly: readOnly,
        validator: validator,
        decoration: _buildInputDecoration(label, suffixIcon),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: 100,
      child: ElevatedButton(
        onPressed: homeController.phoneNumber.value.isNotEmpty
            ? () {
                if (isValidPhoneNumber(homeController.phoneNumber.value)) {
                  homeController.getCustomerDetails();
                } else {
                  Get.snackbar('Invalid Phone Number',
                      'Please enter valid 10 digit phone number');
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: homeController.phoneNumber.isNotEmpty
                  ? CustomColors.secondaryColor
                  : CustomColors.cardBackground,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: homeController.phoneNumber.isNotEmpty
              ? CustomColors.secondaryColor
              : CustomColors.cardBackground,
        ),
        child: Text(
          "Search",
          style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold, color: CustomColors.black),
        ),
      ),
    );
  }

  Widget _buildSelectButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: 100,
      child: ElevatedButton(
        onPressed: homeController.customerName.isNotEmpty
            ? () {
                homeController.isCustomerProxySelected.value = true;
                homeController.isContionueWithOutCustomer.value = false;
                homeController.fetchCustomer(
                  showOTPScreen: homeController.getCustomerDetailsResponse.value
                              .isCustomerVerificationRequired ==
                          true
                      ? true
                      : false,
                  isFromReturns: widget.isDialogForReturns,
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: homeController.customerName.isNotEmpty
                  ? CustomColors.secondaryColor
                  : CustomColors.cardBackground,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: homeController.customerName.isNotEmpty
              ? CustomColors.secondaryColor
              : CustomColors.cardBackground,
        ),
        child: Center(
          child: Text(
            homeController.getCustomerDetailsResponse.value.existingCustomer ==
                    true
                ? 'Select'
                : 'Add',
            style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold, color: CustomColors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton({
    String buttonText = "Continue Without Customer Number",
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
                  // "Continue Without Customer Number",
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
}
