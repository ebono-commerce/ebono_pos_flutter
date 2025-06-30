abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class SelectPort extends LoginEvent {
  final String port;
  SelectPort(this.port);
}

class SelectPrinter extends LoginEvent {
  final String printer;
  SelectPrinter(this.printer);
}

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

class SelectTerminal extends LoginEvent {
  final String terminalName;

  SelectTerminal(this.terminalName);
}

class SubmitTerminalDetails extends LoginEvent {}

class SelectPosMode extends LoginEvent{
  final String posMode;

  SelectPosMode(this.posMode);
}