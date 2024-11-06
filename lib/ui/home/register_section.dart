import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/ui/home/orders_section.dart';
import 'package:kpn_pos_application/ui/payment_summary/weight_controller.dart';
import 'package:kpn_pos_application/utils/dash_line.dart';

class RegisterSection extends StatefulWidget {
  final WeightController weightController;
  final HomeController homeController;

  const RegisterSection(this.weightController, this.homeController,
      {super.key});
  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection>
    with WidgetsBindingObserver {
  String _selectedWidget = 'OPEN_REGISTER';
  String input = '';
  late WeightController weightController;
  late HomeController homeController;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (mounted == true) {
      weightController = widget.weightController;
      homeController = widget.homeController;
      homeController.intializationResponse();
    }
    super.initState();
  }

  void _onKeyPressed(String value) {
    setState(() {
      input += value;
    });
  }

  void _onKeyPressedEnter(String value) {
    homeController.scanApiCall(input);
    print('Entered number: $input');
  }

  void _onClear() {
    setState(() {
      input = input.substring(0, input.length - 1);
    });
  }

  void _onClearAll() {
    setState(() {
      input = '';
      homeController.clearScanData();
    });
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
  Widget build(BuildContext context) {
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(20),
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
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Payment summary',
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buidButton(String label, BuildContext context, bool isEnable) {
    return Container(
      width: 220,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      child: ElevatedButton(
        onPressed: isEnable
            ? () {
                // Respond to button press
              }
            : null,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: isEnable ? CustomColors.primaryColor : CustomColors.grey,
                width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:
              isEnable ? Color(0xFFF0F4F4) : CustomColors.disabledColor,
        ),
        child: Center(
          child: Text(label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isEnable
                      ? CustomColors.primaryColor
                      : CustomColors.greyFont)
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
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(color: Colors.grey),
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(10),
        //     topRight: Radius.circular(10),
        //     bottomLeft: Radius.circular(10),
        //     bottomRight: Radius.circular(10),
        //   ),
        //   shape: BoxShape.rectangle,
        // ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Register is closed!,',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text("Set an opening float to start the sale",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: CustomColors.grey))
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: CustomColors.borderColor),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Opening',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.normal)),
                          Text("#2",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.black))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: CustomColors.borderColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last closing time',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.normal)),
                          Text("Wednesday, 18 September 2024 | 09:12 AM",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.black))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
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

  Widget _buildNumberPadSection(HomeController homeController) {
    print(" Barcode : $input");

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
                                            ? ' 1 '
                                            : ' - ',
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
                                // focusNode: _focusNode,
                                controller: TextEditingController(text: input),
                                //controller: _controller,
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
                                    homeController.scanApiCall(input);
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
                                    'assets/images/number_enter.png', "Enter")
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
                                  '-',
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
                            // Get.toNamed(PageRoutes.paymentSummary);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: CustomColors.secondaryColor),
                          child: SizedBox(
                            height: 56,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Open Register",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                    _buidButton("Customer", context, false),
                    _buidButton("Search items", context, false),
                    _buidButton("Inventory inquiry", context, true),
                    _buidButton("Coupons", context, false),
                    _buidButton("Sales Associate", context, false)
                  ],
                ),
              ),
              _buidButton("Hold cart", context, false)
            ],
          )),
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
      onTap: onPressed ?? () => _onKeyPressedEnter(label),
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
