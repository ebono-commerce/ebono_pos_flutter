import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/ui/returns/data/returns_confirmation_table_data.dart';
import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:ebono_pos/widgets/custom_table/custom_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ReturnSummaryWidget extends StatefulWidget {
  final Customer customer;
  final ReturnsConfirmationTableData returnsConfirmationTableData;
  final Function(String) onPaymentModeSelected;
  final Function()? onTapClose;

  const ReturnSummaryWidget(
      {super.key,
      required this.customer,
      required this.onPaymentModeSelected,
      required this.returnsConfirmationTableData,
      required this.onTapClose});

  @override
  State<ReturnSummaryWidget> createState() => _ReturnSummaryWidgetState();
}

class _ReturnSummaryWidgetState extends State<ReturnSummaryWidget> {
  ReturnsBloc returnsBloc = Get.find<ReturnsBloc>();

  HomeController homeController = Get.find<HomeController>();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode? activeFocusNode;
  late ThemeData theme;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ever(homeController.customerName, (value) {
      _controllerCustomerName.text = value.toString();
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

    return BlocProvider.value(
      value: returnsBloc,
      child: BlocBuilder<ReturnsBloc, ReturnsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: state.isOrderReturnedSuccessfully
                ? SizedBox(
                    width: 600,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: widget.onTapClose,
                            child: SvgPicture.asset(
                              'assets/images/ic_close.svg',
                              semanticsLabel: 'cash icon,',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Lottie.asset(
                          'assets/lottie/success.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                          repeat: true,
                          reverse: false,
                          animate: true,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Yay! Refund Processed",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: CustomColors.black,
                                  ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${state.refundSuccessModel.amountRefunded} refunded",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: CustomColors.black,
                                  ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 400,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Name:"),
                                  Text(state.refundSuccessModel.customerName),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("PhoneNumber:"),
                                  Text(state.refundSuccessModel.phoneNumber),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Items:"),
                                  Text(state.refundSuccessModel.totalItems),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Amount Refunded:",
                                    style: theme.textTheme.titleSmall!.copyWith(
                                      color: CustomColors.green,
                                    ),
                                  ),
                                  Text(state.refundSuccessModel.amountRefunded,
                                      style:
                                          theme.textTheme.titleSmall!.copyWith(
                                        color: CustomColors.green,
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Refund Mode:"),
                                  Text(state.refundSuccessModel.refundMode),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* HEADER */
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Confirm Return",
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
                                tableRowsData: widget
                                    .returnsConfirmationTableData
                                    .buildTableRows(
                                  orderItemsData: state.orderItemsData.copyWith(
                                    orderLines: state.orderItemsData.orderLines
                                            ?.where((order) => order.isSelected)
                                            .toList() ??
                                        [],
                                  ),
                                  onTapSelectedButton: (id) {},
                                  onReasonSelected: (reason, orderLineId) {
                                    context
                                        .read<ReturnsBloc>()
                                        .add(UpdateSelectedItem(
                                          id: orderLineId,
                                          reason: reason,
                                          orderItems: state.orderItemsData,
                                          orderLine: state.lastSelectedItem,
                                        ));
                                  },
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
                              child: _selectPaymentModeUI(
                                bodyLargeBlack,
                                context,
                                state,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.customer.isProxyNumber == true)
                        Visibility(
                          visible: widget.customer.isProxyNumber!,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomQwertyPad(
                                textController: _qwertyPadController,
                                focusNode: activeFocusNode!,
                                onValueChanged: (value) {
                                  if (activeFocusNode == phoneNumberFocusNode) {
                                    homeController.phoneNumber.value = value;
                                  } else if (activeFocusNode ==
                                      customerNameFocusNode) {
                                    homeController.customerName.value = value;
                                  }
                                },
                                onEnterPressed: (value) {
                                  if (activeFocusNode == phoneNumberFocusNode) {
                                    customerNameFocusNode.requestFocus();
                                  } else if (activeFocusNode ==
                                      customerNameFocusNode) {
                                    customerNameFocusNode.unfocus();
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _selectPaymentModeUI(
      TextStyle? bodyLargeBlack, BuildContext context, ReturnsState state) {
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.amber,
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 4, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Mode',
                    style: bodyLargeBlack,
                  ),
                  const SizedBox(height: 4),
                  Divider(
                    color: CustomColors.grey,
                    thickness: 1.5,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.customer.isProxyNumber!,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: commonTextField(
                        label: "Enter Customer Mobile Number",
                        controller: _controllerPhoneNumber,
                        focusNode: phoneNumberFocusNode,
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Phone Number";
                          }
                          if (value.isNotEmpty &&
                              (value.length < 10 || value.length > 10)) {
                            return "Please Enter Valid Phone Number";
                          }
                          return null;
                        },*/
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: commonTextField(
                        label: "Customer Name",
                        controller: _controllerCustomerName,
                        focusNode: customerNameFocusNode,
                        /* validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Customer Name";
                          } else {
                            return null;
                          }
                        },*/
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.customer.isProxyNumber == true
                ? SizedBox(height: 14)
                : Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildPaymentOption(
                      title: 'Cash',
                      path: 'assets/images/cash.svg',
                      isSelected: false,
                      onTap: () => widget.onPaymentModeSelected('cash'),
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
                      onTap: () => widget.onPaymentModeSelected('wallet'),
                      context: context,
                      textStyle: bodyLargeBlack,
                    ),
                  ),
                ],
              ),
            ),
            widget.customer.isProxyNumber == true
                ? SizedBox(height: 14)
                : Spacer(),
            Padding(
              padding: EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: widget.customer.isProxyNumber == true ? 8 : 0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: state.orderItemsData.customer?.isProxyNumber ==
                          false
                      ? () {
                          if (state.orderItemsData.orderLines!
                                  .where((orderLine) => orderLine.isSelected)
                                  .any((orderLine) =>
                                      (orderLine.returnReason == null ||
                                          orderLine.returnReason?.isEmpty ==
                                              true)) ==
                              true) {
                            Get.snackbar(
                                "Invalid Reason", "Please Select the reason");
                          } else {
                            context.read<ReturnsBloc>().add(
                                  ProceedToReturnItems(state.orderItemsData),
                                );
                          }
                        }
                      : isValidPhoneNumber(_controllerPhoneNumber.text) &&
                              _controllerCustomerName.text.isNotEmpty
                          ? () {
                              if (state.orderItemsData.orderLines!
                                      .where(
                                          (orderLine) => orderLine.isSelected)
                                      .any((orderLine) =>
                                          (orderLine.returnReason == null ||
                                              orderLine.returnReason?.isEmpty ==
                                                  true)) ==
                                  true) {
                                Get.snackbar("Invalid Reason",
                                    "Please Select the reason");
                              } else {
                                var orderData = state.orderItemsData;

                                if (orderData.customer!.isProxyNumber!) {
                                  orderData = orderData.copyWith(
                                    customer: orderData.customer!.copyWith(
                                      customerName:
                                          _controllerCustomerName.text,
                                      phoneNumber: orderData
                                          .customer!.phoneNumber!
                                          .copyWith(
                                        number: _controllerPhoneNumber.text,
                                      ),
                                    ),
                                  );
                                }

                                context.read<ReturnsBloc>().add(
                                      ProceedToReturnItems(orderData),
                                    );
                              }
                            }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: state.isReturningOrders
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        )
                      : Text('Complete Return', style: bodyLargeBlack),
                ),
              ),
            ),
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
}
