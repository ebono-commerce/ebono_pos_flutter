import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/model/overide_price_request.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PriceOverrideWithAuthWidget extends StatefulWidget {
  final BuildContext dialogContext;
  final CartLine itemData;

  const PriceOverrideWithAuthWidget(this.dialogContext, this.itemData,
      {super.key});

  @override
  State<PriceOverrideWithAuthWidget> createState() =>
      _PriceOverrideWithAuthWidgetState();
}

class _PriceOverrideWithAuthWidgetState
    extends State<PriceOverrideWithAuthWidget> {
  HomeController homeController = Get.find<HomeController>();
  final TextEditingController loginIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode loginIdFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  FocusNode? activeFocusNode;
  late ThemeData theme;
  late CartLine itemData;

  @override
  void initState() {
    super.initState();
    itemData = widget.itemData;
    if (!loginIdFocusNode.hasFocus) {
      loginIdFocusNode.requestFocus();
    }
    activeFocusNode = loginIdFocusNode;

    loginIdFocusNode.addListener(() {
      setState(() {
        if (loginIdFocusNode.hasFocus) {
          activeFocusNode = loginIdFocusNode;
        }
        _qwertyPadController.text = loginIdController.text;
      });
    });

    passwordFocusNode.addListener(() {
      setState(() {
        if (passwordFocusNode.hasFocus) {
          activeFocusNode = passwordFocusNode;
        }
        _qwertyPadController.text = passwordController.text;
      });
    });

    priceFocusNode.addListener(() {
      setState(() {
        if (priceFocusNode.hasFocus) {
          activeFocusNode = priceFocusNode;
        }
        _qwertyPadController.text = priceController.text;
      });
    });

    _qwertyPadController.addListener(() {
      setState(() {
        if (activeFocusNode == loginIdFocusNode) {
          loginIdController.text = _qwertyPadController.text;
        } else if (activeFocusNode == passwordFocusNode) {
          passwordController.text = _qwertyPadController.text;
        } else if (activeFocusNode == priceFocusNode) {
          priceController.text = _qwertyPadController.text;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0, top: 18),
              child: InkWell(
                onTap: () {
                  Navigator.pop(widget.dialogContext);
                },
                child: SvgPicture.asset(
                  'assets/images/ic_close.svg',
                  semanticsLabel: 'cash icon,',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        Obx(
          () {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                homeController.overideApproverUserId.isEmpty
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Authorization is required for price update!",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: CustomColors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: commonTextField(
                                    label: "Login Id",
                                    controller: loginIdController,
                                    focusNode: loginIdFocusNode,
                                    onValueChanged: (value) => value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: commonTextField(
                                    label: "Password",
                                    controller: passwordController,
                                    focusNode: passwordFocusNode,
                                    obscureText: true,
                                    onValueChanged: (value) => value,
                                    //readOnly: homeController.phoneNumber.isEmpty,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(flex: 1, child: authoriseButton()),
                                Expanded(flex: 1, child: cancelButton(false))
                              ],
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/success.json',
                              width: 130,
                              height: 130,
                              fit: BoxFit.fill,
                              repeat: true,
                              reverse: false,
                              animate: true,
                            ),
                            Text(
                              'Authorization is successful!',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: CustomColors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'User ID:',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: CustomColors.greyFont,
                                  ),
                                ),
                                Text(
                                  homeController.overideApproverUserId.value,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    color: CustomColors.borderColor,
                    width: 1,
                    height: 260,
                  ),
                )),
                Expanded(child: itemDetails())
              ],
            );
          },
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 900,
          child: CustomQwertyPad(
            textController: _qwertyPadController,
            focusNode: activeFocusNode!,
            onEnterPressed: (value) {
              if (activeFocusNode == loginIdFocusNode) {
                passwordFocusNode.requestFocus();
              } else if (activeFocusNode == passwordFocusNode) {
                passwordFocusNode.unfocus();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget authoriseButton() {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        style: commonElevatedButtonStyle(
            theme: theme,
            textStyle: theme.textTheme.bodyMedium,
            padding: EdgeInsets.all(12)),
        onPressed: () {
          homeController.getAuthorisation(loginIdController.text,
              passwordController.text, 'PRICE_OVERRIDE');
        },
        child: Text(
          "Authorise",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget cancelButton(bool priceOverride) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: homeController.overideApproverUserId.value.isNotEmpty
            ? () {
                Navigator.pop(widget.dialogContext);
              }
            : !priceOverride
                ? () {
                    Navigator.pop(widget.dialogContext);
                  }
                : null,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: CustomColors.keyBoardBgColor,
        ),
        child: Center(
          child: Text("Cancel",
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }

  Widget itemDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: CustomColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            itemData.item?.skuTitle ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: CustomColors.black,
            ),
          ),
          SizedBox(height: 8),
          // Subtitle (Phone Number)
          Text(
            itemData.item?.skuCode ?? '',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: CustomColors.greyFont,
            ),
          ),
          SizedBox(height: 8),
          // Price
          Text(
            getActualPrice(
                itemData.unitPrice?.centAmount, itemData.unitPrice?.fraction),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: CustomColors.black,
            ),
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: commonTextField(
              label: "Enter New price",
              controller: priceController,
              focusNode: priceFocusNode,
              obscureText: false,
              onValueChanged: (value) => value,
              //readOnly: homeController.phoneNumber.isEmpty,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(flex: 1, child: updatePriceButton()),
              Expanded(flex: 1, child: cancelButton(true))
            ],
          ),
        ],
      ),
    );
  }

  Widget updatePriceButton() {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        style: commonElevatedButtonStyle(
            theme: theme,
            textStyle: theme.textTheme.bodyMedium,
            padding: EdgeInsets.all(12)),
        onPressed: homeController.overideApproverUserId.value.isNotEmpty
            ? () {
                homeController
                    .overridePrice(OverRidePriceRequest(
                        cartId: homeController.cartId.value,
                        metadata: Metadata(
                            overrideApproverUserId:
                                homeController.overideApproverUserId.value),
                        cartLines: [
                      OverrideCartLine(
                        cartLineId: itemData.cartLineId,
                        unitPrice: UnitPrice(
                          centAmount: int.parse(priceController.text),
                          currency: itemData.unitPrice?.currency,
                          fraction: 1,
                        ),
                      )
                    ]))
                    .then((value) {
                  if (value != null) {
                    Navigator.pop(widget.dialogContext);
                  }
                });
              }
            : null,
        child: Text(
          "Update Price",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
