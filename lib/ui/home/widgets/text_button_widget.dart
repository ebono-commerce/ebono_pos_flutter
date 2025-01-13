import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final int selectedTabButton;
  final int buttonIndex;
  final String title;
  final VoidCallback onPressed;

  const TextButtonWidget({
    super.key,
    required this.selectedTabButton,
    required this.buttonIndex,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.only(left: 10, right: 5),
        backgroundColor: selectedTabButton == buttonIndex
            ? Colors.white
            : Colors.grey.shade100,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(),
          ),
          selectedTabButton == buttonIndex
              ? Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 8,
                  height: 8,
                )
              : Container()
        ],
      ),
    );
  }
}
