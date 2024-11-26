import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/models/cart_response.dart';
import 'package:kpn_pos_application/models/scan_products_response.dart';
import 'package:kpn_pos_application/ui/home/home_controller.dart';
import 'package:kpn_pos_application/utils/price.dart';

class MultipleMrpWidget extends StatefulWidget {
  final HomeController homeController;
  final BuildContext dialogContext;

  const MultipleMrpWidget(this.homeController, this.dialogContext, {super.key});

  @override
  State<MultipleMrpWidget> createState() => _MultipleMrpWidgetState();
}

class _MultipleMrpWidgetState extends State<MultipleMrpWidget> {
  late HomeController homeController;
  late ThemeData theme;
  late CartLine cartLine;
  late ScanProductsResponse scanData;

  @override
  void initState() {
    super.initState();
    homeController = widget.homeController;
    scanData = homeController.scanProductsResponse.value;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return SizedBox(
      width: 460,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select MRP",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.black,
                  ),
                ),
                InkWell(
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
              ],
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListTile(
                    tileColor: CustomColors.dialogGreyBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: CustomColors.borderColor)),
                    title: Text(
                      scanData.ebonoTitle ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: CustomColors.black,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        scanData.esin ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: CustomColors.enabledLabelColor,
                        ),
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.network(
                          scanData.mediaUrl ?? '',
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: const Center(
                                child: Text('Error'),
                              ),
                            ); // Display a custom error widget
                          },
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              'Select MRP printed on the actual product',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.normal,
                color: CustomColors.enabledLabelColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: scanData.priceList?.length ?? 0,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                // Spacing between items
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 400 / (scanData.priceList?.length ?? 1),
                    child: mrpButton(
                      getActualPrice(
                        scanData.priceList?[index].mrp?.centAmount,
                        scanData.priceList?[index].mrp?.fraction,
                      ),
                      (value) {
                        homeController.addToCartApiCall(scanData.esin, 1, scanData.priceList?[index].mrpId, scanData.salesUom, homeController.cartId.value).then((value){
                          Navigator.pop(widget.dialogContext);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mrpButton(String mrpValue, Function(String) onPressed) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          onPressed(mrpValue);
        },
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
          child: Text(mrpValue,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }
}
