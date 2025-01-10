import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/returns/widgets/reason_dropdown_widget.dart';
import 'package:ebono_pos/widgets/custom_table/table_cell_widget.dart';
import 'package:flutter/material.dart';

class ReturnsConfirmationTableData {
  final BuildContext context;

  const ReturnsConfirmationTableData({required this.context});

  List<Widget> buildReturnOrderItemsTableHeader() {
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
      Padding(padding: const EdgeInsets.all(10.0), child: Text("")),
    ];
  }

  List<TableRow> buildTableRows({
    required Function(int index)? onTapSelectedButton,
  }) {
    return List.generate(
      10,
      (index) => buildTableRow(onTap: () => onTapSelectedButton?.call(index)),
    ).toList();
  }

  // List<TableRow> buildTableRowsFromJson(
  //   List<Map<String, dynamic>> jsonData, {
  //   required Function(int id)? onTapSelectedButton,
  // }) {
  //   return jsonData
  //       .map((item) => buildTableRow(
  //             onTap: () => onTapSelectedButton?.call(item['id'] ?? 0),
  //             itemCode: item['itemCode'] ?? '',
  //             name: item['name'] ?? '',
  //             maxQuantity: item['quantity']?.toString() ?? '0',
  //           ))
  //       .toList();
  // }

  TableRow buildTableRow({
    required Function()? onTap,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        TableCellWidget(text: '123456789', width: 110),
        TableCellWidget(text: '29 December 2024 | 00:00 AM', width: 260),
        TableCellWidget(text: '5', width: 60),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
          child: SizedBox(
            height: 45,
            child: ReturnReasonDropdownWidget(
              onReasonSelected: (p0) {},
            ),
          ),
        ),
      ],
    );
  }
}
