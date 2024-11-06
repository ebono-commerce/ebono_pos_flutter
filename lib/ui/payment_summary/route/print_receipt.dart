import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/receipt_data.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/receipt_json.dart';
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
        body: PdfPreview(build: (format) => generatePdf()),
      ),
    );
  }
}

Future<Uint8List> generatePdf() async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.interRegular();
  final fontSizeFactor =
      PdfPageFormat.roll80.availableWidth / PdfPageFormat.a4.availableWidth;
  final fallbackFontByteData =
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf");

  final data = InvoiceData.fromJson(json.decode(jsonData));

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll57,
      margin: const pw.EdgeInsets.all(2),
      build: (pw.Context context) {
        return pw.Container(
          width: PdfPageFormat.roll80.availableWidth,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'EBONO POS',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 40 * fontSizeFactor,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              pw.Text(
                'TAX INVOICE',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 20 * fontSizeFactor,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              pw.Text(
                data.sellerAddress,
                style: pw.TextStyle(
                  fontSize: 14 * fontSizeFactor,
                  font: font,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Text(
                'Invoice No.: ${data.invoiceNumber}',
                style: pw.TextStyle(
                  fontSize: 14 * fontSizeFactor,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              pw.Text(
                'Order No.: ${data.orderNumber}',
                style: pw.TextStyle(
                  fontSize: 14 * fontSizeFactor,
                  font: font,
                ),
              ),
              pw.Divider(),
              pw.Text(
                'Billing Address:',
                style: pw.TextStyle(
                  fontSize: 18 * fontSizeFactor,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              pw.Text(
                data.billingAddress,
                style: pw.TextStyle(
                  fontSize: 14 * fontSizeFactor,
                  font: font,
                ),
              ),
              pw.Text(
                'Shipping Address:',
                style: pw.TextStyle(
                  fontSize: 18 * fontSizeFactor,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              pw.Text(
                data.shipAddress,
                style: pw.TextStyle(
                  fontSize: 14 * fontSizeFactor,
                  font: font,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'IRN No: NA',
                    style: pw.TextStyle(
                      fontSize: 12 * fontSizeFactor,
                      font: font,
                    ),
                  ),
                  pw.Text(
                    'All Amount in',
                    style: pw.TextStyle(
                      fontSize: 12 * fontSizeFactor,
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
                          fontSize: 14 * fontSizeFactor,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Qty',
                        style: pw.TextStyle(
                          fontSize: 14 * fontSizeFactor,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Price',
                        style: pw.TextStyle(
                          fontSize: 14 * fontSizeFactor,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Disc',
                        style: pw.TextStyle(
                          fontSize: 14 * fontSizeFactor,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'GST',
                        style: pw.TextStyle(
                          fontSize: 14 * fontSizeFactor,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          fontSize: 14 * fontSizeFactor,
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5), // Space between header and content
                  pw.Divider(),
                  // Item rows
                  ...data.invoiceLinesDetails.map((item) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Product name lines
                          pw.Text(
                            item.description,
                            style: pw.TextStyle(
                              fontSize: 14 * fontSizeFactor,
                              font: font,
                            ),
                          ),
                          pw.Text(
                            '', // Add additional details if needed
                            style: pw.TextStyle(
                              fontSize: 14 * fontSizeFactor,
                              font: font,
                            ),
                          ),
                          // Details row
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "  ",
                                style: pw.TextStyle(
                                  fontSize: 14 * fontSizeFactor,
                                  font: font,
                                ),
                              ),
                              pw.Text(
                                "  ",
                                style: pw.TextStyle(
                                  fontSize: 14 * fontSizeFactor,
                                  font: font,
                                ),
                              ),
                              pw.Text(
                                item.qty.toString(),
                                style: pw.TextStyle(
                                  fontSize: 14 * fontSizeFactor,
                                  font: font,
                                ),
                              ),
                              pw.Text(
                                '₹${item.unitRate}',
                                style: pw.TextStyle(
                                    fontSize: 14 * fontSizeFactor,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                              pw.Text(
                                '₹${item.unitTotalDiscount}',
                                style: pw.TextStyle(
                                    fontSize: 14 * fontSizeFactor,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                              pw.Text(
                                '₹${item.unitTotalTax}',
                                style: pw.TextStyle(
                                    fontSize: 14 * fontSizeFactor,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                              pw.Text(
                                '₹${item.unitLineTotal}',
                                style: pw.TextStyle(
                                    fontSize: 14 * fontSizeFactor,
                                    font: font,
                                    fontFallback: [
                                      pw.Font.ttf(fallbackFontByteData)
                                    ]),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 10), // Space between rows
                          pw.Divider(), // Divider between product rows
                        ],
                      )),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                'Total: ₹${data.priceInfo.totalInvoiceAmount}',
                style: pw.TextStyle(
                    fontSize: 18 * fontSizeFactor,
                    fontWeight: pw.FontWeight.bold,
                    font: font,
                    fontFallback: [pw.Font.ttf(fallbackFontByteData)]),
              ),
              pw.Text(
                'In Words: ${data.priceInfo.inWords}',
                style: pw.TextStyle(
                  fontSize: 14 * fontSizeFactor,
                  font: font,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Terms & Conditions:',
                style: pw.TextStyle(
                  fontSize: 18 * fontSizeFactor,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              ...data.termsAndConditions.tc.map((term) => pw.Container(
                    child: pw.Text(
                      '- $term',
                      style: pw.TextStyle(
                        fontSize: 14 * fontSizeFactor,
                        font: font,
                      ),
                    ),
                  )),
              pw.SizedBox(height: 20),
              pw.Text(
                'Thank you for shopping with us',
                style: pw.TextStyle(
                  fontSize: 18 * fontSizeFactor,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}

void printReceipt() async {
  final pdfBytes = await generatePdf();

  // Print without showing preview
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async {
      // Add the ESC/POS command for cutting the paper
      final Uint8List cutPaperCommand = Uint8List.fromList([27, 105]);

      // Combine the PDF data with the cut command
      return Uint8List.fromList([...pdfBytes, ...cutPaperCommand]);
    },
  );
}
