import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/returns/models/order_items_model.dart';
import 'package:ebono_pos/ui/returns/widgets/reason_dropdown_widget.dart';
import 'package:ebono_pos/widgets/custom_table/table_cell_widget.dart';
import 'package:flutter/material.dart';

class ReturnsConfirmationTableData {
  final BuildContext context;

  const ReturnsConfirmationTableData({required this.context});

  List<Widget> buildReturnOrderItemsTableHeader({
    required Function(String reason) onReasonSelected,
    required List<String> returnReasons,
    required String selectedReason,
  }) {
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
        child: SizedBox(
          height: 45,
          child: ReturnReasonDropdownWidget(
            returnReasons: returnReasons,
            selectedReason: selectedReason,
            onReasonSelected: onReasonSelected,
          ),
        ),
      ),
    ];
  }

  List<TableRow> buildTableRows({
    required Function(int index)? onTapSelectedButton,
    required OrderItemsModel orderItemsData,
    required Function(String reason, String orderLineId) onReasonSelected,
  }) {
    return List.generate(
      orderItemsData.orderLines!.length,
      (index) => buildTableRow(
        onReasonSelected: (reason) => onReasonSelected(
          reason,
          orderItemsData.orderLines![index].orderLineId!,
        ),
        returnReasons: orderItemsData.getListOfRefundModes(),
        orderLine: orderItemsData.orderLines![index],
        onTap: () => onTapSelectedButton?.call(index),
      ),
    ).toList();
  }

  TableRow buildTableRow({
    required List<String> returnReasons,
    required OrderLine orderLine,
    required Function()? onTap,
    required Function(String reason) onReasonSelected,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        TableCellWidget(text: orderLine.item!.skuCode!, width: 110),
        TableCellWidget(text: orderLine.item!.skuTitle!, width: 260),
        TableCellWidget(text: '${orderLine.returnedQuantity}', width: 60),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
          child: SizedBox(
            height: 45,
            child: ReturnReasonDropdownWidget(
              returnReasons: returnReasons,
              selectedReason: orderLine.returnReason,
              onReasonSelected: onReasonSelected,
            ),
          ),
        ),
      ],
    );
  }
}
