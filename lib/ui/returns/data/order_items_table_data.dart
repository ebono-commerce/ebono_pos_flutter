import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/returns/models/order_items_model.dart';
import 'package:ebono_pos/widgets/custom_table/table_cell_widget.dart';
import 'package:flutter/material.dart';

class OrderItemsTableData {
  final BuildContext context;

  OrderItemsTableData({required this.context});

  List<Widget> buildOrderItemsTableHeader() {
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
            "Returnable Quantity",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(padding: const EdgeInsets.all(10.0), child: Text("")),
    ];
  }

  List<TableRow> buildTableRows({
    required OrderItemsModel orderItemsData,
    required Function(int index)? onTapSelectedButton,
  }) {
    return List.generate(orderItemsData.orderLines!.length, (index) {
      OrderLine orderLine = orderItemsData.orderLines![index];
      return buildTableRow(
        orderLine: orderLine,
        onTap: () => onTapSelectedButton?.call(index),
      );
    }).toList();
  }

  TableRow buildTableRow({
    required OrderLine orderLine,
    required Function()? onTap,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        TableCellWidget(text: orderLine.item!.skuCode!, width: 110),
        TableCellWidget(text: orderLine.item!.skuTitle!, width: 330),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: [
              SizedBox(
                height: 35,
                width: 80,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  cursorColor: CustomColors.black,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                "/${orderLine.orderQuantity!.quantityNumber}",
                style: TextStyle(color: CustomColors.borderColor),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: ElevatedButton(
            onPressed: onTap,
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
                "Selected",
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
