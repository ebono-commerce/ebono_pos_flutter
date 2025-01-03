import 'package:ebono_pos/widgets/order_details_widget.dart';
import 'package:flutter/material.dart';

class ReturnsView extends StatelessWidget {
  const ReturnsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    OrderDetailsWidget(
                      customerName: "",
                      walletBalance: "",
                      phoneNumber: "-",
                      loyaltyPoints: "-",
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.amber,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
