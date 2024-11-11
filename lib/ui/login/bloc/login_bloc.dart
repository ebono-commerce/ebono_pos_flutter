import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_event.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_state.dart';
import 'package:kpn_pos_application/ui/login/model/login_request.dart';
import 'package:kpn_pos_application/ui/login/model/login_response.dart';
import 'package:kpn_pos_application/ui/login/repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  List<OutletDetail> outletDetails = [];
  List<String> outletList = [];

  LoginBloc(this._loginRepository, this._sharedPreferenceHelper)
      : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
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
}
