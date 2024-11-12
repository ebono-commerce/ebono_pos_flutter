abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String loginId;
  final String password;

  LoginButtonPressed(this.loginId, this.password);
}

class LogoutButtonPressed extends LoginEvent {
  final String token;

  LogoutButtonPressed(this.token);
}

class GetOutletDetails extends LoginEvent {
  final String outletName;

  GetOutletDetails(this.outletName);
}

class GetTerminalDetails extends LoginEvent {
  final String terminalName;

  GetTerminalDetails(this.terminalName);
}
