import 'dart:convert';

import 'package:ebono_pos/ui/payment_summary/model/order_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/receipt_json.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

pw.Widget dottedDivider({
  int numberOfDots = 50, // Default number of dots
  double fontSize = 6.0, // Default font size for dots
  pw.FontWeight fontWeight = pw.FontWeight.bold, // Default font weight
}) {
  return pw.Container(
    width: double.infinity,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: List.generate(
        numberOfDots,
        (index) => pw.Text(
          '.',
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    ),
  );
}

Future<Uint8List> generatePdf(OrderSummaryResponse data) async {
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: false,
  );
  final font = await PdfGoogleFonts.interRegular();
  final fontBold = await PdfGoogleFonts.interBold();
  final fallbackFontByteData =
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
  final img = await rootBundle.load('assets/images/savomart_logo.png');
  final img2 =
      await rootBundle.load('assets/images/savo_mart_kannada_logo.jpeg');
  final imageBytes = img.buffer.asUint8List();
  final imageBytes2 = img2.buffer.asUint8List();
  pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
  pw.Image image2 = pw.Image(pw.MemoryImage(imageBytes2));
  const double point = 1.0;
  const double inch = 72.0;
  const double cm = inch / 2.54;
  const double mm = inch / 25.4;

  final isGreaterThanZero = data.mrpSavings != null &&
      (double.parse(
            getActualPrice(
              data.mrpSavings?.centAmount,
              data.mrpSavings?.fraction,
            ).replaceAll("₹", "").trim(),
          )) >
          0;
  //final data = OrderSummaryResponse.fromJson(json.decode(jsonData));

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80.copyWith(
          marginBottom: 0, marginLeft: 0, marginRight: 0, marginTop: 0),
      margin: const pw.EdgeInsets.all(0),
      build: (pw.Context context) {
        return pw.Center(
            child: pw.Container(
          width: PdfPageFormat.roll80.availableWidth,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                alignment: pw.Alignment.center,
                height: 70,
                child: image1,
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
              pw.SizedBox(height: 4),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      data.outletAddress?.fullAddress ?? '',
                      style: pw.TextStyle(
                        fontSize: 8,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      'Phone Number: +91 ${data.outletAddress?.phoneNumber?.number}',
                      style: pw.TextStyle(
                        fontSize: 8,
                        font: font,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'GSTIN: ${data.outletAddress?.gstinNumber}',
                      style: pw.TextStyle(
                        fontSize: 8,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      'FSSAI: ${data.outletAddress?.fssaiNumber}',
                      style: pw.TextStyle(
                        fontSize: 8,
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
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                      if (data.invoiceDate?.isNotEmpty == true)
                        pw.Text(
                          'Invoice Date: ${data.invoiceDate}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                      if (data.orderNumber?.isNotEmpty == true)
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Order No: ${data.orderNumber}',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Text(
                                'Outlet: ${data.outletId}',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ),
                              ),
                            ]),
                      if (data.storeOrderNumber?.isNotEmpty == true)
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Store Order No: ${data.storeOrderNumber}',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ),
                              ),
                              pw.Text(
                                'Outlet: ${data.outletId}',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ),
                              ),
                            ]),
                      if (data.orderDate?.isNotEmpty == true)
                        pw.Text(
                          'Order Date: ${data.orderDate}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                      pw.Text(
                        'Payment Method: ${data.paymentMethods.toString()}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Customer Number: ${data.customer?.isProxyNumber == true ? "Store Number" : data.customer?.phoneNumber?.number}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: font,
                        ),
                      ),
                    ]),
              ),

              // pw.Divider(),
              // pw.Row(
              //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //   children: [
              //     pw.Text(
              //       '',
              //       style: pw.TextStyle(
              //         fontSize: 12,
              //         font: font,
              //       ),
              //     ),
              //     pw.Text(
              //       'All Amount in Rupees',
              //       style: pw.TextStyle(
              //         fontSize: 4,
              //         font: font,
              //       ),
              //     ),
              //   ],
              // ),
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
                  ...?data.invoiceLines
                      ?.asMap()
                      .entries
                      .map((item) => pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // Product name lines
                              pw.Text(
                                item.value.skuTitle ?? '',
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
                                    '${item.value.quantity?.quantityNumber}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      font: font,
                                    ),
                                  ),
                                  pw.Text(
                                    getActualPrice(
                                        item.value.unitPrice?.centAmount,
                                        item.value.unitPrice?.fraction),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        font: font,
                                        fontFallback: [
                                          pw.Font.ttf(fallbackFontByteData)
                                        ]),
                                  ),
                                  pw.Text(
                                    getActualPrice(
                                        item.value.discountTotal?.centAmount,
                                        item.value.discountTotal?.fraction),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        font: font,
                                        fontFallback: [
                                          pw.Font.ttf(fallbackFontByteData)
                                        ]),
                                  ),
                                  pw.Text(
                                    getActualPrice(
                                        item.value.taxTotal?.centAmount,
                                        item.value.taxTotal?.fraction),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        font: font,
                                        fontFallback: [
                                          pw.Font.ttf(fallbackFontByteData)
                                        ]),
                                  ),
                                  pw.Text(
                                    getActualPrice(
                                        item.value.grandTotal?.centAmount,
                                        item.value.grandTotal?.fraction),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        font: font,
                                        fontFallback: [
                                          pw.Font.ttf(fallbackFontByteData)
                                        ]),
                                  ),
                                ],
                              ),
                              if (item.value.taxCode != null)
                                pw.Text(
                                  'HSN: ${item.value.taxCode}',
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    font: font,
                                  ),
                                ),
                              data.invoiceLines?.length != (item.key + 1)
                                  ? dottedDivider()
                                  : pw.Divider(),
                            ],
                          )),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(children: [
                    pw.Text(
                      'Total',
                      style: pw.TextStyle(
                        fontSize: 8,
                        font: font,
                      ),
                    ),
                    pw.SizedBox(width: 13),
                    pw.Text(
                      '${data.quantityTotal}',
                      style: pw.TextStyle(
                        fontSize: 8,
                        font: font,
                      ),
                    ),
                  ]),
                  if (data.roundOff != null &&
                      (double.tryParse(data.roundOff.toString()) ?? 0.0) > 0)
                    pw.Text(
                      'Rounded of ( ₹${data.roundOff} )',
                      style: pw.TextStyle(
                        fontSize: 8,
                        font: font,
                      ),
                    ),
                  pw.Text(
                    '₹${data.roundOffTotal}',
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                    ),
                  ),
                ],
              ),
              if (isGreaterThanZero) pw.SizedBox(height: 4),
              if (isGreaterThanZero)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Your savings: ',
                      style: pw.TextStyle(
                        fontSize: 8,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      getActualPrice(data.mrpSavings?.centAmount,
                          data.mrpSavings?.fraction),
                      style: pw.TextStyle(
                        fontSize: 9,
                        font: fontBold,
                      ),
                    ),
                    if (data.additionalDiscountDescription != null &&
                        data.additionalDiscountDescription?.isNotEmpty == true)
                      pw.Container(
                        margin: pw.EdgeInsets.only(left: 5, top: 1),
                        child: pw.Text(
                          '(${data.additionalDiscountDescription})',
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                      ),
                  ],
                ),
              pw.Divider(),
              if (data.taxDetails?.taxLines?.isNotEmpty == true)
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
                    ...?data.taxDetails?.taxLines
                        ?.asMap()
                        .entries
                        .map((item) => pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      item.value.taxPercentage ?? '',
                                      style: pw.TextStyle(
                                        fontSize: 8,
                                        font: font,
                                      ),
                                    ),
                                    pw.Column(children: [
                                      pw.Text(
                                        item.value.cgstValue ?? '',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                      pw.Text(
                                        '(${item.value.cgstPercentage}%)',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                    ]),
                                    pw.Column(children: [
                                      pw.Text(
                                        item.value.sgstValue ?? '',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                      pw.Text(
                                        '(${item.value.sgstPercentage}%)',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                    ]),
                                    pw.Column(children: [
                                      pw.Text(
                                        item.value.igstValue ?? '',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                      pw.Text(
                                        '(${item.value.igstPercentage}%)',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                    ]),
                                    pw.Column(children: [
                                      pw.Text(
                                        item.value.cessValue ?? '',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                      pw.Text(
                                        '(${item.value.cessPercentage}%)',
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                        ),
                                      ),
                                    ]),
                                    pw.Text(
                                      '₹${item.value.taxValue}',
                                      style: pw.TextStyle(
                                          fontSize: 8,
                                          font: font,
                                          fontFallback: [
                                            pw.Font.ttf(fallbackFontByteData)
                                          ]),
                                    ),
                                  ],
                                ),
                                if (data.taxDetails?.taxLines?.length !=
                                    (item.key + 1))
                                  dottedDivider(),
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
                          '₹ ${data.taxDetails?.taxTotals?.totalCgst}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxTotals?.totalSgst}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxTotals?.totalIgst}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxTotals?.totalCess}',
                          style: pw.TextStyle(
                            fontSize: 8,
                            font: font,
                          ),
                        ),
                        pw.Text(
                          '₹ ${data.taxDetails?.taxTotals?.totalTax}',
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
                    padding: pw.EdgeInsets.only(left: 1),
                    child: pw.Text(
                      term,
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
              pw.Container(
                alignment: pw.Alignment.center,
                height: 40,
                child: image2,
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
  OrderSummaryResponse orderSummaryResponse,
  Printer printer,
) async {
  final pdfBytes = await generatePdf(orderSummaryResponse);

  // Printer commands
  final List<int> printerCommands = [
    0x1B, 0x40, // Initialize printer
    ...pdfBytes,
    0x1D, 0x56, 0x00, // Cut paper
    0x1B, 0x4A, 0x40 // Feed paper
  ];

  await Printing.directPrintPdf(
      printer: printer,
      usePrinterSettings: false,
      forceCustomPrintPaper: true,
      onLayout: (PdfPageFormat format) async {
        final Uint8List cutPaperCommand = Uint8List.fromList([27, 105]);
        return Uint8List.fromList([...pdfBytes, ...cutPaperCommand]);
      });
}
