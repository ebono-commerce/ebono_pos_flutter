import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';

class AddCustomerWidget extends StatefulWidget {
  final HomeController homeController;
  final BuildContext dialogContext;

  const AddCustomerWidget(this.homeController, this.dialogContext, {super.key});

  @override
  State<AddCustomerWidget> createState() => _AddCustomerWidgetState();
}

class _AddCustomerWidgetState extends State<AddCustomerWidget> {
  late HomeController homeController;
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode? activeFocusNode;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    homeController = widget.homeController;

    ever(homeController.customerName, (value) {
      _controllerCustomerName.text = value.toString();
    });

    ever(homeController.customerResponse, (value) {
      if (value.phoneNumber != null) {
        if (widget.dialogContext.mounted) {
          Navigator.pop(widget.dialogContext);
        }
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
        }
        //}
      });
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          homeController.getCustomerDetailsResponse.value
                                      .existingCustomer ==
                                  true
                              ? 'Existing Customer'
                              : 'New Customer',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: CustomColors.green),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildContinueWithoutCustomerButton(),
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
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: _buildInputDecoration(label, suffixIcon),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: 100,
      child: ElevatedButton(
        onPressed: homeController.phoneNumber.isNotEmpty
            ? () => homeController.getCustomerDetails()
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
            ? () => homeController.fetchCustomer()
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

  Widget _buildContinueWithoutCustomerButton() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          homeController.phoneNumber.value =
              homeController.customerProxyNumber.value;
          homeController.customerName.value = 'Admin';

          homeController.fetchCustomer();
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
            "Continue Without Customer Number",
            style: TextStyle(
                color: CustomColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
