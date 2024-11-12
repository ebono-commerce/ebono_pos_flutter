import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kpn_pos_application/ui/common_text_field.dart';

class CustomQwertyPad extends StatelessWidget {
  final TextEditingController textController;
  final FocusNode focusNode = FocusNode();

  CustomQwertyPad({super.key, required this.textController});

  void _onKeyPressed(String value) {
    textController.text += value;
  }

  void _onBackspace() {
    if (textController.text.isNotEmpty) {
      textController.text =
          textController.text.substring(0, textController.text.length - 1);
    }
  }

  void _onEnter() {
    textController.clear();
  }

  void _onSpace() {
    textController.text += ' ';
  }

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {});
    return Column(
      children: [
       /* Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: 780, minWidth: 100),
            child:  commonTextField(
              label: ' Enter value ',
              focusNode: focusNode,
              readOnly: true,
              controller: textController,
            ),
          ),
        ),*/
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildKeyIcon('assets/images/qwerty_1.png', '1'),
                    _buildKeyIcon('assets/images/qwerty_2.png', '2'),
                    _buildKeyIcon('assets/images/qwerty_3.png', '3'),
                    _buildKeyIcon('assets/images/qwerty_4.png', '4'),
                    _buildKeyIcon('assets/images/qwerty_5.png', '5'),
                    _buildKeyIcon('assets/images/qwerty_6.png', '6'),
                    _buildKeyIcon('assets/images/qwerty_7.png', '7'),
                    _buildKeyIcon('assets/images/qwerty_8.png', '8'),
                    _buildKeyIcon('assets/images/qwerty_9.png', '9'),
                    _buildKeyIcon('assets/images/qwerty_0.png', '0'),
                  ],
                ),
                // First row of alphabet keys
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildKeyIcon('assets/images/qwerty_q.png', 'q'),
                    _buildKeyIcon('assets/images/qwerty_w.png', 'w'),
                    _buildKeyIcon('assets/images/qwerty_e.png', 'e'),
                    _buildKeyIcon('assets/images/qwerty_r.png', 'r'),
                    _buildKeyIcon('assets/images/qwerty_t.png', 't'),
                    _buildKeyIcon('assets/images/qwerty_y.png', 'y'),
                    _buildKeyIcon('assets/images/qwerty_u.png', 'u'),
                    _buildKeyIcon('assets/images/qwerty_i.png', 'i'),
                    _buildKeyIcon('assets/images/qwerty_o.png', 'o'),
                    _buildKeyIcon('assets/images/qwerty_p.png', 'p'),
                  ],
                ),
                // Second row of alphabet keys
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildKeyIcon('assets/images/qwerty_a.png', 'a'),
                    _buildKeyIcon('assets/images/qwerty_s.png', 's'),
                    _buildKeyIcon('assets/images/qwerty_d.png', 'd'),
                    _buildKeyIcon('assets/images/qwerty_f.png', 'f'),
                    _buildKeyIcon('assets/images/qwerty_g.png', 'g'),
                    _buildKeyIcon('assets/images/qwerty_h.png', 'h'),
                    _buildKeyIcon('assets/images/qwerty_j.png', 'j'),
                    _buildKeyIcon('assets/images/qwerty_k.png', 'k'),
                    _buildKeyIcon('assets/images/qwerty_l.png', 'l'),
                    _buildKeyBackspaceIcon('assets/images/qwerty_back.png'),
                    // Backspace key
                  ],
                ),
                // Third row of alphabet keys and enter key
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildKeyIcon('assets/images/qwerty_z.png', 'z'),
                    _buildKeyIcon('assets/images/qwerty_x.png', 'x'),
                    _buildKeyIcon('assets/images/qwerty_c.png', 'c'),
                    _buildKeyIcon('assets/images/qwerty_v.png', 'v'),
                    _buildKeySpaceIcon('assets/images/qwerty_space.png'),
                    _buildKeyIcon('assets/images/qwerty_b.png', 'b'),
                    _buildKeyIcon('assets/images/qwerty_n.png', 'n'),
                    _buildKeyIcon('assets/images/qwerty_m.png', 'm'),
                    // Space key
                    // Enter key
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildKeyDot('assets/images/qwerty_dot.png'),
                _buildKeyDot('assets/images/qwerty_comma.png'),
                _buildKeyEnterIcon('assets/images/qwerty_enter.png'),

              ],
            )
          ],
        ),
      ],
    );
  }

  // Function to build a key icon for letters
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
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }

  // Function to build a backspace key icon
  Widget _buildKeyBackspaceIcon(String img) {
    return InkWell(
      onTap: _onBackspace,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            width: 40,
            height: 30,
          ),
        ),
      ),
    );
  }

  // Function to build a space key icon
  Widget _buildKeySpaceIcon(String img) {
    return InkWell(
      onTap: _onSpace,
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
            width: 160,
            height: 20,
          ),
        ),
      ),
    );
  }

  // Function to build an enter key icon
  Widget _buildKeyEnterIcon(String img) {
    return InkWell(
      onTap: _onEnter,
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
            width: 20,
            height: 90,
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
