import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_event.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_state.dart';
import 'package:kpn_pos_application/ui/login/model/get_terminal_details_request.dart';
import 'package:kpn_pos_application/ui/login/model/login_request.dart';
import 'package:kpn_pos_application/ui/login/model/login_response.dart';
import 'package:kpn_pos_application/ui/login/model/logout_response.dart';
import 'package:kpn_pos_application/ui/login/model/outlet_details_response.dart';
import 'package:kpn_pos_application/ui/login/repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  List<OutletDetail> outletDetails = [];
  List<String> outletList = [];
  List<Terminal> terminalDetails = [];
  List<String> terminalList = [];
  late String selectedOutletId;

  LoginBloc(this._loginRepository, this._sharedPreferenceHelper)
      : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
    on<GetOutletDetails>(_getOutletDetails);

  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final LoginResponse response = await _loginRepository.login(
          LoginRequest(userName: event.loginId, password: event.password));

      _sharedPreferenceHelper.storeAuthToken(response.token);
      outletDetails = response.outletDetails;
      for (var i in outletDetails) {
        outletList.add(i.name);
      }
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }

  Future<void> _onLogoutButtonPressed(
      LogoutButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final LogoutResponse response = await _loginRepository.logout(token: event.token);

      _sharedPreferenceHelper.clearAll();
      emit(LogoutSuccess());
    } catch (error) {
      emit(LogoutFailure(error.toString()));
    }
  }

  Future<void> _getOutletDetails(
      GetOutletDetails event, Emitter<LoginState> emit) async {
    //emit(LoginLoading());
    try {
      for (var i in outletDetails) {
       if(event.outletName == i.name){
         selectedOutletId = i.outletId;
       }
      }

      final OutletDetailsResponse response = await _loginRepository.getOutletDetails(selectedOutletId);

      _sharedPreferenceHelper.storeSelectedOutlet(response.outletId);
      terminalDetails = response.terminals;
    //  emit(GetOutletDetailsSuccess());
    } catch (error) {
      emit(GetOutletDetailsFailure(error.toString()));
    }
  }

  Future<void> _getTerminalDetails(
      GetTerminalDetails event, Emitter<LoginState> emit) async {
    //emit(LoginLoading());
    try {
      late String terminalId;
      for (var i in terminalDetails) {
        if(event.terminalName == i.terminalName){
          terminalId = i.terminalId;
        }
      }

      final OutletDetailsResponse response = await _loginRepository.getTerminalDetails(
          GetTerminalDetailsRequest(outletId: selectedOutletId, terminalId: terminalId, userId: 'userId', posMode: 'posMode'));

      _sharedPreferenceHelper.storeSelectedOutlet(response.outletId);
      terminalDetails = response.terminals;
      //  emit(GetOutletDetailsSuccess());
    } catch (error) {
      emit(GetOutletDetailsFailure(error.toString()));
    }
  }

}
