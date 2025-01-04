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
        border: Border.all(color: Colors.grey.shade300),
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
        border: Border.all(color: Colors.grey.shade500),
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
}
