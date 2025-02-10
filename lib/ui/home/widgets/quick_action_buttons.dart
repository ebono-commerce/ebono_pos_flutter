import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/common_widgets/version_widget.dart';
import 'package:flutter/material.dart';

class QuickActionButtons extends StatelessWidget {
  final VoidCallback? onCustomerPressed;
  final VoidCallback? onSearchItemsPressed;
  final VoidCallback? onInventoryInquiryPressed;
  final VoidCallback? onCouponsPressed;
  final VoidCallback? onSalesAssociatePressed;
  final VoidCallback? onClearCartPressed;
  final VoidCallback? onHoldCartPressed;
  final Color? color;

  const QuickActionButtons({
    super.key,
    this.onCustomerPressed,
    this.onSearchItemsPressed,
    this.onInventoryInquiryPressed,
    this.onCouponsPressed,
    this.onSalesAssociatePressed,
    this.onClearCartPressed,
    this.onHoldCartPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: color ?? Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  actionButton(
                      label: "Customer",
                      context: context,
                      onPressed: onCustomerPressed),
                  actionButton(
                      label: "Search items",
                      context: context,
                      onPressed: onSearchItemsPressed),
                  actionButton(
                      label: "Inventory inquiry",
                      context: context,
                      onLongPress: onInventoryInquiryPressed),
                  actionButton(
                      label: "Coupons",
                      context: context,
                      onPressed: onCouponsPressed),
                  actionButton(
                      label: "Sales Associate",
                      context: context,
                      onPressed: onSalesAssociatePressed),
                ],
              ),
            ),
            actionButton(
                label: "Clear cart",
                context: context,
                onPressed: onClearCartPressed),
            actionButton(
                label: "Hold cart",
                context: context,
                onPressed: onHoldCartPressed),
            VersionWidget(
              fontSize: 8,
            )
          ],
        ),
      ),
    );
  }

  Widget actionButton({
    required String label,
    required BuildContext context,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) {
    return Container(
      width: 220,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: CustomColors.keyBoardBgColor,
        ),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600, color: CustomColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
