import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/ui/returns/data/customer_table_data.dart';
import 'package:ebono_pos/ui/returns/data/order_items_table_data.dart';
import 'package:ebono_pos/ui/returns/data/returns_confirmation_table_data.dart';
import 'package:ebono_pos/ui/returns/widgets/summary_payment_section.dart';
import 'package:ebono_pos/widgets/custom_table/custom_table_widget.dart';
import 'package:ebono_pos/widgets/num_pad_widget.dart';
import 'package:ebono_pos/widgets/order_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ReturnsView extends StatefulWidget {
  const ReturnsView({super.key});

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  final TextEditingController customerNumberController =
      TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isCustomerOrdersFetched = false;
  bool isOrderItemsFetched = false;
  bool triggerProccedToPayDialog = false;

  late CustomerTableData _customerTableData;
  late OrderItemsTableData _orderItemsTableData;
  late ReturnsConfirmationTableData _returnsConfirmationTableData;

  void onClickSearchOrders() {
    // if (customerNumberController.text.isEmpty &&
    //     orderNumberController.text.isEmpty) {
    //   // If both are empty, trigger full form validation
    //   _formKey.currentState!.validate();
    // } else if (customerNumberController.text.isNotEmpty) {
    //   // If customer number is provided, validate only that field
    //   if (_formKey.currentState!.validate()) {
    //     context.read<ReturnsBloc>().add(FetchCustomerOrdersData(
    //           customerNumberController.text,
    //         ));
    //   }
    // } else if (orderNumberController.text.isNotEmpty) {
    //   // If order number is provided, no validation needed
    //   if (_formKey.currentState!.validate()) {
    //     context.read<ReturnsBloc>().add(FetchOrderDataBasedOnOrderId(
    //           orderNumberController.text,
    //         ));
    //   }
    // }

    if (_formKey.currentState!.validate()) {
      if (customerNumberController.text.isNotEmpty) {
        context.read<ReturnsBloc>().add(FetchCustomerOrdersData(
              customerNumberController.text,
            ));
      }
      if (orderNumberController.text.isNotEmpty) {
        context.read<ReturnsBloc>().add(FetchOrderDataBasedOnOrderId(
              orderNumberController.text,
            ));
      }
    }
  }

  @override
  void initState() {
    _customerTableData = CustomerTableData(context: context);
    _orderItemsTableData = OrderItemsTableData(context: context);
    _returnsConfirmationTableData =
        ReturnsConfirmationTableData(context: context);
    super.initState();
  }

  @override
  void dispose() {
    customerNumberController.dispose();
    orderNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ReturnsBloc, ReturnsState>(
        listener: (context, state) {
          if (state.isCustomerOrdersDataFetched) {
            isCustomerOrdersFetched = true;
            isOrderItemsFetched = false;
          }
          if (state.isOrderItemsFetched) {
            isOrderItemsFetched = true;
            isCustomerOrdersFetched = false;
          }
          setState(() {});
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
                        const OrderDetailsWidget(
                          customerName: "",
                          walletBalance: "",
                          phoneNumber: "-",
                          loyaltyPoints: "-",
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
                                  _customerTableData.buildTableRows(),
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
                                onTapSelectedButton: (id) {},
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
                          _buildFormUI(context),
                      ],
                    ),
                  ),
                ),

                /* SECTION - 2 */
                Expanded(
                  flex: 2,
                  child: NumPadWidget(
                    skuPrice: '',
                    skuQty: '',
                    skuQtyUom: '',
                    skuTitle: '',
                    skuUrl: '',
                    numPadFocusNode: FocusNode(),
                    numPadTextEditingController: TextEditingController(),
                    onNumPadClearAll: (p0) {},
                    onNumPadEnterPressed: (p0) {},
                    onNumPadValueChanged: (p0) {},
                    onTextFormFieldValueChanged: (p0) {},
                    onProceedToPayClicked: isCustomerOrdersFetched ||
                            isOrderItemsFetched
                        ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: _returnOrderDropdown(context),
                                );
                              },
                            );
                          }
                        : null,
                    textFieldFocusNode: FocusNode(),
                    textFieldTextEditingController: TextEditingController(),
                  ),
                ),

                /* SECTION - 3 */
                Expanded(
                  flex: 1,
                  child: QuickActionButtons(
                    onClearCartPressed:
                        isCustomerOrdersFetched || isOrderItemsFetched
                            ? () {
                                customerNumberController.clear();
                                orderNumberController.clear();
                                isCustomerOrdersFetched = false;
                                isOrderItemsFetched = false;
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
    );
  }

  Widget _buildFormUI(BuildContext context) {
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
                    controller: customerNumberController,
                    decoration: _buildInputDecoration(
                      label: "Enter Customer Mobile Number",
                    ),
                    maxLength: 10,
                    validator: (value) {
                      if (value == null ||
                          (value.isEmpty &&
                              (orderNumberController.text.trim().isEmpty))) {
                        return 'Please enter a phone number';
                      }
                      if (value.length != 10 &&
                          orderNumberController.text.trim().isEmpty) {
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
                    controller: orderNumberController,
                    decoration: _buildInputDecoration(
                      label: "Enter Order Number",
                    ),
                    validator: (value) {
                      if (value == null ||
                          (value.isEmpty &&
                              customerNumberController.text.trim().isEmpty)) {
                        return 'Please enter order number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onClickSearchOrders,
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: CustomColors.secondaryColor,
                      ),
                      child: Text(
                        "Search orders",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
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

  Widget _returnOrderDropdown(BuildContext context) {
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
            Row(
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
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  /* SECTION - 1 */
                  Expanded(
                    flex: 6,
                    child: CustomTableWidget(
                      headers: _returnsConfirmationTableData
                          .buildReturnOrderItemsTableHeader(),
                      tableRowsData:
                          _returnsConfirmationTableData.buildTableRows(
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
                  SummaryPaymentSection(
                    totalRefund: 1235,
                    loyaltyPoints: 5,
                    walletAmount: 30,
                    mopAmount: 1200,
                    onPaymentModeSelected: (String mode) {
                      // Handle payment mode selection
                    },
                  )
                ],
              ),
            ),
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
