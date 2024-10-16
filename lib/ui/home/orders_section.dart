import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/custom_colors.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';
import 'package:kpn_pos_application/utils/dash_line.dart';
import 'package:kpn_pos_application/utils/keypad_screen.dart';

import '../payment_summary/weight_controller.dart';

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
  String input = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  late WeightController weightController;

  //late HomeController homeController;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        input = _controller.text;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    if (mounted == true) {
      weightController = widget.weightController;
      // homeController = widget.homeController;
    }
    super.initState();
  }

  void _onKeyPressed(String value) {
    setState(() {
      input += value;
    });
  }

  void _onClear() {
    setState(() {
      input = input.substring(0, input.length - 1);
    });
  }

  void _onClearAll() {
    setState(() {
      input = '';
    });
  }

  void _onWidgetNameUpdatePressed(String value) {
    setState(() {
      _selectedWidget = value;
      print(" Widget Name: $_selectedWidget");
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _focusNode.requestFocus();
  //   }
  // }
  //
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 6, // 0.6 ratio
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildOrderdetail(_selectedWidget, context),
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
                                          _onWidgetNameUpdatePressed(
                                              "START_SALE"),
                                    )
                                  : _selectedWidget == 'START_SALE'
                                      ? _buildTableView1()
                                      : Container()),
                    )
                  ],
                )

                //  Center(child: Column(children: [_buildOrderdetail(), _buildTableView()],),),
                // child: Center(child: _buildAddCustomer("START_SALE", onPressed :() => _onKeyPressed("START_SALE"),)),
                ),
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

  Widget _buildTableView1() {
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
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(1),
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
            ],
          ),
          //ROW
          Table(
            border: TableBorder.symmetric(
                outside: BorderSide(width: 1, color: Color(0xFFF7F7F7))),
            // Optional: to add borders to the table

            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                    // color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
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
                          "999999999",
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
                          "Dawat basmati rice 1kg Dawat basmati rice 1kg",
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
                      child: Obx(() {
                        return TextField(
                          controller: TextEditingController(
                              text: ' ${widget.weightController.weight.value}'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors
                                      .grey.shade300, // Normal border color
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors
                                      .grey.shade300, // Focused border color
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
                                  color: Colors.red,
                                  // Focused error border color
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
                              hintText: "000.099",
                              suffixText: "KG"),
                        );
                      }),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "99999",
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
                            "99999.99",
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
                              // Custom padding

                              // contentPadding: EdgeInsets.all(0),
                              title: '',
                              // Empty title to remove space
                              middleText: '',
                              titlePadding: EdgeInsets.all(0),
                              barrierDismissible: false,
                              backgroundColor: Colors.white,
                              content: _buildRemoveDialog());
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),

          input != ""
              ? Table(
                  border: TableBorder.symmetric(
                      outside: BorderSide(width: 1, color: Color(0xFFF7F7F7))),
                  // Optional: to add borders to the table

                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                    5: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                          // color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),
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
                                "999999999",
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
                                "Dawat basmati rice 1kg Dawat basmati rice 1kg",
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
                            child: TextField(
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors
                                          .grey.shade300, // Normal border color
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300, // Focused border color
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
                                      color: Colors
                                          .red, // Focused error border color
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
                                  hintText: "000.099",
                                  suffixText: "KG"),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "99999",
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
                                  "99999.99",
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
                                    // Custom padding

                                    // contentPadding: EdgeInsets.all(0),
                                    title: '',
                                    // Empty title to remove space
                                    middleText: '',
                                    titlePadding: EdgeInsets.all(0),
                                    barrierDismissible: false,
                                    backgroundColor: Colors.white,
                                    content: _buildRemoveDialog());
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildNumberPadSection1() {
    return KeypadScreen();
  }

  Widget _buildNumberPadSection(HomeController homeController) {
    print(" Barcode : ${input}");
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
                                      //"asd",
                                      '${homeController.scanProductsResponse.value.ebonoTitle}',
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
                                        text: ' ',
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
                                        text: "",
                                        // text: formatPrice(homeController
                                        //     .items
                                        //     .value
                                        //     .priceList
                                        //     ?.first
                                        //     .mrp as Map<String, dynamic>),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: DashedLine(
                        height: 0.4,
                        dashWidth: 4,
                        color: Colors.grey,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _controller,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      // Normal border color
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      // Focused border color
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
                                      color: Colors
                                          .red, // Focused error border color
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
                                          text: ' Enter Code, Quantity ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onEditingComplete: () {
                                  setState(() {
                                    input = _controller.text;
                                    // homeController.fetchData("10004858");
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildKeyIcon(
                                    'assets/images/number_7.png', "7"),
                                _buildKeyIcon(
                                    'assets/images/number_8.png', "8"),
                                _buildKeyIcon(
                                    'assets/images/number_9.png', "9"),
                                _buildKeyClear(
                                    'assets/images/number_back.png', "C")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildKeyIcon(
                                    'assets/images/number_4.png', "4"),
                                _buildKeyIcon(
                                    'assets/images/number_5.png', "5"),
                                _buildKeyIcon(
                                    'assets/images/number_6.png', "6"),
                                _buildKeyClearAll(
                                    'assets/images/number_clear.png', "CA")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(children: [
                                  Row(
                                    children: [
                                      _buildKeyIcon(
                                          'assets/images/number_1.png', "1"),
                                      _buildKeyIcon(
                                          'assets/images/number_2.png', "2"),
                                      _buildKeyIcon(
                                          'assets/images/number_3.png', "3"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _buildKeyDot(
                                          'assets/images/number_dot.png', "."),
                                      _buildKeyIcon(
                                          'assets/images/number_0.png', "0"),
                                      _buildKeyIcon(
                                          'assets/images/number_00.png', "00"),
                                    ],
                                  ),
                                ]),
                                _buildKeyEnterIcon(
                                    'assets/images/number_enter.png', "")
                              ],
                            ),
                          ],
                        ),
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
                                  'Total Items',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '10',
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
                                  '₹88888.88',
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
                          child: Column(
                            children: [
                              Text(
                                "Proceed To Pay",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₹88888.88",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              elevation: 1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: CustomColors.primaryCTA),
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
              style: ElevatedButton.styleFrom(
                elevation: 1,
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: CustomColors.primaryCTA),
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: CustomColors.primaryCTA,
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
    return Container(
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
                // controller: TextEditingController(text: input),
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
                ),
              )),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: TextField(
                // controller: TextEditingController(text: input),
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
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: ElevatedButton(
              onPressed: onPressed,
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
              style: ElevatedButton.styleFrom(
                elevation: 1,
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: CustomColors.primaryCTA),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBackgroundColor: Colors.grey,
                backgroundColor: CustomColors.primaryCTA,
              ),
            ),
          ),
          Container(
            // width: 200,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: ElevatedButton(
              onPressed: onPressed,
              child: Center(
                child: Text(
                  "Continue Without Customer Number",
                  style: TextStyle(
                      color: Color(0xFF066A69),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 1,
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF066A69)),
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0xFFF0F4F4),
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
  }

  Widget _buildTableView() {
    return LayoutBuilder(builder: (context, constraints) {
      final isTabletOrDesktop = constraints.maxWidth > 600;
      return Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DataTable(
              dataRowMinHeight: 48,
              // horizontalMargin: 50,
              border: TableBorder.all(
                style: BorderStyle.none,
                width: 0.2,
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              columnSpacing: isTabletOrDesktop ? 72 : 40,
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade300),
              columns: [
                DataColumn(
                    headingRowAlignment: MainAxisAlignment.start,
                    label: Container(
                      width: 100,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                      child: Text('Item Code'),
                    )),
                DataColumn(
                    label: Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 4.0),
                        child: Text('Name'))),
                DataColumn(
                    label: Container(
                        width: 120,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4.0),
                        child: Text('Qty'))),
                DataColumn(
                    label: Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 4.0),
                        child: Text('MRP'))),
                DataColumn(
                    label: Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 4.0),
                        child: Text('Price'))),
                DataColumn(
                    label: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 4.0),
                        child: Text('Action'))),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Container(
                      width: 100,
                      height: 80,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                      child: Text(
                        '99999999999',
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))),
                  DataCell(Container(
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                      child: Text(
                        'Dawat basmati rice 1kg Dawat basmati rice 1kg',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ))),
                  DataCell(Container(
                    width: 120,
                    height: 50,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color:
                                    Colors.grey.shade300, // Normal border color
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors
                                    .grey.shade300, // Focused border color
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
                            hintText: "000.099",
                            suffixText: "KG"),
                      ),
                    ),
                  )),
                  DataCell(Container(
                      width: 80,
                      height: 120,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                      child: Text(
                        '₹99999',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ))),
                  DataCell(Container(
                      width: 80,
                      height: 100,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                      child: Text(
                        '₹99999.99',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ))),
                  DataCell(Container(
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
                            // Custom padding

                            // contentPadding: EdgeInsets.all(0),
                            title: '',
                            // Empty title to remove space
                            middleText: '',
                            titlePadding: EdgeInsets.all(0),
                            barrierDismissible: false,
                            backgroundColor: Colors.white,
                            content: _buildRemoveDialog());
                      },
                    ),
                  )),
                ]),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildRemoveDialog() {
    return Container(
      child: Column(
        children: [
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                    ),
                    child: Image.asset(
                      'assets/images/sweet_corn.webp',
                      // height: 80,
                      // width: 80,
                      cacheHeight: 50,
                      cacheWidth: 50,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text('Alphonso Mango',
                            maxLines: 2,
                            softWrap: true,
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
                              text: '1',
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
                              text: '₹1200',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "    Yes, Remove    ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green),
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
                      child: Text(
                        "    No, Cancel    ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
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
        child: Center(
          child: Text("$label",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600, color: CustomColors.primaryColor)
              // style: TextStyle(
              //     color: Color(0xFF066A69),
              //     fontSize: 14,
              //     fontWeight: FontWeight.normal),
              ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Color(0xFFF0F4F4),
        ),
      ),
    );
  }

  Widget _buildOrderdetail(String label, BuildContext context) {
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
                    'Order -',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Wednesday, 18 September 2024',
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
              Container(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Customer: - ',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text: 'Shankar Lonare',
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
                                text: '₹12000',
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
                                text: 'Contact No.: - ',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text: '+918871722186',
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
                                text: '2000',
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
              )
            ],
          ),
        ),
      ),
    );
  }

  // number pad
  Widget _buildKeyIcon(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyClear(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onClear(),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyClearAll(String img, String label,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onClearAll(),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyDot(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Image.asset(
              img,
              height: 10,
              width: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyEnterIcon(String img, String label,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 1),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
            // margin: const EdgeInsets.all(15.0),
            child: Image.asset(
              img,
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
    );
  }
}

/*
  Container(
                              width: 200,
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5), // Adjust the value as needed
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: Colors.teal.shade50,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Customer',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5), // Adjust the value as needed
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: Colors.teal.shade50,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Search items',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5), // Adjust the value as needed
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: Colors.teal.shade50,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Inventory Inquiry',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5), // Adjust the value as needed
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: Colors.teal.shade50,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Coupons',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5), // Adjust the value as needed
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: Colors.teal.shade50,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Sales Associate',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                         
*/
String formatPrice(Map<String, dynamic> priceObject) {
  int centAmount = priceObject['cent_amount'];
  String currency = priceObject['currency'];
  int fraction = priceObject['fraction'];

  // Convert centAmount to actual amount based on fraction
  double amount = centAmount / fraction;

  // Return the formatted string with ₹ symbol and amount
  return '₹${amount.toStringAsFixed(2)}';
}

class StringController extends GetxController {
  var barCodeInput = ''.obs;

  void updateInput(String value) {
    barCodeInput.value = value;
  }
}
