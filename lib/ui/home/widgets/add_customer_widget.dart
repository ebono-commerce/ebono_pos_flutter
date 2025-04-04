import 'dart:async';

import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/extensions/string_extension.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/model/customer_details_response.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddCustomerWidget extends StatefulWidget {
  final BuildContext dialogContext;
  final bool isDialogForHoldCart;
  final bool isDialogForReturns;
  final bool isDialogForAddCustomerFromReturns;
  final bool disableFormFields;
  final String? customerName;
  final String? customerMobileNumber;
  final Function(bool status)? onOTPVerifiedSuccessfully;
  final Function()? onClose;

  const AddCustomerWidget(
    this.dialogContext, {
    super.key,
    this.isDialogForHoldCart = false,
    this.isDialogForReturns = false,
    this.disableFormFields = false,
    this.customerMobileNumber,
    this.customerName,
    this.onOTPVerifiedSuccessfully,
    this.isDialogForAddCustomerFromReturns = false,
    this.onClose,
  });

  @override
  State<AddCustomerWidget> createState() => _AddCustomerWidgetState();
}

class _AddCustomerWidgetState extends State<AddCustomerWidget> {
  final homeController = Get.find<HomeController>();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final TextEditingController _otpTextController = TextEditingController();

  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();
  final RegExp otpRegex = RegExp(r'^[0-9]+$');

  FocusNode? activeFocusNode;
  late ThemeData theme;

  final _formKey = GlobalKey<FormState>();

  int _remainingTime = 30; // Initial timer value
  Timer? _timer;
  bool isResendOTPBtnEnabled = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /* resetting otp count */
      homeController.resendOTPCount.value = 0;

      /* clearing existingCustomer on initital to avoid duplicate  */
      homeController.getCustomerDetailsResponse.value.existingCustomer = null;

