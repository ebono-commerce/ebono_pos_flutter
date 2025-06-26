import 'package:dropdown_search/dropdown_search.dart';
import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/common_text_field.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/login/bloc/login_bloc.dart';
import 'package:ebono_pos/ui/login/bloc/login_event.dart';
import 'package:ebono_pos/ui/login/bloc/login_state.dart';
import 'package:ebono_pos/ui/login/repository/login_repository.dart';
import 'package:ebono_pos/ui/payment_summary/weighing_scale_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../cubit/test_mode_cubit.dart';
import '../common_widgets/version_widget.dart';

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
  final TextEditingController _qwertyPadController = TextEditingController();
  FocusNode? activeFocusNode;

  final _formKey = GlobalKey<FormState>();
  final _portSelectionFormKey = GlobalKey<FormState>();

  final loginBloc = LoginBloc(Get.find<LoginRepository>(),
      Get.find<SharedPreferenceHelper>(), Get.find<HiveStorageHelper>());

  final GlobalKey<DropdownSearchState> printerDropDownKey =
      GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> portDropDownKey =
      GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> outletDropDownKey =
      GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> terminalDropDownKey =
      GlobalKey<DropdownSearchState>();
  late ThemeData theme;

  @override
  void initState() {
    loginBloc.add(LoginInitialEvent());

    storeIdFocusNode.addListener(() {
      setState(() {});
    });
    terminalIdFocusNode.addListener(() {
      setState(() {});
    });

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
          if (_qwertyPadController.text.length <= 10) {
            loginIdController.text = _qwertyPadController.text
                .trim()
                .replaceAll(RegExp(r'[^0-9]'), '');
          } else {
            loginIdController.text = _qwertyPadController.text
                .trim()
                .substring(0, 10)
                .replaceAll(RegExp(r'[^0-9]'), '');
          }
        } else if (activeFocusNode == passwordFocusNode) {
          passwordController.text = _qwertyPadController.text;
        }
        //}
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Scaffold(
      body: BlocProvider(
        create: (context) => loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is PortSelectionSuccess) {
              try {
                print("Initializing WeighingScaleService...");
                if (!Get.isRegistered<WeighingScaleService>()) {
                  Get.put<WeighingScaleService>(
                      WeighingScaleService(Get.find<SharedPreferenceHelper>()));
                }

                print("WeighingScaleService initialized successfully!");
              } catch (e) {
                print("Error initializing WeighingScaleService: $e");
                Get.snackbar(
                    "Error", "Failed to initialize weighing scale service");
              }
            } else if (state is LoginSuccess) {
              loginBloc.add(
                GetOutletDetails(loginBloc.outletList.first, null),
              );
            } else if (state is LoginFailure) {
              Get.snackbar("Login Error ui", state.error);
            } else if (state is GetOutletDetailsSuccess) {
              Get.snackbar(
                  "Outlet Details", "Outlet details loaded successfully!");
            } else if (state is GetOutletDetailsFailure) {
              Get.snackbar("Error", state.error);
            } else if (state is SubmitTerminalDetailsSuccess) {
              Get.offAllNamed(PageRoutes.home);
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      state is PortSelectionSuccess ||
                              state is PrinterSelectionSuccess
                          ? SizedBox()
                          : SizedBox(),
                      Row(
                        children: [
                          Flexible(flex: 3, child: welcomeWidget(context)),
                          state is LoginSuccess ||
                                  state is GetOutletDetailsSuccess ||
                                  state is SubmitTerminalDetailsSuccess ||
                                  state is GetOutletDetailsLoading ||
                                  state is SubmitTerminalDetailsLoading ||
                                  state is SubmitTerminalDetailsFailure
                              ? Flexible(
                                  flex: 2,
                                  child: storeDetailsWidget(context, loginBloc))
                              : state is LoginInitial ||
                                      state is ReadPortSuccess
                                  ? Flexible(
                                      flex: 2,
                                      child: portSelectionWidget(
                                          context, loginBloc))
                                  : Flexible(
                                      flex: 2, child: loginWidget(context)),
                          Flexible(flex: 1, child: SizedBox())
                        ],
                      ),
                      state is PortSelectionSuccess ||
                              state is PrinterSelectionSuccess ||
                              state is LoginFailure
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: 900,
                                      child: Material(
                                        child: CustomQwertyPad(
                                          textController: _qwertyPadController,
                                          focusNode: activeFocusNode!,
                                          onEnterPressed: (value) {
                                            if (activeFocusNode ==
                                                loginIdFocusNode) {
                                              passwordFocusNode.requestFocus();
                                            } else if (activeFocusNode ==
                                                passwordFocusNode) {
                                              passwordFocusNode.unfocus();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20)
                                ],
                              ),
                            )
                          : SizedBox(),
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
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LogoWidget(),
            const SizedBox(height: 20),
            VersionWidget(fontSize: 16),
            const SizedBox(height: 30),
            const WelcomeBackText(),
            const SizedBox(height: 10),
            const EnterDetailsText()
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
        padding: EdgeInsets.all(25),
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
                acceptableLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter login id';
                  } else if (value.length < 10) {
                    return 'login id must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password input
              commonTextField(
                label: 'Enter Password',
                focusNode: passwordFocusNode,
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 4) {
                    return 'Password must be at least 4 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Sign in button
              SizedBox(
                width: double.infinity,
                height: 50,
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
                  child: const Text(
                    'Sign In',
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const UnableToLoginWidget(),

              const SizedBox(height: 10),
              // Unable to log in text
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          loginBloc.add(LoginInitialEvent());
                        },
                        child: const BackToPortSelection()),
                  ],
                ),
              ),

              SizedBox(height: 20),
              BlocBuilder<TestModeCubit, bool>(
                builder: (context, isTrainingModeEnabled) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<TestModeCubit>().toggle();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFA0E64),
                        textStyle:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                      child: Text(
                        '${isTrainingModeEnabled ? 'Exit' : 'Enter'} Test Mode',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
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
              key: outletDropDownKey,
              items: (filter, infiniteScrollProps) => outletDetails,
              decoratorProps: DropDownDecoratorProps(
                  decoration: textFieldDecoration(
                      isFocused:
                          outletDropDownKey.currentState?.isFocused == true,
                      label: 'Enter Store Id')),
              onChanged: (value) {
                if (value != null) {
                  Future.delayed(Duration(milliseconds: 400), () {
                    loginBloc.add(
                      GetOutletDetails(value, () {
                        if (loginBloc.terminalList.isNotEmpty) {
                          terminalDropDownKey.currentState?.changeSelectedItem(
                              loginBloc.terminalList.first);
                        }
                      }),
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
                bottomSheetProps: BottomSheetProps(
                  constraints: BoxConstraints(
                      maxWidth: 940,
                      minWidth: 900,
                      maxHeight: 1000,
                      minHeight: 600),
                ),
                containerBuilder: (context, popupWidget) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 920, // Set your desired width here
                    ),
                    child: Column(
                      children: [
                        // Add any custom widgets here
                        Expanded(child: popupWidget),
                        Divider(
                          color: CustomColors.borderColor,
                        ),
                        SizedBox(
                          child: CustomQwertyPad(
                            textController: storeIdController,
                            focusNode: storeIdFocusNode,
                            onEnterPressed: (value) {},
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Store Mode Selection
            allowedPosDetails.isNotEmpty && allowedPosDetails.length > 1
                ? Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    children: allowedPosDetails
                        .where((modeKey) =>
                            loginBloc.allowedPosData.containsKey(modeKey))
                        .map((modeKey) => storeModeWidget(
                              imagePath: loginBloc
                                  .allowedPosData[modeKey]!['imagePath']!,
                              label:
                                  loginBloc.allowedPosData[modeKey]!['label']!,
                              context: context,
                              mode: loginBloc.allowedPosData[modeKey]!['mode']!,
                            ))
                        .toList(),
                  )
                : SizedBox(),
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
                        Future.delayed(Duration(milliseconds: 400), () {
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
                      bottomSheetProps: BottomSheetProps(
                        constraints: BoxConstraints(
                            maxWidth: 940,
                            minWidth: 900,
                            maxHeight: 1000,
                            minHeight: 600),
                      ),
                      containerBuilder: (context, popupWidget) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 920, // Set your desired width here
                          ),
                          child: Column(
                            children: [
                              // Add any custom widgets here
                              Expanded(child: popupWidget),
                              Divider(
                                color: CustomColors.borderColor,
                              ),
                              SizedBox(
                                child: CustomQwertyPad(
                                  textController: terminalIdController,
                                  focusNode: terminalIdFocusNode,
                                  onEnterPressed: (value) {},
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      },
                    ))
                : SizedBox(),
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
                  Future.delayed(Duration(milliseconds: 400), () {
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
          ],
        ),
      ),
    );
  }

  Widget portSelectionWidget(BuildContext context, LoginBloc loginBloc) {
    var availablePorts = loginBloc.availablePorts;
    var availablePrinters = loginBloc.availablePrinters;
    String? selectedPort;
    String? selectedPrinter;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(40),
        child: Form(
          key: _portSelectionFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              availablePrinters.isNotEmpty
                  ? DropdownSearch<String>(
                      key: printerDropDownKey,
                      items: (filter, infiniteScrollProps) => availablePrinters,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: textFieldDecoration(
                          isFocused:
                              printerDropDownKey.currentState?.isFocused ==
                                  true,
                          label: 'Select the thermal printer',
                        ),
                      ),
                      onChanged: (value) async {
                        if (value != null) {
                          selectedPrinter = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please select thermal printer";
                        }
                        return null;
                      },
                      suffixProps: DropdownSuffixProps(
                          dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_up),
                        iconClosed: Icon(Icons.keyboard_arrow_down),
                      )),
                      selectedItem: selectedPrinter,
                      popupProps: PopupProps.menu(
                        showSearchBox: false,
                        fit: FlexFit.loose,
                        showSelectedItems: true,
                      ),
                      //dropdownBuilder: (ctx, selectedItem) => Text(selectedItem!.name),
                    )
                  : Text(
                      'No printer found',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.black45),
                    ),
              SizedBox(height: 20),
              availablePorts.isNotEmpty
                  ? DropdownSearch<String>(
                      key: portDropDownKey,
                      items: (filter, infiniteScrollProps) => availablePorts,
                      decoratorProps: DropDownDecoratorProps(
                          decoration: textFieldDecoration(
                              isFocused:
                                  portDropDownKey.currentState?.isFocused ==
                                      true,
                              label: 'Select weighing scale port')),
                      onChanged: (value) async {
                        if (value != null) {
                          selectedPort = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please select weighing scale port";
                        }
                        return null;
                      },
                      suffixProps: DropdownSuffixProps(
                          dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_up),
                        iconClosed: Icon(Icons.keyboard_arrow_down),
                      )),
                      selectedItem: selectedPort,
                      popupProps: PopupProps.menu(
                        showSearchBox: false,
                        fit: FlexFit.loose,
                        showSelectedItems: true,
                      ),
                      //dropdownBuilder: (ctx, selectedItem) => Text(selectedItem!.name),
                    )
                  : Text(
                      'No port found',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.black45),
                    ),

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                  onPressed: () {
                    if (_portSelectionFormKey.currentState?.validate() ==
                        true) {
                      Future.delayed(Duration(milliseconds: 400), () {
                        if (availablePorts.isNotEmpty) {
                          loginBloc.add(
                            SelectPort(selectedPort!),
                          );
                        } else {
                          loginBloc.add(
                            SelectPort(''),
                          );
                        }
                        if (availablePrinters.isNotEmpty) {
                          loginBloc.add(
                            SelectPrinter(selectedPrinter!),
                          );
                        } else {
                          loginBloc.add(
                            SelectPrinter(''),
                          );
                        }
                      });
                    }
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
              maxWidth: 100, minWidth: 100, maxHeight: 120, minHeight: 120),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? CustomColors.accentColor : Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: isSelected ? Colors.black : Colors.black45,
                  width: isSelected ? 2 : 1),
            ),
            padding: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 50,
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
                  style: theme.textTheme.labelMedium?.copyWith(
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

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/pos_logo.svg',
      semanticsLabel: 'logo,',
      width: 175,
      height: 175,
    );
  }
}

class WelcomeBackText extends StatelessWidget {
  const WelcomeBackText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome Back',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class EnterDetailsText extends StatelessWidget {
  const EnterDetailsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Please enter your details to sign in',
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(color: Colors.black45),
    );
  }
}

class UnableToLoginWidget extends StatelessWidget {
  const UnableToLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Unable to log in?',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black45),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Contact operations',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class BackToPortSelection extends StatelessWidget {
  const BackToPortSelection({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      'Back to Port selection',
      style: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: CustomColors.grey),
    );
  }
}
