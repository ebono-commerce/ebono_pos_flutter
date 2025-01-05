import 'package:ebono_pos/constants/custom_colors.dart';
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

  List<TableRow> buildTableRows() {
    return [
      buildTableRow(),
      buildTableRow(),
      buildTableRow(),
    ];
  }

  TableRow buildTableRow() {
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
