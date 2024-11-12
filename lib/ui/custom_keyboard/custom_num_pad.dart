import 'package:flutter/material.dart';
import 'package:kpn_pos_application/ui/common_text_field.dart';

class CustomNumPad extends StatefulWidget {
  final TextEditingController textController;

  const CustomNumPad({super.key, required this.textController});

  @override
  State<CustomNumPad> createState() => _CustomNumPadState();
}

class _CustomNumPadState extends State<CustomNumPad> {
  final FocusNode focusNode = FocusNode();

  void _onKeyPressed(String value) {
    widget.textController.text += value;
  }

  void _onClear() {
    if (widget.textController.text.isNotEmpty) {
      widget.textController.text = widget.textController.text
          .substring(0, widget.textController.text.length - 1);
    }
  }

  void _onClearAll() {
    widget.textController.clear();
  }

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300, minWidth: 100),
              child: commonTextField(
                label: ' Enter Code, Quantity ',
                focusNode: focusNode,
                readOnly: false,
                controller: widget.textController,
              ),
            ),
          ),
          Column(
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
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
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
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
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
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
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
        _onClearAll();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 1),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
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
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
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
