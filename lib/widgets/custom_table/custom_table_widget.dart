import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/widgets/custom_table/table_cell_widget.dart';
import 'package:flutter/material.dart';

class CustomTableWidget extends StatelessWidget {
  final List<Widget> headers;
  final List<TableRow> tableRowsData;
  final Map<int, TableColumnWidth> columnWidths;

  const CustomTableWidget({
    super.key,
    required this.headers,
    required this.tableRowsData,
    required this.columnWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Table(
            columnWidths: columnWidths,
            children: [
              _buildTableHeader(context),
            ],
          ),
          tableRowsData.isEmpty
              ? SizedBox(height: 40)
              : Expanded(
                  child: SingleChildScrollView(
                    child: Table(
                      columnWidths: columnWidths,
                      children: tableRowsData,
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      children: headers,
    );
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
