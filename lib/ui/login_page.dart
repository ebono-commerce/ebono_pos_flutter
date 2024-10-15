import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:kpn_pos_application/blocs/login_bloc.dart';
import 'package:kpn_pos_application/custom_colors.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';

import 'common_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode storeIdFocusNode = FocusNode();
  FocusNode terminalIdFocusNode = FocusNode();
  FocusNode loginIdFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  List<String> selectedStoreModes = [];
  final List<String> _items = [
    'ST001',
    'ST002',
    'ST003',
    'ST004',
    'ST005',
    'ST006',
    'ST007'
  ];

  final GlobalKey<DropdownSearchState> dropDownKey =
      GlobalKey<DropdownSearchState>();
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    storeIdFocusNode.addListener(() {
      setState(() {});
    });
    terminalIdFocusNode.addListener(() {
      setState(() {});
    });
    loginIdFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(), // Ensure that LoginBloc is created here
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigate to home page on success
              Get.offAndToNamed('/home');
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                color: CustomColors.backgroundColor,
                child: Row(
                  children: [welcomeWidget(context), loginWidget(context)],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget welcomeWidget(BuildContext context) {
    return Container(
      width: 650,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/pos_logo.svg',
              semanticsLabel: 'cash icon,',
              width: 175,
              height: 175,
            ),
            SizedBox(height: 40),
            Text(
              'Welcome Back',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please enter your details to sign in',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginWidget(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Container(
        width: 600,
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownSearch<String>(
              key: dropDownKey,
              items: (filter, infiniteScrollProps) => _items,
              decoratorProps: DropDownDecoratorProps(
                  decoration: textFieldDecoration(
                      isFocused: dropDownKey.currentState?.isFocused == true,
                      label: 'Enter Store Id')),
              onChanged: (value) {
                // Handle value
                // change
              },
              selectedItem: _items.first,
              popupProps: PopupProps.bottomSheet(
                showSearchBox: true,
                fit: FlexFit.loose,
                showSelectedItems: true,
                searchFieldProps: TextFieldProps(
                  focusNode: storeIdFocusNode,
                  decoration: textFieldDecoration(
                      isFocused: storeIdFocusNode.hasFocus,
                      filled: true,
                      label: '"Search Store Id',
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Store Mode Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                storeModeWidget(
                    imagePath: 'assets/images/vegetables.png',
                    label: 'Fruits & Vegetables',
                    context: context,
                    mode: '1'),
                // General
                storeModeWidget(
                    imagePath: 'assets/images/vegetables.png',
                    label: 'General',
                    context: context,
                    mode: '2'),
                // Non-veg
                storeModeWidget(
                    imagePath: 'assets/images/vegetables.png',
                    label: 'Non-veg',
                    context: context,
                    mode: '3'),
                // Juices
                storeModeWidget(
                    imagePath: 'assets/images/vegetables.png',
                    label: 'Juices',
                    context: context,
                    mode: '4'),
              ],
            ),
            SizedBox(height: 20),
            // Terminal Id input
            commonTextField(
                label: 'Enter Terminal Id', focusNode: terminalIdFocusNode),
            SizedBox(height: 20),

            // Login Id input
            commonTextField(label: 'Login Id', focusNode: loginIdFocusNode),
            SizedBox(height: 20),

            // Password input
            commonTextField(
                label: 'Enter Password',
                focusNode: passwordFocusNode,
                obscureText: true),

            SizedBox(height: 30),

            // Sign in button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
                onPressed: () {
                  Get.toNamed(PageRoutes.home);
                },
                child: Text(
                  'Sign In',
                ),
              ),
            ),
            SizedBox(height: 10),

            // Unable to log in text
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Unable to log in?',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.black45),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Contact operations',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget storeModeWidget(
      {required String imagePath,
      required String label,
      required String mode,
      required BuildContext context}) {
    bool isSelected = selectedStoreModes.contains(mode);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedStoreModes.remove(mode);
          } else {
            selectedStoreModes.add(mode);
          }
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Container(
          width: 110,
          height: 160,
          decoration: BoxDecoration(
            color: isSelected ? CustomColors.accentColor : Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color: isSelected ? Colors.black : Colors.black45,
                width: isSelected ? 2 : 1),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image/Icon
              Image.asset(
                imagePath,
                height: 60, // Adjust image size as needed
              ),
              SizedBox(height: 10),
              // Label
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.black : Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
