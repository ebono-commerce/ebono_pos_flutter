import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
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
import 'package:ebono_pos/ui/home/widgets/price_override_with_auth_widget.dart';
import 'package:ebono_pos/ui/home/widgets/quick_action_buttons.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';
import 'package:ebono_pos/ui/payment_summary/weighing_scale_service.dart';
import 'package:ebono_pos/ui/search/search_widget.dart';
import 'package:ebono_pos/utils/auth_modes.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:ebono_pos/utils/dash_line.dart';
import 'package:ebono_pos/utils/price.dart';

class OrdersSection extends StatefulWidget {
  const OrdersSection({super.key});

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection>
    with WidgetsBindingObserver {
  final FocusNode numPadFocusNode = FocusNode();
  final TextEditingController numPadTextController = TextEditingController();
  HomeController homeController = Get.find<HomeController>();
  late WeighingScaleService weighingScaleService =
      Get.find<WeighingScaleService>();

  @override
  void initState() {
    if (mounted) {
      try {
        weighingScaleService = Get.find<WeighingScaleService>();
        print("WeighingScaleService initialized.");
      } catch (e) {
        print("WeighingScaleService not found: $e");
        if (!Get.isRegistered<WeighingScaleService>()) {
          weighingScaleService = Get.put<WeighingScaleService>(
              WeighingScaleService(Get.find<SharedPreferenceHelper>()));
        } else {
          Get.delete<WeighingScaleService>();
          weighingScaleService = Get.put<WeighingScaleService>(
              WeighingScaleService(Get.find<SharedPreferenceHelper>()));
        }
      }
    }
    ever(homeController.isQuantitySelected, (value) {
      if (value) {
        if (!numPadFocusNode.hasFocus) {
          numPadFocusNode.requestFocus();
        }
      }
    });

    ever(weighingScaleService.weight, (value) {
      if (!numPadFocusNode.hasFocus) {
        numPadFocusNode.requestFocus();
      }
      numPadTextController.clear();
      numPadTextController.text = value.toString();
    });

    ever(homeController.customerResponse, (value) {
      if (value.phoneNumber != null) {
        numPadFocusNode.requestFocus();
      }
    });

    ever(homeController.cartResponse, (value) {
      if (!numPadFocusNode.hasFocus) {
        numPadFocusNode.requestFocus();
      }
    });

    ever(homeController.isScanApiError, (value) {
      if (value) {
        numPadTextController.text = '';
        // setState(() {});
      }
    });

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(homeController.scanProductsResponse, (value) {
        if (value.skuCode != null) {
          numPadTextController.clear();
          numPadFocusNode.requestFocus();
        }

        if ((value.priceList?.length ?? 0) > 1) {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) {
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
        }
      });
    });

