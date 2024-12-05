import 'dart:convert';

import 'package:ebono_pos/ui/payment_summary/model/order_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/receipt_json.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintReceiptPage extends StatelessWidget {
  const PrintReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Print Preview")),
        body: PdfPreview(
            build: (format) => generatePdf(
                OrderSummaryResponse.fromJson(json.decode(jsonData)))),
      ),
    );
  }
}

Future<Uint8List> generatePdf(OrderSummaryResponse data) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.interRegular();
  final fallbackFontByteData =
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf");

  //final data = OrderSummaryResponse.fromJson(json.decode(jsonData));

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      margin: const pw.EdgeInsets.all(0),
      build: (pw.Context context) {
        return pw.Center(
            child: pw.Container(
          width: PdfPageFormat.roll80.availableWidth,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'EBONO',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              if (data.invoiceNumber?.isNotEmpty == true)
                pw.Text(
                  'TAX INVOICE',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    font: font,
                  ),
                ),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      data.outletAddress?.fullAddress ?? '',
                      style: pw.TextStyle(
                        fontSize: 6,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      'Phone Number: +91 ${data.outletAddress?.phoneNumber?.number}',
                      style: pw.TextStyle(
                        fontSize: 6,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      'GSTIN: ${data.outletAddress?.gstinNumber}',
                      style: pw.TextStyle(
                        fontSize: 6,
                        font: font,
                      ),
                    ),
                  ]),

              pw.Divider(),
              pw.Container(
                width: PdfPageFormat.roll80.availableWidth,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (data.invoiceNumber?.isNotEmpty == true)
                        pw.Text(
                          'Invoice No: ${data.invoiceNumber}',
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                      if (data.invoiceDate?.isNotEmpty == true)
                        pw.Text(
                          'Invoice Date: ${data.invoiceDate}',
                          style: pw.TextStyle(
                            fontSize: 6,
                            font: font,
                          ),
                        ),
                      if (data.orderNumber?.isNotEmpty == true)
                        pw.Text(
                          'Order No: ${data.orderNumber}',
                          style: pw.TextStyle(
                            fontSize: 6,
                            font: font,
                          ),
                        ),
                      pw.Text(
                        'Order Date: ${data.orderDate}',
                        style: pw.TextStyle(
                          fontSize: 6,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Payment Method: ${data.paymentMethods.toString()}',
                        style: pw.TextStyle(
                          fontSize: 6,
                          font: font,
                        ),
                      ),
                    ]),
              ),

              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '',
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    'All Amount in Rupees',
                    style: pw.TextStyle(
                      fontSize: 4,
                      font: font,
                    ),
                  ),
                ],
              ),
              pw.Divider(),

              // Custom Table with headers and product details
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header row
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Items',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Qty',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Price',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Disc',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'GST',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(),
                  // Item rows
                  ...?data.invoiceLines?.map((item) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Product name lines
                          pw.Text(
                            item.skuTitle ?? '',
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: font,
                            ),
                          ),
                          pw.Text(
                            '', // Add additional details if needed
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: font,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "  ",
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ),
                              ),
                              pw.Text(
                                "  ",
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ),
                              ),
                              pw.Text(
                                item.quantity?.quantityNumber ?? '',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ),
                              ),
                              pw.Text(
                                getActualPrice(item.unitPrice?.centAmount,
                                    item.unitPrice?.fraction),
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                              pw.Text(
                                getActualPrice(item.discountTotal?.centAmount,
                                    item.discountTotal?.fraction),
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                              pw.Text(
                                getActualPrice(item.taxTotal?.centAmount,
                                    item.taxTotal?.fraction),
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                              pw.Text(
                                getActualPrice(item.grandTotal?.centAmount,
                                    item.grandTotal?.fraction),
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                            ],
                          ),
                          pw.Divider(), // Divider between product rows
                        ],
                      )),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total',
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    '${data.invoiceLines?.length}',
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    getActualPrice(
                        data.mrpSavings?.centAmount, data.mrpSavings?.fraction),
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    getActualPrice(data.discountTotal?.centAmount,
                        data.discountTotal?.fraction),
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    getActualPrice(
                        data.taxTotal?.centAmount, data.taxTotal?.fraction),
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    getActualPrice(
                        data.grandTotal?.centAmount, data.grandTotal?.fraction),
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'In Words: ${data.totalsInWords}',
                style: pw.TextStyle(
                  fontSize: 8,
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Your savings on MRP: ${getActualPrice(data.mrpSavings?.centAmount, data.mrpSavings?.fraction)}',
                style: pw.TextStyle(
                  fontSize: 8,
                  font: font,
                ),
              ),
              pw.Divider(),
              if (data.taxDetails?.taxesLines?.isNotEmpty == true)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Header row
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Tax %',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          'CGST',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          'SGST',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          'IGST',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          'Cess',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          'Tax Value',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(),
                    // Item rows
                    ...?data.taxDetails?.taxesLines?.map((item) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  item.taxPercentage ?? '',
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    font: font,
                                  ),
                                ),
                                pw.Column(children: [
                                  pw.Text(
                                    item.cgstPercentage ?? '',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                  pw.Text(
                                    '₹ ${item.cgstValue}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                ]),
                                pw.Column(children: [
                                  pw.Text(
                                    item.sgstPercentage ?? '',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                  pw.Text(
                                    '₹ ${item.sgstValue}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                ]),
                                pw.Column(children: [
                                  pw.Text(
                                    item.igstPercentage ?? '',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                  pw.Text(
                                    '₹ ${item.igstValue}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                ]),
                                pw.Column(children: [
                                  pw.Text(
                                    item.cessPercentage ?? '',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                  pw.Text(
                                    '₹ ${item.cessValue}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                ]),
                                pw.Text(
                                  '₹${item.taxValue}',
                                  style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                      fontFallback: [
                                        pw.Font.ttf(fallbackFontByteData)
                                      ]),
                                ),
                              ],
                            ),
                          ],
                        )),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxesTotals?.totalCgst}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxesTotals?.totalSgst}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxesTotals?.totalIgst}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxesTotals?.totalCess}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxesTotals?.totalTax}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                      ],
                    ),

                    pw.Divider(),
                  ],
                ),
              pw.Container(
                width: PdfPageFormat.roll80.availableWidth,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'E.&O.E',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Website: ${data.contactDetails?.website}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Contact Us Email: ${data.contactDetails?.emailId}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Terms & Conditions:',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                    ]),
              ),
              ...?data.termsAndConditions?.map((term) => pw.Container(
                    child: pw.Text(
                      '- $term',
                      style: pw.TextStyle(
                        fontSize: 6,
                        font: font,
                      ),
                    ),
                  )),
              pw.SizedBox(height: 4),
              pw.Text(
                'Thank you for shopping with us!',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              pw.SizedBox(height: 4),
            ],
          ),
        ));
      },
    ),
  );

  return pdf.save();
}

void printOrderSummary(
    OrderSummaryResponse orderSummaryResponse, BuildContext context) async {
  final pdfBytes = await generatePdf(orderSummaryResponse);
  if (context.mounted) {
    Printer? selectedPrinter = await Printing.pickPrinter(context: context);
    print('selected printer ${selectedPrinter?.name}');

    await Printing.directPrintPdf(
        printer: selectedPrinter!,
        onLayout: (PdfPageFormat format) async {
          final Uint8List cutPaperCommand = Uint8List.fromList([27, 105]);
          return Uint8List.fromList([...pdfBytes, ...cutPaperCommand]);
        });
  }
  else{
    Get.snackbar('context not mounted', 'print order');
  }
}
