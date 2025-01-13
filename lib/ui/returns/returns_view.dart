import 'package:ebono_pos/ui/returns/data/returns_confirmation_table_data.dart';
import 'package:ebono_pos/ui/returns/widgets/summary_payment_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/ui/returns/data/customer_table_data.dart';
import 'package:ebono_pos/ui/returns/data/order_items_table_data.dart';
import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:ebono_pos/widgets/custom_table/custom_table_widget.dart';
import 'package:ebono_pos/widgets/order_details_widget.dart';

class ReturnsView extends StatefulWidget {
  const ReturnsView({super.key});

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  late ReturnsBloc returnsBloc;

  late TextEditingController customerNumberTextController;
  late TextEditingController orderNumberTextController;
  late TextEditingController numPadTextController;

  /* Num Pad */
  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode orderNumberFocusNode = FocusNode();
  FocusNode? activeFocusNode;

  final _formKey = GlobalKey<FormState>();

  /* State Management */
  bool isCustomerOrdersFetched = false;
  bool isOrderItemsFetched = false;
  bool triggerProccedToPayDialog = false;
  bool isOrderDetailsRetriving = false;

  Customer _customerDetails = Customer();

  late CustomerTableData _customerTableData;
  late OrderItemsTableData _orderItemsTableData;
  late ReturnsConfirmationTableData _returnsConfirmationTableData;

  String customerName = '';
  String walletBalance = '';
  String phoneNumber = '';
  String loyaltyPoints = '';
  String title = '';

