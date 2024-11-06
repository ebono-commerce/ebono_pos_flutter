import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/Common_button.dart';
import 'package:kpn_pos_application/ui/common_text_field.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/ui/home/orders_section.dart';
import 'package:kpn_pos_application/ui/payment_summary/route/print_receipt.dart';

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  late ThemeData theme;
  String input = '';
  late HomeController homeController;

  void _onKeyPressed(String value) {
    setState(() {
      input += value;
    });
  }

  void _onClear() {
    setState(() {
      input = input.substring(0, input.length - 1);
    });
  }

  void _onClearAll() {
    setState(() {
      input = '';
    });
  }

  @override
  void initState() {
    if (mounted == true) {
      homeController = Get.put(HomeController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Payment summary',
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(
              color: CustomColors.borderColor,
              height: 2,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: billSummaryWidget(),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: paymentModeSection(),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2, // 0.2 ratio
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        // borderRadius: BorderRadius.circular(
                        //     10),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: TextField(
                                  controller:
                                      TextEditingController(text: input),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    focusColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        // Normal border color
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        // Focused border color
                                        width: 1,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        // Error border color
                                        width: 1,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        // Focused error border color
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
                                            text: ' Enter Code, Quantity ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // TextField(
                                //   decoration: InputDecoration(
                                //     labelText: 'Enter Code, Quantity',
                                //   ),
                                //   readOnly: true,
                                //   controller: TextEditingController(text: input),
                                // ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildKeyIcon(
                                      'assets/images/number_7.png', "7"),
                                  _buildKeyIcon(
                                      'assets/images/number_8.png', "8"),
                                  _buildKeyIcon(
                                      'assets/images/number_9.png', "9"),
                                  _buildKeyClear(
                                      'assets/images/number_back.png', "C")
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildKeyIcon(
                                      'assets/images/number_4.png', "4"),
                                  _buildKeyIcon(
                                      'assets/images/number_5.png', "5"),
                                  _buildKeyIcon(
                                      'assets/images/number_6.png', "6"),
                                  _buildKeyClearAll(
                                      'assets/images/number_clear.png', "CA")
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(children: [
                                    Row(
                                      children: [
                                        _buildKeyIcon(
                                            'assets/images/number_1.png', "1"),
                                        _buildKeyIcon(
                                            'assets/images/number_2.png', "2"),
                                        _buildKeyIcon(
                                            'assets/images/number_3.png', "3"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        _buildKeyDot(
                                            'assets/images/number_dot.png',
                                            "."),
                                        _buildKeyIcon(
                                            'assets/images/number_0.png', "0"),
                                        _buildKeyIcon(
                                            'assets/images/number_00.png',
                                            "00"),
                                      ],
                                    ),
                                  ]),
                                  _buildKeyEnterIcon(
                                      'assets/images/number_enter.png', "")
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget for Bill Summary Section
  Widget billSummaryWidget() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: CustomColors.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bill Summary',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Divider(
                    color: CustomColors.borderColor,
                    height: 2,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // billDetailRow(label: 'Invoice no.', value: '#123456789'),
                  billDetailRow(
                      label: 'Total items',
                      value: homeController
                                  .cartResponse.value.cartTotals?.length !=
                              null
                          ? '${homeController.cartResponse.value.cartTotals?.length}'
                          : "-"),
                  billDetailRow(
                      label: 'Price',
                      value:
                          '${convertedPrice(homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'ITEM_TOTAL').amount?.centAmount, homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'ITEM_TOTAL').amount?.fraction)}'),
                  billDetailRow(
                      label: 'GST',
                      value:
                          '${convertedPrice(homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'TAX_TOTAL').amount?.centAmount, homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'TAX_TOTAL').amount?.fraction)}'),
                  billDetailRow(
                      label: 'Discount',
                      value:
                          '${convertedPrice(homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'DISCOUNT_TOTAL').amount?.centAmount, homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'DISCOUNT_TOTAL').amount?.fraction)}',
                      isNegative: true),
                  billDetailRow(
                      label: 'Loyalty points', value: '-100', isNegative: true),
                ],
              ),
            ),
            Container(
              color: CustomColors.keyBoardBgColor,
              padding: EdgeInsets.all(16),
              child: billDetailRow(
                  label: 'Total payable',
                  value:
                      '${convertedPrice(homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'GRAND_TOTAL').amount?.centAmount, homeController.cartResponse.value.cartTotals?.firstWhere((item) => item.type == 'GRAND_TOTAL').amount?.fraction)}',
                  isBold: true),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tender Details', style: TextStyle(fontSize: 16)),
                  tenderDetailRow(label: 'Cash', value: '-'),
                  tenderDetailRow(label: 'UPI', value: '-'),
                  tenderDetailRow(label: 'Card', value: '-'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget for Payment Mode Section
  Widget paymentModeSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectRedemptionWidget(),
          SizedBox(height: 20),
          selectPaymentWidget(),
          Spacer(),
          balanceAmountSection(),
        ],
      ),
    );
  }

