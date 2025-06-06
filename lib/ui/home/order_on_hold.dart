import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderOnHold extends StatefulWidget {
  const OrderOnHold({super.key});

  @override
  State<OrderOnHold> createState() => _OrderOnHoldState();
}

class _OrderOnHoldState extends State<OrderOnHold> with WidgetsBindingObserver {
  final FocusNode _numPadFocusNode = FocusNode();
  final TextEditingController _numPadTextController = TextEditingController();

  HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    if (mounted == true) {
      _numPadFocusNode.requestFocus();
    }
    homeController.clearHoldCartOrders();
    homeController.ordersOnHoldApiCall();

    //WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     homeController.ordersOnHoldApiCall();
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _numPadFocusNode.dispose();
    _numPadTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Obx(
          () => Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      Expanded(
                          child: _buildTableView1(context, homeController)),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(child: _buildNumberPadSection(homeController)),
              ),
              Expanded(
                flex: 1,
                child: QuickActionButtons(
                  color: Colors.white,
                  onCustomerPressed: () {},
                  onHoldCartPressed: () {},
                  onSalesAssociatePressed: () {},
                  onCouponsPressed: () {},
                  onClearCartPressed: () {},
                  onSearchItemsPressed: () {},
                ),
              ),
            ],
          ),
        )));
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
                                  child: Text(" - ",
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
                                        text: '- ',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      TextSpan(
                                        text: homeController
                                                    .scanProductsResponse
                                                    .value
                                                    .salesUom
                                                    ?.isNotEmpty ==
                                                true
                                            ? '-'
                                            : " - ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: " - ",
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
                                        text: '-',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      TextSpan(
                                        text: ' - ',
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
                                '',
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
                            focusNode:
                                (homeController.cartId.value.isNotEmpty &&
                                        homeController.registerId.isNotEmpty)
                                    ? _numPadFocusNode
                                    : FocusNode(),
                            readOnly: (homeController.cartId.value.isNotEmpty &&
                                    homeController.registerId.isNotEmpty)
                                ? false
                                : true,
                            controller:
                                (homeController.cartId.value.isNotEmpty &&
                                        homeController.registerId.isNotEmpty)
                                    ? _numPadTextController
                                    : TextEditingController(),
                          ),
                        ),
                        CustomNumPad(
                          focusNode: _numPadFocusNode,
                          textController: _numPadTextController,
                          onEnterPressed: (text) {},
                          onValueChanged: (text) {},
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
                                  '-',
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
                                  '-',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "-",
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              elevation: 1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 10),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: CustomColors.cardBackground),
                          child: SizedBox(
                            height: 56,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "-",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),

                                Text(
                                  "-",
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

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total ${homeController.ordersOnHold.length} ${homeController.ordersOnHold.length == 1 ? 'order is' : 'orders are'} on hold!",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Resume orders to complete the sale",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildTableView1(BuildContext context, HomeController homeController) {
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
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(1),
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
                        "Customer Name",
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
                        "Customer Number",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Cashier",
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
                        "Hold Date & Time",
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
              ...homeController.ordersOnHold.map((itemData) {
                return TableRow(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${itemData.customer?.customerName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${itemData.phoneNumber?.number}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      ),
                    ),
                    Text(
                      '${itemData.cashierDetails?.cashierName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: CustomColors.black),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formatDate(itemData.createdAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 8,
                        ),
                        child: SizedBox(
                          width: 80,
                          height: 34,
                          child: ElevatedButton(
                            onPressed: itemData.holdCartId != ""
                                ? () {
                                    homeController.resumeHoldCartApiCall(
                                      id: itemData.holdCartId,
                                      mobileNumber:
                                          itemData.phoneNumber?.number,
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                elevation: 1,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 4),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: CustomColors.secondaryColor),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                " Resume ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}

String formatDate(String? dateStr) {
  DateTime date = DateTime.parse(dateStr!);
  String formattedDate = DateFormat('dd MMM yyyy | hh:mm a').format(
    date.add(
      Duration(hours: 5, minutes: 30),
    ),
  );
  return formattedDate;
}
