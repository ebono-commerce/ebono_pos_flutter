import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:libserialport/libserialport.dart';
import 'package:uuid/uuid.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  List<OutletDetail> outletDetails = [];
  List<String> outletList = [];
  List<Terminal> terminalDetails = [];
  List<String> terminalList = [];
  late String selectedTerminalId;
  late String selectedOutletId;
  String selectedPosMode = 'POS';
  List<String> allowedPos = [];
  List<String> availablePorts = [];

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

  LoginBloc(this._loginRepository, this._sharedPreferenceHelper)
      : super(LoginInitial()) {
    on<LoginInitialEvent>(_onLoginInitial);
    on<SelectPort>(_onPortSelection);
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
    print('Available ports:');
    _sharedPreferenceHelper.storePortName(availablePorts.first);

    emit(ReadPortSuccess());
  }

  Future<void> _onPortSelection(
      SelectPort event, Emitter<LoginState> emit) async {
    _sharedPreferenceHelper.storePortName(event.port);

    emit(PortSelectionSuccess());
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
      GetStorageHelper.save(
          SharedPreferenceConstants.userDetails, response.userDetails);

      outletDetails = response.outletDetails;
      for (var i in outletDetails) {
        outletList.add(i.name);
      }
      selectedOutletId = response.outletDetails.first.outletId;
      GetStorageHelper.save(SharedPreferenceConstants.selectedOutletId,
          response.outletDetails.first.outletId);
      GetStorageHelper.save(SharedPreferenceConstants.selectedOutletName,
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
          GetStorageHelper.read(SharedPreferenceConstants.selectedOutletId);
      var selectedTerminal =
          GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalId);
      var selectedPosMode =
          GetStorageHelper.read(SharedPreferenceConstants.selectedPosMode);
      final LogoutResponse response = await _loginRepository.logout(
          request: LogoutRequest(
              outletId: selectedOutlet,
              terminalId: selectedTerminal,
              posMode: selectedPosMode));

      _sharedPreferenceHelper.clearAll();
      GetStorageHelper.clear();
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
      GetStorageHelper.save(
          SharedPreferenceConstants.selectedOutletName, event.outletName);
      GetStorageHelper.save(
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
        GetStorageHelper.save(SharedPreferenceConstants.selectedTerminalId,
            response.terminals?.first.terminalId);
        GetStorageHelper.save(SharedPreferenceConstants.selectedTerminalName,
            response.terminals?.first.terminalName);
      }
      final allowedPosModes = response.allowedPosModes;
      if (allowedPosModes != null) {
        allowedPos.clear();
        allowedPos.addAll(allowedPosModes);
        GetStorageHelper.save(
            SharedPreferenceConstants.selectedPosMode, allowedPosModes.first);
      }
      emit(GetOutletDetailsSuccess());
    } catch (error) {
      emit(GetOutletDetailsFailure(error.toString()));
    }
  }

  _selectPosMode(SelectPosMode event, Emitter<LoginState> emit) {
    selectedPosMode = event.posMode;
    GetStorageHelper.save(
        SharedPreferenceConstants.selectedPosMode, event.posMode);
  }

  _selectTerminal(SelectTerminal event, Emitter<LoginState> emit) {
    for (var i in terminalDetails) {
      if (event.terminalName == i.terminalName) {
        selectedTerminalId = i.terminalId ?? '';
      }
    }
    print('selected terminal ${event.terminalName}');
    GetStorageHelper.save(
        SharedPreferenceConstants.selectedTerminalName, event.terminalName);
    GetStorageHelper.save(
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
      GetStorageHelper.save(SharedPreferenceConstants.customerProxyNumber,
          response.outletDetails?.outletCustomerProxyPhoneNumber);
      GetStorageHelper.save(SharedPreferenceConstants.registerId,
          response.registerDetails?.registerId ?? "");
      GetStorageHelper.save(
          SharedPreferenceConstants.customerProxyNumber, response.outletDetails?.outletCustomerProxyPhoneNumber);
      GetStorageHelper.save(
          SharedPreferenceConstants.isQuantityEditEnabled, response.outletDetails?.quantityEditMode);
      GetStorageHelper.save(
          SharedPreferenceConstants.isLineDeleteEnabled, response.outletDetails?.lineDeleteMode);
      GetStorageHelper.save(
          SharedPreferenceConstants.isEnableHoldCartEnabled, response.outletDetails?.enableHoldCartMode);
      GetStorageHelper.save(
          SharedPreferenceConstants.isPriceEditEnabled, response.outletDetails?.priceEditMode);
      GetStorageHelper.save(
          SharedPreferenceConstants.isSalesAssociateLinkEnabled, response.outletDetails?.salesAssociateLink);

      emit(SubmitTerminalDetailsSuccess());
    } catch (error) {
      emit(SubmitTerminalDetailsFailure(error.toString()));
    }
  }
}
