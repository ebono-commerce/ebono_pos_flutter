import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:flutter/material.dart';

class QuantityCellWidget extends StatelessWidget {
  final CartLine itemData;
  final VoidCallback onTap;
  final TextEditingController numPadTextController;

  const QuantityCellWidget({
    super.key,
    required this.itemData,
    required this.onTap,
    required this.numPadTextController,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
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
}
