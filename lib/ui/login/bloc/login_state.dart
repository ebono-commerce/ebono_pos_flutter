abstract class LoginState {}

class LoginInitial extends LoginState {}

class ReadPortSuccess extends LoginState {}

class PortSelectionSuccess extends LoginState {}

class PrinterSelectionSuccess extends LoginState {}

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

class GetOutletDetailsLoading extends LoginState {}

class GetOutletDetailsSuccess extends LoginState {}

class GetOutletDetailsFailure extends LoginState {
  final String error;
  GetOutletDetailsFailure(this.error);
}

class SubmitTerminalDetailsLoading extends LoginState {}

class SubmitTerminalDetailsSuccess extends LoginState {}

class SubmitTerminalDetailsFailure extends LoginState {
  final String error;
  SubmitTerminalDetailsFailure(this.error);
}