      if (widget.customerMobileNumber != null &&
          widget.customerName != null &&
          widget.isDialogForAddCustomerFromReturns == false) {
        setState(() {
          _controllerCustomerName.text = widget.customerName ?? '';
          _controllerPhoneNumber.text = widget.customerMobileNumber ?? '';
        });

        if (widget.isDialogForReturns == true &&
            widget.isDialogForAddCustomerFromReturns == false) {
          /* here setting error message as consistant accross application, making easier for cashier */
          homeController.getCustomerDetailsResponse.value.existingCustomer =
              true;
          homeController.getCustomerDetailsResponse.value
              .isCustomerVerificationRequired = true;
          homeController.getCustomerDetailsResponse.value.customerStatus =
              'EXISTING_CUSTOMER_VERIFICATION_PENDING';
        }
      }
    });

    ever(homeController.customerName, (value) {
      _controllerCustomerName.text = value.toString();
    });

    ever(homeController.customerResponse, (value) {
      if (value.phoneNumber != null) {
        if (widget.dialogContext.mounted &&
            homeController
                    .customerResponse.value.isCustomerVerificationRequired ==
                false &&
            widget.isDialogForReturns == false) {
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
      if (value == true && mounted) {
        if (widget.isDialogForReturns == true) {
          /* triggering the fn to do respective actions in previous screen */
          widget.onOTPVerifiedSuccessfully?.call(value);
        } else {
          Get.back();
        }
        homeController.isOTPVerified.value = false;
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

    activeFocusNode =
        widget.disableFormFields ? FocusNode() : phoneNumberFocusNode;
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
          final numericValue =
              _qwertyPadController.text.replaceAll(RegExp(r'[^0-9]'), '');
          if (numericValue.length > 10) {
            _controllerPhoneNumber.text = numericValue.substring(0, 10);
          } else {
            _controllerPhoneNumber.text = numericValue;
          }
        } else if (activeFocusNode == customerNameFocusNode) {
          _controllerCustomerName.text = _qwertyPadController.text;
        } else if (activeFocusNode == otpFocusNode) {
          final numericValue =
              _qwertyPadController.text.replaceAll(RegExp(r'[^0-9]'), '');
          if (numericValue.length > 4) {
            _otpTextController.text = numericValue.substring(0, 4);
          } else {
            _otpTextController.text = numericValue;
          }
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
      counterText: '',
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
    return PopScope(
      onPopInvokedWithResult: (val, result) {
        if (widget.onClose != null) {
          widget.onClose!();
        }
      },
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: SizedBox(
                width: 900,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 400,
                            child: homeController.displayOTPScreen.value == true
                                ? Builder(builder: (context) {
                                    otpFocusNode.requestFocus();
                                    return Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Verify With OTP",
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text:
                                                    "4 digit OTP has been sent to ",
                                                style: theme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: CustomColors.greyFont,
                                                ),
                                              ),
                                              TextSpan(
                                                text: homeController
                                                    .phoneNumber.value,
                                                style: theme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: CustomColors.black,
                                                ),
                                              ),
                                            ]),
                                          ),
                                          if (widget.isDialogForReturns) ...[
                                            const SizedBox(height: 10),
                                            Text(
                                              "Return will not be processed without OTP verification",
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: CustomColors.black,
                                              ),
                                            ),
                                          ],
                                          if (homeController
                                                  .resendOTPCount.value >
                                              2) ...[
                                            SizedBox(height: 10),
                                            Text(
                                              "Max OTP Limit Reached",
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: CustomColors.red,
                                              ),
                                            )
                                          ],
                                          SizedBox(height: 15),
                                          _buildTextField(
                                            label: "Enter OTP",
                                            controller: _otpTextController,
                                            inputFormater: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            maxLength: 4,
                                            focusNode: otpFocusNode,
                                            onChanged: (value) => homeController
                                                .otpNumber.value = value,
                                            validator: (value) {
                                              if (value == null) {
                                                return "Please Enter OTP";
                                              }
                                              if (value.length < 4 ||
                                                  value.length > 4 ||
                                                  !otpRegex.hasMatch(value)) {
                                                return "Please Enter Valid OTP";
                                              }
                                              if (homeController
                                                      .triggerCustomOTPValidation
                                                      .value ==
                                                  true) {
                                                return homeController
                                                    .otpErrorMessage.value;
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 20),
                                          _buildCustomButton(
                                            onPressed: () {
                                              homeController
                                                  .triggerCustomOTPValidation
                                                  .value = false;
                                              if (_formKey.currentState
                                                      ?.validate() ==
                                                  true) {
                                                homeController
                                                    .generateORValidateOTP(
                                                  tiggerOTP: false,
                                                  isResendOTP: false,
                                                  phoneNumber: widget
                                                              .isDialogForReturns &&
                                                          widget.isDialogForAddCustomerFromReturns ==
                                                              false
                                                      ? widget
                                                          .customerMobileNumber
                                                          .toString()
                                                      : homeController
                                                          .phoneNumber.value,
                                                  otp: _otpTextController.text
                                                      .trim(),
                                                );
                                              }
                                            },
                                            isBtnEnabled: homeController
                                                    .isOTPResendingOrVerifying
                                                    .value ==
                                                false,
                                            buttonText: "Verify",
                                            isLoading: homeController
                                                    .isOTPResendingOrVerifying
                                                    .value ==
                                                true,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 15),
                                          _buildCustomButton(
                                            onPressed: homeController
                                                        .resendOTPCount.value >
                                                    2
                                                ? null
                                                : () async {
                                                    if (homeController
                                                            .resendOTPCount
                                                            .value <
                                                        3) {
                                                      await homeController
                                                          .generateORValidateOTP(
                                                        tiggerOTP: true,
                                                        isResendOTP: true,
                                                        phoneNumber:
                                                            homeController
                                                                .phoneNumber
                                                                .value,
                                                        otp: '',
                                                      );
                                                      if (homeController
                                                              .resendOTPCount
                                                              .value <
                                                          3) {
                                                        _startTimer();
                                                      }
                                                    }
                                                  },
                                            isBtnEnabled:
                                                isResendOTPBtnEnabled &&
                                                    homeController
                                                            .resendOTPCount
                                                            .value <
                                                        3,
                                            buttonText:
                                                "Resend OTP ${_formatTime(_remainingTime).compareTo("00:00") == 0 ? "" : _formatTime(_remainingTime)}",
                                            enableBackground: false,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Add customer details",
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Add customer details before starting the sale",
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: CustomColors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildTextField(
                                            label:
                                                "Enter Customer Mobile Number",
                                            controller: _controllerPhoneNumber,
                                            focusNode:
                                                widget.disableFormFields == true
                                                    ? FocusNode()
                                                    : phoneNumberFocusNode,
                                            onChanged: (value) => homeController
                                                .phoneNumber.value = value,
                                            maxLength: 10,
                                            inputFormater: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            suffixIcon: _buildSearchButton(
                                              isDisabled:
                                                  widget.disableFormFields ==
                                                      true,
                                            ),
                                            isEnabled:
                                                widget.disableFormFields ==
                                                    false,
                                            readOnly:
                                                widget.disableFormFields ==
                                                    true,
                                          ),
                                          _buildTextField(
                                            label: "Customer Name",
                                            controller: _controllerCustomerName,
                                            focusNode:
                                                widget.disableFormFields == true
                                                    ? FocusNode()
                                                    : customerNameFocusNode,
                                            onChanged: (value) => homeController
                                                .customerName.value = value,
                                            suffixIcon: widget
                                                    .isDialogForAddCustomerFromReturns
                                                ? null
                                                : _buildSelectButton(
                                                    isDisabled: widget
                                                            .disableFormFields ==
                                                        true,
                                                  ),
                                            isEnabled:
                                                widget.disableFormFields ==
                                                    false,
                                            readOnly:
                                                widget.disableFormFields ==
                                                    true,
                                          ),
                                          if (homeController
                                                  .getCustomerDetailsResponse
                                                  .value
                                                  .existingCustomer !=
                                              null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Text(
                                                homeController
                                                            .getCustomerDetailsResponse
                                                            .value
                                                            .existingCustomer ==
                                                        true
                                                    ? homeController
                                                                .getCustomerDetailsResponse
                                                                .value
                                                                .customerStatus ==
                                                            null
                                                        ? ''
                                                        : homeController
                                                            .getCustomerDetailsResponse
                                                            .value
                                                            .customerStatus!
                                                            .replaceAll(
                                                                '_', ' ')
                                                            .replaceAll(
                                                                'PENDING',
                                                                'REQUIRED')
                                                            .toTitleCase()
                                                    : 'New Customer Verification Required',
                                                textAlign: TextAlign.center,
                                                style: theme
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
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
                                      Visibility(
                                        visible:
                                            widget.isDialogForReturns == false,
                                        child: _buildCustomButton(
                                          onPressed: () {
                                            homeController.phoneNumber.value =
                                                homeController
                                                    .customerProxyNumber.value;
                                            homeController.customerName.value =
                                                homeController
                                                    .customerProxyName.value;
                                            homeController
                                                .isCustomerProxySelected
                                                .value = true;
                                            homeController
                                                .isContionueWithOutCustomer
                                                .value = true;
                                            homeController.fetchCustomer();
                                          },
                                          isBtnEnabled:
                                              !widget.isDialogForHoldCart,
                                        ),
                                      ),
                                      Visibility(
                                        visible: widget.isDialogForReturns,
                                        child: _buildCustomButton(
                                          onPressed: () async {
                                            /* add customer name & call fetch customer api */
                                            if (widget
                                                    .isDialogForAddCustomerFromReturns ==
                                                false) {
                                              homeController.displayOTPScreen
                                                  .value = true;
                                              homeController.phoneNumber.value =
                                                  widget.customerMobileNumber
                                                      .toString();
                                              homeController
                                                  .generateORValidateOTP(
                                                tiggerOTP: true,
                                                phoneNumber: widget
                                                    .customerMobileNumber
                                                    .toString(),
                                                otp: '',
                                                isResendOTP: false,
                                                disableLoading: true,
                                              );
                                            } else {
                                              // if (homeController.customerName.isNotEmpty) {
                                              homeController
                                                  .isCustomerProxySelected
                                                  .value = true;
                                              homeController
                                                  .isContionueWithOutCustomer
                                                  .value = false;
                                              await homeController
                                                  .fetchCustomer(
                                                showOTPScreen: homeController
                                                            .getCustomerDetailsResponse
                                                            .value
                                                            .isCustomerVerificationRequired ==
                                                        true
                                                    ? true
                                                    : false,
                                                isFromReturns:
                                                    widget.isDialogForReturns,
                                              );
                                              if (homeController
                                                      .getCustomerDetailsResponse
                                                      .value
                                                      .isCustomerVerificationRequired ==
                                                  false) {
                                                widget.onOTPVerifiedSuccessfully
                                                    ?.call(true);
                                              }
                                              // }
                                            }
                                            // }
                                          },
                                          isLoading: homeController
                                              .isOTPTriggering.value,
                                          buttonText: widget
                                                  .isDialogForAddCustomerFromReturns
                                              ? (homeController
                                                              .getCustomerDetailsResponse
                                                              .value
                                                              .existingCustomer ==
                                                          true &&
                                                      homeController
                                                              .getCustomerDetailsResponse
                                                              .value
                                                              .isCustomerVerificationRequired ==
                                                          false)
                                                  ? "ADD CUSTOMER"
                                                  : (homeController
                                                                  .getCustomerDetailsResponse
                                                                  .value
                                                                  .existingCustomer ==
                                                              true &&
                                                          homeController
                                                                  .getCustomerDetailsResponse
                                                                  .value
                                                                  .isCustomerVerificationRequired ==
                                                              true)
                                                      ? "VERIFY CUSTOMER"
                                                      : "ADD CUSTOMER & VERIFY"
                                              : "VERIFY CUSTOMER",
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                              height: homeController.displayOTPScreen.value
                                  ? 10
                                  : 20),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 18,
                      top: 18,
                      child: InkWell(
                        onTap: () {
                          _controllerCustomerName.clear();
                          _controllerPhoneNumber.clear();
                          _qwertyPadController.clear();
                          homeController.customerName.value = '';
                          homeController.phoneNumber.value = '';
                          homeController.getCustomerDetailsResponse.value =
                              CustomerDetailsResponse();
                          Navigator.pop(widget.dialogContext);
                          if (widget.isDialogForReturns == true) {
                            Get.snackbar(
                              'No Return',
                              'Return will not be processed without OTP verification',
                            );
                          }
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
            ),
            SizedBox(
              width: 900,
              child: CustomQwertyPad(
                textController: _qwertyPadController,
                focusNode: activeFocusNode!,
                onValueChanged: (value) {
                  if (activeFocusNode == phoneNumberFocusNode) {
                    final numericValue =
                        value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (numericValue.length > 10) {
                      homeController.phoneNumber.value =
                          numericValue.substring(0, 10);
                    } else {
                      homeController.phoneNumber.value = numericValue;
                    }
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
            SizedBox(height: 18),
          ],
        );
      }),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onChanged,
    String? Function(String? value)? validator,
    List<TextInputFormatter>? inputFormater,
    bool readOnly = false,
    Widget? suffixIcon,
    bool isEnabled = true,
    int? maxLength,
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
        decoration: _buildInputDecoration(label, suffixIcon),
        inputFormatters: inputFormater,
        maxLength: maxLength,
      ),
    );
  }

  Widget _buildSearchButton({
    bool isDisabled = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: 100,
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : homeController.phoneNumber.value.isNotEmpty
                ? () {
                    _controllerCustomerName.clear();
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
              color: homeController.phoneNumber.isNotEmpty && !isDisabled
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

  Widget _buildSelectButton({
    bool isDisabled = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: 100,
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : homeController.customerName.isNotEmpty
                ? () {
                    homeController.isCustomerProxySelected.value = true;
                    homeController.isContionueWithOutCustomer.value = false;
                    homeController.fetchCustomer(
                      showOTPScreen: homeController.getCustomerDetailsResponse
                                  .value.isCustomerVerificationRequired ==
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
              color:
                  homeController.customerName.isNotEmpty && isDisabled == false
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
