import 'package:flutter/material.dart';

class CustomQwertyPad extends StatefulWidget {
  final TextEditingController textController;
  final FocusNode focusNode;
  final void Function(String)? onEnterPressed;
  final void Function(String)? onValueChanged;
  final void Function(String)? onClearAll;

  const CustomQwertyPad(
      {super.key,
      required this.textController,
      required this.focusNode,
      this.onEnterPressed,
      this.onValueChanged,
      this.onClearAll});

  @override
  State<CustomQwertyPad> createState() => _CustomQwertyPadState();
}

class _CustomQwertyPadState extends State<CustomQwertyPad> {
  void _onKeyPressed(String value) {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    widget.textController.text += value;
  }

  void _onBackspace() {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    if (widget.textController.text.isNotEmpty) {
      widget.textController.text = widget.textController.text
          .substring(0, widget.textController.text.length - 1);
    }
  }

  void _onEnterPressed(String value) {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    widget.onEnterPressed!(value);
  }

  void _onSpace() {
    if (!widget.focusNode.hasFocus) {
      widget.focusNode.requestFocus();
    }
    widget.textController.text += ' ';
  }

  void _handleValueChanged() {
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(widget.textController.text);
    }
  }

  @override
  void initState() {
    widget.focusNode.addListener(() {
      setState(() {});
    });
    widget.textController.addListener(_handleValueChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                _buildKeyIcon('assets/images/qwerty_dot.png', '.'),
                _buildKeyIcon('assets/images/qwerty_comma.png', ','),
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
          // border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            width: 25,
            height: 25, // old 20 x20
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
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F4),
          border: Border.all(color: Color(0xFFF0F4F4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Image.asset(
            img,
            width: 30,
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
            width: 165,
            height: 20,
          ),
        ),
      ),
    );
  }

  // Function to build an enter key icon
  Widget _buildKeyEnterIcon(String img) {
    return InkWell(
      onTap: () {
        _onEnterPressed(widget.textController.text);
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
            height: 100, // old 90
          ),
        ),
      ),
    );
  }

  Widget _buildKeyDot(String img, String label) {
    return InkWell(
      onTap: () {
        _onKeyPressed(label);
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
