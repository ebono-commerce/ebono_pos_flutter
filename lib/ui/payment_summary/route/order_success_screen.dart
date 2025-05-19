import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_bloc.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_event.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_state.dart';
import 'package:ebono_pos/ui/payment_summary/route/print_receipt.dart';
import 'package:ebono_pos/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';

class OrderSuccessScreen extends StatefulWidget {
  final bool isOfflineMode;
  const OrderSuccessScreen({super.key, required this.isOfflineMode});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  late ThemeData theme;
  final paymentBloc = Get.find<PaymentBloc>();
  HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    homeController.lastRoute.value = '/order_success';
    Logger.logView(view: 'order_success');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return BlocProvider(
      create: (context) => paymentBloc,
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (BuildContext context, PaymentState state) {},
        child:
            BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Lottie.asset(
                widget.isOfflineMode
                    ? 'assets/lottie/success.json'
                    : !state.allowPrintInvoice
                        ? 'assets/lottie/loading.json'
                        : 'assets/lottie/success.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
                repeat: true,
                reverse: false,
                animate: true,
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.isOfflineMode)
                Text(
                  "Sale Completed",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: CustomColors.black),
                )
              else
                Text(
                  !state.allowPrintInvoice
                      ? "Generating Invoice"
                      : "Invoice Generated Successfully!",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: CustomColors.black),
                ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    //  width: 180,
                    height: 74,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                    child: ElevatedButton(
                      style: commonElevatedButtonStyle(
                          theme: theme,
                          textStyle: theme.textTheme.bodyMedium,
                          padding: EdgeInsets.all(12)),
                      onPressed: !state.isLoading
                          ? () async {
                              try {
                                Printer? selectedPrinter;

                                final printerData = paymentBloc
                                    .hiveStorageHelper
                                    .read<Map<dynamic, dynamic>>(
                                  SharedPreferenceConstants.selectedPrinter,
                                );
                                if (printerData != null) {
                                  selectedPrinter = Printer.fromMap(
                                      printerData); // Convert Map back to Printer
                                }
                                homeController.initialResponse();
                                if (selectedPrinter != null) {
                                  printOrderSummary(
                                      paymentBloc.orderSummaryResponse,
                                      selectedPrinter);
                                } else {
                                  selectedPrinter = await Printing.pickPrinter(
                                      context: context);
                                  if (selectedPrinter != null) {
                                    printOrderSummary(
                                        paymentBloc.orderSummaryResponse,
                                        selectedPrinter);
                                  }
                                }
                              } on Exception catch (e) {
                                print(e);
                                Get.snackbar(
                                  'Error Printing Order Summary',
                                  e.toString(),
                                );
                              } finally {
                                paymentBloc.add(CancelSSEEvent());
                                Get.back();
                                Get.back();
                              }
                            }
                          : null,
                      child: Text(
                        "Print Order Summary",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (widget.isOfflineMode == false)
                    Container(
                      width: 180,
                      height: 74,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                      child: ElevatedButton(
                        onPressed: (!state.isLoading &&
                                    state.allowPrintInvoice) ||
                                widget.isOfflineMode
                            ? () async {
                                try {
                                  Printer? selectedPrinter;

                                  final printerData = paymentBloc
                                      .hiveStorageHelper
                                      .read<Map<dynamic, dynamic>>(
                                    SharedPreferenceConstants.selectedPrinter,
                                  );
                                  if (printerData != null) {
                                    selectedPrinter = Printer.fromMap(
                                        printerData); // Convert Map back to Printer
                                  }
                                  homeController.initialResponse();
                                  if (selectedPrinter != null) {
                                    printOrderSummary(
                                        paymentBloc.invoiceSummaryResponse,
                                        selectedPrinter);
                                  } else {
                                    selectedPrinter =
                                        await Printing.pickPrinter(
                                            context: context);
                                    if (selectedPrinter != null) {
                                      printOrderSummary(
                                          paymentBloc.invoiceSummaryResponse,
                                          selectedPrinter);
                                    }
                                  }
                                } on Exception catch (e) {
                                  Get.snackbar(
                                    'Error Printing Invoice',
                                    e.toString(),
                                  );
                                  paymentBloc.add(CancelSSEEvent());
                                  print(e);
                                }
                                Get.back();
                                Get.back();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: CustomColors.primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: CustomColors.keyBoardBgColor,
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Print Invoice",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    width: 180,
                    height: 74,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                    child: ElevatedButton(
                      onPressed: _isStoreOrder()
                          ? null
                          : !state.isLoading &&
                                  !state.isSmsInvoiceLoading &&
                                  state.allowPrintInvoice &&
                                  state.isSmsInvoiceSuccess == false
                              ? () {
                                  paymentBloc.add(SmsInvoiceEvent(
                                    () {
                                      homeController.initialResponse();
                                      Get.back();
                                      Get.back();
                                      Get.back();
                                    },
                                  ));
                                }
                              : null,
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: CustomColors.primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: CustomColors.keyBoardBgColor,
                          disabledBackgroundColor: CustomColors.grey,
                          disabledForegroundColor: CustomColors.grey),
                      child: Center(
                        child: state.isSmsInvoiceLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : Text(
                                textAlign: TextAlign.center,
                                "SMS Digital Invoice",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.primaryColor),
                              ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }

  _isStoreOrder() {
    return homeController.customerProxyNumber.value ==
            paymentBloc.paymentSummaryRequest.phoneNumber
        ? true
        : false;
  }
}
