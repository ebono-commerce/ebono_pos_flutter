import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/ui/returns/data/customer_table_data.dart';
import 'package:ebono_pos/ui/returns/data/order_items_table_data.dart';
import 'package:ebono_pos/ui/returns/data/returns_confirmation_table_data.dart';
import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/ui/returns/widgets/refund_summary_widget.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:ebono_pos/widgets/custom_table/custom_table_widget.dart';
import 'package:ebono_pos/widgets/order_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ReturnsView extends StatefulWidget {
  const ReturnsView({super.key});

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  late ReturnsBloc returnsBloc;
  final homeController = Get.find<HomeController>();

  late TextEditingController customerNumberTextController;
  late TextEditingController orderNumberTextController;
  late TextEditingController numPadTextController;

  final FocusNode customerNumberFocusNode = FocusNode();
  final FocusNode orderNumberFocusNode = FocusNode();
  final FocusNode numPadFocusNode = FocusNode();

  FocusNode? activeFocusNode;

  final _formKey = GlobalKey<FormState>();

  /* State Management */
  bool isCustomerOrdersFetched = false;
  bool isOrderItemsFetched = false;
  bool triggerProceedToPayDialog = false;
  bool isOrderDetailsRetrieving = false;

  Customer _customerDetails = Customer();

  late CustomerTableData _customerTableData;
  late OrderItemsTableData _orderItemsTableData;
  late ReturnsConfirmationTableData _returnsConfirmationTableData;

  @override
  void initState() {
    customerNumberTextController = TextEditingController();
    orderNumberTextController = TextEditingController();
    numPadTextController = TextEditingController();

    returnsBloc = Get.find<ReturnsBloc>();
    _customerTableData = CustomerTableData(context: context);
    _orderItemsTableData = OrderItemsTableData(context: context);
    _returnsConfirmationTableData =
        ReturnsConfirmationTableData(context: context);

    ever(homeController.isReturnViewReset, (value) {
      _resetAllValues();
    });

    activeFocusNode = customerNumberFocusNode;

    customerNumberFocusNode.addListener(() {
      setState(() {
        if (customerNumberFocusNode.hasFocus) {
          activeFocusNode = customerNumberFocusNode;
        }
        numPadTextController.text = customerNumberTextController.text;
      });
    });

    orderNumberFocusNode.addListener(() {
      setState(() {
        if (orderNumberFocusNode.hasFocus) {
          activeFocusNode = orderNumberFocusNode;
        }

        numPadTextController.text = orderNumberTextController.text;
      });
    });

    numPadFocusNode.addListener(() {
      setState(() {
        if (numPadFocusNode.hasFocus) {
          activeFocusNode = numPadFocusNode;
        }
        numPadTextController.text = numPadTextController.text;
      });
    });

    numPadTextController.addListener(() {
      setState(() {
        if (activeFocusNode == customerNumberFocusNode) {
          customerNumberTextController.text = numPadTextController.text;
        } else if (activeFocusNode == orderNumberFocusNode) {
          orderNumberTextController.text = numPadTextController.text;
        }
      });
    });

    super.initState();
  }

  void _resetAllValues() {
    /*customerNumberTextController.clear();
    orderNumberTextController.clear();*/
    isCustomerOrdersFetched = false;
    isOrderItemsFetched = false;
    numPadTextController.clear();
    _customerDetails = const Customer();
    returnsBloc.add(ReturnsResetEvent());
    homeController.isReturnViewReset.value = false;
    setState(() {});
  }

  void onClickSearchOrders() {
    if (!context.mounted) return;

    bool hasCustomerNumber =
        customerNumberTextController.text.trim().isNotEmpty;

    if (_formKey.currentState!.validate()) {
      if (hasCustomerNumber) {
        returnsBloc.add(
          FetchCustomerOrdersData(customerNumberTextController.text),
        );
      } else {
        returnsBloc.add(
          FetchOrderDataBasedOnOrderId(orderId: orderNumberTextController.text),
        );
      }
    }
  }

  @override
  void dispose() {
    customerNumberTextController.dispose();
    orderNumberTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => returnsBloc,
        child: BlocConsumer<ReturnsBloc, ReturnsState>(
          bloc: returnsBloc,
          listener: (context, state) {
            if (state.isCustomerOrdersDataFetched) {
              isCustomerOrdersFetched = true;
              isOrderItemsFetched = false;
              customerNumberTextController.clear();
              numPadTextController.clear();
              _customerDetails = state.customerOrdersList.isNotEmpty
                  ? state.customerOrdersList.first.customer ?? Customer()
                  : Customer();
              setState(() {});
            }
            if (state.isOrderItemsFetched) {
              isOrderItemsFetched = true;
              isCustomerOrdersFetched = false;
              orderNumberTextController.clear();
              numPadTextController.clear();
              _customerDetails = state.orderItemsData.customer ?? Customer();
              setState(() {});
            }

            if (state.isError) {
              Get.snackbar(
                "Error Fetching Customer Orders",
                state.errorMessage,
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Row(
                children: [
                  /* SECTION - 1: */
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          OrderDetailsWidget(
                            customerName: _customerDetails.customerName ?? '',
                            walletBalance: "",
                            phoneNumber:
                                _customerDetails.phoneNumber?.number ?? '-',
                            loyaltyPoints: "-",
                            title: isCustomerOrdersFetched
                                ? "Order #"
                                : "Order #${state.orderItemsData.orderNumber ?? ""}",
                          ),
                          if (!isCustomerOrdersFetched && !isOrderItemsFetched)
                            CustomTableWidget(
                              headers:
                                  _customerTableData.buildInitialTableHeader(),
                              tableRowsData: [],
                              columnWidths: const {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(6),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(3),
                                4: FlexColumnWidth(3),
                                5: FlexColumnWidth(1),
                              },
                            ),
                          if (isCustomerOrdersFetched ||
                              state.isFetchingOrderItems)
                            Expanded(
                              child: CustomTableWidget(
                                headers: _customerTableData
                                    .buildCustomerOrdersTableHeader(),
                                tableRowsData:
                                    _customerTableData.buildTableRows(
                                  customerOrderDetails:
                                      state.customerOrdersList,
                                  onClickRetrive: (orderId) {
                                    returnsBloc.add(
                                      FetchOrderDataBasedOnOrderId(
                                        orderId: orderId!,
                                        isRetrivingOrderItems: true,
                                        customerOrderDetailsList:
                                            state.customerOrdersList,
                                      ),
                                    );
                                  },
                                ),
                                emptyDataMessage: 'No Orders to be returned',
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(4),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(3),
                                  4: FlexColumnWidth(3),
                                },
                              ),
                            ),
                          if (isOrderItemsFetched &&
                              !state.isFetchingOrderItems)
                            Expanded(
                              child: CustomTableWidget(
                                headers: _orderItemsTableData
                                    .buildOrderItemsTableHeader(),
                                tableRowsData:
                                    _orderItemsTableData.buildTableRows(
                                  orderItemsData: state.orderItemsData,
                                  returnsBLoc: returnsBloc,
                                  onTapSelectedButton: (orderLine) {
                                    if (!orderLine.isSelected) {
                                      numPadFocusNode.requestFocus();
                                      numPadTextController.text =
                                          '${orderLine.returnedQuantity ?? ''}';
                                    } else {
                                      numPadTextController.text = '';
                                    }
                                    returnsBloc.add(UpdateSelectedItem(
                                      id: orderLine.orderLineId ?? '',
                                      orderItems: state.orderItemsData,
                                      orderLine: orderLine,
                                    ));
                                  },
                                ),
                                emptyDataMessage: 'No items to be returned',
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(5),
                                  2: FlexColumnWidth(3),
                                  3: FlexColumnWidth(2),
                                },
                              ),
                            ),
                          if (!isCustomerOrdersFetched && !isOrderItemsFetched)
                            _buildFormUI(state.isLoading),
                        ],
                      ),
                    ),
                  ),

                  /* SECTION - 2 */
                  Expanded(flex: 2, child: numpadSection(state)),

                  /* SECTION - 3 */
                  Expanded(
                    flex: 1,
                    child: QuickActionButtons(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormUI(bool isLoading) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Returns",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 5),
          Text(
            "Enter the details to retrieve order & start returns.",
            style: TextStyle(
              color: Colors.black.withAlpha(153),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 350,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  commonTextField(
                    focusNode: customerNumberFocusNode,
                    controller: customerNumberTextController,
                    label: "Enter Customer Mobile Number",
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          orderNumberTextController.text.isEmpty) {
                        return 'Please enter a phone number';
                      } else if (value!.length != 10 &&
                          customerNumberTextController.text.trim().isEmpty &&
                          orderNumberTextController.text.isEmpty) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const ORWidget(),
                  const SizedBox(height: 20),
                  commonTextField(
                    focusNode: orderNumberFocusNode,
                    controller: orderNumberTextController,
                    label: "Enter Order Number",
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          customerNumberTextController.text.isEmpty) {
                        return 'Please enter order number';
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : onClickSearchOrders,
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          minimumSize: const Size(double.infinity, 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: CustomColors.secondaryColor,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 3))
                            : Text(
                                "Search orders",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget numpadSection(ReturnsState state) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  contentPadding:
                      EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 10),
                  title: Text(
                    isOrderItemsFetched
                        ? 'Enter Returnable Quantity'
                        : customerNumberFocusNode.hasFocus
                            ? 'Enter Customer Mobile Number'
                            : orderNumberFocusNode.hasFocus
                                ? 'Enter Order Number'
                                : customerNumberTextController.text.isNotEmpty
                                    ? 'Customer Mobile Number'
                                    : orderNumberTextController.text.isNotEmpty
                                        ? 'Order Number'
                                        : 'Enter Customer/Order Number',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 10, right: 10, top: 0),
                  child: DashedLine(
                    height: 0.4,
                    dashWidth: 4,
                    color: Colors.grey,
                  ),
                ),
                if (isOrderItemsFetched)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: commonTextField(
                      label: 'Enter Quantity',
                      focusNode: numPadFocusNode,
                      readOnly: false,
                      controller: numPadTextController,
                      onValueChanged: (value) {},
                    ),
                  ),
                if (!isOrderItemsFetched)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          numPadTextController.text,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.black),
                        )),
                  ),
                CustomNumPad(
                  focusNode: activeFocusNode!,
                  textController: numPadTextController,
                  onValueChanged: (value) {
                    if (activeFocusNode == customerNumberFocusNode) {
                      customerNumberTextController.text = value;
                    } else if (activeFocusNode == orderNumberFocusNode) {
                      orderNumberTextController.text = value;
                    } else if (activeFocusNode == numPadFocusNode) {
                      numPadTextController.text = value;
                    }
                  },
                  onEnterPressed: (value) {
                    if (activeFocusNode == customerNumberFocusNode) {
                      customerNumberFocusNode.unfocus();
                    } else if (activeFocusNode == orderNumberFocusNode) {
                      orderNumberFocusNode.unfocus();
                    } else if (activeFocusNode == numPadFocusNode) {
                      if ((returnsBloc.state.lastSelectedItem.returnableQuantity
                              ?.quantityNumber)! >=
                          double.parse(numPadTextController.text)) {
                        final updatedItem =
                            returnsBloc.state.lastSelectedItem.copyWith(
                          returnedQuantity: returnsBloc.state.lastSelectedItem
                                      .returnableQuantity?.quantityUom ==
                                  "pcs"
                              ? int.parse(numPadTextController.text.toString())
                              : double.parse(
                                  numPadTextController.text.toString(),
                                ),
                        );

                        final updatedOrderLines = returnsBloc
                            .state.orderItemsData.orderLines
                            ?.map((item) {
                          if (item.orderLineId == updatedItem.orderLineId) {
                            return updatedItem;
                          }
                          return item;
                        }).toList();

                        final updatedOrderItemsData =
                            returnsBloc.state.orderItemsData.copyWith(
                          orderLines: updatedOrderLines,
                        );

                        returnsBloc.add(UpdateSelectedItem(
                          id: updatedItem.orderLineId ?? '',
                          orderItems: updatedOrderItemsData,
                          orderLine: updatedItem,
                        ));
                      } else {
                        Get.snackbar(
                          "Invalid Quantity",
                          "Returnable quantity should not be more than ${(returnsBloc.state.lastSelectedItem.returnableQuantity?.quantityNumber)!}",
                        );
                      }
                    }
                  },
                  onClearAll: (p0) {},
                ),
              ],
            ),
          ),
          Spacer(),
          buildProceedBtnUI(state),
        ],
      ),
    );
  }

  Widget buildProceedBtnUI(ReturnsState state) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          // borderRadius: BorderRadius.circular(
          //     10),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Items',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Savings',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "--",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
              child: ElevatedButton(
                onPressed: state.isProceedBtnEnabled
                    ? () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: ReturnSummaryWidget(
                                customer: _customerDetails,
                                returnsConfirmationTableData:
                                    _returnsConfirmationTableData,
                                onTapClose: () {
                                  _resetAllValues();
                                  Get.back();
                                },
                                onPaymentModeSelected: (String mode) {
                                  // Handle payment mode selection
                                },
                              ),
                            );
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: CustomColors.secondaryColor),
                child: SizedBox(
                  height: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Proceed",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ORWidget extends StatelessWidget {
  const ORWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: CustomColors.borderColor,
          ),
        ),
        SizedBox(width: 10),
        Text(
          "OR",
          style: TextStyle(
            color: CustomColors.greyFont,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: CustomColors.borderColor,
          ),
        ),
      ],
    );
  }
}
