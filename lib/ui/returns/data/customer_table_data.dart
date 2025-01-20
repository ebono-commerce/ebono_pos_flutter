import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/home/order_on_hold.dart';
import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:ebono_pos/widgets/custom_table/table_cell_widget.dart';
import 'package:flutter/material.dart';

class CustomerTableData {
  final BuildContext context;

  CustomerTableData({required this.context});

  List<Widget> buildInitialTableHeader() {
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

  List<Widget> buildCustomerOrdersTableHeader() {
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
            "Items",
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

  List<TableRow> buildTableRows({
    required List<CustomerOrderDetails> customerOrderDetails,
    required Function(String? orderId)? onClickRetrive,
  }) {
    return customerOrderDetails
        .map((orders) => buildTableRow(
              customerOrder: orders,
              onClickRetrive: () => onClickRetrive?.call(orders.orderNumber),
            ))
        .toList();
  }

  TableRow buildTableRow({
    required CustomerOrderDetails customerOrder,
    required Function() onClickRetrive,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        TableCellWidget(text: customerOrder.orderNumber.toString(), width: 100),
        TableCellWidget(text: formatDate(customerOrder.createdAt), width: 220),
        TableCellWidget(text: customerOrder.totalItems.toString(), width: 100),
        TableCellWidget(
            text: getActualPrice(
              customerOrder.orderTotals!.first.amount!.centAmount,
              customerOrder.orderTotals!.first.amount!.fraction,
            ),
            width: 120),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: ElevatedButton(
            onPressed: onClickRetrive,
            style: ElevatedButton.styleFrom(
              elevation: 1,
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: CustomColors.secondaryColor,
            ),
            child: Center(
              child: customerOrder.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
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
