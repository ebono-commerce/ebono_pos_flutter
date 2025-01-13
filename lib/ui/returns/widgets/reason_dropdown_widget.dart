import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class ReturnReasonDropdownWidget extends StatefulWidget {
  final List<String> returnReasons;
  final Function(String) onReasonSelected;

  const ReturnReasonDropdownWidget({
    super.key,
    required this.returnReasons,
    required this.onReasonSelected,
  });

  @override
  State<ReturnReasonDropdownWidget> createState() =>
      _ReturnReasonDropdownWidgetState();
}

class _ReturnReasonDropdownWidgetState
    extends State<ReturnReasonDropdownWidget> {
  String? selectedReason;
  bool isDropdownOpened = false;
  final _formKey = GlobalKey<FormState>();

  final List<String> returnReasons = [
    'Wrong item',
    'Damaged product',
    'Expired product',
    'Price mismatch',
    'Changed my mind',
  ];

  List<DropdownMenuItem<String>> _addDividersAfterItems() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in returnReasons) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            enabled: false,
            child: Divider(color: CustomColors.greyFont),
          ),
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: TextStyle(fontSize: 16, color: CustomColors.greyFont),
              ),
            ),
          ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights() {
    final List<double> itemsHeights = [];
    final menuItems = _addDividersAfterItems();

    for (var i = 0; i < menuItems.length; i++) {
      if (menuItems[i].enabled == false) {
        itemsHeights.add(4); // height for divider
      } else {
        itemsHeights.add(40); // height for menu item
      }
    }
    return itemsHeights;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        hint: Text("Select a Reason"),
        decoration: InputDecoration(
          label: isDropdownOpened || selectedReason != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Select For Return"),
                )
              : null,
          hintMaxLines: 1,
         // maintainHintHeight: true,
          hintStyle: TextStyle(color: CustomColors.greyFont, fontSize: 16),
          labelStyle: TextStyle(color: CustomColors.greyFont),
          floatingLabelStyle: TextStyle(color: CustomColors.greyFont),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: CustomColors.grey, width: 1),
            gapPadding: 0,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            gapPadding: 0,
            borderSide: BorderSide(color: CustomColors.grey, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: CustomColors.grey, width: 1),
            gapPadding: 0,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        selectedItemBuilder: (context) {
          return _addDividersAfterItems()
              .map((item) => item.enabled
                  ? Text(
                      item.value.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.black,
                      ),
                    )
                  : Text(""))
              .toList();
        },
        items: _addDividersAfterItems(),
        validator: (value) {
          if (value == null) {
            return 'Please select a return reason';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            selectedReason = value;
          });
          if (value != null) {
            widget.onReasonSelected(value);
          }
        },
        onMenuStateChange: (isOpen) {
          setState(() {
            isDropdownOpened = isOpen;
          });
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 4),
          height: 60,
        ),
        iconStyleData: IconStyleData(
          icon: Center(
            child: Icon(
              Icons.keyboard_arrow_down,
              color: CustomColors.greyFont,
            ),
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: Colors.white,
            border: Border(
              top: BorderSide.none,
              left: BorderSide(width: 1, color: CustomColors.grey),
              right: BorderSide(width: 1, color: CustomColors.grey),
              bottom: BorderSide(width: 1, color: CustomColors.grey),
            ),
          ),
          elevation: 0,
          offset: const Offset(0, 10),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          customHeights: _getCustomItemsHeights(),
        ),
      ),
    );
  }
}