  @override
  void initState() {
    customerNumberTextController = TextEditingController();
    orderNumberTextController = TextEditingController();
    numPadTextController = TextEditingController();

    // returnsBloc = Get.put(ReturnsBloc(Get.find<ReturnsRepository>()));
    returnsBloc = Get.find<ReturnsBloc>();
    _customerTableData = CustomerTableData(context: context);
    _orderItemsTableData = OrderItemsTableData(context: context);
    _returnsConfirmationTableData =
        ReturnsConfirmationTableData(context: context);

    activeFocusNode = customerNameFocusNode;

    customerNameFocusNode.addListener(() {
      setState(() {
        if (customerNameFocusNode.hasFocus) {
          activeFocusNode = customerNameFocusNode;
        }
        numPadTextController.text = customerNumberTextController.text;
      });
    });

    orderNumberFocusNode.addListener(() {
      setState(() {
        if (orderNumberFocusNode.hasFocus) {
          activeFocusNode = orderNumberFocusNode;
        }

        orderNumberTextController.text = numPadTextController.text;
      });
    });

    numPadTextController.addListener(() {
      if (activeFocusNode == customerNameFocusNode) {
        customerNumberTextController.text = numPadTextController.text;
      } else if (activeFocusNode == orderNumberFocusNode) {
        orderNumberTextController.text = numPadTextController.text;
      }
    });

    print("inistate");

    super.initState();
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
  void didChangeDependencies() {
    print("called");
    super.didChangeDependencies();
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
                          if (isCustomerOrdersFetched)
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
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(5),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(2),
                                  4: FlexColumnWidth(3),
                                },
                              ),
                            ),
                          if (isOrderItemsFetched)
                            Expanded(
                              child: CustomTableWidget(
                                headers: _orderItemsTableData
                                    .buildOrderItemsTableHeader(),
                                tableRowsData:
                                    _orderItemsTableData.buildTableRows(
                                  orderItemsData: state.orderItemsData,
                                  onTapSelectedButton: (id) {
                                    print(
                                        "DID: ${state.orderItemsData.deliveryGroupId}");
                                    returnsBloc.add(UpdateSelectedItem(
                                      id: id!,
                                      orderItems: state.orderItemsData,
                                    ));
                                  },
                                ),
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(4.5),
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
                      onClearCartPressed:
                          isCustomerOrdersFetched || isOrderItemsFetched
                              ? () {
                                  customerNumberTextController.clear();
                                  orderNumberTextController.clear();
                                  isCustomerOrdersFetched = false;
                                  isOrderItemsFetched = false;
                                  _customerDetails = const Customer();
                                  setState(() {});
                                }
                              : null,
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
                  TextFormField(
                    // focusNode: customerNameFocusNode,
                    controller: customerNumberTextController,
                    decoration: _buildInputDecoration(
                      label: "Enter Customer Mobile Number",
                    ),
                    maxLength: 10,
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),
                  const ORWidget(),
                  const SizedBox(height: 20),
                  TextFormField(
                    // focusNode: orderNumberFocusNode,
                    controller: orderNumberTextController,
                    decoration: _buildInputDecoration(
                      label: "Enter Order Number",
                    ),
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          customerNumberTextController.text.isEmpty) {
                        return 'Please enter order number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

  // Widget _buildNumberPadSection() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               border: Border.all(color: Colors.grey),
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(10),
  //                 topRight: Radius.circular(10),
  //                 bottomLeft: Radius.circular(10),
  //                 bottomRight: Radius.circular(10),
  //               ),
  //               // borderRadius: BorderRadius.circular(
  //               //     10),
  //               shape: BoxShape.rectangle,
  //             ),
  //             child: Column(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(10.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Expanded(
  //                         flex: 2,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                               padding: EdgeInsets.only(right: 2),
  //                               child: Text(" - ",
  //                                   maxLines: 2,
  //                                   softWrap: true,
  //                                   overflow: TextOverflow.ellipsis,
  //                                   style: TextStyle(
  //                                       overflow: TextOverflow.ellipsis,
  //                                       color: Colors.black,
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.bold)),
  //                             ),
  //                             SizedBox(height: 5),
  //                             RichText(
  //                               text: TextSpan(
  //                                 children: <TextSpan>[
  //                                   TextSpan(
  //                                     text: 'QTY:',
  //                                     style: TextStyle(
  //                                         color: Colors.black87,
  //                                         fontSize: 12,
  //                                         fontWeight: FontWeight.w400),
  //                                   ),
  //                                   TextSpan(
  //                                     text: " - ",
  //                                     style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontSize: 13,
  //                                         fontWeight: FontWeight.normal),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(height: 5),
  //                             RichText(
  //                               text: TextSpan(
  //                                 children: <TextSpan>[
  //                                   TextSpan(
  //                                     text: 'Price:',
  //                                     style: TextStyle(
  //                                         color: Colors.black87,
  //                                         fontSize: 12,
  //                                         fontWeight: FontWeight.w400),
  //                                   ),
  //                                   TextSpan(
  //                                     text: ' - ',
  //                                     style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         padding: EdgeInsets.all(4),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           border: Border.all(color: Colors.grey.shade300),
  //                           borderRadius: BorderRadius.circular(10),
  //                           shape: BoxShape.rectangle,
  //                         ),
  //                         child: Image.network(
  //                           '',
  //                           cacheHeight: 50,
  //                           cacheWidth: 50,
  //                           errorBuilder: (BuildContext context, Object error,
  //                               StackTrace? stackTrace) {
  //                             return Center(
  //                               child: Container(
  //                                 height: 50,
  //                                 width: 50,
  //                                 color: CustomColors.cardBackground,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding:
  //                       const EdgeInsets.only(bottom: 10, left: 10, right: 10),
  //                   child: DashedLine(
  //                     height: 0.4,
  //                     dashWidth: 4,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                       child: commonTextField(
  //                         label: ' Enter Code, Quantity ',
  //                         readOnly: true,
  //                         focusNode: activeFocusNode ?? FocusNode(),
  //                         controller: numPadTextController,
  //                       ),
  //                     ),
  //                     CustomNumPad(
  //                       focusNode: activeFocusNode!,
  //                       textController: numPadTextController,
  //                       onValueChanged: (value) {
  //                         if (activeFocusNode == customerNameFocusNode) {
  //                           customerNumberTextController.text = value;
  //                         }
  //                         if (activeFocusNode == orderNumberFocusNode) {
  //                           orderNumberTextController.text = value;
  //                         }
  //                       },
  //                       onEnterPressed: (value) {
  //                         if (activeFocusNode == customerNameFocusNode) {
  //                           customerNameFocusNode.unfocus();
  //                         }
  //                         if (activeFocusNode == orderNumberFocusNode) {
  //                           orderNumberFocusNode.unfocus();
  //                         }
  //                       },
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(height: 10)
  //               ],
  //             ),
  //           ),
  //         ),
  //         Spacer(),
  //         Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Container(
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 border: Border.all(color: Colors.grey),
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(10),
  //                   topRight: Radius.circular(10),
  //                   bottomLeft: Radius.circular(10),
  //                   bottomRight: Radius.circular(10),
  //                 ),
  //                 // borderRadius: BorderRadius.circular(
  //                 //     10),
  //                 shape: BoxShape.rectangle,
  //               ),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.only(
  //                         left: 10, right: 10, top: 5, bottom: 10),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'Total Items',
  //                               style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                             Text(
  //                               '-',
  //                               style: TextStyle(
  //                                   color: Colors.black87,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             ),
  //                           ],
  //                         ),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'Total Savings',
  //                               style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                             Text(
  //                               "-",
  //                               style: TextStyle(
  //                                   color: Colors.black87,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w600),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     width: double.infinity,
  //                     padding: EdgeInsets.only(
  //                         left: 4, right: 4, top: 10, bottom: 4),
  //                     child: ElevatedButton(
  //                       onPressed: () {},
  //                       style: ElevatedButton.styleFrom(
  //                           elevation: 1,
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 1, vertical: 10),
  //                           shape: RoundedRectangleBorder(
  //                             side: BorderSide.none,
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           backgroundColor: CustomColors.cardBackground),
  //                       child: SizedBox(
  //                         height: 56,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               "Proceed",
  //                               style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize: 26,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               )),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _returnConfirmationDialog(BuildContext context) {
  //   return SizedBox(
  //     width: MediaQuery.sizeOf(context).width * 0.9,
  //     height: MediaQuery.sizeOf(context).height * 0.88,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 20,
  //         vertical: 25,
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           /* HEADER */
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 10),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Return Confirmation",
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: SvgPicture.asset(
  //                     'assets/images/ic_close.svg',
  //                     semanticsLabel: 'cash icon,',
  //                     width: 30,
  //                     height: 30,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           Expanded(
  //             flex: 6,
  //             child: Row(
  //               children: [
  //                 /* SECTION - 1 */
  //                 Expanded(
  //                   flex: 6,
  //                   child: CustomTableWidget(
  //                     headers: _returnsConfirmationTableData
  //                         .buildReturnOrderItemsTableHeader(),
  //                     tableRowsData:
  //                         _returnsConfirmationTableData.buildTableRows(
  //                       onTapSelectedButton: (id) {},
  //                     ),
  //                     columnWidths: {
  //                       0: FlexColumnWidth(1.5),
  //                       1: FlexColumnWidth(3),
  //                       2: FlexColumnWidth(0.8),
  //                       3: FlexColumnWidth(2.5),
  //                     },
  //                   ),
  //                 ),

  //                 /* SECTION - 2 */
  //                 SummaryPaymentSection(
  //                   totalRefund: 1235,
  //                   loyaltyPoints: 5,
  //                   walletAmount: 30,
  //                   mopAmount: 1200,
  //                   customerTableData: _customerTableData,
  //                   returnsConfirmationTableData: _returnsConfirmationTableData,
  //                   onPaymentModeSelected: (String mode) {
  //                     // Handle payment mode selection
  //                   },
  //                 )
  //               ],
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               CustomQwertyPad(
  //                 textController: TextEditingController(),
  //                 focusNode: FocusNode(),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                  // trailing: SvgPicture.asset(
                  //   'assets/images/ic_cash_inhand.svg',
                  //   semanticsLabel: 'cash icon,',
                  //   width: 40,
                  //   height: 40,
                  // ),
                  title: Text(
                    customerNameFocusNode.hasFocus
                        ? 'Customer Name'
                        : 'Order Id',
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
                    if (activeFocusNode == customerNameFocusNode) {
                      customerNumberTextController.text = value;
                    } else if (activeFocusNode == orderNumberFocusNode) {
                      orderNumberTextController.text = value;
                    }
                  },
                  onEnterPressed: (value) {
                    if (activeFocusNode == customerNameFocusNode) {
                      customerNameFocusNode.unfocus();
                    } else if (activeFocusNode == orderNumberFocusNode) {
                      orderNumberFocusNode.unfocus();
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
                              child: SummaryPaymentSection(
                                customer: _customerDetails,
                                returnsConfirmationTableData:
                                    _returnsConfirmationTableData,
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

  InputDecoration _buildInputDecoration({
    required String label,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      counterText: "",
      fillColor: Colors.white,
      labelStyle: TextStyle(
        color: CustomColors.greyFont,
      ),
      focusColor: Colors.black,
      floatingLabelStyle: TextStyle(
        color: CustomColors.black,
      ),
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
      suffixIcon: suffixIcon,
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