    super.initState();
  }

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
                            homeController.selectedTabButton.value = 1;
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
                if (homeController.isContionueWithOutCustomer.value) {
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
                } else {
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
                    Get.snackbar('Action Disabled for this account',
                        'Please contact support');
                  }
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
                Get.defaultDialog(
                  title: '',
                  content: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Are you sure you want to clear cart?",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  AuthModes enableHoldCartMode =
                                      AuthModeExtension.fromString(
                                          homeController
                                              .isEnableHoldCartEnabled.value);
                                  if (enableHoldCartMode == AuthModes.enabled) {
                                    homeController.clearFullCart();
                                    Get.back();
                                  } else if (enableHoldCartMode ==
                                      AuthModes.authorised) {
                                    Get.back();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: AuthorisationRequiredWidget(
                                              context),
                                        );
                                      },
                                    );
                                  } else {
                                    Get.snackbar(
                                        'Action Disabled for this account',
                                        'Please contact support');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: CustomColors.secondaryColor,
                                ),
                                child: Text(
                                  "Yes, Clear Cart",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 10),
                              child: ElevatedButton(
                                onPressed: () => Get.back(),
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: CustomColors.primaryColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: CustomColors.keyBoardBgColor,
                                ),
                                child: Text(
                                  "No, Cancel",
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
              },
              onInventoryInquiryPressed: () {
                homeController.clearDataAndLogout();
              },
              onSearchItemsPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: SearchWidget(context),
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
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          )),
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

  final Map<int, TableColumnWidth> columnWidths = const {
    0: FlexColumnWidth(3),
    1: FlexColumnWidth(6),
    2: FlexColumnWidth(2),
    3: FlexColumnWidth(3),
    4: FlexColumnWidth(3),
    5: FlexColumnWidth(1),
  };

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
            columnWidths: columnWidths,
            children: [
              _buildTableHeader(),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: columnWidths,
                children: homeController.cartLines.map(_buildTableRow).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(CartLine itemData) {
    var borderColor = (homeController.selectedItemData.value.cartLineId ==
                itemData.cartLineId &&
            homeController.isQuantitySelected.value)
        ? Colors.grey.shade800
        : Colors.grey.shade300;

    return TableRow(
      decoration: BoxDecoration(
        color: (homeController.selectedItemData.value.cartLineId ==
                    itemData.cartLineId &&
                homeController.isQuantitySelected.value)
            ? CustomColors.accentColor
            : Colors.white,
        border: Border.all(color: borderColor, width: 1),
      ),
      children: [
        InkWell(
            onTap: () {
              homeController.selectedItemData.value = itemData;
              homeController.isQuantitySelected.value = true;
              var quantity =
                  '${(itemData.item?.isWeighedItem == true) ? (itemData.quantity?.quantityNumber) : (itemData.quantity?.quantityNumber?.toInt())}';
              numPadTextController.text = quantity;
            },
            child: _buildTableCell(itemData.item?.skuCode ?? '',
                maxLines: 1, width: 100)),
        InkWell(
            onTap: () {
              homeController.selectedItemData.value = itemData;
              homeController.isQuantitySelected.value = true;
              var quantity =
                  '${(itemData.item?.isWeighedItem == true) ? (itemData.quantity?.quantityNumber) : (itemData.quantity?.quantityNumber?.toInt())}';
              numPadTextController.text = quantity;
            },
            child: _buildTableCell(itemData.item?.skuTitle ?? '',
                maxLines: 2, width: 280)),
        _buildQuantityCell(itemData),
        InkWell(
          onTap: () {
            AuthModes enablePriceEdit = AuthModeExtension.fromString(
                homeController.isPriceEditEnabled.value);
            if (enablePriceEdit == AuthModes.enabled ||
                enablePriceEdit == AuthModes.authorised) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: PriceOverrideWithAuthWidget(context, itemData),
                  );
                },
              );
            } else {
              Get.snackbar(
                  'Action Disabled for this account', 'Please contact support');
            }
          },
          child: _buildTableCell(
              getActualPrice(itemData.mrp?.centAmount, itemData.mrp?.fraction),
              width: 100),
        ),
        InkWell(
          onTap: () {
            AuthModes enablePriceEdit = AuthModeExtension.fromString(
                homeController.isPriceEditEnabled.value);
            if (enablePriceEdit == AuthModes.enabled ||
                enablePriceEdit == AuthModes.authorised) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: PriceOverrideWithAuthWidget(context, itemData),
                  );
                },
              );
            } else {
              Get.snackbar(
                  'Action Disabled for this account', 'Please contact support');
            }
          },
          child: _buildTableCell(
              getActualPrice(
                  itemData.unitPrice?.centAmount, itemData.unitPrice?.fraction),
              width: 100),
        ),
        _buildDeleteButton(itemData),
      ],
    );
  }

  Widget _buildTableCell(String text,
      {int maxLines = 1, required double width}) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Text(
                text,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CustomColors.black,
                    ),
              ),
            ),
          ),
          maxLines == 1
              ? Container(
                  color: CustomColors.borderColor,
                  height: 30,
                  width: 1,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildQuantityCell(
    CartLine itemData,
  ) {
    return InkWell(
      onTap: () {
        homeController.selectedItemData.value = itemData;
        homeController.isQuantitySelected.value = true;
        var quantity =
            '${(itemData.item?.isWeighedItem == true) ? (itemData.quantity?.quantityNumber) : (itemData.quantity?.quantityNumber?.toInt())}';
        numPadTextController.text = quantity;
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 85,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${(itemData.item?.isWeighedItem == true) ? (itemData.quantity?.quantityNumber) : (itemData.quantity?.quantityNumber?.toInt())}',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.black,
                                  ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${itemData.quantity?.quantityUom}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.greyFont,
                                  ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: CustomColors.borderColor,
                  height: 30,
                  width: 1,
                ),
              ],
            ),
            itemData.quantity?.quantityNumber == 0
                ? Text(
                    'Please weigh this item',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: CustomColors.red,
                        ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(CartLine itemData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(0),
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
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
                Get.snackbar('Action Disabled for this account',
                    'Please contact support');
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
      String skuTitle = '';
      String skuQty = '';
      String skuQtyUom = '';
      String skuPrice = '';
      String skuUrl = '';
      bool isError = false;

      if (homeController.isQuantitySelected.value) {
        skuTitle = homeController.selectedItemData.value.item?.skuTitle ?? '';
        skuQty = homeController.selectedItemData.value.quantity?.quantityNumber
                .toString() ??
            '';
        skuQtyUom =
            homeController.selectedItemData.value.quantity?.quantityUom ?? '';
        skuPrice = getActualPrice(
            homeController.selectedItemData.value.unitPrice?.centAmount,
            homeController.selectedItemData.value.unitPrice?.fraction);
        skuUrl =
            homeController.selectedItemData.value.item?.primaryImageUrl ?? '';
        isError = scanData.isError;
      } else {
        {
          skuTitle = scanData.skuTitle ?? '';
          skuQty = scanData.salesUom?.isNotEmpty == true ? '1' : '';
          skuQtyUom = scanData.salesUom?.isNotEmpty == true
              ? scanData.salesUom ?? ''
              : '';
          skuPrice = scanData.priceList?[0].mrp != null
              ? getActualPrice(
                  scanData.priceList?[0].mrp!.centAmount,
                  scanData.priceList?[0].mrp!.fraction,
                )
              : ' - ';
          skuUrl = scanData.mediaUrl ?? '';
          isError = scanData.isError;
        }
      }
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
                                      color: isError
                                          ? CustomColors.red
                                          : Colors.black,
                                      fontSize: isError ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                            label: homeController.isQuantitySelected.value
                                ? homeController.selectedItemData.value.item
                                            ?.isWeighedItem ==
                                        true
                                    ? 'Enter Weight'
                                    : ' Enter Quantity'
                                : 'Enter Code',
                            focusNode:
                                (homeController.cartId.value.isNotEmpty &&
                                        homeController.registerId.isNotEmpty)
                                    ? numPadFocusNode
                                    : FocusNode(),
                            readOnly: (homeController.cartId.value.isNotEmpty &&
                                    homeController.registerId.isNotEmpty)
                                ? false
                                : true,
                            controller:
                                (homeController.cartId.value.isNotEmpty &&
                                        homeController.registerId.isNotEmpty)
                                    ? numPadTextController
                                    : TextEditingController(),
                            onEditingComplete: () async {
                              if (homeController.isQuantitySelected.value ==
                                  false) {
                                if (homeController.cartId.value.isNotEmpty &&
                                    homeController.registerId.isNotEmpty) {
                                  if (isValidOfferId(
                                          numPadTextController.text.trim()) ||
                                      numPadTextController.text
                                          .trim()
                                          .contains("W")) {
                                    homeController
                                        .scanApiCall(numPadTextController.text);

                                    homeController.isQuantitySelected.value =
                                        false;
                                    numPadTextController.text = '';
                                  }
                                }
                              } else {
                                try {
                                  if (numPadTextController.text != '0.0' &&
                                      numPadTextController.text.isNotEmpty ==
                                          true &&
                                      numPadTextController.text !=
                                          homeController.selectedItemData.value
                                              .quantity?.quantityNumber
                                              .toString()) {
                                    if (!homeController.isApiCallInProgress) {
                                      try {
                                        if (homeController
                                                .isQuantitySelected.value &&
                                            homeController
                                                    .selectedItemData
                                                    .value
                                                    .item
                                                    ?.isWeighedItem ==
                                                true) {
                                          if (double.parse(
                                                  numPadTextController.text) >
                                              300) {
                                            Get.snackbar('Invalid Weight',
                                                'Weight can\'t be more than 300kgs, Please enter valid weight');
                                            return;
                                          } else {
                                            homeController
                                                .updateCartItemApiCall(
                                              homeController.selectedItemData
                                                  .value.cartLineId,
                                              homeController.selectedItemData
                                                  .value.quantity?.quantityUom,
                                              double.parse(
                                                  numPadTextController.text),
                                            );

                                            homeController.isQuantitySelected
                                                .value = false;
                                            numPadTextController.text = '';
                                          }
                                        }
                                      } on Exception catch (e) {
                                        print('error on numpad enter $e');
                                      }
                                    }
                                  } else {
                                    Get.snackbar(
                                        'Invalid or Duplicate Quantity',
                                        'Please enter valid Quantity');
                                  }
                                } on Exception catch (e) {
                                  print(e);
                                }
                              }
                            },
                          ),
                        ),
                        CustomNumPad(
                          focusNode: numPadFocusNode,
                          textController: numPadTextController,
                          onEnterPressed: (text) {
                            print("Enter pressed with text: $text");
                            if (homeController.isQuantitySelected.value ==
                                false) {
                              if (homeController.cartId.value.isNotEmpty &&
                                  homeController.registerId.isNotEmpty) {
                                if (isValidOfferId(text) ||
                                    (text.trim().length >= 1 &&
                                        text.length <= 3)) {
                                  homeController
                                      .scanApiCall(numPadTextController.text);
                                }
                              }
                              numPadFocusNode.unfocus();
                            } else {
                              try {
                                if (numPadTextController.text != '0.0' &&
                                    numPadTextController.text.isNotEmpty ==
                                        true &&
                                    numPadTextController.text !=
                                        homeController.selectedItemData.value
                                            .quantity?.quantityNumber
                                            .toString()) {
                                  if (!homeController.isApiCallInProgress) {
                                    try {
                                      if (homeController
                                              .isQuantitySelected.value &&
                                          homeController.selectedItemData.value
                                                  .item?.isWeighedItem ==
                                              true) {
                                        if (double.parse(
                                                numPadTextController.text) >
                                            300) {
                                          Get.snackbar('Invalid Weight',
                                              'Weight can\'t be more than 300kgs, Please enter valid weight');
                                          return;
                                        }
                                      } else if (homeController
                                          .isQuantitySelected.value) {
                                        if (int.parse(
                                                numPadTextController.text) >
                                            999) {
                                          Get.snackbar('Invalid Quantity',
                                              'Quantity can\'t be more than 999, Please enter valid quantity');
                                          return;
                                        }
                                      }
                                    } on Exception catch (e) {
                                      print('error on numpad enter $e');
                                    }
                                    homeController.updateCartItemApiCall(
                                      homeController
                                          .selectedItemData.value.cartLineId,
                                      homeController.selectedItemData.value
                                          .quantity?.quantityUom,
                                      double.parse(numPadTextController.text),
                                    );
                                    homeController.isQuantitySelected.value =
                                        false;
                                    numPadTextController.text = '';
                                  }
                                } else {
                                  Get.snackbar('Invalid or Duplicate Quantity',
                                      'Please enter valid Quantity');
                                }
                              } on Exception catch (e) {
                                print(e);
                              }
                              numPadFocusNode.unfocus();
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
                          onPressed: homeController.isQuantityEmpty.value
                              ? null
                              : () {
                                  PaymentSummaryRequest request =
                                      PaymentSummaryRequest(
                                          phoneNumber:
                                              homeController.phoneNumber.value,
                                          cartId: homeController.cartId.value,
                                          customer: null,
                                          cartType: homeController
                                              .selectedPosMode.value);
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
                            text: '${itemData?.item?.skuTitle}',
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
                            text: '${itemData?.item?.skuCode}',
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
                    backgroundColor: CustomColors.keyBoardBgColor,
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
    return Column(
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
    );
  }
}

class StringController extends GetxController {
  var barCodeInput = ''.obs;

  void updateInput(String value) {
    barCodeInput.value = value;
  }
}
