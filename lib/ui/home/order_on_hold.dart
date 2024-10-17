import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/custom_colors.dart';

class OrderOnHold extends StatefulWidget {
  const OrderOnHold({super.key});

  @override
  State<OrderOnHold> createState() => _OrderOnHoldState();
}

class _OrderOnHoldState extends State<OrderOnHold> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9, // 0.6 ratio
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  Expanded(child: _buildTableView1(context)),
                ],
              )),
        ),
        Expanded(
          flex: 1, // 0.1 ratio
          child: _buildRightActionButtons(context),
        ),
      ],
    );
  }
}

Widget _buildTitle() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Total 12 orders are on hold!",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Resume orders to complete the sale",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

Widget _buildTableView1(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(bottom: 2),
    decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
    child: Column(
      children: [
        //Table header
        Table(
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1),
          },
          children: [
            TableRow(
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
                      "Cart Id",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w100,
                          color: CustomColors.greyFont),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Reserved Order Id",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w100,
                          color: CustomColors.greyFont),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Customer Name",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w100,
                          color: CustomColors.greyFont),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Customer Number",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w100,
                          color: CustomColors.greyFont),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Cashier",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w100,
                          color: CustomColors.greyFont),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Hold Date",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w100,
                          color: CustomColors.greyFont),
                    )),
                Padding(padding: const EdgeInsets.all(10.0), child: Text("")),
                Padding(padding: const EdgeInsets.all(10.0), child: Text("")),
              ],
            ),
          ],
        ),
        //ROW
        Table(
          border: TableBorder.symmetric(
              outside: BorderSide(width: 1, color: Color(0xFFF7F7F7))),
          // Optional: to add borders to the table

          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                  // color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              // ),
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "#11122",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "#1231313",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Shankar Lonare",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "+91 8871722186",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(6.0),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Akshay",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.black),
                        ))),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "18 September 2024",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 80,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        {
                          Get.defaultDialog(
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              // Custom padding

                              // contentPadding: EdgeInsets.all(0),
                              title: '',
                              // Empty title to remove space
                              middleText: '',
                              titlePadding: EdgeInsets.all(0),
                              barrierDismissible: false,
                              backgroundColor: Colors.white,
                              content: _buildRemoveDialog());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.green),
                      child: Text(
                        "    Resume    ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 80,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        {
                          Get.defaultDialog(
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              // Custom padding

                              // contentPadding: EdgeInsets.all(0),
                              title: '',
                              // Empty title to remove space
                              middleText: '',
                              titlePadding: EdgeInsets.all(0),
                              barrierDismissible: false,
                              backgroundColor: Colors.white,
                              content: _buildRemoveDialog());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.red),
                      child: Text(
                        "    Delete    ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Table(
          border: TableBorder.symmetric(
              outside: BorderSide(width: 1, color: Color(0xFFF7F7F7))),
          // Optional: to add borders to the table

          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                  // color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              // ),
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "#11122",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "#1231313",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Shankar Lonare",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "+91 8871722186",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(6.0),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Akshay",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.black),
                        ))),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "18 September 2024",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.black),
                      )),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 80,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        {
                          Get.defaultDialog(
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              // Custom padding

                              // contentPadding: EdgeInsets.all(0),
                              title: '',
                              // Empty title to remove space
                              middleText: '',
                              titlePadding: EdgeInsets.all(0),
                              barrierDismissible: false,
                              backgroundColor: Colors.white,
                              content: _buildRemoveDialog());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.green),
                      child: Text(
                        "    Resume    ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 80,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        {
                          Get.defaultDialog(
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              // Custom padding

                              // contentPadding: EdgeInsets.all(0),
                              title: '',
                              // Empty title to remove space
                              middleText: '',
                              titlePadding: EdgeInsets.all(0),
                              barrierDismissible: false,
                              backgroundColor: Colors.white,
                              content: _buildRemoveDialog());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.red),
                      child: Text(
                        "    Delete    ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildRightActionButtons(BuildContext context) {
  return Center(
    child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buidButton("Customer", context),
                  _buidButton("Search items", context),
                  _buidButton("Inventory inquiry", context),
                  _buidButton("Coupons", context),
                  _buidButton("Sales Associate", context)
                ],
              ),
            ),
            _buidButton("Hold cart", context)
          ],
        )),
  );
}

Widget _buidButton(String label, BuildContext context) {
  return Container(
    width: 200,
    height: 80,
    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
    child: ElevatedButton(
      onPressed: () {
        // Respond to button press
      },
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: CustomColors.primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color(0xFFF0F4F4),
      ),
      child: Center(
        child: Text(label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600, color: CustomColors.primaryColor)
            // style: TextStyle(
            //     color: Color(0xFF066A69),
            //     fontSize: 14,
            //     fontWeight: FontWeight.normal),
            ),
      ),
    ),
  );
}

Widget _buildRemoveDialog() {
  return Container(
    child: Column(
      children: [
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Order Id:  ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: '#33444441',
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
                              text: 'Customer Number:  ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: '+91 8871722186',
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
                              text: 'Customer Name:  ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: 'Shankar Lonare',
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
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Are you sure you want to Delete the order?",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        padding:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.green),
                    child: Text(
                      "    Yes, Delete    ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        padding:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red),
                    child: Text(
                      "    No, Cancel    ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
