import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/ui/payment_summary/weight_controller.dart';

class WeightDisplayPage extends StatelessWidget {
  final String port = 'COM3'; // Replace with actual port
  final String model = 'alfa';
  final int rate = 9600;
  final int timeout = 1000;

  const WeightDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the WeightController
    final WeightController weightController =
        Get.put(WeightController(port, model, rate, timeout));

    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Display'),
      ),
      body: Center(
        child: Obx(() {
          return Text(
            'Weight: ${weightController.weight.value} kg',
            style: TextStyle(fontSize: 30),
          );
        }),
      ),
    );
  }
}
