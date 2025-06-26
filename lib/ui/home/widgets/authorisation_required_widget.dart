import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/Common_button.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AuthorisationRequiredWidget extends StatefulWidget {
  final BuildContext dialogContext;
  final Function()? onClose;
  final Function()? onAuthSuccess;
  final String authFor;

  const AuthorisationRequiredWidget(this.dialogContext, this.authFor,
      {super.key, this.onClose, this.onAuthSuccess});

  @override
  State<AuthorisationRequiredWidget> createState() =>
      _AuthorisationRequiredWidgetState();
}

class _AuthorisationRequiredWidgetState
    extends State<AuthorisationRequiredWidget> {
  HomeController homeController = Get.find<HomeController>();
  final TextEditingController loginIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode loginIdFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  FocusNode? activeFocusNode;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    if (!loginIdFocusNode.hasFocus) {
      loginIdFocusNode.requestFocus();
    }
    activeFocusNode = loginIdFocusNode;

    loginIdFocusNode.addListener(() {
      setState(() {
        if (loginIdFocusNode.hasFocus) {
          activeFocusNode = loginIdFocusNode;
        }
        _qwertyPadController.text = loginIdController.text;
      });
    });

    passwordFocusNode.addListener(() {
      setState(() {
        if (passwordFocusNode.hasFocus) {
          activeFocusNode = passwordFocusNode;
        }
        _qwertyPadController.text = passwordController.text;
      });
    });

    _qwertyPadController.addListener(() {
      setState(() {
        //if (_qwertyPadController.text.isNotEmpty) {
        if (activeFocusNode == loginIdFocusNode) {
          loginIdController.text = _qwertyPadController.text;
        } else if (activeFocusNode == passwordFocusNode) {
          passwordController.text = _qwertyPadController.text;
        }
        //}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return PopScope(
      onPopInvokedWithResult: (val, result) {
        if (widget.onClose != null) {
          widget.onClose!();
        }
      },
      child: Column(
        children: [
          SizedBox(
            width: 900,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, top: 18),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(widget.dialogContext);
                    },
                    child: SvgPicture.asset(
                      'assets/images/ic_close.svg',
                      semanticsLabel: 'cash icon,',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Authorization required!",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: commonTextField(
                        label: "Login Id",
                        controller: loginIdController,
                        focusNode: loginIdFocusNode,
                        onValueChanged: (value) => value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: commonTextField(
                        label: "Password",
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        obscureText: true,
                        onValueChanged: (value) => value,
                        //readOnly: homeController.phoneNumber.isEmpty,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(flex: 1, child: authoriseButton()),
                    Expanded(flex: 1, child: cancelButton())
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 900,
            child: CustomQwertyPad(
              textController: _qwertyPadController,
              focusNode: activeFocusNode!,
              onEnterPressed: (value) {
                if (activeFocusNode == loginIdFocusNode) {
                  passwordFocusNode.requestFocus();
                } else if (activeFocusNode == passwordFocusNode) {
                  passwordFocusNode.unfocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget authoriseButton() {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        style: commonElevatedButtonStyle(
            theme: theme,
            textStyle: theme.textTheme.bodyMedium,
            padding: EdgeInsets.all(12)),
        onPressed: () async {
          // Navigator.pop(widget.dialogContext);
          // Get.snackbar("Not yet implemented", 'Not yet implemented');
          final isAuthorized = await homeController.getAuthorisation(
              loginIdController.text, passwordController.text, widget.authFor);
          if (isAuthorized) {
            Navigator.pop(widget.dialogContext);
            if (widget.onAuthSuccess != null) {
              widget.onAuthSuccess!();
            }
          }
        },
        child: Text(
          "Authorise",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget cancelButton() {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(widget.dialogContext);
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: CustomColors.keyBoardBgColor,
        ),
        child: Center(
          child: Text("Cancel",
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }
}