// Widget for Bill Detail Row
  Widget billDetailRow(
      {required String label,
      required String value,
      bool isBold = false,
      bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isNegative ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

// Widget for Tender Detail Row
  Widget tenderDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

// Widget for Payment Mode Option
  Widget paymentModeOption(
      {required String label,
      required String iconPath,
      required String inputHint,
      required String buttonLabel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              semanticsLabel: 'cash icon,',
              width: 20,
              height: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 140,
              child: commonTextField(
                  label: inputHint,
                  focusNode: FocusNode(),
                  controller: TextEditingController()),
            ),
            SizedBox(width: 14),
            SizedBox(
                width: 140,
                height: 50,
                child: ElevatedButton(
                  style: elevatedButtonStyle(
                      theme: theme,
                      textStyle: theme.textTheme.bodyMedium,
                      padding: EdgeInsets.all(12)),
                  onPressed: () {},
                  child: Text(
                    buttonLabel,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ],
    );
  }

// Widget for Redemption Option
  Widget selectPaymentWidget() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: CustomColors.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Payment Mode',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Divider(
                  color: CustomColors.borderColor,
                  height: 2,
                ),
                SizedBox(height: 16),
                paymentModeOption(
                    label: 'Cash payment  ',
                    iconPath: 'assets/images/ic_cash.svg',
                    inputHint: 'Enter Amount',
                    buttonLabel: 'Received'),
                SizedBox(height: 16),
                paymentModeOption(
                    label: 'Online payment',
                    iconPath: 'assets/images/ic_cash.svg',
                    inputHint: 'Enter Amount',
                    buttonLabel: 'Generate link'),
              ],
            ),
          ),
        ));
  }

  Widget selectRedemptionWidget() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: CustomColors.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select redemption',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Divider(
                  color: CustomColors.borderColor,
                  height: 2,
                ),
                SizedBox(height: 16),
                paymentModeOption(
                    label: 'Enter coupon code',
                    iconPath: 'assets/images/ic_coupon.svg',
                    inputHint: 'Enter Code',
                    buttonLabel: 'Apply'),
                //redemptionOption(),
                SizedBox(height: 16),
                paymentModeOption(
                    label: 'Loyalty Points   ',
                    iconPath: 'assets/images/ic_loyalty.svg',
                    inputHint: 'Available points',
                    buttonLabel: 'Redeem'),
                //loyaltyPointsRedemption(),
              ],
            ),
          ),
        ));
  }

// Widget for Balance Amount Section
  Widget balanceAmountSection() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: CustomColors.borderColor, width: 1),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Balance amount',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '₹4,900',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 300,
                      height: 100,
                      child: ElevatedButton(
                        style: elevatedButtonStyle(
                            theme: theme,
                            textStyle: theme.textTheme.bodyMedium,
                            padding: EdgeInsets.all(12)),
                        onPressed: () {
                          printReceipt();

                          /// Get.offAndToNamed(PageRoutes.weightDisplay);
                        },
                        child: Text(
                          "Mark Complete",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ))));
  }

  // number pad
  Widget _buildKeyIcon(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyClear(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onClear(),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyClearAll(String img, String label,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onClearAll(),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyDot(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Image.asset(
              img,
              height: 10,
              width: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyEnterIcon(String img, String label,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 1),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
            // margin: const EdgeInsets.all(15.0),
            child: Image.asset(
              img,
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
    );
  }
}
