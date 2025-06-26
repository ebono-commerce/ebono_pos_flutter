import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/extensions/string_extension.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/widgets/add_customer_widget.dart';
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
import 'package:flutter_svg/svg.dart';
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
  bool displayProxyNumberError = false;
  bool showOrderItemsOnSuccess = false;
  bool showCustomerOrdersOnSuccess = false;
  String? storeTempOrderId;

  /* New Flags to show or hide the table data */
  bool displayCustomerOrdersTableData = false;
  bool displayOrderItemsTableData = false;
  bool displayFormField = true;
  bool displayInitialEmptyTable = true;

  /* Flags for dialog */
  bool isCustomerDialogOpened = false;

  /* For Table Data */
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
        numPadTextController.text =
            customerNumberTextController.text.replaceAll(RegExp(r'[^0-9]'), '');
      });
    });

    orderNumberFocusNode.addListener(() {
      setState(() {
        if (orderNumberFocusNode.hasFocus) {
          activeFocusNode = orderNumberFocusNode;
        }

        numPadTextController.text =
            orderNumberTextController.text.replaceAll(RegExp(r'[^0-9]'), '');
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
      numPadTextController.text =
          numPadTextController.text.limitDecimalDigits(decimalRange: 3);
      setState(() {
        if (activeFocusNode == customerNumberFocusNode) {
          if (numPadTextController.text.length <= 10) {
            customerNumberTextController.text =
                numPadTextController.text.replaceAll(RegExp(r'[^0-9]'), '');
          } else {
            numPadTextController.text = numPadTextController.text
                .substring(0, 10)
                .replaceAll(RegExp(r'[^0-9]'), '');
          }
        } else if (activeFocusNode == orderNumberFocusNode) {
          orderNumberTextController.text =
              numPadTextController.text.replaceAll(RegExp(r'[^0-9]'), '');
        }
      });
    });

    super.initState();
  }

  void _resetAllValues() {
    returnsBloc.add(ReturnsResetEvent());
    homeController.isReturnViewReset.value = false;
    setState(() {});
  }

  void onClickSearchOrders() {
    if (!context.mounted) return;

    bool hasCustomerNumber =
        customerNumberTextController.text.trim().isNotEmpty;

    setState(() => displayProxyNumberError = false);
    if (_formKey.currentState!.validate()) {
      if (homeController.customerProxyNumber.value ==
          customerNumberTextController.text.trim()) {
        setState(() => displayProxyNumberError = true);
        _formKey.currentState?.validate();
      } else if (hasCustomerNumber) {
        returnsBloc.add(
          FetchCustomerOrdersData(customerNumberTextController.text),
        );
      } else {
        setState(() => storeTempOrderId = orderNumberTextController.text);
        returnsBloc.add(
          FetchOrderDataBasedOnOrderId(
            orderId: orderNumberTextController.text,
            outletId: homeController.selectedOutletId,
          ),
        );
      }
    }
  }

  void addORVerifyCustomerDialog({
    required String name,
    required String mobileNumber,
    bool isDialogForAddCustomer = false,
    String? orderId,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: AddCustomerWidget(
            context,
            isDialogForReturns: true,
            customerMobileNumber: mobileNumber,
            isDialogForAddCustomerFromReturns: isDialogForAddCustomer,
            customerName: name,
            disableFormFields: isDialogForAddCustomer ? false : true,
            onOTPVerifiedSuccessfully: (status) {
              if (status == true && isDialogForAddCustomer == false) {
                /* to display customer data */
                if (showCustomerOrdersOnSuccess == true &&
                    showOrderItemsOnSuccess == false) {
                  setState(() {
                    displayCustomerOrdersTableData = true;
                    displayOrderItemsTableData = false;
                    displayFormField = false;
                    displayInitialEmptyTable = false;
                  });
                  returnsBloc.add(FetchCustomerOrdersData(mobileNumber));
                }

                /* to display order items data */
                if (showOrderItemsOnSuccess == true &&
                    storeTempOrderId != null &&
                    showCustomerOrdersOnSuccess == false) {
                  setState(() {
                    displayCustomerOrdersTableData = false;
                    displayOrderItemsTableData = true;
                    displayFormField = false;
                    displayInitialEmptyTable = false;
                  });

                  returnsBloc.add(
                    FetchOrderDataBasedOnOrderId(
                      orderId: storeTempOrderId!,
                      outletId: homeController.selectedOutletId,
                    ),
                  );
                }
              } else if (status == true && isDialogForAddCustomer == true) {
                /* upon success, we are updating customer data & verification status in internal state */
                returnsBloc.add(
                  UpdateOrderItemsInternalState(
                    customerName: homeController
                            .getCustomerDetailsResponse.value.customerName ??
                        '',
                    customerNumber: homeController.phoneNumber.value,
                  ),
                );
                setState(() => isCustomerDialogOpened == false);
              }

              Get.back();
            },
          ),
        );
      },
    );

    homeController.displayOTPScreen.value = false;
    homeController.getCustomerDetailsResponse.value.existingCustomer = null;

    setState(() => isCustomerDialogOpened = false);
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
            if (state.isCustomerOrdersDataFetched == true) {
              /* check whether customer needs verification or not*/
              if (state.customerOrders.isCustomerVerificationRequired == true &&
                  state.customerOrders.customerOrderList.isNotEmpty &&
                  isCustomerDialogOpened == false) {
                setState(() {
                  showCustomerOrdersOnSuccess = true;
                  showOrderItemsOnSuccess = false;
                });
                addORVerifyCustomerDialog(
                  mobileNumber: state.customerOrders.customerOrderList.first
                          .customer?.phoneNumber?.number ??
                      'NA',
                  name: state.customerOrders.customerOrderList.first.customer
                          ?.customerName ??
                      'NA',
                  isDialogForAddCustomer: false,
                  orderId: null,
                );
              } else {
                /* New parameters to show or hide table */
                displayCustomerOrdersTableData = true;
                isCustomerOrdersFetched = true;
                displayOrderItemsTableData = false;
                displayInitialEmptyTable = false;
                displayFormField = false;
                /* clearing the un-used values */
                customerNumberTextController.clear();
                numPadTextController.clear();
                _customerDetails = state
                        .customerOrders.customerOrderList.isNotEmpty
                    ? state.customerOrders.customerOrderList.first.customer ??
                        Customer()
                    : Customer();
              }
              setState(() => isCustomerDialogOpened = true);
            } else if (state.isOrderItemsFetched == true) {
              /* check whether customer needs verification or not*/
              if (state.orderItemsData.isCustomerVerificationRequired == true &&
                  state.orderItemsData.orderLines?.isNotEmpty == true &&
                  state.orderItemsData.customer?.isProxyNumber == false &&
                  isCustomerDialogOpened == false) {
                setState(() {
                  showOrderItemsOnSuccess = true;
                  showCustomerOrdersOnSuccess = false;
                });
                addORVerifyCustomerDialog(
                  mobileNumber:
                      state.orderItemsData.customer?.phoneNumber?.number ??
                          'NA',
                  name: state.orderItemsData.customer?.customerName ?? 'NA',
                  orderId: state.orderItemsData.orderNumber,
                  isDialogForAddCustomer: false,
                );
                setState(() {
                  isCustomerDialogOpened = true;
                });
              }
              /* when search with order id which is billed with store proxy number */
              else if (state.orderItemsData.isCustomerVerificationRequired ==
                      true &&
                  state.orderItemsData.orderLines?.isNotEmpty == true &&
                  state.orderItemsData.customer?.isProxyNumber == true &&
                  isCustomerDialogOpened == false) {
                setState(() {
                  showOrderItemsOnSuccess = false;
                  showCustomerOrdersOnSuccess = false;
                });
                addORVerifyCustomerDialog(
                  mobileNumber: '',
                  name: '',
                  isDialogForAddCustomer: true,
                  orderId: state.orderItemsData.orderNumber,
                );
                setState(() {
                  isCustomerDialogOpened = true;
                });
              } else {
                /* New parameters to show or hide table */
                displayOrderItemsTableData = true;
                displayCustomerOrdersTableData = false;
                displayInitialEmptyTable = false;
                displayFormField = false;
                isCustomerOrdersFetched = false;
                isOrderItemsFetched = true;

                /* clearing the un-used values */
                // orderNumberTextController.clear();
                // numPadTextController.clear();
                activeFocusNode = numPadFocusNode;
              }
              setState(() => isCustomerDialogOpened = true);
            }
            /* resetting all values */
            else if (state.resetAllValues == true) {
              displayCustomerOrdersTableData = false;
              displayCustomerOrdersTableData = false;
              displayInitialEmptyTable = true;
              displayFormField = true;
              isCustomerDialogOpened = false;
              customerNumberTextController.clear();
              orderNumberTextController.clear();
              numPadTextController.clear();
              isCustomerOrdersFetched = false;
              isOrderItemsFetched = false;
              displayOrderItemsTableData = false;
              numPadTextController.clear();
              _customerDetails = state.orderItemsData.customer ?? Customer();
              setState(() {});
            }

            /* if nothing is selected clearing numpad */
            if (state.orderItemsData.orderLines
                    ?.every((orderitem) => orderitem.isSelected == false) ==
                true) {
              numPadTextController.clear();
              numPadFocusNode.unfocus();
            } else {
              numPadFocusNode.requestFocus();
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
                          if (displayInitialEmptyTable == true &&
                              homeController.registerId.value.isNotEmpty)
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
                          /*isCustomerOrdersFetched ||  state.isFetchingOrderItems */
                          if (displayCustomerOrdersTableData)
                            Expanded(
                              child: CustomTableWidget(
                                headers: _customerTableData
                                    .buildCustomerOrdersTableHeader(),
                                tableRowsData:
                                    _customerTableData.buildTableRows(
                                  customerOrderDetails:
                                      state.customerOrders.customerOrderList,
                                  onClickRetrive: (orderId) {
                                    returnsBloc.add(
                                      FetchOrderDataBasedOnOrderId(
                                        orderId: orderId!,
                                        isRetrivingOrderItems: true,
                                        outletId:
                                            homeController.selectedOutletId,
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
                          /*isOrderItemsFetched && !state.isFetchingOrderItems */
                          if (displayOrderItemsTableData)
                            Expanded(
                              child: CustomTableWidget(
                                headers: _orderItemsTableData
                                    .buildOrderItemsTableHeader(
                                  isAllOrdersSelected:
                                      state.orderItemsData.isAllOrdersSelected,
                                  onTapSelectAll: () {
                                    returnsBloc.add(OnSelectAllBtnEvent());
                                  },
                                  hideButton: state
                                          .orderItemsData.orderLines?.isEmpty ==
                                      true,
                                ),
                                tableRowsData:
                                    _orderItemsTableData.buildTableRows(
                                  orderItemsData: state.orderItemsData,
                                  returnsBLoc: returnsBloc,
                                  onTapTextFieldButton: (orderLine) {
                                    if (orderLine.isSelected == true) {
                                      numPadTextController.text =
                                          '${orderLine.returnedQuantity ?? ''}';
                                      numPadFocusNode.requestFocus();
                                      returnsBloc.add(
                                        UpdateSelectedItem(
                                          id: orderLine.orderLineId!,
                                          isSelected: true,
                                          orderLine: orderLine,
                                        ),
                                      );
                                    }
                                  },
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
                                      // orderItems: state.orderItemsData,
                                      orderLine: orderLine,
                                      isSelected: !orderLine.isSelected,
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
                          if (displayFormField &&
                              homeController.registerId.value.isNotEmpty) ...[
                            _buildFormUI(
                              isLoading: state.isLoading,
                              isStoreOrderNumber: state.isStoreOrderNumber,
                            )
                          ],
                          if (homeController.registerId.value.isEmpty) ...[
                            Expanded(
                              child: Center(
                                child: _buildRegisterClosed(
                                  context,
                                  onPressed: () async {
                                    homeController.selectedTabButton.value = 1;
                                  },
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),

                  /* SECTION - 2 */
                  Expanded(flex: 2, child: numpadSection(state)),

                  /* SECTION - 3 */
                  const Expanded(
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

  Widget _buildFormUI({
    required bool isLoading,
    required bool isStoreOrderNumber,
  }) {
    return Expanded(
      child: Row(
        spacing: 50,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
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
                          acceptableLength: 10,
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                orderNumberTextController.text.isEmpty) {
                              return 'Please enter a phone number';
                            } else if (value!.length != 10 &&
                                customerNumberTextController.text
                                    .trim()
                                    .isEmpty &&
                                orderNumberTextController.text.isEmpty) {
                              return 'Phone number must be 10 digits';
                            } else if (displayProxyNumberError) {
                              return "Please search with customer number";
                            } else if (customerNumberTextController
                                    .text.isNotEmpty &&
                                value.trim().length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                          onTap: () {
                            orderNumberTextController.clear();
                          }),
                      const SizedBox(height: 20),
                      const ORWidget(),
                      const SizedBox(height: 20),
                      commonTextField(
                          focusNode: orderNumberFocusNode,
                          controller: orderNumberTextController,
                          label: "Enter Store Order / Order Number",
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                customerNumberTextController.text.isEmpty) {
                              return 'Please enter order number';
                            } else if (orderNumberTextController
                                    .text.isNotEmpty &&
                                value != null &&
                                value.length < 8) {
                              return "Please enter valid order number";
                            }
                            return null;
                          },
                          onTap: () {
                            customerNumberTextController.clear();
                          }),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => returnsBloc.add(UpdateOrderType(true)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'Store Order',
                                    splashRadius: 0,
                                    groupValue: isStoreOrderNumber
                                        ? 'Store Order'
                                        : 'Order',
                                    onChanged: (_) =>
                                        returnsBloc.add(UpdateOrderType(true)),
                                  ),
                                  Text(
                                    'Store Order No',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () =>
                                returnsBloc.add(UpdateOrderType(false)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'Order',
                                    splashRadius: 0,
                                    groupValue: isStoreOrderNumber
                                        ? 'Store Order'
                                        : 'Order',
                                    onChanged: (_) =>
                                        returnsBloc.add(UpdateOrderType(false)),
                                  ),
                                  Text(
                                    'Order No',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : onClickSearchOrders,
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1),
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
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3))
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
          SvgPicture.asset(
            'assets/images/cashier_instructions.svg',
            height: 450,
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
            margin: EdgeInsets.only(top: 10),
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
                      if (numPadTextController.text.isEmpty) {
                        return;
                      } else if (double.tryParse(
                              numPadTextController.text.toString()) ==
                          0) {
                        Get.snackbar("Invalid Quantity",
                            "Returnable quantity should not be Zero");
                      } else
                      /* checking whether user is entering or updating quantity for weigh items or non weigh items */
                      if (returnsBloc.state.lastSelectedItem.returnableQuantity
                              ?.quantityUom ==
                          'pcs') {
                        /* check for double i.e non-integer values */
                        if (double.tryParse(numPadTextController.text)
                                ?.truncateToDouble() !=
                            double.tryParse(numPadTextController.text)) {
                          Get.snackbar("Invalid Quantity",
                              "Returnable quantity should be in Integer");
                        } else if (int.parse(numPadTextController.text) <=
                            returnsBloc.state.lastSelectedItem
                                .returnableQuantity!.quantityNumber!) {
                          returnsBloc.add(UpdateOrderLineQuantity(
                            id: returnsBloc.state.lastSelectedItem.orderLineId!,
                            quantity: numPadTextController.text,
                          ));
                        } else {
                          Get.snackbar("Invalid Quantity",
                              "Returnable quantity should not be more than ${returnsBloc.state.lastSelectedItem.returnableQuantity!.quantityNumber}");
                        }
                      } else {
                        /* check for not empty & returnable quantity isNot greaterthan eligible quantity */
                        if (numPadTextController.text.trim().isNotEmpty &&
                            (returnsBloc.state.lastSelectedItem
                                    .returnableQuantity?.quantityNumber)! >=
                                double.parse(numPadTextController.text)) {
                          /* when appropriate weigh or quantity is selected from numpad */
                          returnsBloc.add(UpdateOrderLineQuantity(
                            id: returnsBloc.state.lastSelectedItem.orderLineId!,
                            quantity: numPadTextController.text.toString(),
                          ));
                        } else {
                          Get.snackbar(
                            "Invalid Quantity",
                            "Returnable quantity should not be more than ${(returnsBloc.state.lastSelectedItem.returnableQuantity?.quantityNumber)!}",
                          );
                        }
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
                    ? () async {
                        await showDialog(
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
                                  returnsBloc.add(ReturnsResetEvent());
                                  Get.back();
                                },
                                onPaymentModeSelected: (String mode) {
                                  // Handle payment mode selection
                                },
                              ),
                            );
                          },
                        );
                        // Clearing Dropdown values on dialog close
                        returnsBloc.add(ResetValuesOnDialogCloseEvent());
                        if (returnsBloc.state.isOrderReturnedSuccessfully) {
                          homeController.isReturnViewReset.value = true;
                        }
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

  Widget _buildRegisterClosed(BuildContext context, {VoidCallback? onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(
          child: Text(
            "Register is closed!",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: CustomColors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Set an opening float to start the sale",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.normal, color: CustomColors.black),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 1,
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: CustomColors.secondaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: CustomColors.secondaryColor,
            ),
            child: Center(
              child: Text(
                "Open register",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: CustomColors.black),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
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
