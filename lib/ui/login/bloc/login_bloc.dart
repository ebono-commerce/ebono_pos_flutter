import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/login/bloc/login_event.dart';
import 'package:ebono_pos/ui/login/bloc/login_state.dart';
import 'package:ebono_pos/ui/login/model/get_terminal_details_request.dart';
import 'package:ebono_pos/ui/login/model/login_request.dart';
import 'package:ebono_pos/ui/login/model/login_response.dart';
import 'package:ebono_pos/ui/login/model/logout_request.dart';
import 'package:ebono_pos/ui/login/model/logout_response.dart';
import 'package:ebono_pos/ui/login/model/outlet_details_response.dart';
import 'package:ebono_pos/ui/login/model/terminal_details_response.dart';
import 'package:ebono_pos/ui/login/repository/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:libserialport/libserialport.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/logger.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  final HiveStorageHelper hiveStorageHelper;
  List<OutletDetail> outletDetails = [];
  List<String> outletList = [];
  List<Terminal> terminalDetails = [];
  List<String> terminalList = [];
  late String selectedTerminalId;
  late String selectedOutletId;
  String selectedPosMode = 'POS';
  List<String> allowedPos = [];
  List<String> availablePorts = [];
  List<Printer> availablePrintersDetails = [];
  List<String> availablePrinters = [];

  Map<String, Map<String, String>> allowedPosData = {
    'POS': {
      'imagePath': 'assets/images/vegetables.png',
      'label': 'Fruits & Vegetables',
      'mode': 'POS',
    },
    'GPOS': {
      'imagePath': 'assets/images/vegetables.png',
      'label': 'General',
      'mode': 'GPOS',
    },
    'NVPOS': {
      'imagePath': 'assets/images/vegetables.png',
      'label': 'Non-veg',
      'mode': 'NVPOS',
    },
    'JPOS': {
      'imagePath': 'assets/images/vegetables.png',
      'label': 'Juices',
      'mode': 'JPOS',
    },
  };

  LoginBloc(this._loginRepository, this._sharedPreferenceHelper,
      this.hiveStorageHelper)
      : super(LoginInitial()) {
    on<LoginInitialEvent>(_onLoginInitial);
    on<SelectPort>(_onPortSelection);
    on<SelectPrinter>(_onPrinterSelection);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
    on<GetOutletDetails>(_getOutletDetails);
    on<SelectTerminal>(_selectTerminal);
    on<SubmitTerminalDetails>(_submitTerminalDetails);
    on<SelectPosMode>(_selectPosMode);
  }

  Future<void> _onLoginInitial(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    availablePorts = SerialPort.availablePorts;
    //Printer? selectedPrinter = await Printing.pickPrinter(context: context);
    availablePrintersDetails = await Printing.listPrinters();
    for (var i in availablePrintersDetails) {
      availablePrinters.add(i.name);
    }
    print('Available ports:');
    _sharedPreferenceHelper.storePortName(availablePorts.first);

    emit(ReadPortSuccess());
  }

  Future<void> _onPortSelection(
      SelectPort event, Emitter<LoginState> emit) async {
    _sharedPreferenceHelper.storePortName(event.port);

    emit(PortSelectionSuccess());
  }

  Future<void> _onPrinterSelection(
      SelectPrinter event, Emitter<LoginState> emit) async {
    for (var i in availablePrintersDetails) {
      if (event.printer == i.name) {
        hiveStorageHelper.save(
            SharedPreferenceConstants.selectedPrinter, i.toMap());
      }
    }

    emit(PrinterSelectionSuccess());
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      /* check for health status api */
      final status = await healthCheckAPI();

      await _sharedPreferenceHelper.pointTo(isCloud: status == false);

      String? appUUID = await _sharedPreferenceHelper.getAppUUID();
      if (appUUID == null) {
        var uuid = Uuid();
        var appUUID = uuid.v1();
        _sharedPreferenceHelper.storeAppUUID(appUUID);
      }

      final LoginResponse response = await _loginRepository.login(
          LoginRequest(userName: event.loginId, password: event.password));

      _sharedPreferenceHelper.storeAuthToken(response.token);
      _sharedPreferenceHelper.storeUserID(response.userDetails.userId);
      hiveStorageHelper.save(
          SharedPreferenceConstants.userDetails, response.userDetails.toJson());

      outletDetails = response.outletDetails;
      for (var i in outletDetails) {
        outletList.add(i.name);
      }
      selectedOutletId = response.outletDetails.first.outletId;
      hiveStorageHelper.save(SharedPreferenceConstants.selectedOutletId,
          response.outletDetails.first.outletId);
      hiveStorageHelper.save(SharedPreferenceConstants.selectedOutletName,
          response.outletDetails.first.name);
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }

  Future<bool> healthCheckAPI() async {
    /* Health Check API, if other than 200, clear all exsisting data and navigate to login screen */
    // Initialize API service
    final apiService = Get.find<HomeRepository>();

    try {
      // Make your API call here
      final response = await apiService.healthCheckApiCall();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _onLogoutButtonPressed(
      LogoutButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      var selectedOutlet =
          hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletId);
      var selectedTerminal =
          hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId);
      var selectedPosMode =
          hiveStorageHelper.read(SharedPreferenceConstants.selectedPosMode);
      final LogoutResponse response = await _loginRepository.logout(
          request: LogoutRequest(
              outletId: selectedOutlet,
              terminalId: selectedTerminal,
              posMode: selectedPosMode));

      _sharedPreferenceHelper.clearAll();
      hiveStorageHelper.clear();
      emit(LogoutSuccess());
    } catch (error) {
      emit(LogoutFailure(error.toString()));
    }
  }

  Future<void> _getOutletDetails(
      GetOutletDetails event, Emitter<LoginState> emit) async {
    emit(GetOutletDetailsLoading());
    try {
      for (var i in outletDetails) {
        if (event.outletName == i.name) {
          selectedOutletId = i.outletId;
        }
      }

      final OutletDetailsResponse response =
          await _loginRepository.getOutletDetails(selectedOutletId);

      _sharedPreferenceHelper.storeSelectedOutlet(response.outletId ?? "");
      hiveStorageHelper.save(
          SharedPreferenceConstants.selectedOutletName, event.outletName);
      hiveStorageHelper.save(
          SharedPreferenceConstants.selectedOutletId, response.outletId);
      terminalDetails = response.terminals ?? [];
      terminalList.clear();
      if (terminalDetails.isNotEmpty) {
        for (var i in terminalDetails) {
          if (i.terminalName != null) {
            terminalList.add(i.terminalName!);
          }
        }
        selectedTerminalId = response.terminals?.first.terminalId ?? '';
        hiveStorageHelper.save(SharedPreferenceConstants.selectedTerminalId,
            response.terminals?.first.terminalId);
        hiveStorageHelper.save(SharedPreferenceConstants.selectedTerminalName,
            response.terminals?.first.terminalName);
      }
      final allowedPosModes = response.allowedPosModes;
      allowedPos.clear();
      if (allowedPosModes != null && allowedPosModes.isNotEmpty) {
        allowedPos.addAll(allowedPosModes);
        hiveStorageHelper.save(
            SharedPreferenceConstants.selectedPosMode, allowedPosModes.first);
      }
      emit(GetOutletDetailsSuccess());
    } catch (error) {
      emit(GetOutletDetailsFailure(error.toString()));
    }
  }

  _selectPosMode(SelectPosMode event, Emitter<LoginState> emit) {
    selectedPosMode = event.posMode;
    hiveStorageHelper.save(
        SharedPreferenceConstants.selectedPosMode, event.posMode);
  }

  _selectTerminal(SelectTerminal event, Emitter<LoginState> emit) {
    for (var i in terminalDetails) {
      if (event.terminalName == i.terminalName) {
        selectedTerminalId = i.terminalId ?? '';
      }
    }
    print('selected terminal ${event.terminalName}');
    hiveStorageHelper.save(
        SharedPreferenceConstants.selectedTerminalName, event.terminalName);
    hiveStorageHelper.save(
        SharedPreferenceConstants.selectedTerminalId, selectedTerminalId);
  }

  Future<void> _submitTerminalDetails(
      SubmitTerminalDetails event, Emitter<LoginState> emit) async {
    emit(SubmitTerminalDetailsLoading());
    try {
      var userId = await _sharedPreferenceHelper.getUserID();
      final TerminalDetailsResponse response =
          await _loginRepository.getTerminalDetails(GetTerminalDetailsRequest(
              outletId: selectedOutletId,
              terminalId: selectedTerminalId,
              userId: userId ?? '',
              posMode: selectedPosMode));
      _sharedPreferenceHelper.storeLoginStatus(true);
      hiveStorageHelper.save(SharedPreferenceConstants.customerProxyNumber,
          response.outletDetails?.outletCustomerProxyPhoneNumber);
      hiveStorageHelper.save(SharedPreferenceConstants.customerProxyName,
          response.outletDetails?.name ?? "STORE");
      hiveStorageHelper.save(SharedPreferenceConstants.registerId,
          response.registerDetails?.registerId ?? "");
      hiveStorageHelper.save(SharedPreferenceConstants.registerTransactionId,
          response.registerDetails?.registerTransactionId ?? "");
      hiveStorageHelper.save(SharedPreferenceConstants.isQuantityEditEnabled,
          response.outletDetails?.quantityEditMode);
      hiveStorageHelper.save(SharedPreferenceConstants.isLineDeleteEnabled,
          response.outletDetails?.lineDeleteMode);
      hiveStorageHelper.save(SharedPreferenceConstants.isEnableHoldCartEnabled,
          response.outletDetails?.enableHoldCartMode);
      hiveStorageHelper.save(SharedPreferenceConstants.isPriceEditEnabled,
          response.outletDetails?.priceEditMode);
      hiveStorageHelper.save(
          SharedPreferenceConstants.isSalesAssociateLinkEnabled,
          response.outletDetails?.salesAssociateLink);

      final provider = response.terminalDetails?.edcDevices?.isNotEmpty == true
          ? response.terminalDetails!.edcDevices!.first.provider
                  ?.toLowerCase() ??
              ""
          : "";

      hiveStorageHelper.save(
        SharedPreferenceConstants.paymentProvider,
        provider,
      );

      List<Map<String, dynamic>> allowedPaymentModeJson = response
              .outletDetails!.allowedPaymentModes
              ?.map((mode) => mode.toJson())
              .toList() ??
          [];

      hiveStorageHelper.save(SharedPreferenceConstants.allowedPaymentModes,
          allowedPaymentModeJson);

      List<Map<String, dynamic>> edcDeviceDetails = response
              .terminalDetails?.edcDevices
              ?.map((mode) => mode.toJson())
              .toList() ??
          [];

      hiveStorageHelper.save(
          SharedPreferenceConstants.edcDeviceDetails, edcDeviceDetails);

      print('edc details:${edcDeviceDetails.firstOrNull}');
      emit(SubmitTerminalDetailsSuccess());
    } catch (error, stackTrace) {
      emit(SubmitTerminalDetailsFailure(error.toString()));
      Logger.logException(
        error: error.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  void storeAllowedPaymentModes(List<AllowedPaymentMode>? allowedPaymentModes) {
    if (allowedPaymentModes != null) {
      // Convert each AllowedPaymentMode to a Map
      List<Map<String, dynamic>> allowedPaymentModesList =
          allowedPaymentModes.map((mode) {
        return {
          "payment_option_id": mode.paymentOptionId,
          "payment_option_code": mode.paymentOptionCode,
          "psp_id": mode.pspId,
          "psp_name": mode.pspName,
        };
      }).toList();

      // Store it in the Hive box
      hiveStorageHelper.save(SharedPreferenceConstants.allowedPaymentModes,
          allowedPaymentModesList);
    }
  }
}
