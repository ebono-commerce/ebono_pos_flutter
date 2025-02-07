import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:flutter/material.dart';

class NumPadWidget extends StatelessWidget {
  final String skuTitle;
  final String skuQty;
  final String skuQtyUom;
  final String skuPrice;
  final String skuUrl;
  final FocusNode numPadFocusNode;
  final FocusNode textFieldFocusNode;
  final TextEditingController numPadTextEditingController;
  final TextEditingController textFieldTextEditingController;
  final Function(String) onTextFormFieldValueChanged;
  final Function(String) onNumPadValueChanged;
  final Function(String) onNumPadEnterPressed;
  final Function(String) onNumPadClearAll;
  final Function()? onProceedToPayClicked;

  const NumPadWidget({
    super.key,
    required this.skuTitle,
    required this.skuQty,
    required this.skuQtyUom,
    required this.skuPrice,
    required this.skuUrl,
    required this.numPadFocusNode,
    required this.textFieldFocusNode,
    required this.numPadTextEditingController,
    required this.textFieldTextEditingController,
    required this.onTextFormFieldValueChanged,
    required this.onNumPadValueChanged,
    required this.onNumPadEnterPressed,
    required this.onNumPadClearAll,
    required this.onProceedToPayClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 2),
                                child: Text(
                                    skuTitle.isNotEmpty == true
                                        ? skuTitle
                                        : " - ",
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Qty:  ',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: skuQty.isNotEmpty == true
                                          ? skuQty
                                          : " - ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: skuQtyUom.isNotEmpty == true
                                          ? '($skuQtyUom)'
                                          : " - ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Price:  ',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: skuPrice.isNotEmpty
                                          ? skuPrice
                                          : ' - ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                            ),
                            child: Image.network(
                              skuUrl,
                              cacheHeight: 50,
                              cacheWidth: 50,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Center(
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    color: CustomColors.cardBackground,
                                  ),
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: DashedLine(
                      height: 0.4,
                      dashWidth: 4,
                      color: Colors.grey,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CommonTextField(
                          labelText: 'Enter Code, Quantity',
                          focusNode: textFieldFocusNode,
                          readOnly: false,
                          controller: textFieldTextEditingController,
                          onValueChanged: onTextFormFieldValueChanged,
                        ),
                      ),
                      CustomNumPad(
                        focusNode: numPadFocusNode,
                        textController: numPadTextEditingController,
                        onEnterPressed: onNumPadEnterPressed,
                        onValueChanged: onNumPadValueChanged,
                        onClearAll: onNumPadClearAll,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Items',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '-',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Savings',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "--",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 4, right: 4, top: 10, bottom: 4),
                      child: ElevatedButton(
                        onPressed: onProceedToPayClicked,
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: onProceedToPayClicked == null
                              ? CustomColors.cardBackground
                              : CustomColors.secondaryColor,
                        ),
                        child: SizedBox(
                          height: 56,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Proceed To Pay",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "--",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
