import 'package:flutter/material.dart';

class KeypadScreen extends StatefulWidget {
  const KeypadScreen({super.key});

  @override
  _KeypadScreenState createState() => _KeypadScreenState();
}

class _KeypadScreenState extends State<KeypadScreen> {
  String input = '';

  void _onKeyPressed(String value) {
    setState(() {
      input += value;
    });
  }

  void _onClear() {
    setState(() {
      input = input.substring(0, input.length - 1);
    });
  }

  void _onClearAll() {
    setState(() {
      input = '';
    });
  }

  void _onBackspace() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  void _onEnter() {
    print('Entered number: $input');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  // borderRadius: BorderRadius.circular(
                  //     10),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                controller: TextEditingController(text: input),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors
                                          .grey.shade300, // Normal border color
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300, // Focused border color
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red, // Error border color
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors
                                          .red, // Focused error border color
                                      width: 1,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  label: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: ' Enter Code, Quantity ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // TextField(
                              //   decoration: InputDecoration(
                              //     labelText: 'Enter Code, Quantity',
                              //   ),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: input),
                              // ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildKeyIcon(
                                    'assets/images/number_7.png', "7"),
                                _buildKeyIcon(
                                    'assets/images/number_8.png', "8"),
                                _buildKeyIcon(
                                    'assets/images/number_9.png', "9"),
                                _buildKeyClear(
                                    'assets/images/number_back.png', "C")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildKeyIcon(
                                    'assets/images/number_4.png', "4"),
                                _buildKeyIcon(
                                    'assets/images/number_5.png', "5"),
                                _buildKeyIcon(
                                    'assets/images/number_6.png', "6"),
                                _buildKeyClearAll(
                                    'assets/images/number_clear.png', "CA")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(children: [
                                  Row(
                                    children: [
                                      _buildKeyIcon(
                                          'assets/images/number_1.png', "1"),
                                      _buildKeyIcon(
                                          'assets/images/number_2.png', "2"),
                                      _buildKeyIcon(
                                          'assets/images/number_3.png', "3"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _buildKeyDot(
                                          'assets/images/number_dot.png', "."),
                                      _buildKeyIcon(
                                          'assets/images/number_0.png', "0"),
                                      _buildKeyIcon(
                                          'assets/images/number_00.png', "00"),
                                    ],
                                  ),
                                ]),
                                _buildKeyEnterIcon(
                                    'assets/images/number_enter.png', "")
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyIcon(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
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

  Widget _buildKeyClear(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onClear(),
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

  Widget _buildKeyClearAll(String img, String label,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onClearAll(),
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

  Widget _buildKeyDot(String img, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
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

  Widget _buildKeyEnterIcon(String img, String label,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(label),
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
}
