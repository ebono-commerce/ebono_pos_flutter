import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/returns/data/customer_table_data.dart';
import 'package:ebono_pos/ui/returns/data/returns_confirmation_table_data.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:ebono_pos/widgets/custom_table/custom_table_widget.dart';

class SummaryPaymentSection extends StatefulWidget {
  final double totalRefund;
  final int loyaltyPoints;
  final double walletAmount;
  final double mopAmount;
  final ReturnsConfirmationTableData returnsConfirmationTableData;
  final CustomerTableData customerTableData;
  final Function(String) onPaymentModeSelected;

  const SummaryPaymentSection({
    super.key,
    required this.totalRefund,
    required this.loyaltyPoints,
    required this.walletAmount,
    required this.mopAmount,
    required this.onPaymentModeSelected,
    required this.customerTableData,
    required this.returnsConfirmationTableData,
  });

  @override
  State<SummaryPaymentSection> createState() => _SummaryPaymentSectionState();
}

class _SummaryPaymentSectionState extends State<SummaryPaymentSection> {
  HomeController homeController = Get.find<HomeController>();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode? activeFocusNode;
  late ThemeData theme;

  @override
  void initState() {
    ever(homeController.customerName, (value) {
      _controllerCustomerName.text = value.toString();
    });

    ever(homeController.customerResponse, (value) {
      if (value.phoneNumber != null) {
        /* TODO */
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    final bodyLargeBlack = theme.textTheme.bodyLarge?.copyWith(
      color: Colors.black,
    );

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: MediaQuery.sizeOf(context).height * 0.88,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* HEADER */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Return Confirmation",
                    style: TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/images/ic_close.svg',
                      semanticsLabel: 'cash icon,',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 6, // height
              child: Row(
                children: [
                  /* SECTION - 1 */
                  Expanded(
                    flex: 8, // width
                    child: CustomTableWidget(
                      headers: widget.returnsConfirmationTableData
                          .buildReturnOrderItemsTableHeader(),
                      tableRowsData:
                          widget.returnsConfirmationTableData.buildTableRows(
                        onTapSelectedButton: (id) {},
                      ),
                      columnWidths: {
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(0.8),
                        3: FlexColumnWidth(2.5),
                      },
                    ),
                  ),

                  /* SECTION - 2 */
                  Expanded(
                    flex: 4, // width
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Colors.amber,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Payment Mode',
                                  style: bodyLargeBlack,
                                ),
                                const SizedBox(height: 10),
                                Divider(
                                  color: CustomColors.grey,
                                  thickness: 1.5,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                  label: "Enter Customer Mobile Number",
                                  controller: _controllerPhoneNumber,
                                  focusNode: phoneNumberFocusNode,
                                  onChanged: (value) =>
                                      homeController.phoneNumber.value = value,
                                  // suffixIcon: _buildSearchButton(),
                                ),
                                _buildTextField(
                                  label: "Customer Name",
                                  controller: _controllerCustomerName,
                                  focusNode: customerNameFocusNode,
                                  onChanged: (value) =>
                                      homeController.customerName.value = value,
                                  //readOnly: homeController.phoneNumber.isEmpty,
                                  // suffixIcon: _buildSelectButton(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildPaymentOption(
                                    title: 'Cash',
                                    path: 'assets/images/cash.svg',
                                    isSelected: false,
                                    onTap: () =>
                                        widget.onPaymentModeSelected('cash'),
                                    context: context,
                                    textStyle: bodyLargeBlack!,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildPaymentOption(
                                    title: 'Wallet',
                                    path: 'assets/images/wallet.svg',
                                    isSelected: true,
                                    onTap: () =>
                                        widget.onPaymentModeSelected('wallet'),
                                    context: context,
                                    textStyle: bodyLargeBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle complete return
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text('Complete Return',
                                    style: bodyLargeBlack),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomQwertyPad(
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
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String path,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
    required TextStyle textStyle,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBEB) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(path, width: 28),
            const SizedBox(width: 8),
            Text(title, style: textStyle),
          ],
        ),
      ),
    );
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
                homeController.fetchCustomer();
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
}
