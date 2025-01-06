import 'package:flutter/material.dart';
import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:flutter_svg/svg.dart';

class SummaryPaymentSection extends StatelessWidget {
  final double totalRefund;
  final int loyaltyPoints;
  final double walletAmount;
  final double mopAmount;
  final Function(String) onPaymentModeSelected;

  const SummaryPaymentSection({
    super.key,
    required this.totalRefund,
    required this.loyaltyPoints,
    required this.walletAmount,
    required this.mopAmount,
    required this.onPaymentModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyLargeBlack = textTheme.bodyLarge?.copyWith(
      color: Colors.black,
    );
    final bodyLargeBold = textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );

    return Expanded(
      flex: 4,
      child: Column(
        children: [
          // Summary Section
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Summary', style: bodyLargeBold),
                  const SizedBox(height: 10),
                  Divider(
                    color: CustomColors.grey,
                    thickness: 1.5,
                  ),
                  _buildSummaryItem(
                    label: 'Total refund',
                    value: '₹${totalRefund.toStringAsFixed(0)}',
                    context: context,
                    textStyle: bodyLargeBlack!,
                  ),
                  _buildSummaryItem(
                    label: 'Loyalty points',
                    value: loyaltyPoints.toString(),
                    context: context,
                    textStyle: bodyLargeBlack,
                  ),
                  _buildSummaryItem(
                    label: 'Wallet',
                    value: '₹${walletAmount.toStringAsFixed(0)}',
                    context: context,
                    textStyle: bodyLargeBlack,
                  ),
                  _buildSummaryItem(
                    label: 'MOP',
                    value: '₹${mopAmount.toStringAsFixed(0)}',
                    context: context,
                    textStyle: bodyLargeBlack,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Payment Mode Section
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Payment Mode',
                          style: bodyLargeBlack,
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color: CustomColors.grey,
                          thickness: 1.5,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPaymentOption(
                                title: 'Cash',
                                path: 'assets/images/cash.svg',
                                isSelected: false,
                                onTap: () => onPaymentModeSelected('cash'),
                                context: context,
                                textStyle: bodyLargeBlack,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildPaymentOption(
                                title: 'Wallet',
                                path: 'assets/images/wallet.svg',
                                isSelected: true,
                                onTap: () => onPaymentModeSelected('wallet'),
                                context: context,
                                textStyle: bodyLargeBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 80,
                    color: CustomColors.keyBoardBgColor,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Refund to customer', style: bodyLargeBlack),
                        Text(
                          '₹${mopAmount.toStringAsFixed(0)}',
                          style: bodyLargeBlack,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle complete return
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Complete Return', style: bodyLargeBlack),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required BuildContext context,
    required TextStyle textStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String path,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
    required TextStyle textStyle,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBEB) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(path, width: 28),
            const SizedBox(width: 8),
            Text(title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
