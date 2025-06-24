import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/models/scan_products_response.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:ebono_pos/widgets/custom_table/table_cell_widget.dart';
import 'package:flutter/material.dart';

class SearchProductsTableData {
  final BuildContext context;

  SearchProductsTableData({required this.context});

  List<Widget> buildScanProductsTableHeaders() {
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
            "Category",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Price₹",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w100, color: CustomColors.greyFont),
          )),
    ];
  }

  List<TableRow> buildTableRows({
    required List<ScanProductsResponse> scanProductResponseList,
  }) {
    return scanProductResponseList
        .map((scanProduct) => buildTableRow(
              scanProductsResponse: scanProduct,
            ))
        .toList();
  }

  TableRow buildTableRow({
    required ScanProductsResponse scanProductsResponse,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        TableCellWidget(
          text: scanProductsResponse.skuCode.toString(),
          width: 140,
        ),
        TableCellWidget(
          text: scanProductsResponse.skuTitle.toString(),
          width: 420,
        ),
        TableCellWidget(
          text: scanProductsResponse.productType.toString(),
          width: 240,
        ),
        TableCellWidget(
          text: scanProductsResponse.priceList?.isEmpty == true
              ? ''
              : getActualPrice(
                  scanProductsResponse
                      .priceList?.first.sellingPrice?.centAmount,
                  scanProductsResponse.priceList?.first.sellingPrice?.fraction,
                  includeRupee: false,
                ),
          width: 120,
          maxLines: 2,
        ),
      ],
    );
  }
}
