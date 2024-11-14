import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';

class AddCustomer extends StatefulWidget {
  final HomeController homeController;

  const AddCustomer(this.homeController, {super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> with WidgetsBindingObserver {
  late HomeController homeController;

  // String _selectedWidget = 'ADD_CUSTOMER';

  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerCustomerName = TextEditingController();

  @override
  void initState() {
    if (mounted == true) {
      homeController = widget.homeController;
      //homeController.initialCustomerDetails();
    }
    _controllerCustomerName.text = homeController.customerName.value.toString();
    _controllerCustomerName?.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controllerPhoneNumber.dispose();
    _controllerCustomerName.dispose();
    super.dispose();
  }

  void _StaleButtonPressed() {
    if (homeController.phoneNumber.value != '') {
      setState(() {
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
                              ? () {
                                  _StaleButtonPressed();
                                }
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
                              ? () {}
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
                            ),
                          ),
                        ),
                      )),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              // width: 200,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: ElevatedButton(
                onPressed: () {
                  // need to call api through default number
                  // first set the default to _controllerPhoneNumber then call api through controller
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
