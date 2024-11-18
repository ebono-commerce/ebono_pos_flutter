import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';
import 'package:kpn_pos_application/ui/common_text_field.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_bloc.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_event.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_state.dart';
import 'package:kpn_pos_application/ui/login/repository/login_repository.dart';
import 'package:libserialport/libserialport.dart';

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
  TextEditingController storeIdController = TextEditingController();
  TextEditingController terminalIdController = TextEditingController();
  TextEditingController loginIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final loginBloc = LoginBloc(
      Get.find<LoginRepository>(), Get.find<SharedPreferenceHelper>());

  final GlobalKey<DropdownSearchState> dropDownKey =
      GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> terminalDropDownKey =
      GlobalKey<DropdownSearchState>();
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    loginBloc.add(LoginInitialEvent());

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
        create: (context) => loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              loginBloc.add(
                GetOutletDetails(loginBloc.outletList.first),
              );
            } else if (state is LoginFailure) {
              Get.snackbar("Login Error ui", state.error);
            } else if (state is GetOutletDetailsSuccess) {
              Get.snackbar(
                  "Outlet Details", "Outlet details loaded successfully!");
            } else if (state is GetOutletDetailsFailure) {
              Get.snackbar("Error", state.error);
            } else if (state is SubmitTerminalDetailsSuccess) {
              Get.toNamed(PageRoutes.home);
            } else if (state is SubmitTerminalDetailsFailure) {
              Get.snackbar("Error", state.error);
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              print("Current State: $state");
              return Stack(children: [
                Container(
                  color: CustomColors.backgroundColor,
                  child: Row(
                    children: [
                      Flexible(flex: 3, child: welcomeWidget(context)),
                      state is LoginSuccess ||
                              state is GetOutletDetailsSuccess ||
                              state is SubmitTerminalDetailsSuccess
                          ? Flexible(
                              flex: 2,
                              child: storeDetailsWidget(context, loginBloc))
                          : state is LoginInitial || state is ReadPortSuccess ? Flexible(flex: 2, child: portSelectionWidget(context, loginBloc)):  Flexible(flex: 2, child: loginWidget(context)),
                      Flexible(flex: 1, child: SizedBox())
                    ],
                  ),
                ),
                state is LoginLoading ||
                        state is GetOutletDetailsLoading ||
                        state is SubmitTerminalDetailsLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(),
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget welcomeWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/pos_logo.svg',
              semanticsLabel: 'logo,',
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
        padding: EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Login Id input
              commonTextField(
                label: 'Login Id',
                focusNode: loginIdFocusNode,
                controller: loginIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter login id';
                  } else if (value.length < 4) {
                    return 'login id must be at least 4 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password input
              commonTextField(
                label: 'Enter Password',
                focusNode: passwordFocusNode,
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginBloc.add(
                        LoginButtonPressed(
                          loginIdController.text,
                          passwordController.text,
                        ),
                      );
                    } else {
                      Get.snackbar(
                          "Invalid Data", "Please enter all mandatory fields");
                    }
                  },
                  child: Text(
                    'Sign In',
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Unable to log in text
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
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
      ),
    );
  }

  Widget storeDetailsWidget(BuildContext context, LoginBloc loginBloc) {
    var outletDetails = loginBloc.outletList;
    var terminalDetails = loginBloc.terminalList;
    var allowedPosDetails = loginBloc.allowedPos;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownSearch<String>(
              key: dropDownKey,
              items: (filter, infiniteScrollProps) => outletDetails,
              decoratorProps: DropDownDecoratorProps(
                  decoration: textFieldDecoration(
                      isFocused: dropDownKey.currentState?.isFocused == true,
                      label: 'Enter Store Id')),
              onChanged: (value) {
                if (value != null) {
                  Future.delayed(Duration(milliseconds: 200), () {
                    loginBloc.add(
                      GetOutletDetails(value),
                    );
                  });
                }
              },
              suffixProps: DropdownSuffixProps(
                  dropdownButtonProps: DropdownButtonProps(
                iconOpened: Icon(Icons.keyboard_arrow_up),
                iconClosed: Icon(Icons.keyboard_arrow_down),
              )),
              selectedItem: outletDetails.first,
              popupProps: PopupProps.bottomSheet(
                showSearchBox: true,
                fit: FlexFit.loose,
                showSelectedItems: true,
                searchFieldProps: TextFieldProps(
                  controller: storeIdController,
                  focusNode: storeIdFocusNode,
                  decoration: textFieldDecoration(
                      isFocused: storeIdFocusNode.hasFocus,
                      filled: true,
                      label: '"Search Store Id',
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
              //dropdownBuilder: (ctx, selectedItem) => Text(selectedItem!.name),
            ),

            SizedBox(height: 20),

            // Store Mode Selection
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              children: allowedPosDetails
                  .where((modeKey) =>
                      loginBloc.allowedPosData.containsKey(modeKey))
                  .map((modeKey) => storeModeWidget(
                        imagePath:
                            loginBloc.allowedPosData[modeKey]!['imagePath']!,
                        label: loginBloc.allowedPosData[modeKey]!['label']!,
                        context: context,
                        mode: loginBloc.allowedPosData[modeKey]!['mode']!,
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            terminalDetails.isNotEmpty
                ? DropdownSearch<String>(
                    key: terminalDropDownKey,
                    items: (filter, infiniteScrollProps) => terminalDetails,
                    decoratorProps: DropDownDecoratorProps(
                        decoration: textFieldDecoration(
                            isFocused:
                                terminalDropDownKey.currentState?.isFocused ==
                                    true,
                            label: 'Enter Terminal Id')),
                    onChanged: (value) {
                      if (value != null) {
                        Future.delayed(Duration(milliseconds: 200), () {
                          loginBloc.add(
                            SelectTerminal(value),
                          );
                        });
                      }
                    },
                    suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                      iconOpened: Icon(Icons.keyboard_arrow_up),
                      iconClosed: Icon(Icons.keyboard_arrow_down),
                    )),
                    selectedItem: terminalDetails.first,
                    popupProps: PopupProps.bottomSheet(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                      showSelectedItems: true,
                      searchFieldProps: TextFieldProps(
                        controller: terminalIdController,
                        focusNode: terminalIdFocusNode,
                        decoration: textFieldDecoration(
                            isFocused: terminalIdFocusNode.hasFocus,
                            filled: true,
                            label: '"Search Terminal Id',
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                    //dropdownBuilder: (ctx, selectedItem) => Text(selectedItem!.name),
                  )
                : SizedBox(),
            SizedBox(height: 20),

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
                  Future.delayed(Duration(milliseconds: 200), () {
                    loginBloc.add(
                      SubmitTerminalDetails(),
                    );
                  });
                },
                child: Text(
                  'Continue',
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget portSelectionWidget(BuildContext context, LoginBloc loginBloc) {
    var availablePorts = loginBloc.availablePorts;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            availablePorts.isNotEmpty
                ? DropdownSearch<String>(
                    key: dropDownKey,
                    items: (filter, infiniteScrollProps) => availablePorts,
                    decoratorProps: DropDownDecoratorProps(
                        decoration: textFieldDecoration(
                            isFocused:
                                dropDownKey.currentState?.isFocused == true,
                            label: 'Select port Id')),
                    onChanged: (value) {
                      if (value != null) {
                        Future.delayed(Duration(milliseconds: 200), () {
                          loginBloc.add(
                            SelectPort(value),
                          );
                        });
                      }
                    },
                    suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                      iconOpened: Icon(Icons.keyboard_arrow_up),
                      iconClosed: Icon(Icons.keyboard_arrow_down),
                    )),
                    selectedItem: availablePorts.first,
                    popupProps: PopupProps.bottomSheet(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                      showSelectedItems: true,
                      searchFieldProps: TextFieldProps(
                        controller: storeIdController,
                        focusNode: storeIdFocusNode,
                        decoration: textFieldDecoration(
                            isFocused: storeIdFocusNode.hasFocus,
                            filled: true,
                            label: 'Select Port Id',
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                    //dropdownBuilder: (ctx, selectedItem) => Text(selectedItem!.name),
                  )
                : SizedBox(),

            SizedBox(height: 20),
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
                  Future.delayed(Duration(milliseconds: 200), () {
                    loginBloc.add(
                      SubmitTerminalDetails(),
                    );
                  });
                },
                child: Text(
                  'Continue',
                ),
              ),
            ),
            SizedBox(height: 10),
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
    bool isSelected = loginBloc.selectedPosMode == mode;
    return GestureDetector(
      onTap: () {
        loginBloc.add(
          SelectPosMode(mode),
        );
        setState(() {
          isSelected = loginBloc.selectedPosMode == mode;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: 110, minWidth: 110, maxHeight: 160, minHeight: 160),
          child: Container(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 60,
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
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
      ),
    );
  }
}
