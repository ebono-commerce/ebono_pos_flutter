import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_num_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/home/widgets/add_customer_static_widget.dart';
import 'package:ebono_pos/ui/home/widgets/add_customer_widget.dart';
import 'package:ebono_pos/ui/home/widgets/authorisation_required_widget.dart';
import 'package:ebono_pos/ui/home/widgets/coupon_code_widget.dart';
import 'package:ebono_pos/ui/home/widgets/multiple_mrp_widget.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';
import 'package:ebono_pos/utils/auth_modes.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersSection extends StatefulWidget {
  const OrdersSection({super.key});

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection>
    with WidgetsBindingObserver {
  final TextEditingController numPadTextController = TextEditingController();
  final FocusNode scanFocusNode = FocusNode();
  final TextEditingController scanTextController = TextEditingController();
  HomeController homeController = Get.find<HomeController>();
  FocusNode? activeFocusNode;

  @override
  void initState() {
    activeFocusNode = scanFocusNode;
    scanFocusNode.addListener(() {
      setState(() {
        if (scanFocusNode.hasFocus) {
          activeFocusNode = scanFocusNode;
        }
        numPadTextController.text = scanTextController.text;
      });
    });

    numPadTextController.addListener(() {
      setState(() {
        if (activeFocusNode == scanFocusNode) {
          scanTextController.text = numPadTextController.text;
        }
      });
    });

    ever(homeController.customerResponse, (value) {
      if (value.phoneNumber != null) {
        scanFocusNode.requestFocus();
      }
    });

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(homeController.scanProductsResponse, (value) {
        if (value.esin != null) {
          scanTextController.clear();
          scanFocusNode.requestFocus();
        }
        if ((value.priceList?.length ?? 0) > 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: MultipleMrpWidget(context),
              );
            },
          );
        }
      });
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState $state ${homeController.lastRoute.value}');
    if(homeController.lastRoute.value ==  '/order_success'){
      homeController.initialResponse();
    }

  }

  /*@override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _numPadFocusNode.dispose();
    _numPadTextController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 5, // 0.6 ratio
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Obx(() {
                      return _buildOrderDetail(context);
                    }),
                    Expanded(
                      child: Obx(() {
                        if (homeController.registerId.value.isNotEmpty) {
                          return homeController.cartId.value.isEmpty
                              ? AddCustomerStaticWidget()
                              : _buildTableView();
                        } else {
                          return _buildRegisterClosed(context,
                              onPressed: () async {
                            setState(() {
                              homeController.selectedTabButton.value = 1;
                            });
                          });
                        }
                      }),
                    )
                  ],
                )),
          ),
          Expanded(
            flex: 2, // 0.2 ratio
            child: Center(child: _buildNumberPadSection(homeController)),
          ),
          Expanded(
            flex: 1,
            child: QuickActionButtons(
              color: Colors.white,
              onCustomerPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: AddCustomerWidget(context),
                    );
                  },
                );
              },
              onHoldCartPressed: () {
                AuthModes enableHoldCartMode = AuthModeExtension.fromString(
                    homeController.isEnableHoldCartEnabled.value);
                if (enableHoldCartMode == AuthModes.enabled) {
                  homeController.holdCartApiCall();
                } else if (enableHoldCartMode == AuthModes.authorised) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: AuthorisationRequiredWidget(context),
                      );
                    },
                  );
                } else {
                  Get.snackbar('Need Permission', 'Please contact support');
                }
              },
              onSalesAssociatePressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: AuthorisationRequiredWidget(context),
                    );
                  },
                );
              },
              onCouponsPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: CouponCodeWidget(context),
                    );
                  },
                );
              },
              onClearCartPressed: () {
                AuthModes enableHoldCartMode = AuthModeExtension.fromString(
                    homeController.isEnableHoldCartEnabled.value);
                if (enableHoldCartMode == AuthModes.enabled) {
                  homeController.clearFullCart();
                } else if (enableHoldCartMode == AuthModes.authorised) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: AuthorisationRequiredWidget(context),
                      );
                    },
                  );
                } else {
                  Get.snackbar('Need Permission', 'Please contact support');
                }
              },
              onSearchItemsPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: MultipleMrpWidget(context),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w100, color: CustomColors.greyFont),
            )),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Name",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w100, color: CustomColors.greyFont),
            )),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Quantity",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w100, color: CustomColors.greyFont),
            )),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              " ",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w100, color: CustomColors.greyFont),
            )),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "MRP ₹",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w100, color: CustomColors.greyFont),
            )),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Price ₹",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w100, color: CustomColors.greyFont),
            )),
        Padding(padding: const EdgeInsets.all(10.0), child: Text("")),
      ],
    );
  }

  Widget _buildTableView() {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2),
              6: FlexColumnWidth(1),
            },
            children: [
              _buildTableHeader(),
              ...homeController.cartLines.map(_buildTableRow).toList(),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(CartLine itemData) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        _buildTableCell(itemData.item?.esin ?? '',
            maxLines: 1, outerPadding: 8.0, innerPadding: 10.0),
        _buildTableCell(itemData.item?.ebonoTitle ?? '',
            maxLines: 2, outerPadding: 4.0, innerPadding: 2.0),
        _buildEditableQuantityCell(itemData,
            outerPadding: 8.0, innerPadding: 10.0),
        _buildUnitCell(itemData, outerPadding: 4.0, innerPadding: 4.0),
        _buildTableCell(
            getActualPrice(itemData.mrp?.centAmount, itemData.mrp?.fraction),
            outerPadding: 8.0,
            innerPadding: 10.0),
        _buildTableCell(
            getActualPrice(
                itemData.unitPrice?.centAmount, itemData.unitPrice?.fraction),
            outerPadding: 8.0,
            innerPadding: 10.0),
        _buildDeleteButton(itemData),
      ],
    );
  }

  Widget _buildTableCell(String text,
      {int maxLines = 1,
      required double outerPadding,
      required double innerPadding}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(outerPadding),
      child: Padding(
        padding: EdgeInsets.all(innerPadding),
        child: Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: CustomColors.black,
              ),
        ),
      ),
    );
  }

  Widget _buildEditableTextField(CartLine itemData) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(2.0),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: commonTextField(
          label: '',
          focusNode: itemData.weightFocusNode ?? FocusNode(),
          readOnly: false,
          controller: itemData.weightController ?? TextEditingController(),
          suffixLabel: null,
          suffixWidget: InkWell(
            onTap: () {
              itemData.weightFocusNode?.requestFocus();
            },
            child: const Text(''),
          ),
          onValueChanged: (value) {
            print('on value change');
          },
        ),
      ),
    );
  }

  Widget _buildEditableQuantityCell(CartLine itemData,
      {required double outerPadding, required double innerPadding}) {

    numPadTextController.addListener(() {
      setState(() {
        if (activeFocusNode == itemData.weightFocusNode) {
          itemData.weightController?.text = numPadTextController.text ;
        }
      });
    });



    ever(homeController.weight, (value) {
      if (value != 0.0) {
        itemData.weightController?.text = homeController.weight.value.toString();
        //homeController.weight.value = 0.0;
      }
    });

    itemData.weightFocusNode?.addListener(() {
      setState(() {
        if (itemData.weightFocusNode?.hasFocus == true ) {
          homeController.selectedItemData.value = itemData;
          activeFocusNode = itemData.weightFocusNode;
        }
       numPadTextController.text = itemData.weightController?.text ?? '';
      });
    });
    return _buildEditableTextField(itemData);
  }

  Widget _buildUnitCell(CartLine itemData,
      {required double outerPadding, required double innerPadding}) {
    String unitText = itemData.item?.isWeighedItem == true
        ? itemData.quantity?.quantityUom ?? ''
        : '';
    return _buildTableCell(unitText,
        outerPadding: outerPadding, innerPadding: innerPadding);
  }

  Widget _buildDeleteButton(CartLine itemData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(0),
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.red, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
            icon: ImageIcon(
              const AssetImage('assets/images/ic_remove.png'),
              size: 20,
              color: CustomColors.red,
            ),
            onPressed: () {
              AuthModes deleteMode = AuthModeExtension.fromString(
                homeController.isLineDeleteEnabled.value,
              );

              if (deleteMode == AuthModes.enabled) {
                _showRemoveDialog(itemData);
              } else if (deleteMode == AuthModes.authorised) {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: AuthorisationRequiredWidget(context),
                  ),
                );
              } else {
                Get.snackbar('Need Permission', 'Please contact support');
              }
            }),
      ),
    );
  }

  void _showRemoveDialog(CartLine itemData) {
    Get.defaultDialog(
      title: '',
      content: _buildRemoveDialog(itemData, onPressed: () {
        homeController.deleteCartItemApiCall(itemData.cartLineId);
        Get.back();
      }),
    );
  }

  Widget _buildNumberPadSection(HomeController homeController) {
    return Obx(() {
      var scanData = homeController.scanProductsResponse.value;
      var cartData = homeController.cartResponse.value;
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
                                      scanData.ebonoTitle?.isNotEmpty == true
                                          ? '${scanData.ebonoTitle}'
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
                                        text: scanData.salesUom?.isNotEmpty ==
                                                true
                                            ? '1 '
                                            : " - ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: scanData.salesUom?.isNotEmpty ==
                                                true
                                            ? scanData.isWeighedItem == true
                                                ? '(${scanData.salesUom})'
                                                : ''
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
                                        text: scanData.priceList?[0].mrp != null
                                            ? getActualPrice(
                                                scanData.priceList?[0].mrp!
                                                    .centAmount,
                                                scanData.priceList?[0].mrp!
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
                                '${scanData.mediaUrl}',
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
                                    ? scanFocusNode
                                    : FocusNode(),
                            readOnly: (homeController.cartId.value.isNotEmpty &&
                                    homeController.registerId.isNotEmpty)
                                ? false
                                : true,
                            controller:
                                (homeController.cartId.value.isNotEmpty &&
                                        homeController.registerId.isNotEmpty)
                                    ? scanTextController
                                    : TextEditingController(),
                          ),
                        ),
                        CustomNumPad(
                          focusNode: activeFocusNode!,
                          textController: numPadTextController,
                          onEnterPressed: (text) {
                            print("Enter pressed with text: $text");
                            if(activeFocusNode==scanFocusNode){
                              if (homeController.cartId.value.isNotEmpty &&
                                  homeController.registerId.isNotEmpty) {
                                print("onTextListener text: $text");
                                if (isValidOfferId(text)) {
                                  homeController.scanApiCall(text);
                                }
                              }
                              activeFocusNode?.unfocus();
                            }else{
                              try {
                                if (numPadTextController.text != '0.0' &&
                                    numPadTextController.text.isNotEmpty == true &&
                                    numPadTextController.text !=
                                        homeController.selectedItemData.value.quantity?.quantityNumber.toString()) {
                                  double weight =
                                  double.parse(homeController.selectedItemData.value.weightController?.text ?? '');
                                  if (!homeController.isApiCallInProgress) {
                                    homeController.updateCartItemApiCall(
                                      homeController.selectedItemData.value.cartLineId,
                                      homeController.selectedItemData.value.quantity?.quantityUom,
                                      weight,
                                    );
                                  }
                                }
                              } on Exception catch (e) {
                                print(e);
                              }
                              activeFocusNode?.unfocus();
                            }
                          },
                          onValueChanged: (text) {
                            if (activeFocusNode == scanFocusNode) {
                              if (homeController.cartId.value.isNotEmpty &&
                                  homeController.registerId.isNotEmpty) {
                                print("onTextListener text: $text");
                                if (isValidOfferId(text)) {
                                  homeController.scanApiCall(text);
                                }
                              }
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
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
                                  cartData.cartLines?.length != null
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
                                  cartData.mrpSavings != null
                                      ? getActualPrice(
                                                  cartData
                                                      .mrpSavings!.centAmount,
                                                  cartData
                                                      .mrpSavings!.fraction) !=
                                              "₹0.00"
                                          ? getActualPrice(
                                              cartData.mrpSavings!.centAmount,
                                              cartData.mrpSavings!.fraction)
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
                            PaymentSummaryRequest request =
                                PaymentSummaryRequest(
                                    phoneNumber:
                                        homeController.phoneNumber.value,
                                    cartId: homeController.cartId.value,
                                    customer: null,
                                    cartType:
                                        homeController.selectedPosMode.value);
                            Get.toNamed(PageRoutes.paymentSummary,
                                arguments: request);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 10),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: cartData.amountPayable != null
                                  ? getActualPrice(
                                              cartData
                                                  .amountPayable!.centAmount,
                                              cartData
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
                                Text(
                                  cartData.amountPayable != null
                                      ? getActualPrice(
                                          cartData.amountPayable!.centAmount,
                                          cartData.amountPayable!.fraction)
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

  Widget _buildRemoveDialog(CartLine? itemData, {VoidCallback? onPressed}) {
    return Column(
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
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
                            text: getActualPrice(itemData.unitPrice?.centAmount,
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
                padding: EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
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
                padding: EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
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
    );
  }

  Widget _buildOrderDetail(BuildContext context) {
    DateTime now = DateTime.now();
    // Format the date using intl package
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
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

  Widget _buildRegisterClosed(BuildContext context, {VoidCallback? onPressed}) {
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
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 150,
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
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class StringController extends GetxController {
  var barCodeInput = ''.obs;

  void updateInput(String value) {
    barCodeInput.value = value;
  }
}
