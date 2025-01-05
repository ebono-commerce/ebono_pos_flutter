import 'package:flutter/material.dart';

class TableCellWidget extends StatelessWidget {
  final String text;
  final int maxLines;
  final double width;

  const TableCellWidget({
    super.key,
    this.text = '',
    this.maxLines = 1,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          maxLines == 1
              ? Container(
                  color: Colors.grey.shade300,
                  height: 30,
                  width: 1,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
