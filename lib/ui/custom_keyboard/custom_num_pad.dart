import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomNumPad extends StatefulWidget {
  final TextEditingController textController;
  final FocusNode focusNode;
  final void Function(String)? onEnterPressed;
  final void Function(String)? onValueChanged;
  final void Function(String)? onClearAll;
  const CustomNumPad(
      {super.key,
      required this.textController,
      this.onEnterPressed,
      this.onValueChanged,
      this.onClearAll,
      required this.focusNode});

  @override
  State<CustomNumPad> createState() => _CustomNumPadState();
}

class _CustomNumPadState extends State<CustomNumPad> {
  void _onKeyPressed(String value) {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    widget.textController.text += value;
  }

  void _onEnterPressed(String value) {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    widget.onEnterPressed!(value);
  }

  void _onClear() {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    if (widget.textController.text.isNotEmpty) {
      widget.textController.text = widget.textController.text
          .substring(0, widget.textController.text.length - 1);
    }
  }

  void _onClearAll() {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    widget.textController.clear();
    widget.onClearAll?.call(widget.textController.text);
  }

  void _handleValueChanged() {
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(widget.textController.text);
    }
  }

  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    widget.textController.addListener(_handleValueChanged);

    super.initState();
  }

  /*@override
  void dispose() {
    focusNode.dispose();
    //widget.textController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildKeyIcon('assets/images/number_7.png', "7"),
              _buildKeyIcon('assets/images/number_8.png', "8"),
              _buildKeyIcon('assets/images/number_9.png', "9"),
              _buildKeyClear('assets/images/number_back.png')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildKeyIcon('assets/images/number_4.png', "4"),
              _buildKeyIcon('assets/images/number_5.png', "5"),
              _buildKeyIcon('assets/images/number_6.png', "6"),
              _buildKeyClearAll('assets/images/number_clear.png')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                Row(
                  children: [
                    _buildKeyIcon('assets/images/number_1.png', "1"),
                    _buildKeyIcon('assets/images/number_2.png', "2"),
                    _buildKeyIcon('assets/images/number_3.png', "3"),
                  ],
                ),
                Row(
                  children: [
                    _buildKeyDot('assets/images/number_dot.png'),
                    _buildKeyIcon('assets/images/number_0.png', "0"),
                    _buildKeyIcon('assets/images/number_00.png', "00"),
                  ],
                ),
              ]),
              _buildKeyEnterIcon('assets/images/number_enter.png')
            ],
          ),
        ],
      ),
    );
  }

  // Function to build a key icon
  Widget _buildKeyIcon(String img, String label) {
    return InkWell(
      onTap: () {
        _onKeyPressed(label);
      },
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: CustomColors.keyBoardBgColor,
          border: Border.all(color: CustomColors.keyBoardBgColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyClear(String img) {
    return InkWell(
      onTap: () {
        _onClear();
      },
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: CustomColors.keyBoardBgColor,
          border: Border.all(color: CustomColors.keyBoardBgColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyClearAll(String img) {
    return InkWell(
      onTap: () {
        _onClearAll();
      },
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: CustomColors.keyBoardBgColor,
          border: Border.all(color: CustomColors.keyBoardBgColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyEnterIcon(String img) {
    return InkWell(
      onTap: () {
        _onEnterPressed(widget.textController.text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 1),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: CustomColors.keyBoardBgColor,
          border: Border.all(color: CustomColors.keyBoardBgColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
            // margin: const EdgeInsets.all(15.0),
            child: Image.asset(
              img,
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyDot(String img) {
    return InkWell(
      onTap: () {
        _onKeyPressed(".");
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: CustomColors.keyBoardBgColor,
          border: Border.all(color: CustomColors.keyBoardBgColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Image.asset(
              img,
              height: 10,
              width: 10,
            ),
          ),
        ),
      ),
    );
  }
}
