import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_event.dart';
import 'package:kpn_pos_application/ui/login/bloc/login_state.dart';
import 'package:kpn_pos_application/ui/login/model/login_request.dart';
import 'package:kpn_pos_application/ui/login/repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final LoginRepository _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
     final response = await _loginRepository.login(LoginRequest( loginId:  event.loginId, password:  event.password));
     emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }
}
