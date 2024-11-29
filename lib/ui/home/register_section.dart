import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterSection extends StatefulWidget {

  const RegisterSection({super.key});

  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection>
    with WidgetsBindingObserver {
  late ThemeData theme;

  final FocusNode cashPaymentFocusNode = FocusNode();
  final FocusNode openingFloatPaymentFocusNode = FocusNode();
  final FocusNode cardsPaymentFocusNode = FocusNode();
  final FocusNode upiPaymentFocusNode = FocusNode();
  final FocusNode upiSlipCountFocusNode = FocusNode();
  final FocusNode cardSlipCountFocusNode = FocusNode();

  final FocusNode openCommentFocusNode = FocusNode();
  final FocusNode closeCommentFocusNode = FocusNode();

  FocusNode? activeFocusNode;

  final TextEditingController numPadTextController = TextEditingController();
  final TextEditingController cashPaymentTextController =
      TextEditingController();
  final TextEditingController openingFloatPaymentTextController =
      TextEditingController();
  final TextEditingController cardsPaymentTextController =
      TextEditingController();
  final TextEditingController upiPaymentTextController =
      TextEditingController();
  final TextEditingController upiSlipCountTextController =
      TextEditingController();
  final TextEditingController cardSlipCountTextController =
      TextEditingController();

  final TextEditingController closeCommentTextController =
      TextEditingController();
  final TextEditingController openCommentTextController =
      TextEditingController();

  HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    if (mounted == true) {
    }
    if (!openingFloatPaymentFocusNode.hasFocus) {
      openingFloatPaymentFocusNode.requestFocus();
    }
    cashPaymentFocusNode.addListener(() {
      setState(() {
        if (cashPaymentFocusNode.hasFocus) {
          activeFocusNode = cashPaymentFocusNode;
        }
        numPadTextController.text = cashPaymentTextController.text;
      });
    });
    activeFocusNode = cashPaymentFocusNode;

    openingFloatPaymentFocusNode.addListener(() {
      setState(() {
        if (openingFloatPaymentFocusNode.hasFocus) {
          activeFocusNode = openingFloatPaymentFocusNode;
        }
        numPadTextController.text = openingFloatPaymentTextController.text;
      });
    });
    cardsPaymentFocusNode.addListener(() {
      setState(() {
        if (cardsPaymentFocusNode.hasFocus) {
          activeFocusNode = cardsPaymentFocusNode;
        }
        numPadTextController.text = cardsPaymentTextController.text;
      });
    });
    upiPaymentFocusNode.addListener(() {
      setState(() {
        if (upiPaymentFocusNode.hasFocus) {
          activeFocusNode = upiPaymentFocusNode;
        }
        numPadTextController.text = upiPaymentTextController.text;
      });
    });

    openCommentFocusNode.addListener(() {
      setState(() {
        if (openCommentFocusNode.hasFocus) {
          activeFocusNode = openCommentFocusNode;
        }
        numPadTextController.text = openCommentTextController.text;
      });
    });
    closeCommentFocusNode.addListener(() {
      setState(() {
        if (closeCommentFocusNode.hasFocus) {
          activeFocusNode = closeCommentFocusNode;
        }
        numPadTextController.text = closeCommentTextController.text;
      });
    });

    upiSlipCountFocusNode.addListener(() {
      setState(() {
        if (upiSlipCountFocusNode.hasFocus) {
          activeFocusNode = upiSlipCountFocusNode;
        }
        numPadTextController.text = upiSlipCountTextController.text;
      });
    });
    cardSlipCountFocusNode.addListener(() {
      setState(() {
        if (cardSlipCountFocusNode.hasFocus) {
          activeFocusNode = cardSlipCountFocusNode;
        }
        numPadTextController.text = cardSlipCountTextController.text;
      });
    });

    numPadTextController.addListener(() {
      setState(() {
        if (activeFocusNode == cashPaymentFocusNode) {
          cashPaymentTextController.text = numPadTextController.text;
        } else if (activeFocusNode == openingFloatPaymentFocusNode) {
          openingFloatPaymentTextController.text = numPadTextController.text;
        } else if (activeFocusNode == cardsPaymentFocusNode) {
          cardsPaymentTextController.text = numPadTextController.text;
        } else if (activeFocusNode == upiPaymentFocusNode) {
          upiPaymentTextController.text = numPadTextController.text;
        } else if (activeFocusNode == openCommentFocusNode) {
          openCommentTextController.text = numPadTextController.text;
        } else if (activeFocusNode == closeCommentFocusNode) {
          closeCommentTextController.text = numPadTextController.text;
        } else if (activeFocusNode == upiSlipCountFocusNode) {
          upiSlipCountTextController.text = numPadTextController.text;
        } else if (activeFocusNode == cardSlipCountFocusNode) {
          cardSlipCountTextController.text = numPadTextController.text;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          _buildRegisterInfo(
                              homeController.registerId.value, context),
                          (homeController.registerId.value != "" &&
                                  homeController.registerId.value != null)
                              ? _buildCloseRegister()
                              : _buildOpenRegister(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: numpadSection(),
                    ),
                    Expanded(
                      flex: 1,
                      child: QuickActionButtons(
                        // color: Colors.grey.shade100,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          ),
          homeController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : SizedBox(),
        ],
      ),
    );
  }

  Widget numpadSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 10),
                  trailing: SvgPicture.asset(
                    'assets/images/ic_cash_inhand.svg',
                    semanticsLabel: 'cash icon,',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    homeController.registerId.value == ""
                        ? 'Opening Float'
                        : 'Cash Payments',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 10, right: 10, top: 10),
                  child: DashedLine(
                    height: 0.4,
                    dashWidth: 4,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      )),
                  //padding: const EdgeInsets.all(8.0),
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        numPadTextController.text,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                CustomNumPad(
                  focusNode: activeFocusNode!,
                  textController: numPadTextController,
                  onValueChanged: (value) {
                    if (activeFocusNode == cashPaymentFocusNode) {
                      homeController.cashPayment.value = value;
                    } else if (activeFocusNode ==
                        openingFloatPaymentFocusNode) {
                      homeController.openFloatPayment.value = value;
                    } else if (activeFocusNode == cardsPaymentFocusNode) {
                      homeController.cardPayment.value = value;
                    } else if (activeFocusNode == upiPaymentFocusNode) {
                      homeController.upiPayment.value = value;
                    } else if (activeFocusNode == upiSlipCountFocusNode) {
                      homeController.upiPaymentCount.value = value;
                    } else if (activeFocusNode == cardSlipCountFocusNode) {
                      homeController.cardPaymentCount.value = value;
                    }
                  },
                  onEnterPressed: (value) {
                    if (activeFocusNode == cashPaymentFocusNode) {
                      cashPaymentFocusNode.unfocus();
                    } else if (activeFocusNode ==
                        openingFloatPaymentFocusNode) {
                      openingFloatPaymentFocusNode.unfocus();
                    } else if (activeFocusNode == cardsPaymentFocusNode) {
                      cardsPaymentFocusNode.unfocus();
                    } else if (activeFocusNode == upiPaymentFocusNode) {
                      upiPaymentFocusNode.unfocus();
                    } else if (activeFocusNode == upiSlipCountFocusNode) {
                      upiSlipCountFocusNode.unfocus();
                    } else if (activeFocusNode == cardSlipCountFocusNode) {
                      cardSlipCountFocusNode.unfocus();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          openCloseButtonSection()
        ],
      ),
    );
  }

  Widget openCloseButtonSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: " - ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: " - ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: " - ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: " - ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  style: commonElevatedButtonStyle(
                      theme: theme,
                      textStyle: theme.textTheme.bodyMedium,
                      padding: EdgeInsets.all(12)),
                  onPressed: () {
                    if (homeController.registerId.value == "") {
                      // OPEN
                      homeController.openRegisterApiCall();
                    } else {
                      // CLOSE
                      homeController.closeRegisterApiCall();
                    }
                  },
                  child: Text(
                    homeController.registerId.value != ""
                        ? "Close Register"
                        : "Open Register",
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildRegisterInfo(String label, BuildContext context) {
    DateTime now = DateTime.now();
    // Format the date using intl package
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
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
                padding: EdgeInsets.all(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        label == ""
                            ? 'Register is closed!'
                            : 'Register is open!',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text("Set an opening float to start the sale",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: CustomColors.grey))
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
                      width: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label == "" ? 'Opening' : 'Closing',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.greyFont)),
                          Text("# ---",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.black))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: CustomColors.borderColor,
                    ),
                    SizedBox(
                      width: 5,
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
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.greyFont)),
                          Text("Wednesday, 18 September 2024 | 09:12 AM",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
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

  Widget _buildOpenRegister() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Payment summary',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.normal)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
              decoration: BoxDecoration(
                color: CustomColors.enabledBorderColor,
                border: Border.all(color: CustomColors.borderColor),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text('Payment type',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.normal)),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 140,
                      child: Text('Counted ₹',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.normal)),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // color: Colors.amberAccent,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      "Opening Float",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 140,
                    child: commonTextField(
                        label: "Enter Amount",
                        focusNode: openingFloatPaymentFocusNode,
                        controller: openingFloatPaymentTextController,
                        onValueChanged: (value) {
                          print('commonTextField $value');
                        }),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _buildAddCommentForOpen(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseRegister() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
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
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('Payment summary',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.normal)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.enabledBorderColor,
                    border:
                        Border.all(color: CustomColors.enabledBorderColor),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text('Payment type',
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.normal)),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 140,
                          child: Text('Counted ₹',
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.normal)),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 140,
                          child: Text('Charge slip count',
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.normal)),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // color: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          "Cash payments",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 140,
                        child: commonTextField(
                            label: "Enter Amount",
                            readOnly: true,
                            focusNode: cashPaymentFocusNode,
                            controller: cashPaymentTextController,
                            onValueChanged: (value) {
                              print('commonTextField $value');
                            }),
                      ),
                      Spacer(),
                      SizedBox(width: 140, child: Container()),
                      Spacer()
                    ],
                  ),
                ),
                Container(
                  // color: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          "Card",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 140,
                        child: commonTextField(
                            label: "Enter Amount",
                            readOnly: true,
                            focusNode: cardsPaymentFocusNode,
                            controller: cardsPaymentTextController,
                            onValueChanged: (value) {
                              print('commonTextField $value');
                            }),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 140,
                        child: commonTextField(
                            label: "Enter Count",
                            readOnly: true,
                            focusNode: cardSlipCountFocusNode,
                            controller: cardSlipCountTextController,
                            onValueChanged: (value) {
                              print('commonTextField $value');
                            }),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Container(
                  // color: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          "UPI payments",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 140,
                        child: commonTextField(
                            label: "Enter Amount",
                            readOnly: true,
                            focusNode: upiPaymentFocusNode,
                            controller: upiPaymentTextController,
                            onValueChanged: (value) {
                              print('commonTextField $value');
                            }),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 140,
                        child: commonTextField(
                            label: "Enter Count",
                            readOnly: true,
                            focusNode: upiSlipCountFocusNode,
                            controller: upiSlipCountTextController,
                            onValueChanged: (value) {
                              print('commonTextField $value');
                            }),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildAddCommentForClose(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddCommentForOpen() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: SizedBox(
        width: double.maxFinite,
        child: commonTextField(
            label: "Add comments here",
            focusNode: openCommentFocusNode,
            controller: openCommentTextController,
            onValueChanged: (value) {
              print('commonTextField $value');
            }),
      ),
    );
  }

  Widget _buildAddCommentForClose() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: SizedBox(
        width: double.maxFinite,
        child: commonTextField(
            label: "Add comments here",
            focusNode: closeCommentFocusNode,
            controller: closeCommentTextController,
            onValueChanged: (value) {
              print('commonTextField $value');
            }),
      ),
    );
  }
}
