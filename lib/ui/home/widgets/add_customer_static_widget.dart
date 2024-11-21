import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/ui/home/widgets/add_customer_widget.dart';

class AddCustomerStaticWidget extends StatefulWidget {
  final HomeController homeController;

  const AddCustomerStaticWidget(this.homeController, {super.key});

  @override
  State<AddCustomerStaticWidget> createState() => _AddCustomerStaticWidgetState();
}

class _AddCustomerStaticWidgetState extends State<AddCustomerStaticWidget>
    with WidgetsBindingObserver {
  late HomeController homeController;
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();
  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  late ThemeData theme;

  @override
  void initState() {
    if (mounted == true) {
      homeController = widget.homeController;
    }

    ever(homeController.phoneNumber, (value) {
      _controllerPhoneNumber.text = value.toString();
    });
    ever(homeController.customerName, (value) {
      _controllerCustomerName.text = value.toString();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: CustomColors.black),
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
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: AddCustomerWidget(homeController),
                            );
                          },
                        );
                      },
                      child: IgnorePointer(
                        child: TextField(
                          readOnly: true,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 1),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: homeController
                                                  .phoneNumber.isNotEmpty
                                              ? CustomColors.secondaryColor
                                              : CustomColors.cardBackground),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBackgroundColor:
                                        CustomColors.cardBackground,
                                    backgroundColor:
                                        CustomColors.secondaryColor,
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
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    )),
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: AddCustomerWidget(homeController),
                            );
                          },
                        );
                      },
                      child: IgnorePointer(
                        child: TextField(
                          controller: _controllerCustomerName,
                          onChanged: (value) {
                            homeController.customerName.value = value;
                          },
                          readOnly: true,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 1),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: homeController
                                                  .customerName.isNotEmpty
                                              ? CustomColors.secondaryColor
                                              : CustomColors.cardBackground),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBackgroundColor:
                                        CustomColors.cardBackground,
                                    backgroundColor:
                                        CustomColors.secondaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      homeController.getCustomerDetailsResponse
                                                  .value.existingCustomer ==
                                              true
                                          ? 'Select'
                                          : 'Add',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.black),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    )),
                Visibility(
                  visible: homeController
                          .getCustomerDetailsResponse.value.existingCustomer !=
                      null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      homeController.getCustomerDetailsResponse.value
                                  .existingCustomer ==
                              true
                          ? 'Existing Customer'
                          : 'New Customer',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: CustomColors.green),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              // width: 200,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: ElevatedButton(
                onPressed: () {
                  homeController.phoneNumber.value = homeController.customerProxyNumber.value;
                  homeController.customerName.value = 'Admin';

                  homeController.fetchCustomer();
                  },
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
}
