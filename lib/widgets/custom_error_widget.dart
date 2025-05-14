import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomErrorWidget extends StatefulWidget {
  final FlutterErrorDetails details;

  const CustomErrorWidget({super.key, required this.details});

  @override
  State<CustomErrorWidget> createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget> {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 80, color: Colors.redAccent),
                    const SizedBox(height: 20),
                    const Text(
                      "Oops! Something went wrong.",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.details.exception.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildStackTrace(),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (widget.details.context != null &&
                            Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Go Back"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStackTrace() {
    final ScrollController scrollController = ScrollController();

    return Container(
      height: 400,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Text(
            widget.details.stack?.toString() ?? 'No stack trace available.',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
