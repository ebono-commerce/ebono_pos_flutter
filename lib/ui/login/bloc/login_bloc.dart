import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/get_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
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
import 'package:libserialport/libserialport.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  final GetStorageHelper getStorageHelper;
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

  LoginBloc(this._loginRepository, this._sharedPreferenceHelper, this.getStorageHelper)
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
        getStorageHelper.save(
            SharedPreferenceConstants.selectedPrinter, i);
      }
    }

    emit(PrinterSelectionSuccess());
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
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
      getStorageHelper.save(
          SharedPreferenceConstants.userDetails, response.userDetails);

      outletDetails = response.outletDetails;
      for (var i in outletDetails) {
        outletList.add(i.name);
      }
      selectedOutletId = response.outletDetails.first.outletId;
      getStorageHelper.save(SharedPreferenceConstants.selectedOutletId,
          response.outletDetails.first.outletId);
      getStorageHelper.save(SharedPreferenceConstants.selectedOutletName,
          response.outletDetails.first.name);
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }

  Future<void> _onLogoutButtonPressed(
      LogoutButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      var selectedOutlet =
          getStorageHelper.read(SharedPreferenceConstants.selectedOutletId);
      var selectedTerminal =
          getStorageHelper.read(SharedPreferenceConstants.selectedTerminalId);
      var selectedPosMode =
          getStorageHelper.read(SharedPreferenceConstants.selectedPosMode);
      final LogoutResponse response = await _loginRepository.logout(
          request: LogoutRequest(
              outletId: selectedOutlet,
              terminalId: selectedTerminal,
              posMode: selectedPosMode));

      _sharedPreferenceHelper.clearAll();
      getStorageHelper.clear();
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
      getStorageHelper.save(
          SharedPreferenceConstants.selectedOutletName, event.outletName);
      getStorageHelper.save(
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
        getStorageHelper.save(SharedPreferenceConstants.selectedTerminalId,
            response.terminals?.first.terminalId);
        getStorageHelper.save(SharedPreferenceConstants.selectedTerminalName,
            response.terminals?.first.terminalName);
      }
      final allowedPosModes = response.allowedPosModes;
      if (allowedPosModes != null) {
        allowedPos.clear();
        allowedPos.addAll(allowedPosModes);
        getStorageHelper.save(
            SharedPreferenceConstants.selectedPosMode, allowedPosModes.first);
      }
      emit(GetOutletDetailsSuccess());
    } catch (error) {
      emit(GetOutletDetailsFailure(error.toString()));
    }
  }

  _selectPosMode(SelectPosMode event, Emitter<LoginState> emit) {
    selectedPosMode = event.posMode;
    getStorageHelper.save(
        SharedPreferenceConstants.selectedPosMode, event.posMode);
  }

  _selectTerminal(SelectTerminal event, Emitter<LoginState> emit) {
    for (var i in terminalDetails) {
      if (event.terminalName == i.terminalName) {
        selectedTerminalId = i.terminalId ?? '';
      }
    }
    print('selected terminal ${event.terminalName}');
    getStorageHelper.save(
        SharedPreferenceConstants.selectedTerminalName, event.terminalName);
    getStorageHelper.save(
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
      getStorageHelper.save(SharedPreferenceConstants.customerProxyNumber,
          response.outletDetails?.outletCustomerProxyPhoneNumber);
      getStorageHelper.save(SharedPreferenceConstants.registerId,
          response.registerDetails?.registerId ?? "");
      getStorageHelper.save(SharedPreferenceConstants.customerProxyNumber,
          response.outletDetails?.outletCustomerProxyPhoneNumber);
      getStorageHelper.save(SharedPreferenceConstants.isQuantityEditEnabled,
          response.outletDetails?.quantityEditMode);
      getStorageHelper.save(SharedPreferenceConstants.isLineDeleteEnabled,
          response.outletDetails?.lineDeleteMode);
      getStorageHelper.save(SharedPreferenceConstants.isEnableHoldCartEnabled,
          response.outletDetails?.enableHoldCartMode);
      getStorageHelper.save(SharedPreferenceConstants.isPriceEditEnabled,
          response.outletDetails?.priceEditMode);
      getStorageHelper.save(
          SharedPreferenceConstants.isSalesAssociateLinkEnabled,
          response.outletDetails?.salesAssociateLink);

      emit(SubmitTerminalDetailsSuccess());
    } catch (error) {
      emit(SubmitTerminalDetailsFailure(error.toString()));
    }
  }
}
