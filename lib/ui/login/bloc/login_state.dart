abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LogoutSuccess extends LoginState {}

class LogoutFailure extends LoginState {
  final String error;
  LogoutFailure(this.error);
}


class GetOutletDetailsSuccess extends LoginState {}

class GetOutletDetailsFailure extends LoginState {
  final String error;
  GetOutletDetailsFailure(this.error);
}