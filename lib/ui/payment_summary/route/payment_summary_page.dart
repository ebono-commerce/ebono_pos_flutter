import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/Common_button.dart';
import 'package:kpn_pos_application/ui/common_text_field.dart';
import 'package:kpn_pos_application/ui/custom_keyboard/custom_num_pad.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  late ThemeData theme;
  String input = '';
  late HomeController homeController;
  final FocusNode numpadFocusNode = FocusNode();
  final FocusNode qwertyFocusNode = FocusNode();
  final TextEditingController numPadTextController = TextEditingController();
  final TextEditingController qwertyTextController = TextEditingController();

  @override
  void initState() {
    if (mounted == true) {
      homeController = Get.find<HomeController>();
    }
    numpadFocusNode.addListener(() {
      setState(() {});
    });
    qwertyFocusNode.addListener(() {
      setState(() {});
    });
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
                flex: 5,
                child: paymentModeSection(),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 3, // 0.2 ratio
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: commonTextField(
                                label: ' Enter Code, Quantity ',
                                focusNode: FocusNode(),
                                readOnly: false,
                                controller: numPadTextController,
                              ),
                            ),
                            CustomNumPad(
                              textController: numPadTextController,
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
        ));
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
                  billDetailRow(label: 'Total items', value: "-"),
                  billDetailRow(label: 'Price', value: ""
                      // convertedPrice(
                      //     homeController.cartResponse.value.cartTotals
                      //         ?.firstWhere((item) => item.type == 'ITEM_TOTAL')
                      //         .amount
                      //         ?.centAmount,
                      //     homeController.cartResponse.value.cartTotals
                      //         ?.firstWhere((item) => item.type == 'ITEM_TOTAL')
                      //         .amount
                      //         ?.fraction)
                      ),
                  billDetailRow(label: 'GST', value: "-"
                      // convertedPrice(
                      //     homeController.cartResponse.value.cartTotals
                      //         ?.firstWhere((item) => item.type == 'TAX_TOTAL')
                      //         .amount
                      //         ?.centAmount,
                      //     homeController.cartResponse.value.cartTotals
                      //         ?.firstWhere((item) => item.type == 'TAX_TOTAL')
                      //         .amount
                      //         ?.fraction)
                      ),
                  billDetailRow(
                      label: 'Discount',
                      value: "-"
                      // convertedPrice(
                      //     homeController.cartResponse.value.cartTotals
                      //         ?.firstWhere(
                      //             (item) => item.type == 'DISCOUNT_TOTAL')
                      //         .amount
                      //         ?.centAmount,
                      //     homeController.cartResponse.value.cartTotals
                      //         ?.firstWhere(
                      //             (item) => item.type == 'DISCOUNT_TOTAL')
                      //         .amount
                      //         ?.fraction)
                      ,
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
                  value: "-",
                  // convertedPrice(
                  //     homeController.cartResponse.value.cartTotals
                  //         ?.firstWhere((item) => item.type == 'GRAND_TOTAL')
                  //         .amount
                  //         ?.centAmount,
                  //     homeController.cartResponse.value.cartTotals
                  //         ?.firstWhere((item) => item.type == 'GRAND_TOTAL')
                  //         .amount
                  //         ?.fraction),
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
          SizedBox(height: 20),
          balanceAmountSection(),
          /*Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: 780, minWidth: 100),
              child:  commonTextField(
                label: ' Enter value ',
                focusNode: qwertyFocusNode,
                readOnly: false,
                controller: qwertyTextController,
              ),
            ),
          ),*/
          //CustomQwertyPad(textController: qwertyTextController)
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
    homeController = Get.find<HomeController>();
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
                          //  printReceipt();
                          // homeController.paymentInitiateCall();
                          _showPaymentDialog();

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

  void _showPaymentDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Please wait....',
        ),
        content: Text(
          'Online payment is in processing',
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.black87),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: CustomColors.red,
              side: BorderSide(color: CustomColors.red, width: 1),
            ),
            onPressed: () {
              // Get.back();
              homeController.paymentCancelCall();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Cancel Payment',
                style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: CustomColors.secondaryColor,
              disabledBackgroundColor: CustomColors.enabledBorderColor,
              disabledForegroundColor: CustomColors.enabledBorderColor,
              side: BorderSide(color: CustomColors.secondaryColor, width: 1),
            ),
            isSemanticButton: true,
            onPressed: () {
              homeController.paymentStatusCheckCall(false);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Check Payment Status',
                style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
      // Prevents the dialog from closing on outside tap
    );
  }
}
