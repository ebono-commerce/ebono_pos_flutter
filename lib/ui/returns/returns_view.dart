import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/ui/returns/bloc/returns_bloc.dart';
import 'package:ebono_pos/widgets/custom_table_widget.dart';
import 'package:ebono_pos/widgets/num_pad_widget.dart';
import 'package:ebono_pos/widgets/order_details_widget.dart';
import 'package:ebono_pos/widgets/table_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReturnsView extends StatefulWidget {
  const ReturnsView({super.key});

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  final TextEditingController customerNumberController =
      TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();

  bool isCustomerOrdersFetched = false;

  void onClickSearchOrders(BuildContext context) {
    if (customerNumberController.text.isNotEmpty) {
      context.read<ReturnsBloc>().add(FetchCustomerOrdersData(
            customerNumberController.text,
          ));
    }
    if (orderNumberController.text.isNotEmpty) {
      context.read<ReturnsBloc>().add(FetchCustomerOrdersData(
            orderNumberController.text,
          ));
    }
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
      body: BlocProvider(
        create: (context) => ReturnsBloc(),
        child: BlocConsumer<ReturnsBloc, ReturnsState>(
          listener: (context, state) {
            if (state.isCustomerOrdersDataFetched) {
              setState(() => isCustomerOrdersFetched = true);
            }
          },
          builder: (context, state) {
            return Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          OrderDetailsWidget(
                            customerName: "",
                            walletBalance: "",
                            phoneNumber: "-",
                            loyaltyPoints: "-",
                          ),

                          /* rendering empty table ui */
                          Visibility(
                            visible: !isCustomerOrdersFetched,
                            child: CustomTableWidget(
                              headers: _buildInitialTableHeader(),
                              tableRowsData: [],
                              columnWidths: {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(6),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(3),
                                4: FlexColumnWidth(3),
                                5: FlexColumnWidth(1),
                              },
                            ),
                          ),

                          /* rendering customer orders when user enters customer phone number */
                          Visibility(
                            visible: isCustomerOrdersFetched,
                            child: Expanded(
                              child: CustomTableWidget(
                                headers: _buildCustomerOrdersTableHeader(),
                                tableRowsData: <TableRow>[
                                  _buildTableRow(),
                                  _buildTableRow(),
                                  _buildTableRow()
                                ],
                                columnWidths: {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(5),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(2),
                                  4: FlexColumnWidth(3),
                                },
                              ),
                            ),
                          ),

                          /* rendering form field to enter customer number and order id */
                          Visibility(
                            visible: !isCustomerOrdersFetched,
                            child: Expanded(
                              child: SizedBox(
                                width: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      controller: customerNumberController,
                                      decoration: _buildInputDecoration(
                                        label: "Enter Customer Mobile Number",
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ORWidget(),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: orderNumberController,
                                      decoration: _buildInputDecoration(
                                        label: "Enter Order Number",
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            onClickSearchOrders(context),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 1,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1, vertical: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                              CustomColors.secondaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Continue Without Customer Number",
                                            style: TextStyle(
                                              color: CustomColors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      textFieldFocusNode: FocusNode(),
                      textFieldTextEditingController: TextEditingController(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: QuickActionButtons(
                      onClearCartPressed: isCustomerOrdersFetched
                          ? () {
                              setState(() => isCustomerOrdersFetched = false);
                              customerNumberController.clear();
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

  InputDecoration _buildInputDecoration({
    required String label,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
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

  List<Widget> _buildInitialTableHeader() {
    return [
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Item Code",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Name",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Quantity",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "MRP ₹",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Price ₹",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w100, color: CustomColors.greyFont),
        ),
      ),
    ];
  }

  List<Widget> _buildCustomerOrdersTableHeader() {
    return [
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Order No.",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Date & Time",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Quantity",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Order Value",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(padding: const EdgeInsets.all(10.0), child: Text("")),
    ];
  }

  TableRow _buildTableRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        TableCellWidget(text: '123456789', width: 110),
        TableCellWidget(text: '29 December 2024 | 00:00 AM', width: 300),
        TableCellWidget(text: '5', width: 110),
        TableCellWidget(text: '₹5,256', width: 110),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 1,
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: CustomColors.secondaryColor,
            ),
            child: Center(
              child: Text(
                "Retrive",
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
