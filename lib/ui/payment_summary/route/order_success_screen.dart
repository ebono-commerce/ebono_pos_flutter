import 'dart:convert';

import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/get_storage_helper.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_bloc.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_state.dart';
import 'package:ebono_pos/ui/payment_summary/model/order_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/receipt_json.dart';
import 'package:ebono_pos/ui/payment_summary/route/print_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

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
                state.isLoading
                    ? 'assets/lottie/loading.json'
                    : 'assets/lottie/success.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
                repeat: true,
                reverse: true,
                animate: true,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                state.isLoading
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
                  Flexible(
                    flex: 1,
                    child: Container(
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
                                Printer? selectedPrinter =
                                    GetStorageHelper.read(
                                        SharedPreferenceConstants
                                            .selectedPrinter);
                                homeController.initialResponse();
                                if(selectedPrinter != null){
                                  printOrderSummary(
                                      OrderSummaryResponse.fromJson(
                                          json.decode(jsonData)),
                                      selectedPrinter);
                                }
                                Get.back();
                                Get.back();
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
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 180,
                      height: 74,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                      child: ElevatedButton(
                        onPressed: !state.isLoading
                            ? () async {
                                Printer? selectedPrinter =
                                    GetStorageHelper.read(
                                        SharedPreferenceConstants
                                            .selectedPrinter);
                                homeController.initialResponse();
                                if(selectedPrinter != null){
                                  printOrderSummary(
                                      OrderSummaryResponse.fromJson(
                                          json.decode(jsonData)),
                                      selectedPrinter);
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
                          backgroundColor: Color(0xFFF0F4F4),
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
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 180,
                      height: 74,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                      child: ElevatedButton(
                        onPressed: !state.isLoading
                            ? () {
                                homeController.initialResponse();
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
                          backgroundColor: Color(0xFFF0F4F4),
                        ),
                        child: Center(
                          child: Text(
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
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
