import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/models/cart_response.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';
import 'package:kpn_pos_application/ui/common_text_field.dart';
import 'package:kpn_pos_application/ui/custom_keyboard/custom_num_pad.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/ui/payment_summary/weight_controller.dart';
import 'package:kpn_pos_application/utils/common_methods.dart';
import 'package:kpn_pos_application/utils/dash_line.dart';

class OrdersSection extends StatefulWidget {
  final WeightController weightController;
  final HomeController homeController;

  const OrdersSection(this.weightController, this.homeController, {super.key});

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection>
    with WidgetsBindingObserver {
  String _selectedWidget = 'OPEN_REGISTER';
  final FocusNode _numPadFocusNode = FocusNode();
  final TextEditingController _numPadTextController = TextEditingController();

  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();

  late WeightController weightController;
  late HomeController homeController;

  @override
  void initState() {
    if (mounted == true) {
      weightController = widget.weightController;
      homeController = widget.homeController;
      homeController.intializationResponse();
    }
    super.initState();
  }

  void _onWidgetNameUpdatePressed(String value) {
    setState(() {
      _selectedWidget = value;
      print(" Widget Name: $_selectedWidget");
    });
  }

  void _StaleButtonPressed(String value) {
    if (homeController.phoneNumber.value != '') {
      setState(() {
        _selectedWidget = value;
        print(" Widget Name: $_selectedWidget");
        //add fetch call data
        homeController.fetchCustomer();
      });
    } else {
      showToast('Please enter phone number',
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.center);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _numPadFocusNode.dispose();
    _numPadTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final HomeController homeController = Get.put(HomeController());

    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 6, // 0.6 ratio
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Obx(() {
                      return _buildOrderdetail(_selectedWidget, context);
                    }),
                    Expanded(
                      // flex: 1,
                      child: Center(
                          child: _selectedWidget == 'OPEN_REGISTER'
                              ? _buildRegisterClosed(context, "ADD_CUSTOMER",
                                  onPressed: () => _onWidgetNameUpdatePressed(
                                      "ADD_CUSTOMER"))
                              : _selectedWidget == 'ADD_CUSTOMER'
                                  ? _buildAddCustomer(
                                      context,
                                      "START_SALE",
                                      onPressed: () =>
                                          _StaleButtonPressed("START_SALE"),
                                    )
                                  : _selectedWidget == 'START_SALE'
                                      ? Obx(() {
                                          return _buildTableView2();
                                        })
                                      : Container()),
                    )
                  ],
                )),
          ),
          Expanded(
            flex: 2, // 0.2 ratio
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Center(child: _buildNumberPadSection(homeController)),
            ),
          ),
          Expanded(
            flex: 1, // 0.1 ratio
            child: _buildRightActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView2() {
    print(
        "_buildTableView2: ${homeController.cartResponse.value.cartLines?.length}");
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Column(
        children: [
          //Table header
          Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2),
              6: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    )), // Header background color
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Item Code",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Name",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Quantity",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        " ",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "MRP ₹",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Price ₹",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(padding: const EdgeInsets.all(10.0), child: Text("")),
                ],
              ),
              ...homeController.cartLines.map((itemData) {
                /*itemData.controller?.text =
                    weightController.weight.value.toString();*/
                itemData.focusNode?.addListener(() {
                  setState(() {});
                });
                if (itemData.focusNode != null) {
                  if (itemData.focusNode?.hasFocus == true) {
                    itemData.controller?.text =
                        weightController.weight.value.toString();
                  }
                }
                return TableRow(
                  decoration: BoxDecoration(
                      // color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  // ),
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '${itemData.item?.esin}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.black),
                          )),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(4.0),
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '${itemData.item?.ebonoTitle}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.black),
                          )),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(2.0),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            itemData.focusNode?.requestFocus();
                          },
                          child: commonTextField(
                              label: '',
                              focusNode: itemData.focusNode ?? FocusNode(),
                              readOnly: false,
                              controller: itemData.controller ??
                                  TextEditingController(),
                              onValueChanged: (value) {}),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.black),
                          )),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            convertedPrice(itemData.mrp?.centAmount,
                                itemData.mrp?.fraction),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.black),
                          )),
                    ),
                    Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              convertedPrice(itemData.unitPrice?.centAmount,
                                  itemData.unitPrice?.fraction),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.black),
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFE56363),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: ImageIcon(
                            size: 20,
                            color: Color(0xFFE56363),
                            AssetImage('assets/images/ic_remove.png'),
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                title: '',
                                middleText: '',
                                titlePadding: EdgeInsets.all(0),
                                barrierDismissible: false,
                                backgroundColor: Colors.white,
                                content: _buildRemoveDialog2(itemData,
                                    onPressed: () {
                                  homeController.deleteCartItemApiCall(
                                      itemData.cartLineId);
                                  Get.back();
                                }));
                          },
                        ),
                      ),
                    )
                  ],
                );
              })
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPadSection(HomeController homeController) {
    return Obx(() {
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  // borderRadius: BorderRadius.circular(
                  //     10),
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
                                      homeController.scanProductsResponse.value
                                                  .ebonoTitle?.isNotEmpty ==
                                              true
                                          ? '${homeController.scanProductsResponse.value.ebonoTitle}'
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
                                        text: homeController
                                                    .scanProductsResponse
                                                    .value
                                                    .ebonoTitle
                                                    ?.isNotEmpty ==
                                                true
                                            ? '1'
                                            : " - ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
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
                                        // text: "",
                                        text: homeController
                                                    .scanProductsResponse
                                                    .value
                                                    .priceList?[0]
                                                    .mrp !=
                                                null
                                            ? convertedPrice(
                                                homeController
                                                    .scanProductsResponse
                                                    .value
                                                    .priceList?[0]
                                                    .mrp!
                                                    .centAmount,
                                                homeController
                                                    .scanProductsResponse
                                                    .value
                                                    .priceList?[0]
                                                    .mrp!
                                                    .fraction,
                                              )
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
                                '${homeController.scanProductsResponse.value.mediaUrl}',
                                cacheHeight: 50,
                                cacheWidth: 50,
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
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
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
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
                          child: commonTextField(
                            label: ' Enter Code, Quantity ',
                            focusNode: _numPadFocusNode,
                            readOnly: false,
                            controller: _numPadTextController,
                          ),
                        ),
                        CustomNumPad(
                          textController: _numPadTextController,
                          onEnterPressed: (text) {
                            print("Enter pressed with text: $text");
                            _numPadFocusNode.unfocus();
                          },
                          onValueChanged: (text) {
                            print("onTextListener text: $text");
                            if (isValidOfferId(text)) {
                              homeController.scanApiCall(text);
                            }
                          },
                          onClearAll: (text) {
                            print("onClearAll $text");

                            homeController.clearScanData();
                          },
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    // borderRadius: BorderRadius.circular(
                    //     10),
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
                                  homeController.cartResponse.value.cartLines
                                              ?.length !=
                                          null
                                      ? 'Total Items'
                                      : '-',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  homeController.cartResponse.value.cartLines
                                              ?.length !=
                                          null
                                      ? '${homeController.cartResponse.value.totalItems}'
                                      : '-',
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
                                  homeController.cartResponse.value.mrpSavings !=
                                          null
                                      ? convertedPrice(
                                                  homeController
                                                      .cartResponse
                                                      .value
                                                      .mrpSavings!
                                                      .centAmount,
                                                  homeController
                                                      .cartResponse
                                                      .value
                                                      .mrpSavings!
                                                      .fraction) !=
                                              "₹0.00"
                                          ? convertedPrice(
                                              homeController.cartResponse.value
                                                  .mrpSavings!.centAmount,
                                              homeController.cartResponse.value
                                                  .mrpSavings!.fraction)
                                          : "--"
                                      : "--",
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
                          onPressed: () {
                            Get.toNamed(PageRoutes.paymentSummary);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: homeController
                                          .cartResponse.value.amountPayable !=
                                      null
                                  ? convertedPrice(
                                              homeController.cartResponse.value
                                                  .amountPayable!.centAmount,
                                              homeController.cartResponse.value
                                                  .amountPayable!.fraction) !=
                                          "₹0.00"
                                      ? CustomColors.secondaryColor
                                      : CustomColors.cardBackground
                                  : CustomColors.cardBackground),
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
                                // homeController.cartResponse.value.cartTotals
                                //             ?.firstWhere((item) =>
                                //                 item.type == 'GRAND_TOTAL')
                                //             .amount !=
                                //         null
                                //     ?
                                Text(
                                  homeController.cartResponse.value
                                              .amountPayable !=
                                          null
                                      ? convertedPrice(
                                          homeController.cartResponse.value
                                              .amountPayable!.centAmount,
                                          homeController.cartResponse.value
                                              .amountPayable!.fraction)
                                      : "--",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                // : Container(
                                //     //height: 40,
                                //     ),
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
    });
  }

  Widget _buildRightActionButtons(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buidButton("Customer", context),
                    _buidButton("Search items", context),
                    _buidButton("Inventory inquiry", context),
                    _buidButton("Coupons", context),
                    _buidButton("Sales Associate", context)
                  ],
                ),
              ),
              _buidButton("Hold cart", context)
            ],
          )),
    );
  }

  Widget _buildRegisterClosed(BuildContext context, String widgetName,
      {VoidCallback? onPressed}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Text(
              "Register is closed!",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: CustomColors.black),
              // style: TextStyle(
              //     color: Color(0xFF000000),
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Set an opening float to start the sale",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.normal, color: CustomColors.black),
              // style: TextStyle(
              //     color: Color(0xFF000000),
              //     fontSize: 14,
              //     fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 150,
            // height: 50,
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 1,
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: CustomColors.secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: CustomColors.secondaryColor,
              ),
              child: Center(
                child: Text(
                  "Open register",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: CustomColors.black),
                  // style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold),
                ),
              ),
              //  onPressed: () { pdfController.printPdf();  },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAddCustomer(BuildContext context, String widgetName,
      {VoidCallback? onPressed}) {
    return Obx(() {
      return SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                "Add customer details",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: CustomColors.black),
                // style: TextStyle(
                //     color: Color(0xFF000000),
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Add customer details before starting the sale",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal, color: CustomColors.black),
                // style: TextStyle(
                //     color: Color(0xFF000000),
                //     fontSize: 14,
                //     fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: TextField(
                  controller: _controllerPhoneNumber,
                  onChanged: (value) {
                    homeController.phoneNumber.value = value;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300, // Normal border color
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300, // Focused border color
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.red, // Error border color
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.red, // Focused error border color
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' Enter Customer Mobile Number ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      suffixIcon: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        width: 100,
                        child: ElevatedButton(
                          onPressed: homeController.phoneNumber.isNotEmpty
                              ? onPressed
                              : null,
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 1),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: homeController.phoneNumber.isNotEmpty
                                      ? CustomColors.secondaryColor
                                      : CustomColors.cardBackground),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledBackgroundColor:
                                CustomColors.cardBackground,
                            backgroundColor: CustomColors.secondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Search",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.black),
                              // style: TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                )),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: TextField(
                  controller: _controllerCustomerName,
                  onChanged: (value) {
                    homeController.customerName.value = value;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300, // Normal border color
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300, // Focused border color
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.red, // Error border color
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.red, // Focused error border color
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' Customer Name ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      suffixIcon: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        width: 100,
                        child: ElevatedButton(
                          onPressed: homeController.phoneNumber.isNotEmpty
                              ? onPressed
                              : null,
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 1),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: homeController.phoneNumber.isNotEmpty
                                      ? CustomColors.secondaryColor
                                      : CustomColors.cardBackground),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledBackgroundColor:
                                CustomColors.cardBackground,
                            backgroundColor: CustomColors.secondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Select",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.black),
                              // style: TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                )),
            SizedBox(
              height: 20,
            ),

            /*
          Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 1,
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: CustomColors.secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBackgroundColor: Colors.grey,
                backgroundColor: CustomColors.secondaryColor,
              ),
              child: Center(
                child: Text(
                  "Start Sale",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: CustomColors.black),
                  // style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

         */
            Container(
              // width: 200,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFF066A69)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color(0xFFF0F4F4),
                ),
                child: Center(
                  child: Text(
                    "Continue Without Customer Number",
                    style: TextStyle(
                        color: Color(0xFF066A69),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                "Select above if the customer denies his/her number",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRemoveDialog2(CartLine? itemData, {VoidCallback? onPressed}) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Are you sure you want to remove this item?",
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            // padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFF8F8F8),
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            //color: Color(0xFFF8F8F8),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      RichText(
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${itemData?.item?.ebonoTitle}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${itemData?.item?.esin}',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              text: '${itemData!.quantity?.quantityNumber}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' (${itemData.quantity?.quantityUom})',
                              style: TextStyle(
                                  color: CustomColors.greyFont,
                                  fontSize: 11,
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
                              text: convertedPrice(
                                  itemData.unitPrice?.centAmount,
                                  itemData.unitPrice?.fraction),
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
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      padding:
                          EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: homeController.phoneNumber.isNotEmpty
                                ? CustomColors.secondaryColor
                                : CustomColors.cardBackground),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: CustomColors.cardBackground,
                      backgroundColor: CustomColors.secondaryColor,
                    ),
                    child: Text(
                      "    Yes, Remove    ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      padding:
                          EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: CustomColors.primaryColor, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFFF0F4F4),
                    ),
                    child: Text(
                      "    No, Cancel    ",
                      style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buidButton(String label, BuildContext context) {
    return Container(
      width: 220,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          // Respond to button press
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Color(0xFFF0F4F4),
        ),
        child: Center(
          child: Text(label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600, color: CustomColors.primaryColor)
              // style: TextStyle(
              //     color: Color(0xFF066A69),
              //     fontSize: 14,
              //     fontWeight: FontWeight.normal),
              ),
        ),
      ),
    );
  }

  Widget _buildOrderdetail(String label, BuildContext context) {
    DateTime now = DateTime.now();
    // Format the date using intl package
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today,',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    // 'Wednesday, 18 September 2024',
                    formattedDate,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Customer: ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: homeController.customerResponse.value
                                          .customerName !=
                                      null
                                  ? homeController
                                      .customerResponse.value.customerName
                                      .toString()
                                  : " - ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Wallet balance: - ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: homeController
                                  .customerResponse.value.walletBalance,
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
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Contact No.: ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: homeController
                                          .customerResponse.value.phoneNumber !=
                                      null
                                  ? '${homeController.customerResponse.value.phoneNumber?.number}'
                                  : " - ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Loyalty Points: - ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: homeController
                                  .customerResponse.value.loyaltyPoints,
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String convertedPrice(int? centAmount, int? fraction) {
  if (centAmount == null) {
    return '₹0.00'; // Handle null values gracefully
  }

  double amount = (centAmount / fraction!);

  return '₹${amount.toStringAsFixed(2)}';
}

class StringController extends GetxController {
  var barCodeInput = ''.obs;

  void updateInput(String value) {
    barCodeInput.value = value;
  }
}
