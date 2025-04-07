import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/cubit/connectivity_cubit.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/widgets/home_app_bar.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_bloc.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_event.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_state.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/repository/PaymentRepository.dart';
import 'package:ebono_pos/ui/payment_summary/route/order_success_screen.dart';
import 'package:ebono_pos/ui/payment_summary/route/validate_otp_widget.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:ebono_pos/utils/logger.dart';
import 'package:ebono_pos/utils/enums.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  final paymentBloc = Get.put(
    PaymentBloc(
      Get.find<PaymentRepository>(),
      Get.find<HiveStorageHelper>(),
      Get.find<HomeController>(),
    ),
  );

  late ThemeData theme;
  String input = '';
  HomeController homeController = Get.find<HomeController>();
  bool isOnline = false;
  bool isVerifyDialogOpen = false;

  final FocusNode cashPaymentFocusNode = FocusNode();
  final FocusNode onlinePaymentFocusNode = FocusNode();
  final FocusNode loyaltyPaymentFocusNode = FocusNode();
  final FocusNode walletPaymentFocusNode = FocusNode();
  FocusNode? activeFocusNode;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController numPadTextController = TextEditingController();
  final TextEditingController cashPaymentTextController =
      TextEditingController();
  final TextEditingController onlinePaymentTextController =
      TextEditingController();
  final TextEditingController loyaltyTextController = TextEditingController();
  final TextEditingController walletTextController = TextEditingController();

  @override
  void initState() {
    PaymentSummaryRequest paymentSummaryRequest = Get.arguments;
    if (mounted == true) {
      paymentBloc.add(PaymentInitialEvent(paymentSummaryRequest));
    }
    /* if (!cashPaymentFocusNode.hasFocus) {
      cashPaymentFocusNode.requestFocus();
    }*/
    activeFocusNode = cashPaymentFocusNode;

    cashPaymentFocusNode.addListener(() {
      setState(() {
        if (cashPaymentFocusNode.hasFocus) {
          activeFocusNode = cashPaymentFocusNode;
        }
        numPadTextController.text = cashPaymentTextController.text;
      });
    });
    onlinePaymentFocusNode.addListener(() {
      setState(() {
        if (onlinePaymentFocusNode.hasFocus) {
          activeFocusNode = onlinePaymentFocusNode;
        }
        numPadTextController.text = onlinePaymentTextController.text;
      });
    });
    loyaltyPaymentFocusNode.addListener(() {
      setState(() {
        if (loyaltyPaymentFocusNode.hasFocus) {
          activeFocusNode = loyaltyPaymentFocusNode;
        }
        numPadTextController.text = loyaltyTextController.text;
      });
    });
    walletPaymentFocusNode.addListener(() {
      setState(() {
        if (walletPaymentFocusNode.hasFocus) {
          activeFocusNode = walletPaymentFocusNode;
        }
        numPadTextController.text = walletTextController.text;
      });
    });

    numPadTextController.addListener(() {
      setState(() {
        if (activeFocusNode == cashPaymentFocusNode) {
          _formKey.currentState?.validate();
          cashPaymentTextController.text = numPadTextController.text;
          paymentBloc.isOfflinePaymentVerified = false;
        } else if (activeFocusNode == onlinePaymentFocusNode) {
          _formKey.currentState?.validate();
          paymentBloc.onlinePayment = numPadTextController.text;
          //  onlinePaymentTextController.text = numPadTextController.text;
        } else if (activeFocusNode == loyaltyPaymentFocusNode) {
          loyaltyTextController.text = numPadTextController.text;
        } else if (activeFocusNode == walletPaymentFocusNode) {
          walletTextController.text = numPadTextController.text;
        }
      });
    });
    homeController.lastRoute.value = PageRoutes.paymentSummary;
    Logger.logView(view: 'Payment Summery screen');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      homeController.orderNumber.value = '';
    }
  }

  void showOTPDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ValidateOtpWidget(context),
        );
      },
    );
    homeController.isOTPError.value = false;

    setState(() => isVerifyDialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return BlocBuilder<NetworkCubit, InternetStatus>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                  state.status == ConnectivityStatus.connected
                      ? kToolbarHeight
                      : kToolbarHeight + 30),
              child: Column(
                children: [
                  HomeAppBar(
                    showBackButton: true,
                    titleWidget: Text(
                      'Payment summary',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Visibility(
                    visible: state.status == ConnectivityStatus.disconnected,
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.all(2),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                      ),
                      child: Center(
                          child: Text('No Internet Connection',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 14))),
                    ),
                  )
                ],
              )),
          body: BlocProvider(
            create: (context) => paymentBloc,
            child: BlocListener<PaymentBloc, PaymentState>(
              listener: (BuildContext context, PaymentState state) async {
                if (state.showPaymentPopup && state.isPaymentStartSuccess) {
                  _showPaymentDialog();
                }
                if (state.isPaymentSummarySuccess) {
                  var applicableBalance = paymentBloc
                          .paymentSummaryResponse
                          .redeemablePaymentOptions
                          ?.firstOrNull
                          ?.applicableBalance ??
                      '';
                  if (applicableBalance.isNotEmpty &&
                      double.parse(applicableBalance) > 0 &&
                      (getPrice(
                              paymentBloc.paymentSummaryResponse
                                  .redeemedWalletAmount?.centAmount,
                              paymentBloc.paymentSummaryResponse
                                  .redeemedWalletAmount?.fraction) <=
                          0)) {
                    walletTextController.text = paymentBloc
                            .paymentSummaryResponse
                            .redeemablePaymentOptions
                            ?.firstOrNull
                            ?.applicableBalance ??
                        '';
                  } else {
                    walletTextController.text = '';
                  }
                }
                if (state.isPlaceOrderSuccess) {
                  paymentBloc.add(PaymentIdealEvent());
                  _showOrderSuccessDialog();
                }
                if (state.isPlaceOrderError) {
                  cashPaymentTextController.text = '';
                  onlinePaymentTextController.text = '';
                  paymentBloc.add(PaymentIdealEvent());
                  Get.snackbar("Place Order Error", state.errorMessage ?? "");
                }

                if (state.isWalletAuthenticationSuccess &&
                    isVerifyDialogOpen == false) {
                  print(
                      'wallet authentication state is ${state.isWalletAuthenticationSuccess}');
                  paymentBloc.add(WalletIdealEvent());
                  print(
                      'wallet authentication state is ${state.isWalletAuthenticationSuccess}');

                  showOTPDialog();

                  setState(() => isVerifyDialogOpen = true);
                }

                if (state.isWalletChargeSuccess) {
                  cashPaymentTextController.clear();
                  onlinePaymentTextController.clear();
                  paymentBloc.onlinePayment = '';
                  paymentBloc.cashPayment = '';
                }

                if (state.isWalletAuthenticationError) {
                  Get.snackbar(
                      "Wallet Authentication Error", state.errorMessage ?? "");
                }
              },
              child: BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 0, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 3,
                            child: state.isPaymentSummarySuccess
                                ? billSummaryWidget(
                                    paymentBloc.paymentSummaryResponse)
                                : SizedBox(),
                          ),
                          Expanded(
                            flex: 7,
                            child: state.isPaymentSummarySuccess
                                ? paymentModeSection(
                                    paymentBloc.paymentSummaryResponse, state)
                                : SizedBox(),
                          ),
                          Expanded(
                            flex: 5,
                            child: state.isPaymentSummarySuccess
                                ? numpadSection(state)
                                : SizedBox(),
                          ),
                          Expanded(
                            flex: 2,
                            child: QuickActionButtons(
                              color: Colors.grey.shade100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    state.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: 1,
                            height: 1,
                          ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

// Widget for Bill Summary Section
  Widget billSummaryWidget(PaymentSummaryResponse? data) {
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
                  //billDetailRow(label: 'Invoice no.', value: '#123456789'),
                  billDetailRow(
                      label: 'Total items',
                      value: data?.totalItems.toString() ?? ''),
                  billDetailRow(
                      label: 'Price',
                      value: getActualPrice(data?.itemTotal?.centAmount,
                          data?.amountPayable?.fraction)),
                  billDetailRow(
                      label: 'GST',
                      value: getActualPrice(data?.taxTotal?.centAmount,
                          data?.taxTotal?.fraction)),
                  if (getPrice(data?.redeemedWalletAmount?.centAmount,
                          data?.redeemedWalletAmount?.fraction) >
                      0)
                    billDetailRow(
                        label: 'Wallet Applied',
                        value: getActualPrice(
                            data?.redeemedWalletAmount?.centAmount,
                            data?.redeemedWalletAmount?.fraction),
                        isNegative: true),
                  if (getPrice(data?.discountTotal?.centAmount,
                          data?.discountTotal?.fraction) >
                      0)
                    billDetailRow(
                        label: 'Discount',
                        value: getActualPrice(data?.discountTotal?.centAmount,
                            data?.discountTotal?.fraction),
                        isNegative: true),
                  if (getPrice(data?.totalSavings?.centAmount,
                          data?.totalSavings?.fraction) >
                      0)
                    billDetailRow(
                      label: 'Total Savings',
                      value: getActualPrice(data?.totalSavings?.centAmount,
                          data?.totalSavings?.fraction),
                      isNegative: true,
                    ),
                  //billDetailRow(label: 'Loyalty points', value: '-100', isNegative: true),
                ],
              ),
            ),
            Container(
              color: CustomColors.keyBoardBgColor,
              padding: EdgeInsets.all(16),
              child: billDetailRow(
                  label: 'Total payable',
                  value: getActualPrice(data?.amountPayable?.centAmount,
                      data?.amountPayable?.fraction),
                  isBold: true),
            ),
            SizedBox(height: 12),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tender Details', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Divider(
                    color: CustomColors.borderColor,
                    height: 2,
                  ),
                  SizedBox(height: 12),
                  tenderDetailRow(
                    label: 'Cash',
                    value:
                        getTenderAmountString(cashPaymentTextController.text),
                  ),
                  if ((paymentBloc.paymentSummaryResponse.paymentOptions?.any(
                          (option) => (option.code == "CARD" ||
                              option.code == "UPI")) ??
                      false))
                    tenderDetailRow(
                      label: 'Online',
                      value: getTenderAmountString(
                          onlinePaymentTextController.text),
                    ),
                  Visibility(
                    visible: data?.redeemedWalletAmount?.centAmount != 0,
                    child: tenderDetailRow(
                        label: 'Wallet',
                        value: getActualPriceWithoutSymbol(
                            data?.redeemedWalletAmount?.centAmount,
                            data?.redeemedWalletAmount?.fraction)),
                  ),
                  Visibility(
                    visible: paymentBloc.offlinePayment.isNotEmpty,
                    child: tenderDetailRow(
                        label: 'Static QR',
                        value:
                            getTenderAmountString(paymentBloc.offlinePayment)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget for Payment Mode Section
  Widget paymentModeSection(PaymentSummaryResponse data, PaymentState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectRedemptionWidget(data),
          SizedBox(height: 20),
          selectPaymentWidget(state),
        ],
      ),
    );
  }

  Widget numpadSection(PaymentState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/ic_coupon.svg',
                    semanticsLabel: 'cash icon,',
                    width: 20,
                    height: 20,
                  ),
                  title: Text(
                    'Select Payment Mode',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: DashedLine(
                    height: 0.4,
                    dashWidth: 4,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      )),
                  //padding: const EdgeInsets.all(8.0),
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        numPadTextController.text,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                CustomNumPad(
                  focusNode: activeFocusNode!,
                  textController: numPadTextController,
                  onValueChanged: (value) {
                    if (activeFocusNode == cashPaymentFocusNode) {
                      paymentBloc.cashPayment = value;
                      if (value.isNotEmpty &&
                          double.parse(value) < paymentBloc.totalPayable) {
                        onlinePaymentTextController.text =
                            '${(double.parse(value) - paymentBloc.totalPayable).abs()}';
                        paymentBloc.onlinePayment =
                            '${(double.parse(value) - paymentBloc.totalPayable).abs()}';
                      } else {
                        onlinePaymentTextController.text = '';
                        paymentBloc.onlinePayment = '';
                        paymentBloc.offlinePayment = '';
                      }
                    } else if (activeFocusNode == onlinePaymentFocusNode) {
                      paymentBloc.onlinePayment = value;
                      if (double.parse(value) < paymentBloc.totalPayable) {
                        cashPaymentTextController.text =
                            '${(double.parse(value) - paymentBloc.totalPayable).abs()}';
                      } else {
                        cashPaymentTextController.text = '';
                      }
                    } else if (activeFocusNode == loyaltyPaymentFocusNode) {
                      paymentBloc.loyaltyValue = value;
                    } else if (activeFocusNode == walletPaymentFocusNode) {
                      paymentBloc.walletValue = value;
                    }
                  },
                  onEnterPressed: (value) {
                    if (activeFocusNode == cashPaymentFocusNode) {
                      cashPaymentFocusNode.unfocus();
                    } else if (activeFocusNode == onlinePaymentFocusNode) {
                      onlinePaymentFocusNode.unfocus();
                    } else if (activeFocusNode == loyaltyPaymentFocusNode) {
                      loyaltyPaymentFocusNode.unfocus();
                    } else if (activeFocusNode == walletPaymentFocusNode) {
                      walletPaymentFocusNode.unfocus();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          balanceAmountSection(state),
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
  Widget paymentModeOption({
    required String label,
    required String iconPath,
    required String inputHint,
    required String buttonLabel,
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback? onPressed,
    required FormFieldValidator<String>? validator,
    bool readOnly = false,
  }) {
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
            IgnorePointer(
              ignoring: readOnly,
              child: SizedBox(
                width: 140,
                child: commonTextField(
                    label: inputHint,
                    focusNode: focusNode,
                    controller: controller,
                    readOnly: readOnly,
                    onValueChanged: (value) {
                      print('commonTextField $value');
                    },
                    validator: validator),
              ),
            ),
            SizedBox(width: 14),
            SizedBox(
                width: 140,
                height: 50,
                child: ElevatedButton(
                  style: commonElevatedButtonStyle(
                      theme: theme,
                      textStyle: theme.textTheme.bodyMedium,
                      padding: EdgeInsets.all(12)),
                  onPressed: onPressed,
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
  Widget selectPaymentWidget(PaymentState state) {
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
            child: Form(
              key: _formKey,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 165,
                          height: 50,
                          child: ElevatedButton(
                            style: commonElevatedButtonStyle(
                                theme: theme,
                                textStyle: theme.textTheme.bodyMedium,
                                padding: EdgeInsets.all(12)),
                            onPressed: paymentBloc.totalPayable == 0
                                ? null
                                : () {
                                    cashPaymentFocusNode.requestFocus();
                                    Logger.logButtonPress(
                                        button: 'Cash payment');
                                  },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/ic_cash.svg',
                                  semanticsLabel: 'cash icon,',
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Cash payment',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: IgnorePointer(
                              ignoring: paymentBloc.totalPayable == 0,
                              child: commonTextField(
                                  label: 'Enter Amount',
                                  focusNode: cashPaymentFocusNode,
                                  controller: cashPaymentTextController,
                                  readOnly: paymentBloc.totalPayable == 0,
                                  onValueChanged: (value) {},
                                  validator: null),
                            ),
                          ),
                          SizedBox(width: 14),
                          SizedBox(
                            width: 140,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  /// if payment amount is zero disable the state of buttons
                  if ((paymentBloc.totalPayable) <= 0.0) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 165,
                            height: 50,
                            child: ElevatedButton(
                              style: commonElevatedButtonStyle(
                                  theme: theme,
                                  textStyle: theme.textTheme.bodyMedium,
                                  padding: EdgeInsets.all(12)),
                              onPressed: null,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/ic_cash.svg',
                                    semanticsLabel: 'cash icon,',
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Online payment',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                        Row(
                          children: [
                            IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                width: 140,
                                child: commonTextField(
                                    label: 'Enter Amount',
                                    focusNode: onlinePaymentFocusNode,
                                    controller: onlinePaymentTextController,
                                    readOnly: true,
                                    onValueChanged: (value) {}),
                              ),
                            ),
                            SizedBox(width: 14),
                            SizedBox(
                                width: 140,
                                height: 50,
                                child: ElevatedButton(
                                  style: commonElevatedButtonStyle(
                                      theme: theme,
                                      textStyle: theme.textTheme.bodyMedium,
                                      padding: EdgeInsets.all(12)),
                                  onPressed: null,
                                  child: Text(
                                    'Generate link',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )
                  ] else ...[
                    Visibility(
                      visible: (paymentBloc
                              .paymentSummaryResponse.paymentOptions
                              ?.any((option) => (option.code == "CARD" ||
                                  option.code == "UPI")) ??
                          false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 165,
                              height: 50,
                              child: ElevatedButton(
                                style: commonElevatedButtonStyle(
                                    theme: theme,
                                    textStyle: theme.textTheme.bodyMedium,
                                    padding: EdgeInsets.all(12)),
                                onPressed: paymentBloc.cashPayment.isEmpty ||
                                        double.parse(paymentBloc.cashPayment) <
                                            paymentBloc.totalPayable
                                    ? () {
                                        var balance =
                                            (paymentBloc.totalPayable -
                                                    (paymentBloc.cashAmount))
                                                .abs()
                                                .toString();
                                        paymentBloc.onlinePayment = balance;
                                        onlinePaymentTextController.text =
                                            balance;
                                      }
                                    : null,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/ic_cash.svg',
                                      semanticsLabel: 'cash icon,',
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Online payment',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                          Row(
                            children: [
                              IgnorePointer(
                                ignoring: true,
                                child: SizedBox(
                                  width: 140,
                                  child: commonTextField(
                                      label: 'Enter Amount',
                                      focusNode: onlinePaymentFocusNode,
                                      controller: onlinePaymentTextController,
                                      readOnly: true,
                                      onValueChanged: (value) {
                                        print('commonTextField $value');
                                      },
                                      validator: (value) {
                                        if (paymentBloc.onlineAmount >= 0 &&
                                            paymentBloc.onlineAmount <=
                                                (paymentBloc.totalPayable)) {
                                          return null;
                                        } else {
                                          Get.snackbar(
                                              'Amount can\'t be more than total payable',
                                              'please enter valid amount');
                                          return 'Invalid Amount';
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(width: 14),
                              SizedBox(
                                  width: 140,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: commonElevatedButtonStyle(
                                        theme: theme,
                                        textStyle: theme.textTheme.bodyMedium,
                                        padding: EdgeInsets.all(12)),
                                    onPressed: onlinePaymentTextController
                                            .value.text.isNotEmpty
                                        ? () {
                                            paymentBloc
                                                .add(PaymentStartEvent());
                                          }
                                        : null,
                                    child: Text(
                                      'Generate link',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                  SizedBox(height: 16),

                  ///offline payment
                  if (paymentBloc.paymentSummaryResponse.paymentOptions
                          ?.any((option) => option.code == "STATIC_QR_CODE") ??
                      false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 165,
                            height: 50,
                            child: ElevatedButton(
                              style: commonElevatedButtonStyle(
                                  theme: theme,
                                  textStyle: theme.textTheme.bodyMedium,
                                  padding: EdgeInsets.all(12)),
                              onPressed: (paymentBloc.totalPayable) <= 0.0
                                  ? null
                                  : paymentBloc.cashPayment.isEmpty ||
                                          double.parse(
                                                  paymentBloc.cashPayment) <
                                              paymentBloc.totalPayable
                                      ? () {
                                          var balance =
                                              (paymentBloc.totalPayable -
                                                      (paymentBloc.cashAmount))
                                                  .abs()
                                                  .toString();
                                          onlinePaymentTextController.text =
                                              balance;
                                        }
                                      : null,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/ic_cash.svg',
                                    semanticsLabel: 'cash icon,',
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Offline payment',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                        Row(
                          children: [
                            IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                width: 140,
                                child: commonTextField(
                                    label: 'Enter Amount',
                                    focusNode: onlinePaymentFocusNode,
                                    controller: TextEditingController(
                                        text: paymentBloc.offlinePayment),
                                    readOnly: true,
                                    onValueChanged: (value) {},
                                    validator: (value) {}),
                              ),
                            ),
                            SizedBox(width: 14),
                            SizedBox(
                                width: 140,
                                height: 50,
                                child: ElevatedButton(
                                  style: commonElevatedButtonStyle(
                                      theme: theme,
                                      textStyle: theme.textTheme.bodyMedium,
                                      padding: EdgeInsets.all(12)),
                                  onPressed: paymentBloc
                                              .isOfflinePaymentVerified ||
                                          (double.tryParse(paymentBloc
                                                      .offlinePayment) ??
                                                  0.0) <=
                                              0
                                      ? null
                                      : () {
                                          paymentBloc.isOfflinePaymentVerified =
                                              true;
                                        },
                                  child: Text(
                                    'Received',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )

                  /* paymentModeOption(
                      label: 'Cash payment  ',
                      iconPath: 'assets/images/ic_cash.svg',
                      inputHint: 'Enter Amount',
                      buttonLabel: 'Received',
                      controller: cashPaymentTextController,
                      focusNode: cashPaymentFocusNode,
                      onPressed: cashPaymentTextController.value.text.isNotEmpty
                          ? () {}
                          : null,
                      validator: null),
                  SizedBox(height: 16),
                  paymentModeOption(
                      label: 'Online payment',
                      iconPath: 'assets/images/ic_cash.svg',
                      inputHint: 'Enter Amount',
                      buttonLabel: 'Generate link',
                      controller: onlinePaymentTextController,
                      focusNode: onlinePaymentFocusNode,
                      onPressed:
                          onlinePaymentTextController.value.text.isNotEmpty
                              ? () {
                                  paymentBloc.add(PaymentStartEvent());
                                }
                              : null,
                      validator: (value) {
                        var onlineAmount =
                            onlinePaymentTextController.text.isNotEmpty
                                ? double.parse(onlinePaymentTextController.text)
                                : 0;
                        if (onlineAmount >= 0 &&
                            onlineAmount <= (paymentBloc.totalPayable)) {
                          return null;
                        } else {
                          Get.snackbar(
                              'Amount can\'t be more than total payable',
                              'please enter valid amount');
                          return 'Invalid Amount';
                        }
                      }),*/
                ],
              ),
            ),
          ),
        ));
  }

  Widget selectRedemptionWidget(PaymentSummaryResponse data) {
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
                    label: 'Loyalty Points   ',
                    iconPath: 'assets/images/ic_loyalty.svg',
                    inputHint: 'Available points',
                    buttonLabel: 'Apply',
                    controller: loyaltyTextController,
                    focusNode: loyaltyPaymentFocusNode,
                    readOnly: true,
                    onPressed: null,
                    validator: null),
                //redemptionOption(),
                SizedBox(height: 16),
                paymentModeOption(
                    label: 'Wallet',
                    iconPath: 'assets/images/ic_coupon.svg',
                    inputHint: 'Available',
                    buttonLabel: 'Redeem',
                    controller: walletTextController,
                    focusNode: walletPaymentFocusNode,
                    readOnly: true,
                    onPressed: (!paymentBloc.isOfflineMode) &&
                            (double.parse(paymentBloc
                                        .paymentSummaryResponse
                                        .redeemablePaymentOptions
                                        ?.firstOrNull
                                        ?.applicableBalance ??
                                    '0') >
                                0)
                        ? () {
                            paymentBloc.add(WalletAuthenticationEvent());
                            Logger.logButtonPress(button: 'Redeem Wallet');
                          }
                        : null,
                    validator: null),

                //loyaltyPointsRedemption(),
              ],
            ),
          ),
        ));
  }

  getPayableAmount() {
    var cash = cashPaymentTextController.text.isNotEmpty
        ? cashPaymentTextController.text
        : '0';
    var online = onlinePaymentTextController.text.isNotEmpty
        ? onlinePaymentTextController.text
        : '0';
    var wallet =
        walletTextController.text.isNotEmpty ? walletTextController.text : '0';

    paymentBloc.add(GetBalancePayableAmountEvent(cash, online, wallet));
  }

// Widget for Balance Amount Section
  Widget balanceAmountSection(PaymentState state) {
    getPayableAmount();
    var balancePayableAmount = state.balancePayableAmount ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    balancePayableAmount >= 0
                        ? 'Balance amount'
                        : 'Balance amount return to customer',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                  Text(
                    '₹ ${balancePayableAmount.abs()}',
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: balancePayableAmount >= 0
                            ? Colors.black
                            : CustomColors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  style: commonElevatedButtonStyle(
                      theme: theme,
                      textStyle: theme.textTheme.bodyMedium,
                      padding: EdgeInsets.all(12)),
                  onPressed: (paymentBloc.allowPlaceOrder)
                      ? () {
                          paymentBloc.add(PlaceOrderEvent());
                          Logger.logButtonPress(button: 'Place Order');
                        }
                      : null,
                  child: Text(
                    "Place Order",
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _showPaymentDialog() {
    if (!Get.isDialogOpen!) {
      Logger.logView(view: 'Online payment process Dialog');
      Get.dialog(
        barrierDismissible: true,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: EdgeInsets.all(100),
          backgroundColor: Colors.transparent,
          child: Wrap(
            children: [
              Center(
                child: Container(
                    width: 600,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Please wait....',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.black),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Online payment is in processing',
                            style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: CustomColors.red,
                                    side: BorderSide(
                                        color: CustomColors.red, width: 1),
                                  ),
                                  onPressed: () {
                                    paymentBloc.add(PaymentCancelEvent());
                                    Logger.logButtonPress(
                                        button: 'Cancel Payment');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Cancel Payment',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        CustomColors.secondaryColor,
                                    disabledBackgroundColor:
                                        CustomColors.enabledBorderColor,
                                    disabledForegroundColor:
                                        CustomColors.enabledBorderColor,
                                    side: BorderSide(
                                        color: CustomColors.secondaryColor,
                                        width: 1),
                                  ),
                                  onPressed: () {
                                    paymentBloc.add(PaymentStatusEvent());
                                    Logger.logButtonPress(
                                        button: 'Check Payment Status');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Check Payment Status',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ])),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showOrderSuccessDialog() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
          barrierDismissible: false,
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: EdgeInsets.all(100),
            backgroundColor: Colors.transparent,
            child:
                // WillPopScope(
                //   onWillPop: () async => true,
                //   child:
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: OrderSuccessScreen(
                      isOfflineMode: paymentBloc.isOfflineMode,
                    )),
            // ),
          ));
    }
  }
}
